// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_dao.dart';

// ignore_for_file: type=lint
mixin _$SessionDaoMixin on DatabaseAccessor<AppDatabase> {
  $PhasesTable get phases => attachedDatabase.phases;
  $SessionsTable get sessions => attachedDatabase.sessions;
  $WorkoutLogsTable get workoutLogs => attachedDatabase.workoutLogs;
  $BlocksTable get blocks => attachedDatabase.blocks;
  $ExercisesTable get exercises => attachedDatabase.exercises;
  $BlockExercisesTable get blockExercises => attachedDatabase.blockExercises;
  $SetLogsTable get setLogs => attachedDatabase.setLogs;
  SessionDaoManager get managers => SessionDaoManager(this);
}

class SessionDaoManager {
  final _$SessionDaoMixin _db;
  SessionDaoManager(this._db);
  $$PhasesTableTableManager get phases =>
      $$PhasesTableTableManager(_db.attachedDatabase, _db.phases);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db.attachedDatabase, _db.sessions);
  $$WorkoutLogsTableTableManager get workoutLogs =>
      $$WorkoutLogsTableTableManager(_db.attachedDatabase, _db.workoutLogs);
  $$BlocksTableTableManager get blocks =>
      $$BlocksTableTableManager(_db.attachedDatabase, _db.blocks);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
  $$BlockExercisesTableTableManager get blockExercises =>
      $$BlockExercisesTableTableManager(
          _db.attachedDatabase, _db.blockExercises);
  $$SetLogsTableTableManager get setLogs =>
      $$SetLogsTableTableManager(_db.attachedDatabase, _db.setLogs);
}
