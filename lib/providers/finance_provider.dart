import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../database/daos/finance_dao.dart';
import '../database/app_database.dart';

class FinanceProvider extends ChangeNotifier {
  final FinanceDao _dao;

  List<FinanceTransaction> _transactions = [];
  bool isLoading = false;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  String typeFilter = 'all'; // 'all', 'income', 'expense'

  FinanceProvider(this._dao) {
    load();
  }

  String _search = '';

  List<FinanceTransaction> get transactions => _transactions;

  List<FinanceTransaction> get filtered {
    var list = typeFilter == 'all'
        ? _transactions
        : _transactions.where((t) => t.type == typeFilter).toList();
    if (_search.isEmpty) return list;
    final q = _search.toLowerCase();
    return list
        .where((t) =>
            t.category.toLowerCase().contains(q) ||
            (t.description?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  void setSearch(String v) {
    _search = v;
    notifyListeners();
  }

  double get totalIncome => _transactions
      .where((t) => t.type == 'income')
      .fold(0.0, (s, t) => s + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == 'expense')
      .fold(0.0, (s, t) => s + t.amount);

  double get netBalance => totalIncome - totalExpense;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    try {
      _transactions = await _dao.getByMonthYear(selectedMonth, selectedYear);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeMonthYear(int month, int year) async {
    selectedMonth = month;
    selectedYear = year;
    await load();
  }

  void setTypeFilter(String filter) {
    typeFilter = filter;
    notifyListeners();
  }

  Future<void> add({
    required String type,
    required String category,
    required double amount,
    String? description,
    required DateTime date,
  }) async {
    await _dao.insertOne(FinanceTransactionsCompanion(
      type: Value(type),
      category: Value(category),
      amount: Value(amount),
      description: Value(description),
      transactionDate: Value(date),
    ));
    await load();
  }

  Future<void> edit({
    required int id,
    required String type,
    required String category,
    required double amount,
    String? description,
    required DateTime date,
  }) async {
    await _dao.updateOne(FinanceTransactionsCompanion(
      id: Value(id),
      type: Value(type),
      category: Value(category),
      amount: Value(amount),
      description: Value(description),
      transactionDate: Value(date),
    ));
    await load();
  }

  Future<void> remove(int id) async {
    await _dao.deleteOne(id);
    await load();
  }
}
