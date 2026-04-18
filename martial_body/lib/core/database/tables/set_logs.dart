import 'package:drift/drift.dart';
import 'workout_logs.dart';
import 'block_exercises.dart';

class SetLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutLogId => integer().references(WorkoutLogs, #id)();
  IntColumn get blockExerciseId => integer().references(BlockExercises, #id)();
  IntColumn get setNumber => integer()();
  IntColumn get repsCompleted => integer().nullable()();
  RealColumn get weightKg => real().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
}
