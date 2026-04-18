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
