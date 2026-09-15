import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/payroll_table.dart';
import '../tables/employees_table.dart';

part 'payroll_dao.g.dart';

class PayrollWithEmployee {
  final PayrollRecord payroll;
  final Employee employee;

  PayrollWithEmployee({required this.payroll, required this.employee});
}

@DriftAccessor(tables: [Payroll, Employees])
class PayrollDao extends DatabaseAccessor<AppDatabase> with _$PayrollDaoMixin {
  PayrollDao(super.db);

  Future<List<PayrollRecord>> getByMonthYear(int month, int year) =>
      (select(payroll)
            ..where((t) => t.month.equals(month) & t.year.equals(year)))
          .get();

  Future<List<PayrollWithEmployee>> getWithEmployeesByMonthYear(
      int month, int year) async {
    final query = select(payroll).join([
      innerJoin(employees, employees.id.equalsExp(payroll.employeeId)),
    ])
      ..where(payroll.month.equals(month) & payroll.year.equals(year));
    final rows = await query.get();
    return rows
        .map((row) => PayrollWithEmployee(
              payroll: row.readTable(payroll),
              employee: row.readTable(employees),
            ))
        .toList();
  }

  Future<void> upsertOne(PayrollCompanion entry) =>
      into(payroll).insertOnConflictUpdate(entry);

  Future<void> insertIfNew(PayrollCompanion entry) =>
      into(payroll).insert(entry, mode: InsertMode.insertOrIgnore);

  Future<PayrollRecord?> getLatestForEmployee(int empId, int month, int year) async {
    final currentIndex = year * 12 + month;
    final rows = await (select(payroll)
          ..where((t) => t.employeeId.equals(empId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.year),
            (t) => OrderingTerm.desc(t.month),
          ]))
        .get();
    for (final row in rows) {
      if (row.year * 12 + row.month < currentIndex) return row;
    }
    return null;
  }

  Future<int> deleteOne(int id) =>
      (delete(payroll)..where((t) => t.id.equals(id))).go();

  Future<int> deleteByMonthYear(int month, int year) =>
      (delete(payroll)
            ..where((t) => t.month.equals(month) & t.year.equals(year)))
          .go();
}
