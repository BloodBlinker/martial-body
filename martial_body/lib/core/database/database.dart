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
import 'daos/program_dao.dart';
import 'daos/session_dao.dart';
import 'daos/user_dao.dart';
import 'daos/user_profile_dao.dart';

export 'tables/phases.dart';
export 'tables/sessions.dart';
export 'tables/blocks.dart';
export 'tables/exercises.dart';
export 'tables/block_exercises.dart';
export 'tables/workout_logs.dart';
export 'tables/set_logs.dart';
export 'tables/user_state.dart';
export 'tables/user_profiles.dart';
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
  ],
  daos: [ProgramDao, SessionDao, UserDao, UserProfileDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

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
