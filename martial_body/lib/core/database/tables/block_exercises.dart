import 'package:drift/drift.dart';
import 'blocks.dart';
import 'exercises.dart';

class BlockExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get blockId => integer().references(Blocks, #id)();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get exerciseOrder => integer()();
  IntColumn get sets => integer().nullable()();
  TextColumn get reps => text().nullable()(); // "12", "8/leg", "30–45s", "Max time"
  TextColumn get tempo => text().nullable()(); // "3-1-1-0", "Static", "Controlled"
  IntColumn get restSeconds => integer().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isNew => boolean().withDefault(const Constant(false))();
}
