import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'database/app_database.dart';
import 'providers/position_provider.dart';
import 'providers/military_rank_provider.dart';
import 'providers/employee_provider.dart';
import 'providers/payroll_provider.dart';
import 'providers/finance_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        ChangeNotifierProvider(
            create: (_) => PositionProvider(db.positionDao)),
        ChangeNotifierProvider(
            create: (_) => MilitaryRankProvider(db.militaryRankDao)),
        ChangeNotifierProvider(
            create: (_) => EmployeeProvider(db.employeeDao)),
        ChangeNotifierProvider(
            create: (_) => PayrollProvider(db.payrollDao)),
        ChangeNotifierProvider(
            create: (_) => FinanceProvider(db.financeDao)),
        ChangeNotifierProvider(
            create: (_) => DashboardProvider(db)),
        ChangeNotifierProvider(
            create: (_) => SettingsProvider()),
      ],
      child: const HrApp(),
    ),
  );
}
