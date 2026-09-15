// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_dao.dart';

// ignore_for_file: type=lint
mixin _$PositionDaoMixin on DatabaseAccessor<AppDatabase> {
  $PositionsTable get positions => attachedDatabase.positions;
  PositionDaoManager get managers => PositionDaoManager(this);
}

class PositionDaoManager {
  final _$PositionDaoMixin _db;
  PositionDaoManager(this._db);
  $$PositionsTableTableManager get positions =>
      $$PositionsTableTableManager(_db.attachedDatabase, _db.positions);
}
