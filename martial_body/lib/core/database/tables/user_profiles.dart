import 'package:drift/drift.dart';

/// Stores a single row of user biometric data (one profile per device).
class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  IntColumn get age => integer().nullable()();
  TextColumn get sex => text().nullable()(); // 'male' | 'female'
  RealColumn get weightKg => real().nullable()();
  RealColumn get heightCm => real().nullable()();
}
