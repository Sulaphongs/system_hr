import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/attendance_table.dart';
import '../tables/employees_table.dart';

part 'attendance_dao.g.dart';

@DriftAccessor(tables: [Attendance, Employees])
class AttendanceDao extends DatabaseAccessor<AppDatabase>
    with _$AttendanceDaoMixin {
  AttendanceDao(super.db);

  Future<List<AttendanceRecord>> getByDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return (select(attendance)..where((t) => t.date.equals(d))).get();
  }

  Future<List<AttendanceRecord>> getByEmployee(int employeeId) =>
      (select(attendance)
            ..where((t) => t.employeeId.equals(employeeId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<void> upsertOne(AttendanceCompanion entry) =>
      into(attendance).insertOnConflictUpdate(entry);

  Future<int> countPresentToday() async {
    final today = DateTime.now();
    final d = DateTime(today.year, today.month, today.day);
    final countExpr = attendance.id.count();
    final query = selectOnly(attendance)
      ..addColumns([countExpr])
      ..where(attendance.date.equals(d) &
          attendance.status.equals('present'));
    return await query.map((row) => row.read(countExpr) ?? 0).getSingle();
  }
}
