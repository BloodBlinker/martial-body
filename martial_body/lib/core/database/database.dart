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

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/phases.dart';
import 'tables/sessions.dart';
import 'tables/blocks.dart';
import 'tables/exercises.dart';
import 'tables/block_exercises.dart';
import 'tables/workout_logs.dart';
import 'tables/set_logs.dart';
import 'tables/user_state.dart';
import 'tables/user_profiles.dart';
import 'tables/user_weights.dart';
import 'daos/program_dao.dart';
import 'daos/session_dao.dart';
import 'daos/user_dao.dart';
import 'daos/user_profile_dao.dart';
import '../program/phase_math.dart';

export 'tables/phases.dart';
export 'tables/sessions.dart';
export 'tables/blocks.dart';
export 'tables/exercises.dart';
export 'tables/block_exercises.dart';
export 'tables/workout_logs.dart';
export 'tables/set_logs.dart';
export 'tables/user_state.dart';
export 'tables/user_profiles.dart';
export 'tables/user_weights.dart';
export 'daos/program_dao.dart';
export 'daos/session_dao.dart';
export 'daos/user_dao.dart';
export 'daos/user_profile_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Phases,
    Sessions,
    Blocks,
    Exercises,
    BlockExercises,
    WorkoutLogs,
    SetLogs,
    UserStateTable,
    UserProfiles,
    UserWeights,
  ],
  daos: [ProgramDao, SessionDao, UserDao, UserProfileDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createUniqueIndexes();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(userProfiles);
          }
          if (from < 3) {
            await _createUniqueIndexes();
          }
          if (from < 4) {
            await m.addColumn(setLogs, setLogs.leftRepsCompleted);
            await m.addColumn(setLogs, setLogs.rightRepsCompleted);
          }
          if (from < 5) {
            await m.createTable(userWeights);
          }
          if (from < 6) {
            await m.addColumn(workoutLogs, workoutLogs.rpe);
          }
          if (from < 7) {
            await m.addColumn(workoutLogs, workoutLogs.sleepHours);
          }
          if (from < 8) {
            // Completion-anchored scheduling fields.
            await m.addColumn(userStateTable, userStateTable.currentWeek);
            await m.addColumn(userStateTable, userStateTable.weekAnchorDate);
            await m.addColumn(userStateTable, userStateTable.programComplete);
            // Backfill existing users from their current calendar position so
            // nobody loses their place on upgrade.
            final row = await userDao.getUserState();
            if (row != null) {
              final now = DateTime.now();
              final calendarWeek =
                  computeWeekNumber(row.programStartDate, now);
              final clampedWeek = calendarWeek < 1
                  ? 1
                  : (calendarWeek > kProgramWeeks ? kProgramWeeks : calendarWeek);
              // Anchor the current week to the upgrade day (not this Monday) so
              // the new 2-missed-days reset rule is NEVER applied retroactively
              // to days that elapsed under the old calendar-based version. The
              // current week effectively restarts fresh from the upgrade — no
              // surprise reset, no loss of this week's logged sessions.
              final today = DateTime(now.year, now.month, now.day);
              await userDao.updateScheduleState(
                currentWeek: clampedWeek,
                weekAnchorDate: today,
                programComplete: calendarWeek > kProgramWeeks,
              );
            }
          }
        },
      );

  /// Prevent duplicate rows at the database level. Defence-in-depth against
  /// a logic bug that would otherwise insert a second Session for the same
  /// (phase, weekDay), or a second SetLog for the same slot in one workout.
  Future<void> _createUniqueIndexes() async {
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS uq_sessions_phase_weekday '
      'ON sessions(phase_id, week_day)',
    );
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS uq_set_logs_slot '
      'ON set_logs(workout_log_id, block_exercise_id, set_number)',
    );
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'martial_body.db'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
