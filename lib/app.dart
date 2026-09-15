import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'providers/settings_provider.dart';
import 'widgets/layout/app_shell.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/employees/employee_list_screen.dart';
import 'screens/employees/employee_form_screen.dart';
import 'screens/employees/employee_detail_screen.dart';
import 'screens/positions/position_list_screen.dart';
import 'screens/positions/position_form_screen.dart';
import 'screens/military_ranks/military_rank_list_screen.dart';
import 'screens/military_ranks/military_rank_form_screen.dart';
import 'screens/finance/finance_screen.dart';
import 'screens/payroll/payroll_list_screen.dart';
import 'screens/payroll/payroll_form_screen.dart';
import 'screens/reports/reports_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/org_chart/org_chart_screen.dart';

final _router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (_, __) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/employees',
          builder: (_, __) => const EmployeeListScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (_, __) => const EmployeeFormScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (_, s) => EmployeeDetailScreen(
                  id: int.parse(s.pathParameters['id']!)),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (_, s) => EmployeeFormScreen(
                      employeeId: int.parse(s.pathParameters['id']!)),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/positions',
          builder: (_, __) => const PositionListScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (_, __) => const PositionFormScreen(),
            ),
            GoRoute(
              path: ':id/edit',
              builder: (_, s) => PositionFormScreen(
                  positionId: int.parse(s.pathParameters['id']!)),
            ),
          ],
        ),
        GoRoute(
          path: '/military-ranks',
          builder: (_, __) => const MilitaryRankListScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (_, __) => const MilitaryRankFormScreen(),
            ),
            GoRoute(
              path: ':id/edit',
              builder: (_, s) => MilitaryRankFormScreen(
                  rankId: int.parse(s.pathParameters['id']!)),
            ),
          ],
        ),
        GoRoute(
          path: '/finance',
          builder: (_, __) => const FinanceScreen(),
        ),
        GoRoute(
          path: '/payroll',
          builder: (_, __) => const PayrollListScreen(),
          routes: [
            GoRoute(
              path: ':id/edit',
              builder: (_, s) => PayrollFormScreen(
                  payrollId: int.parse(s.pathParameters['id']!)),
            ),
          ],
        ),
        GoRoute(
          path: '/reports',
          builder: (_, __) => const ReportsScreen(),
        ),
        GoRoute(
          path: '/org-chart',
          builder: (_, __) => const OrgChartScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (_, __) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);

class HrApp extends StatelessWidget {
  const HrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appTitle,
      theme: AppColors.theme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final scale = context.watch<SettingsProvider>().fontScale;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(scale),
          ),
          child: child!,
        );
      },
    );
  }
}
