import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/daos/payroll_dao.dart';
import '../database/app_database.dart';
import '../core/utils/csv_parser.dart';
import '../core/utils/date_utils.dart';

class PayrollProvider extends ChangeNotifier {
  final PayrollDao _dao;

  List<PayrollWithEmployee> _records = [];
  bool _isLoading = false;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  PayrollProvider(this._dao) {
    load();
  }

  String _search = '';

  List<PayrollWithEmployee> get records => _records;
  bool get isLoading => _isLoading;
  int get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedYear;

  List<PayrollWithEmployee> get filtered {
    if (_search.isEmpty) return _records;
    final q = _search.toLowerCase();
    return _records.where((r) =>
        '${r.employee.firstName} ${r.employee.lastName}'.toLowerCase().contains(q) ||
        r.employee.employeeCode.toLowerCase().contains(q)).toList();
  }

  void setSearch(String v) {
    _search = v;
    notifyListeners();
  }

  void changeMonthYear(int month, int year) {
    _selectedMonth = month;
    _selectedYear = year;
    load();
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _records = await _dao.getWithEmployeesByMonthYear(
          _selectedMonth, _selectedYear);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> upsert(PayrollCompanion entry) async {
    await _dao.upsertOne(entry);
    await load();
  }

  Future<void> generateForEmployees(List<Employee> employees) async {
    for (final emp in employees) {
      // Auto-calculated fields (always fresh)
      final rankSal = emp.salary;
      final militaryBonus = (rankSal * 0.30).roundToDouble();

      // Copy manually-entered fields from most recent previous month
      final prev = await _dao.getLatestForEmployee(emp.id, _selectedMonth, _selectedYear);
      final years = AppDateUtils.yearsOfServiceInt(emp.hireDate);
      final seniority = AppDateUtils.calcSeniorityAllowance(years);
      final dutyAll        = prev?.dutyAllowance        ?? 0.0;
      final specialistAll  = prev?.specialistAllowance  ?? 0.0;
      final nutritionAll   = prev?.nutritionAllowance   ?? 0.0;
      // ຈຳນວນຄົນ × 200,000 ກີບ
      final wifeCount      = prev?.wifeCount            ?? 0;
      final childrenCount  = prev?.childrenCount        ?? 0;
      final wifeAll        = wifeCount * 200000.0;
      final childrenAll    = childrenCount * 200000.0;
      final costOfLivingAll  = prev?.costOfLivingAllowance  ?? 0.0;
      final professionalAll  = prev?.professionalAllowance  ?? 0.0;
      final certificateAll   = prev?.certificateAllowance   ?? 0.0;
      final extraMealAll     = prev?.extraMealAllowance     ?? 0.0;
      final incomeTax        = prev?.incomeTax              ?? 0.0;
      final clothingDeduct   = prev?.clothingDeduction      ?? 0.0;
      final utilityDeduct    = prev?.utilityDeduction       ?? 0.0;
      final riceDeduct       = prev?.riceDeduction          ?? 0.0;
      final foodRateDeduct   = prev?.foodRateDeduction      ?? 0.0;
      final tenPercentDeduct = prev?.tenPercentDeduction    ?? 0.0;
      final socialSecurity   = prev?.socialSecurity          ?? 0.0;

      final total = rankSal + militaryBonus + seniority + dutyAll + specialistAll +
          extraMealAll + childrenAll + nutritionAll + costOfLivingAll +
          professionalAll + certificateAll;
      final totalDeduct = socialSecurity + incomeTax + clothingDeduct + utilityDeduct +
          riceDeduct + foodRateDeduct + tenPercentDeduct;
      final net = total - totalDeduct;

      await _dao.insertIfNew(PayrollCompanion(
        employeeId: drift.Value(emp.id),
        month: drift.Value(_selectedMonth),
        year: drift.Value(_selectedYear),
        rankSalary: drift.Value(rankSal),
        dutyAllowance: drift.Value(dutyAll),
        seniorityAllowance: drift.Value(seniority),
        militaryBonus: drift.Value(militaryBonus),
        specialistAllowance: drift.Value(specialistAll),
        nutritionAllowance: drift.Value(nutritionAll),
        childrenAllowance: drift.Value(childrenAll),
        childrenCount: drift.Value(childrenCount),
        wifeAllowance: drift.Value(wifeAll),
        wifeCount: drift.Value(wifeCount),
        costOfLivingAllowance: drift.Value(costOfLivingAll),
        professionalAllowance: drift.Value(professionalAll),
        certificateAllowance: drift.Value(certificateAll),
        extraMealAllowance: drift.Value(extraMealAll),
        totalIncome: drift.Value(total),
        socialSecurity: drift.Value(socialSecurity),
        incomeTax: drift.Value(incomeTax),
        clothingDeduction: drift.Value(clothingDeduct),
        utilityDeduction: drift.Value(utilityDeduct),
        riceDeduction: drift.Value(riceDeduct),
        foodRateDeduction: drift.Value(foodRateDeduct),
        tenPercentDeduction: drift.Value(tenPercentDeduct),
        totalDeductions: drift.Value(totalDeduct),
        netPay: drift.Value(net),
      ));
    }
    await load();
  }

  Future<void> remove(int id) async {
    await _dao.deleteOne(id);
    await load();
  }

  Future<void> removeAll() async {
    await _dao.deleteByMonthYear(_selectedMonth, _selectedYear);
    await load();
  }

  Future<void> removeMultiple(List<int> ids) async {
    for (final id in ids) {
      await _dao.deleteOne(id);
    }
    await load();
  }

  /// Import payroll rows parsed from a CSV file.
  /// Returns the number of records successfully inserted/updated.
  Future<int> importFromCsv(
      List<CsvPayrollRow> rows, int month, int year) async {
    int count = 0;
    for (final row in rows) {
      if (row.employeeId == null) continue;
      await _dao.upsertOne(PayrollCompanion(
        employeeId: drift.Value(row.employeeId!),
        month: drift.Value(month),
        year: drift.Value(year),
        rankSalary: drift.Value(row.rankSalary),
        dutyAllowance: drift.Value(row.dutyAllowance),
        seniorityAllowance: drift.Value(row.seniorityAllowance),
        militaryBonus: drift.Value(row.militaryBonus),
        specialistAllowance: drift.Value(row.specialistAllowance),
        nutritionAllowance: drift.Value(row.nutritionAllowance),
        costOfLivingAllowance: drift.Value(row.costOfLivingAllowance),
        wifeAllowance: drift.Value(row.wifeCount * 200000.0),
        wifeCount: drift.Value(row.wifeCount),
        childrenAllowance: drift.Value(row.childrenCount * 200000.0),
        childrenCount: drift.Value(row.childrenCount),
        totalIncome: drift.Value(row.totalIncome),
        socialSecurity: drift.Value(row.socialSecurity),
        incomeTax: drift.Value(row.incomeTax),
        tenPercentDeduction: drift.Value(row.tenPercentDeduction),
        riceDeduction: drift.Value(row.riceDeduction),
        totalDeductions: drift.Value(row.totalDeductions),
        netPay: drift.Value(row.netPay),
      ));
      count++;
    }
    await load();
    return count;
  }
}
