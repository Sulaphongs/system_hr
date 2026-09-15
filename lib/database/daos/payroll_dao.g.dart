// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_dao.dart';

// ignore_for_file: type=lint
mixin _$PayrollDaoMixin on DatabaseAccessor<AppDatabase> {
  $PositionsTable get positions => attachedDatabase.positions;
  $MilitaryRanksTable get militaryRanks => attachedDatabase.militaryRanks;
  $EmployeesTable get employees => attachedDatabase.employees;
  $PayrollTable get payroll => attachedDatabase.payroll;
  PayrollDaoManager get managers => PayrollDaoManager(this);
}

class PayrollDaoManager {
  final _$PayrollDaoMixin _db;
  PayrollDaoManager(this._db);
  $$PositionsTableTableManager get positions =>
      $$PositionsTableTableManager(_db.attachedDatabase, _db.positions);
  $$MilitaryRanksTableTableManager get militaryRanks =>
      $$MilitaryRanksTableTableManager(_db.attachedDatabase, _db.militaryRanks);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db.attachedDatabase, _db.employees);
  $$PayrollTableTableManager get payroll =>
      $$PayrollTableTableManager(_db.attachedDatabase, _db.payroll);
}
