import 'package:drift/drift.dart';
import 'phases.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get phaseId => integer().references(Phases, #id)();
  IntColumn get weekDay => integer()(); // 1=Mon … 5=Fri
  TextColumn get name => text()();
  TextColumn get focus => text()();
  IntColumn get estimatedMinutes => integer()();
}
