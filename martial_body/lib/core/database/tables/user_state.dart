import 'package:drift/drift.dart';

// @DataClassName avoids a naming conflict between the table class and
// the generated data class (both would otherwise be called "UserState").
@DataClassName('UserStateRow')
class UserStateTable extends Table {
  @override
  String get tableName => 'user_state';

  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get programStartDate => dateTime()();
  BoolColumn get onboardingComplete => boolean().withDefault(const Constant(false))();
}
