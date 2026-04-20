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

part 'user_profile_dao.g.dart';

@DriftAccessor(tables: [UserProfiles])
class UserProfileDao extends DatabaseAccessor<AppDatabase>
    with _$UserProfileDaoMixin {
  UserProfileDao(super.db);

  Stream<UserProfile?> watchProfile() =>
      select(userProfiles).watchSingleOrNull();

  Future<UserProfile?> getProfile() =>
      select(userProfiles).getSingleOrNull();

  Future<void> upsertProfile({
    String? name,
    int? age,
    String? sex,
    double? weightKg,
    double? heightCm,
  }) async {
    final existing = await getProfile();
    if (existing == null) {
      await into(userProfiles).insert(UserProfilesCompanion.insert(
        name: Value(name),
        age: Value(age),
        sex: Value(sex),
        weightKg: Value(weightKg),
        heightCm: Value(heightCm),
      ));
    } else {
      await (update(userProfiles)..where((p) => p.id.equals(existing.id)))
          .write(UserProfilesCompanion(
        name: Value(name),
        age: Value(age),
        sex: Value(sex),
        weightKg: Value(weightKg),
        heightCm: Value(heightCm),
      ));
    }
  }
}
