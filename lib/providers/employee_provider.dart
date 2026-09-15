import 'package:flutter/material.dart';
import '../database/daos/employee_dao.dart';
import '../database/app_database.dart';

class EmployeeProvider extends ChangeNotifier {
  final EmployeeDao _dao;

  List<EmployeeWithDetails> _all = [];
  bool _isLoading = false;
  String? _error;
  String _search = '';
  String _statusFilter = 'all';

  EmployeeProvider(this._dao) {
    load();
  }

  List<EmployeeWithDetails> get employees => _all;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get search => _search;
  String get statusFilter => _statusFilter;

  List<EmployeeWithDetails> get filtered {
    return _all.where((e) {
      final emp = e.employee;
      final matchSearch = _search.isEmpty ||
          emp.firstName.toLowerCase().contains(_search.toLowerCase()) ||
          emp.lastName.toLowerCase().contains(_search.toLowerCase()) ||
          emp.employeeCode.toLowerCase().contains(_search.toLowerCase());
      final matchStatus =
          _statusFilter == 'all' || emp.status == _statusFilter;
      return matchSearch && matchStatus;
    }).toList();
  }

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _all = await _dao.getAllWithDetails();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearch(String q) {
    _search = q;
    notifyListeners();
  }

  void setStatusFilter(String s) {
    _statusFilter = s;
    notifyListeners();
  }

  Future<Employee?> getById(int id) => _dao.getById(id);

  Future<List<Employee>> getActiveList() => _dao.getActive();

  Future<void> add(EmployeesCompanion entry) async {
    await _dao.insertOne(entry);
    await load();
  }

  Future<void> edit(EmployeesCompanion entry) async {
    await _dao.updateOne(entry);
    await load();
  }

  Future<void> importBatch(List<EmployeesCompanion> entries) async {
    for (final entry in entries) {
      await _dao.insertOne(entry);
    }
    await load();
  }

  Future<void> removeAll() async {
    await _dao.deleteAll();
    await load();
  }

  Future<void> remove(int id) async {
    await _dao.deleteOne(id);
    await load();
  }

  Future<int> countActive() => _dao.countActive();

  String get nextCode {
    int max = 0;
    for (final e in _all) {
      final match = RegExp(r'EMP(\d+)').firstMatch(e.employee.employeeCode);
      if (match != null) {
        final n = int.tryParse(match.group(1)!) ?? 0;
        if (n > max) max = n;
      }
    }
    return 'EMP${(max + 1).toString().padLeft(3, '0')}';
  }
}
