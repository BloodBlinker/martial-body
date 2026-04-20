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

part 'user_dao.g.dart';

@DriftAccessor(tables: [UserStateTable])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<UserStateRow?> getUserState() =>
      select(userStateTable).getSingleOrNull();

  Stream<UserStateRow?> watchUserState() =>
      select(userStateTable).watchSingleOrNull();

  Future<bool> hasUserState() async {
    final row = await getUserState();
    return row != null;
  }

  Future<int> insertUserState(DateTime programStartDate) =>
      into(userStateTable).insert(UserStateTableCompanion.insert(
        programStartDate: programStartDate,
        onboardingComplete: const Value(true),
      ));

  /// Overwrites the stored program start date. Used when correcting a
  /// stale/hardcoded development value on existing installs.
  Future<void> updateProgramStartDate(DateTime newDate) =>
      (update(userStateTable)).write(
        UserStateTableCompanion(programStartDate: Value(newDate)),
      );
}
