import 'package:drift/drift.dart';
import 'sessions.dart';

class WorkoutLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  IntColumn get weekNumber => integer()();
  IntColumn get phaseNumber => integer()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
}
