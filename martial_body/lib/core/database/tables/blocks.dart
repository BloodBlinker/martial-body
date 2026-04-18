import 'package:drift/drift.dart';
import 'sessions.dart';

class Blocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  TextColumn get name => text()();
  IntColumn get blockOrder => integer()();
  TextColumn get blockType => text()(); // warmup|main|tendon|conditioning|grip|core|posterior|finishing|cooldown
  TextColumn get instructions => text().nullable()();
  IntColumn get durationMinutes => integer().nullable()();
}
