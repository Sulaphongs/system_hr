import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/daos/attendance_dao.dart';
import '../database/app_database.dart';
import '../core/utils/date_utils.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceDao _dao;

  List<AttendanceRecord> _records = [];
  DateTime _selectedDate = AppDateUtils.toDateOnly(DateTime.now());
  bool _isLoading = false;

  AttendanceProvider(this._dao) {
    load();
  }

  List<AttendanceRecord> get records => _records;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;

  void changeDate(DateTime date) {
    _selectedDate = AppDateUtils.toDateOnly(date);
    load();
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _records = await _dao.getByDate(_selectedDate);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> save(AttendanceCompanion entry) async {
    await _dao.upsertOne(entry);
    await load();
  }

  Future<void> markPresent(int employeeId) async {
    await _dao.upsertOne(AttendanceCompanion(
      employeeId: drift.Value(employeeId),
      date: drift.Value(_selectedDate),
      status: const drift.Value('present'),
      checkIn: drift.Value(DateTime.now()),
    ));
    await load();
  }

  Future<int> countPresentToday() => _dao.countPresentToday();
}
