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
