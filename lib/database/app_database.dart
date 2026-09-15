import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/positions_table.dart';
import 'tables/military_ranks_table.dart';
import 'tables/employees_table.dart';
import 'tables/attendance_table.dart';
import 'tables/leaves_table.dart';
import 'tables/payroll_table.dart';
import 'tables/finance_table.dart';
import 'daos/position_dao.dart';
import 'daos/military_rank_dao.dart';
import 'daos/employee_dao.dart';
import 'daos/attendance_dao.dart';
import 'daos/leave_dao.dart';
import 'daos/payroll_dao.dart';
import 'daos/finance_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Positions, MilitaryRanks, Employees, Attendance, Leaves, Payroll, FinanceTransactions],
  daos: [
    PositionDao,
    MilitaryRankDao,
    EmployeeDao,
    AttendanceDao,
    LeaveDao,
    PayrollDao,
    FinanceDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          await m.createAll();
          if (from < 5) {
            await customStatement('ALTER TABLE payroll ADD COLUMN professional_allowance REAL NOT NULL DEFAULT 0.0');
            await customStatement('ALTER TABLE payroll ADD COLUMN certificate_allowance REAL NOT NULL DEFAULT 0.0');
            await customStatement('ALTER TABLE payroll ADD COLUMN extra_meal_allowance REAL NOT NULL DEFAULT 0.0');
            await customStatement('ALTER TABLE payroll ADD COLUMN ten_percent_deduction REAL NOT NULL DEFAULT 0.0');
          }
          if (from < 6) {
            await customStatement('ALTER TABLE payroll ADD COLUMN wife_count INTEGER NOT NULL DEFAULT 0');
            await customStatement('ALTER TABLE payroll ADD COLUMN children_count INTEGER NOT NULL DEFAULT 0');
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'system_hr.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
