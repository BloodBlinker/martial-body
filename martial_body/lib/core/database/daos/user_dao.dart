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

@DriftAccessor(tables: [UserStateTable, UserWeights])
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

  /// Get the most recent weight entry.
  Future<UserWeight?> getLatestWeight() => (select(userWeights)
        ..orderBy([(w) => OrderingTerm.desc(w.date)])
        ..limit(1))
      .getSingleOrNull();

  /// Get weight recorded on a specific date (normalized to start of day).
  Future<UserWeight?> getWeightForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (select(userWeights)
          ..where((w) =>
              w.date.isBiggerOrEqualValue(startOfDay) &
              w.date.isSmallerThanValue(endOfDay)))
        .getSingleOrNull();
  }

  /// Insert or update weight for today. If a weight already exists for today,
  /// it's overwritten. Otherwise, a new entry is created.
  Future<void> upsertTodayWeight(double weightKg) async {
    final today = DateTime.now();
    final existing = await getWeightForDate(today);
    if (existing != null) {
      await (update(userWeights)..where((w) => w.id.equals(existing.id)))
          .write(UserWeightsCompanion(weightKg: Value(weightKg)));
    } else {
      await into(userWeights).insert(UserWeightsCompanion.insert(
        date: DateTime.now(),
        weightKg: weightKg,
      ));
    }
  }
}
