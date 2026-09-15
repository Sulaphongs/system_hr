import 'package:flutter/material.dart';
import '../database/daos/leave_dao.dart';
import '../database/app_database.dart';

class LeaveProvider extends ChangeNotifier {
  final LeaveDao _dao;

  List<Leave> _leaves = [];
  bool _isLoading = false;
  String _statusFilter = 'all';

  LeaveProvider(this._dao) {
    load();
  }

  bool get isLoading => _isLoading;
  String get statusFilter => _statusFilter;

  List<Leave> get filtered {
    if (_statusFilter == 'all') return _leaves;
    return _leaves
        .where((l) => l.approvalStatus == _statusFilter)
        .toList();
  }

  void setStatusFilter(String s) {
    _statusFilter = s;
    notifyListeners();
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _leaves = await _dao.getAll();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(LeavesCompanion entry) async {
    await _dao.insertOne(entry);
    await load();
  }

  Future<void> approve(int id) async {
    await _dao.updateStatus(id, 'approved');
    await load();
  }

  Future<void> reject(int id) async {
    await _dao.updateStatus(id, 'rejected');
    await load();
  }

  Future<void> remove(int id) async {
    await _dao.deleteOne(id);
    await load();
  }

  Future<int> countPending() => _dao.countPending();

  Future<List<Leave>> getByEmployee(int employeeId) =>
      _dao.getByEmployee(employeeId);
}
