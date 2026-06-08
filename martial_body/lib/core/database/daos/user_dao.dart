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

  /// Create the user_state row when the user taps "Begin Program".
  /// Week 1 anchors to the install day (a brand-new user starts immediately),
  /// per the completion-anchored scheduling design.
  Future<int> insertUserState(DateTime programStartDate) =>
      into(userStateTable).insert(UserStateTableCompanion.insert(
        programStartDate: programStartDate,
        onboardingComplete: const Value(true),
        currentWeek: const Value(1),
        weekAnchorDate: Value(programStartDate),
        programComplete: const Value(false),
      ));

  /// Update any subset of the completion-anchored scheduling fields.
  Future<void> updateScheduleState({
    int? currentWeek,
    DateTime? weekAnchorDate,
    bool? programComplete,
  }) =>
      update(userStateTable).write(UserStateTableCompanion(
        currentWeek:
            currentWeek == null ? const Value.absent() : Value(currentWeek),
        weekAnchorDate: weekAnchorDate == null
            ? const Value.absent()
            : Value(weekAnchorDate),
        programComplete: programComplete == null
            ? const Value.absent()
            : Value(programComplete),
      ));

  /// Full reset back to Week 1 (used by the end-of-program "Reset" action).
  /// Profile is preserved; the caller wipes workout/weight data separately.
  Future<void> resetSchedule(DateTime anchor) =>
      update(userStateTable).write(UserStateTableCompanion(
        currentWeek: const Value(1),
        weekAnchorDate: Value(anchor),
        programComplete: const Value(false),
        programStartDate: Value(anchor),
      ));

  /// All bodyweight entries, oldest first — for the bodyweight trend chart.
  Future<List<UserWeight>> getAllWeights() =>
      (select(userWeights)..orderBy([(w) => OrderingTerm.asc(w.date)])).get();

  Stream<List<UserWeight>> watchAllWeights() =>
      (select(userWeights)..orderBy([(w) => OrderingTerm.asc(w.date)])).watch();

  /// Wipe all bodyweight history. Only used by the end-of-program full reset.
  Future<void> deleteAllWeights() => delete(userWeights).go();

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
