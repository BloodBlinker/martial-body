// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dao.dart';

// ignore_for_file: type=lint
mixin _$UserDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserStateTableTable get userStateTable => attachedDatabase.userStateTable;
  UserDaoManager get managers => UserDaoManager(this);
}

class UserDaoManager {
  final _$UserDaoMixin _db;
  UserDaoManager(this._db);
  $$UserStateTableTableTableManager get userStateTable =>
      $$UserStateTableTableTableManager(
          _db.attachedDatabase, _db.userStateTable);
}
