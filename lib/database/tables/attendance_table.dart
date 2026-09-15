import 'package:drift/drift.dart';
import 'employees_table.dart';

@DataClassName('AttendanceRecord')
class Attendance extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get employeeId => integer().references(Employees, #id)();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get checkIn => dateTime().nullable()();
  DateTimeColumn get checkOut => dateTime().nullable()();
  TextColumn get status => text()();
  TextColumn get note => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {employeeId, date}
      ];
}
