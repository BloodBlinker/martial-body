import 'package:drift/drift.dart';

class Phases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get number => integer()(); // 1–4
  TextColumn get name => text()(); // "Foundation"
  TextColumn get subtitle => text()();
  IntColumn get weeksStart => integer()();
  IntColumn get weeksEnd => integer()();
  RealColumn get intensityMin => real()();
  RealColumn get intensityMax => real()();
  TextColumn get deloadWeeks => text()(); // JSON: "[4]"
  TextColumn get overviewText => text()();
}
