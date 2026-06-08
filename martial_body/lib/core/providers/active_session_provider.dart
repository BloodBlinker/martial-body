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

      // Build flat exercise list, injecting a synthetic placeholder for any
      // block that has no exercises (e.g. a cardio/conditioning finisher).
      final allExercises = <BlockExerciseDetail>[];
      for (final bd in blockDetails) {
        if (bd.exercises.isEmpty) {
          final syntheticId = -(bd.block.id);
          allExercises.add(BlockExerciseDetail(
            blockExercise: BlockExercise(
              id: syntheticId,
              blockId: bd.block.id,
              exerciseId: 0,
              exerciseOrder: 0,
              sets: 1,
              reps: bd.block.durationMinutes != null
                  ? '${bd.block.durationMinutes} min'
                  : null,
              notes: bd.block.instructions,
              isNew: false,
            ),
            exercise: Exercise(
              id: 0,
              name: bd.block.name,
              category: 'cardio',
            ),
            isCardioBlock: true,
          ));
        } else {
          allExercises.addAll(bd.exercises);
        }
      }

      // Resolve workout log: prefer an existing incomplete log (from any date)
      // so a workout started at 11:55 PM and resumed at 12:05 AM doesn't
      // create a second orphan. Fall back to today's log, then create a new one.
      final incomplete = await _db.sessionDao.getIncompleteLog(_sessionId);
      final int workoutLogId;
      final DateTime sessionStartedAt;

      if (incomplete != null) {
        workoutLogId = incomplete.id;
        sessionStartedAt = incomplete.startedAt ?? incomplete.date;
      } else {
        final todayLog = await _db.sessionDao.getTodayLog(_sessionId);
        if (todayLog != null) {
          workoutLogId = todayLog.id;
          sessionStartedAt = todayLog.startedAt ?? todayLog.date;
        } else {
          final userState = await _db.userDao.getUserState();
          final weekNumber = userState?.currentWeek ?? 1;
          final phaseNumber = phaseNumberForWeek(weekNumber);

          workoutLogId = await _db.sessionDao.startSession(
            sessionId: _sessionId,
            weekNumber: weekNumber,
            phaseNumber: phaseNumber,
          );
          sessionStartedAt = DateTime.now();
        }
      }

      // Load existing set logs into draft maps
      final setLogs = await _db.sessionDao.getSetLogsForWorkout(workoutLogId);
      final setsDone = <String, bool>{};
      final weightDrafts = <String, String>{};
      final repsDrafts = <String, String>{};
      final rightRepsDrafts = <String, String>{};

      for (final log in setLogs) {
        final k = ActiveSessionState.key(log.blockExerciseId, log.setNumber);
        setsDone[k] = log.completed;
        if (log.weightKg != null) {
          weightDrafts[k] = formatWeight(log.weightKg!);
        }
        if (log.repsCompleted != null) {
          repsDrafts[k] = log.repsCompleted.toString();
        }
        if (log.rightRepsCompleted != null) {
          rightRepsDrafts[k] = log.rightRepsCompleted.toString();
        }
      }

      // Preload "last time" hints — one query per session, not per exercise.
      final exerciseIds = allExercises
          .where((e) => !e.isCardioBlock)
          .map((e) => e.exercise.id)
          .toSet()
          .toList();
      final lastByExerciseId =
          await _db.sessionDao.getLastCompletedSetLogByExerciseId(
        exerciseIds,
        excludeWorkoutLogId: workoutLogId,
      );

      // Auto-scroll to the first incomplete exercise on resume (#15).
      int startIndex = 0;
      if (setsDone.isNotEmpty) {
        for (int i = 0; i < allExercises.length; i++) {
          final be = allExercises[i];
          if (be.isCardioBlock) continue;
          final exSets = be.blockExercise.sets ?? 1;
          bool allDone = true;
          for (int s = 1; s <= exSets; s++) {
            final k = ActiveSessionState.key(be.blockExercise.id, s);
            if (setsDone[k] != true) {
              allDone = false;
              break;
            }
          }
          if (!allDone) {
            startIndex = i;
            break;
          }
        }
      }

      state = AsyncValue.data(ActiveSessionState(
        workoutLogId: workoutLogId,
        sessionDetail: sessionDetail,
        allExercises: allExercises,
        currentExerciseIndex: startIndex,
        sessionStartedAt: sessionStartedAt,
        setsDone: setsDone,
        weightDrafts: weightDrafts,
        repsDrafts: repsDrafts,
        rightRepsDrafts: rightRepsDrafts,
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
  /// Cardio placeholder entries (beId < 0) are tracked in memory only — they
  /// have no real block_exercise row so we cannot insert a set_log for them.
  Future<bool> toggleSet({
    required int beId,
    required int setNumber,
    required String weightText,
    required String repsText,
    String rightRepsText = '',
  }) async {
    final current = state.value;
    if (current == null) return false;

    final k = ActiveSessionState.key(beId, setNumber);
    final newDone = !(current.setsDone[k] ?? false);

    if (newDone) {
      // Skip DB writes for synthetic cardio placeholder entries.
      if (beId > 0) {
        final weight = weightText.trim().isEmpty ? null : double.tryParse(weightText);
        final reps = repsText.trim().isEmpty ? null : int.tryParse(repsText);
        final rightReps = rightRepsText.trim().isEmpty ? null : int.tryParse(rightRepsText);

        await _db.sessionDao.upsertSetLog(
          workoutLogId: current.workoutLogId,
          blockExerciseId: beId,
          setNumber: setNumber,
          weightKg: weight,
          repsCompleted: reps,
          leftRepsCompleted: reps,
          rightRepsCompleted: rightReps,
          completed: true,
        );
      }

      state = AsyncValue.data(current.copyWith(
        setsDone: {...current.setsDone, k: true},
        weightDrafts: {...current.weightDrafts, k: weightText},
        repsDrafts: {...current.repsDrafts, k: repsText},
        rightRepsDrafts: {...current.rightRepsDrafts, k: rightRepsText},
      ));
    } else {
      if (beId > 0) {
        await _db.sessionDao.setCompleted(
          workoutLogId: current.workoutLogId,
          blockExerciseId: beId,
          setNumber: setNumber,
          completed: false,
        );
      }

      state = AsyncValue.data(current.copyWith(
        setsDone: {...current.setsDone, k: false},
      ));
    }
    return newDone;
  }

  Future<void> persistRemainingDrafts({
    required Map<String, String> weightTexts,
    required Map<String, String> repsTexts,
    Map<String, String> rightRepsTexts = const {},
  }) async {
    final current = state.value;
    if (current == null) return;

    final updatedDone = {...current.setsDone};
    final updatedWeight = {...current.weightDrafts};
    final updatedReps = {...current.repsDrafts};
    final updatedRightReps = {...current.rightRepsDrafts};

    for (final be in current.allExercises) {
      if (be.isCardioBlock) continue;
      final sets = be.blockExercise.sets ?? 1;
      for (int i = 1; i <= sets; i++) {
        final k = ActiveSessionState.key(be.blockExercise.id, i);
        final alreadyDone = current.setsDone[k] ?? false;
        if (alreadyDone) continue;

        final wText = (weightTexts[k] ?? '').trim();
        final rText = (repsTexts[k] ?? '').trim();
        final rrText = (rightRepsTexts[k] ?? '').trim();
        if (wText.isEmpty && rText.isEmpty && rrText.isEmpty) continue;

        final weight = wText.isEmpty ? null : double.tryParse(wText);
        final reps = rText.isEmpty ? null : int.tryParse(rText);
        final rightReps = rrText.isEmpty ? null : int.tryParse(rrText);

        await _db.sessionDao.upsertSetLog(
          workoutLogId: current.workoutLogId,
          blockExerciseId: be.blockExercise.id,
          setNumber: i,
          weightKg: weight,
          repsCompleted: reps,
          leftRepsCompleted: reps,
          rightRepsCompleted: rightReps,
          completed: true,
        );

        updatedDone[k] = true;
        updatedWeight[k] = wText;
        updatedReps[k] = rText;
        updatedRightReps[k] = rrText;
      }
    }

    state = AsyncValue.data(current.copyWith(
      setsDone: updatedDone,
      weightDrafts: updatedWeight,
      repsDrafts: updatedReps,
      rightRepsDrafts: updatedRightReps,
    ));
  }

  /// Persist current draft values (weight/reps typed but not yet ticked) to
  /// the DB as incomplete set logs so they survive a "Continue Later" / resume.
  Future<void> saveDraftsForResume({
    required Map<String, String> weightTexts,
    required Map<String, String> repsTexts,
    Map<String, String> rightRepsTexts = const {},
  }) async {
    final current = state.value;
    if (current == null) return;

    for (final be in current.allExercises) {
      if (be.isCardioBlock) continue;
      final sets = be.blockExercise.sets ?? 1;
      for (int i = 1; i <= sets; i++) {
        final k = ActiveSessionState.key(be.blockExercise.id, i);
        if (current.setsDone[k] ?? false) continue; // already saved by toggleSet

        final wText = (weightTexts[k] ?? '').trim();
        final rText = (repsTexts[k] ?? '').trim();
        final rrText = (rightRepsTexts[k] ?? '').trim();
        if (wText.isEmpty && rText.isEmpty && rrText.isEmpty) continue;

        final weight = wText.isEmpty ? null : double.tryParse(wText);
        final reps = rText.isEmpty ? null : int.tryParse(rText);
        final rightReps = rrText.isEmpty ? null : int.tryParse(rrText);

        await _db.sessionDao.upsertSetLog(
          workoutLogId: current.workoutLogId,
          blockExerciseId: be.blockExercise.id,
          setNumber: i,
          weightKg: weight,
          repsCompleted: reps,
          leftRepsCompleted: reps,
          rightRepsCompleted: rightReps,
          completed: false,
        );
      }
    }
  }

  Future<void> completeSession(int? rpe) async {
    final current = state.value;
    if (current == null) return;
    await _db.sessionDao.completeWorkoutLog(current.workoutLogId, rpe: rpe);
  }

  Future<void> uncompleteSession() async {
    final current = state.value;
    if (current == null) return;
    await _db.sessionDao.uncompleteWorkoutLog(current.workoutLogId);
  }

  /// Delete the workout log entirely. Called when the user explicitly exits
  /// ("Exit Session") so the session is not shown as in-progress afterward.
  Future<void> abandonSession() async {
    final current = state.value;
    if (current == null) return;
    await _db.sessionDao.deleteWorkoutLog(current.workoutLogId);
  }
}
