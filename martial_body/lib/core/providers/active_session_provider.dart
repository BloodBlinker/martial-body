// Martial Body — 24-week MMA preparation trainer
// Copyright (C) 2026 Robin Roy <robinroy3107@gmail.com>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../models/active_session_state.dart';
import '../models/session_detail.dart';
import '../program/phase_math.dart';
import 'database_provider.dart';

final activeSessionProvider = StateNotifierProvider.family<
    ActiveSessionNotifier, AsyncValue<ActiveSessionState>, int>(
  (ref, sessionId) => ActiveSessionNotifier(ref.watch(databaseProvider), sessionId),
);

class ActiveSessionNotifier extends StateNotifier<AsyncValue<ActiveSessionState>> {
  final AppDatabase _db;
  final int _sessionId;

  ActiveSessionNotifier(this._db, this._sessionId)
      : super(const AsyncValue.loading()) {
    _init();
  }

  /// Weight display: drop trailing zero only — preserves 10.5, 50, 40 correctly.
  static String formatWeight(double w) =>
      (w % 1 == 0) ? w.toInt().toString() : w.toStringAsFixed(1);

  Future<void> _init() async {
    try {
      final session = await _db.programDao.getSessionById(_sessionId);
      if (session == null) throw StateError('Session $_sessionId not found');

      final phase = await _db.programDao.getPhaseById(session.phaseId);
      if (phase == null) throw StateError('Phase ${session.phaseId} not found');

      final blocks = await _db.programDao.getBlocksForSession(_sessionId);
      final blockDetails = await Future.wait(
        blocks.map((b) async {
          final exercises = await _db.programDao.getBlockExercisesWithExercise(b.id);
          return BlockDetail(block: b, exercises: exercises);
        }),
      );
      final sessionDetail =
          SessionDetail(session: session, phase: phase, blocks: blockDetails);
      final allExercises = blockDetails.expand((b) => b.exercises).toList();

      // Get or create today's workout log
      final existing = await _db.sessionDao.getTodayLog(_sessionId);
      final int workoutLogId;
      if (existing != null) {
        workoutLogId = existing.id;
      } else {
        final userState = await _db.userDao.getUserState();
        // Contract: main.dart always inserts userState before any session screen
        // can mount. Fall back to "today" rather than a stale hardcoded date so
        // that a missing row produces week 1, not nonsense historical weeks.
        final programStart = userState?.programStartDate ?? DateTime.now();
        final weekNumber = computeWeekNumber(programStart, DateTime.now());
        final phaseNumber = phaseNumberForWeek(weekNumber);

        workoutLogId = await _db.sessionDao.startSession(
          sessionId: _sessionId,
          weekNumber: weekNumber,
          phaseNumber: phaseNumber,
        );
      }

      // Load existing set logs into state
      final setLogs = await _db.sessionDao.getSetLogsForWorkout(workoutLogId);
      final setsDone = <String, bool>{};
      final weightDrafts = <String, String>{};
      final repsDrafts = <String, String>{};

      for (final log in setLogs) {
        final k = ActiveSessionState.key(log.blockExerciseId, log.setNumber);
        setsDone[k] = log.completed;
        if (log.weightKg != null) {
          weightDrafts[k] = formatWeight(log.weightKg!);
        }
        if (log.repsCompleted != null) {
          repsDrafts[k] = log.repsCompleted.toString();
        }
      }

      // Preload "last time" hints — one query per session, not per exercise.
      final exerciseIds =
          allExercises.map((e) => e.exercise.id).toSet().toList();
      final lastByExerciseId =
          await _db.sessionDao.getLastCompletedSetLogByExerciseId(
        exerciseIds,
        excludeWorkoutLogId: workoutLogId,
      );

      state = AsyncValue.data(ActiveSessionState(
        workoutLogId: workoutLogId,
        sessionDetail: sessionDetail,
        allExercises: allExercises,
        currentExerciseIndex: 0,
        setsDone: setsDone,
        weightDrafts: weightDrafts,
        repsDrafts: repsDrafts,
        lastByExerciseId: lastByExerciseId,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void navigateTo(int index) {
    final current = state.value;
    if (current == null) return;
    if (index < 0 || index >= current.allExercises.length) return;
    state = AsyncValue.data(current.copyWith(currentExerciseIndex: index));
  }

  /// Toggle the done/undone state of a set.
  ///
  /// On toggle-ON: persist weight+reps (parsed from text drafts).
  /// On toggle-OFF: only flip the completed flag and clear completedAt — do
  /// NOT overwrite weight/reps, so tapping the check to uncomplete never loses
  /// values the user entered earlier.
  ///
  /// Returns the new done-state so callers can trigger side effects (e.g.
  /// start the rest countdown only on toggle-ON).
  Future<bool> toggleSet({
    required int beId,
    required int setNumber,
    required String weightText,
    required String repsText,
  }) async {
    final current = state.value;
    if (current == null) return false;

    final k = ActiveSessionState.key(beId, setNumber);
    final newDone = !(current.setsDone[k] ?? false);

    if (newDone) {
      final weight = weightText.trim().isEmpty ? null : double.tryParse(weightText);
      final reps = repsText.trim().isEmpty ? null : int.tryParse(repsText);

      await _db.sessionDao.upsertSetLog(
        workoutLogId: current.workoutLogId,
        blockExerciseId: beId,
        setNumber: setNumber,
        weightKg: weight,
        repsCompleted: reps,
        completed: true,
      );

      state = AsyncValue.data(current.copyWith(
        setsDone: {...current.setsDone, k: true},
        weightDrafts: {...current.weightDrafts, k: weightText},
        repsDrafts: {...current.repsDrafts, k: repsText},
      ));
    } else {
      await _db.sessionDao.setCompleted(
        workoutLogId: current.workoutLogId,
        blockExerciseId: beId,
        setNumber: setNumber,
        completed: false,
      );

      state = AsyncValue.data(current.copyWith(
        setsDone: {...current.setsDone, k: false},
      ));
    }
    return newDone;
  }

  /// Persist any non-empty, uncompleted draft as a completed set. Used when
  /// the user finishes a session without tapping the final check.
  Future<void> persistRemainingDrafts({
    required Map<String, String> weightTexts,
    required Map<String, String> repsTexts,
  }) async {
    final current = state.value;
    if (current == null) return;

    final updatedDone = {...current.setsDone};
    final updatedWeight = {...current.weightDrafts};
    final updatedReps = {...current.repsDrafts};

    for (final be in current.allExercises) {
      final sets = be.blockExercise.sets ?? 1;
      for (int i = 1; i <= sets; i++) {
        final k = ActiveSessionState.key(be.blockExercise.id, i);
        final alreadyDone = current.setsDone[k] ?? false;
        if (alreadyDone) continue;

        final wText = (weightTexts[k] ?? '').trim();
        final rText = (repsTexts[k] ?? '').trim();
        if (wText.isEmpty && rText.isEmpty) continue;

        final weight = wText.isEmpty ? null : double.tryParse(wText);
        final reps = rText.isEmpty ? null : int.tryParse(rText);

        await _db.sessionDao.upsertSetLog(
          workoutLogId: current.workoutLogId,
          blockExerciseId: be.blockExercise.id,
          setNumber: i,
          weightKg: weight,
          repsCompleted: reps,
          completed: true,
        );

        updatedDone[k] = true;
        updatedWeight[k] = wText;
        updatedReps[k] = rText;
      }
    }

    state = AsyncValue.data(current.copyWith(
      setsDone: updatedDone,
      weightDrafts: updatedWeight,
      repsDrafts: updatedReps,
    ));
  }

  Future<void> completeSession() async {
    final current = state.value;
    if (current == null) return;
    await _db.sessionDao.completeWorkoutLog(current.workoutLogId);
  }
}
