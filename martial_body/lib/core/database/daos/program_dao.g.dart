// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_dao.dart';

// ignore_for_file: type=lint
mixin _$ProgramDaoMixin on DatabaseAccessor<AppDatabase> {
  $PhasesTable get phases => attachedDatabase.phases;
  $SessionsTable get sessions => attachedDatabase.sessions;
  $BlocksTable get blocks => attachedDatabase.blocks;
  $ExercisesTable get exercises => attachedDatabase.exercises;
  $BlockExercisesTable get blockExercises => attachedDatabase.blockExercises;
  ProgramDaoManager get managers => ProgramDaoManager(this);
}

class ProgramDaoManager {
  final _$ProgramDaoMixin _db;
  ProgramDaoManager(this._db);
  $$PhasesTableTableManager get phases =>
      $$PhasesTableTableManager(_db.attachedDatabase, _db.phases);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db.attachedDatabase, _db.sessions);
  $$BlocksTableTableManager get blocks =>
      $$BlocksTableTableManager(_db.attachedDatabase, _db.blocks);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
  $$BlockExercisesTableTableManager get blockExercises =>
      $$BlockExercisesTableTableManager(
          _db.attachedDatabase, _db.blockExercises);
}
