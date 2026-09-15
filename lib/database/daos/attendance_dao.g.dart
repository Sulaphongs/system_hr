// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_dao.dart';

// ignore_for_file: type=lint
mixin _$AttendanceDaoMixin on DatabaseAccessor<AppDatabase> {
  $PositionsTable get positions => attachedDatabase.positions;
  $MilitaryRanksTable get militaryRanks => attachedDatabase.militaryRanks;
  $EmployeesTable get employees => attachedDatabase.employees;
  $AttendanceTable get attendance => attachedDatabase.attendance;
  AttendanceDaoManager get managers => AttendanceDaoManager(this);
}

class AttendanceDaoManager {
  final _$AttendanceDaoMixin _db;
  AttendanceDaoManager(this._db);
  $$PositionsTableTableManager get positions =>
      $$PositionsTableTableManager(_db.attachedDatabase, _db.positions);
  $$MilitaryRanksTableTableManager get militaryRanks =>
      $$MilitaryRanksTableTableManager(_db.attachedDatabase, _db.militaryRanks);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db.attachedDatabase, _db.employees);
  $$AttendanceTableTableManager get attendance =>
      $$AttendanceTableTableManager(_db.attachedDatabase, _db.attendance);
}
