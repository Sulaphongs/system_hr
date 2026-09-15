// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_dao.dart';

// ignore_for_file: type=lint
mixin _$LeaveDaoMixin on DatabaseAccessor<AppDatabase> {
  $PositionsTable get positions => attachedDatabase.positions;
  $MilitaryRanksTable get militaryRanks => attachedDatabase.militaryRanks;
  $EmployeesTable get employees => attachedDatabase.employees;
  $LeavesTable get leaves => attachedDatabase.leaves;
  LeaveDaoManager get managers => LeaveDaoManager(this);
}

class LeaveDaoManager {
  final _$LeaveDaoMixin _db;
  LeaveDaoManager(this._db);
  $$PositionsTableTableManager get positions =>
      $$PositionsTableTableManager(_db.attachedDatabase, _db.positions);
  $$MilitaryRanksTableTableManager get militaryRanks =>
      $$MilitaryRanksTableTableManager(_db.attachedDatabase, _db.militaryRanks);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db.attachedDatabase, _db.employees);
  $$LeavesTableTableManager get leaves =>
      $$LeavesTableTableManager(_db.attachedDatabase, _db.leaves);
}
