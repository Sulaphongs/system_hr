// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_dao.dart';

// ignore_for_file: type=lint
mixin _$EmployeeDaoMixin on DatabaseAccessor<AppDatabase> {
  $PositionsTable get positions => attachedDatabase.positions;
  $MilitaryRanksTable get militaryRanks => attachedDatabase.militaryRanks;
  $EmployeesTable get employees => attachedDatabase.employees;
  EmployeeDaoManager get managers => EmployeeDaoManager(this);
}

class EmployeeDaoManager {
  final _$EmployeeDaoMixin _db;
  EmployeeDaoManager(this._db);
  $$PositionsTableTableManager get positions =>
      $$PositionsTableTableManager(_db.attachedDatabase, _db.positions);
  $$MilitaryRanksTableTableManager get militaryRanks =>
      $$MilitaryRanksTableTableManager(_db.attachedDatabase, _db.militaryRanks);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db.attachedDatabase, _db.employees);
}
