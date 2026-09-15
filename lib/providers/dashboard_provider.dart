import 'package:flutter/material.dart';
import '../database/app_database.dart';

class MonthlyFinanceData {
  final int month;
  final int year;
  final double income;
  final double expense;

  const MonthlyFinanceData({
    required this.month,
    required this.year,
    this.income = 0,
    this.expense = 0,
  });

  double get net => income - expense;
}

class DashboardProvider extends ChangeNotifier {
  final AppDatabase _db;

  int totalEmployees = 0;
  int totalPositions = 0;
  double monthlyIncome = 0;
  double monthlyExpense = 0;
  List<MonthlyFinanceData> chartData = [];
  bool isLoading = false;

  DashboardProvider(this._db) {
    refresh();
  }

  double get netBalance => monthlyIncome - monthlyExpense;

  Future<void> refresh() async {
    isLoading = true;
    notifyListeners();
    try {
      final now = DateTime.now();

      totalEmployees = await _db.employeeDao.countActive();
      totalPositions = await _db.positionDao.countAll();
      monthlyIncome = await _db.financeDao
          .sumByTypeAndMonthYear('income', now.month, now.year);
      monthlyExpense = await _db.financeDao
          .sumByTypeAndMonthYear('expense', now.month, now.year);

      // Last 6 months for chart (i=5 oldest … i=0 current)
      final list = <MonthlyFinanceData>[];
      for (int i = 5; i >= 0; i--) {
        final d = DateTime(now.year, now.month - i, 1);
        final inc = await _db.financeDao
            .sumByTypeAndMonthYear('income', d.month, d.year);
        final exp = await _db.financeDao
            .sumByTypeAndMonthYear('expense', d.month, d.year);
        list.add(MonthlyFinanceData(
            month: d.month, year: d.year, income: inc, expense: exp));
      }
      chartData = list;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
