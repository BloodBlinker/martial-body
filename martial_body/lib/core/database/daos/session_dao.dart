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

import 'package:drift/drift.dart';
import '../database.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [WorkoutLogs, SetLogs, BlockExercises])
class SessionDao extends DatabaseAccessor<AppDatabase> with _$SessionDaoMixin {
  SessionDao(super.db);

  Future<int> startSession({
    required int sessionId,
    required int weekNumber,
    required int phaseNumber,
  }) =>
      into(workoutLogs).insert(WorkoutLogsCompanion.insert(
        date: DateTime.now(),
        sessionId: sessionId,
        weekNumber: weekNumber,
        phaseNumber: phaseNumber,
        startedAt: Value(DateTime.now()),
      ));

  Future<WorkoutLog?> getTodayLog(int sessionId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (select(workoutLogs)
          ..where((w) =>
              w.sessionId.equals(sessionId) &
              w.date.isBiggerOrEqualValue(startOfDay) &
              w.date.isSmallerThanValue(endOfDay)))
        .getSingleOrNull();
  }

  Future<void> completeWorkoutLog(int id) =>
      (update(workoutLogs)..where((w) => w.id.equals(id))).write(
        WorkoutLogsCompanion(
          completed: const Value(true),
          completedAt: Value(DateTime.now()),
        ),
      );

  Future<void> upsertSetLog({
    required int workoutLogId,
    required int blockExerciseId,
    required int setNumber,
    double? weightKg,
    int? repsCompleted,
    required bool completed,
  }) async {
    final existing = await (select(setLogs)
          ..where((s) =>
              s.workoutLogId.equals(workoutLogId) &
              s.blockExerciseId.equals(blockExerciseId) &
              s.setNumber.equals(setNumber)))
        .getSingleOrNull();

    if (existing != null) {
      await (update(setLogs)..where((s) => s.id.equals(existing.id))).write(
        SetLogsCompanion(
          repsCompleted: Value(repsCompleted),
          weightKg: Value(weightKg),
          completed: Value(completed),
          completedAt: Value(completed ? DateTime.now() : null),
        ),
      );
    } else {
      await into(setLogs).insert(SetLogsCompanion.insert(
        workoutLogId: workoutLogId,
        blockExerciseId: blockExerciseId,
        setNumber: setNumber,
        repsCompleted: Value(repsCompleted),
        weightKg: Value(weightKg),
        completed: Value(completed),
        completedAt: Value(completed ? DateTime.now() : null),
      ));
    }
  }

  /// Flip only the completed flag + completedAt. Does NOT overwrite
  /// weightKg / repsCompleted, so toggling a set off preserves the values the
  /// user had already entered.
  Future<void> setCompleted({
    required int workoutLogId,
    required int blockExerciseId,
    required int setNumber,
    required bool completed,
  }) async {
    final existing = await (select(setLogs)
          ..where((s) =>
              s.workoutLogId.equals(workoutLogId) &
              s.blockExerciseId.equals(blockExerciseId) &
              s.setNumber.equals(setNumber)))
        .getSingleOrNull();
    if (existing == null) return;
    await (update(setLogs)..where((s) => s.id.equals(existing.id))).write(
      SetLogsCompanion(
        completed: Value(completed),
        completedAt: Value(completed ? DateTime.now() : null),
      ),
    );
  }

  Future<List<SetLog>> getSetLogsForWorkout(int workoutLogId) =>
      (select(setLogs)..where((s) => s.workoutLogId.equals(workoutLogId))).get();

  /// Single-shot fetch of every completed set log. Used by analytics to avoid
  /// N+1 per-workout queries.
  Future<List<SetLog>> getAllCompletedSetLogs() =>
      (select(setLogs)..where((s) => s.completed.equals(true))).get();

  Stream<List<WorkoutLog>> watchAllLogs() =>
      (select(workoutLogs)
            ..orderBy([(w) => OrderingTerm.desc(w.date)]))
          .watch();

  /// One-shot fetch — analytics is a FutureProvider and should not hold a
  /// stream subscription open just to grab the current list.
  Future<List<WorkoutLog>> getAllLogs() =>
      (select(workoutLogs)
            ..orderBy([(w) => OrderingTerm.desc(w.date)]))
          .get();

  Future<List<WorkoutLog>> getLogsForWeek(int weekNumber) =>
      (select(workoutLogs)..where((w) => w.weekNumber.equals(weekNumber))).get();

  /// Returns the most recent completed SetLog for each of [exerciseIds],
  /// optionally excluding one workoutLog (the current session) so the "last
  /// time" hint is truly *prior*. Map is keyed by exerciseId.
  ///
  /// One query → in-memory fold. Good enough for the ~30 distinct exercises
  /// per session.
  Future<Map<int, SetLog>> getLastCompletedSetLogByExerciseId(
    List<int> exerciseIds, {
    int? excludeWorkoutLogId,
  }) async {
    if (exerciseIds.isEmpty) return {};

    final query = select(setLogs).join([
      innerJoin(
        blockExercises,
        blockExercises.id.equalsExp(setLogs.blockExerciseId),
      ),
    ])
      ..where(
        setLogs.completed.equals(true) &
            blockExercises.exerciseId.isIn(exerciseIds) &
            (excludeWorkoutLogId != null
                ? setLogs.workoutLogId.equals(excludeWorkoutLogId).not()
                : const Constant(true)),
      )
      ..orderBy([OrderingTerm.desc(setLogs.completedAt)]);

    final rows = await query.get();
    final Map<int, SetLog> out = {};
    for (final row in rows) {
      final be = row.readTable(blockExercises);
      if (!out.containsKey(be.exerciseId)) {
        out[be.exerciseId] = row.readTable(setLogs);
      }
    }
    return out;
  }
}
