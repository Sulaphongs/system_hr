import 'package:drift/drift.dart';
import 'employees_table.dart';

class Leaves extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get employeeId => integer().references(Employees, #id)();
  TextColumn get leaveType => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get totalDays => integer()();
  TextColumn get reason => text().nullable()();
  TextColumn get approvalStatus =>
      text().withDefault(const Constant('pending'))();
  TextColumn get approvedBy => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
