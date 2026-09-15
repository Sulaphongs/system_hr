import '../../database/app_database.dart';

class CsvPayrollRow {
  final String rawName;
  final String rawRankCode;
  int? employeeId;

  final double rankSalary;
  final double dutyAllowance;
  final double seniorityAllowance;
  final double militaryBonus;
  final double specialistAllowance;
  final double nutritionAllowance;
  final double costOfLivingAllowance;
  // ຈຳນວນຄົນ (col 13 / 15) — amount ຄຳນວນໃນ provider: count × 200,000
  final int wifeCount;
  final int childrenCount;
  final double totalIncome;
  final double socialSecurity;
  final double incomeTax;
  final double tenPercentDeduction;
  final double riceDeduction;
  final double totalDeductions;
  final double netPay;

  CsvPayrollRow({
    required this.rawName,
    required this.rawRankCode,
    this.employeeId,
    required this.rankSalary,
    required this.dutyAllowance,
    required this.seniorityAllowance,
    required this.militaryBonus,
    required this.specialistAllowance,
    required this.nutritionAllowance,
    required this.costOfLivingAllowance,
    required this.wifeCount,
    required this.childrenCount,
    required this.totalIncome,
    required this.socialSecurity,
    required this.incomeTax,
    required this.tenPercentDeduction,
    required this.riceDeduction,
    required this.totalDeductions,
    required this.netPay,
  });
}

List<CsvPayrollRow> parseCsvPayroll(String content) {
  // Strip UTF-8 BOM if present
  if (content.startsWith('﻿')) {
    content = content.substring(1);
  }

  final lines = content.split('\n');
  final rows = <CsvPayrollRow>[];

  for (final raw in lines) {
    final line = raw.trimRight();
    if (line.isEmpty) continue;

    final cols = _parseCsvLine(line);
    if (cols.isEmpty) continue;

    final first = cols[0].trim();

    // Skip header rows: first cell is not a positive integer
    final seq = int.tryParse(first);
    if (seq == null || seq <= 0) continue;

    // Stop at summary row (col[0] might be "ລວມ" — caught by tryParse returning null above)
    if (cols.length < 24) continue;

    rows.add(CsvPayrollRow(
      rawName: _str(cols, 2),
      rawRankCode: _str(cols, 1),
      rankSalary: _num(cols, 5),
      dutyAllowance: _num(cols, 6),
      seniorityAllowance: _num(cols, 7),
      militaryBonus: _num(cols, 8),
      specialistAllowance: _num(cols, 9),
      nutritionAllowance: _num(cols, 10),
      costOfLivingAllowance: _num(cols, 11),
      // col 12 = sub-total (skip)
      wifeCount: _int(cols, 13),      // col 13 = ຈ/ນ ເມຍ
      // col 14 = wife amount (ignored — recalculated from count)
      childrenCount: _int(cols, 15),  // col 15 = ຈ/ນ ລູກ
      // col 16 = children amount (ignored — recalculated from count)
      totalIncome: _num(cols, 17),
      socialSecurity: _num(cols, 18),
      incomeTax: _num(cols, 19),
      tenPercentDeduction: _num(cols, 20),
      riceDeduction: _num(cols, 21),
      totalDeductions: _num(cols, 22),
      netPay: _num(cols, 23),
    ));
  }

  return rows;
}

/// Match CSV rows to employees by normalising the CSV name and comparing
/// against firstName + " " + lastName of each employee.
void matchEmployees(List<CsvPayrollRow> rows, List<Employee> employees) {
  for (final row in rows) {
    final csvName = _normaliseName(row.rawName);
    // Exact match first
    int? found;
    for (final e in employees) {
      final empName = '${e.firstName} ${e.lastName}'.trim();
      if (empName == csvName) {
        found = e.id;
        break;
      }
    }
    // Fallback: contains match (either direction)
    if (found == null) {
      for (final e in employees) {
        final empName = '${e.firstName} ${e.lastName}'.trim();
        if (empName.contains(csvName) || csvName.contains(empName)) {
          found = e.id;
          break;
        }
      }
    }
    row.employeeId = found;
  }
}

// ─── Employee CSV ─────────────────────────────────────────────────────────────

class CsvEmployeeRow {
  final String rawName;
  final String rankCode;   // col[1], e.g. "ທ/ອ"
  final String hireDateRaw; // col[3], e.g. "8.1986"
  final double salary;     // col[5]

  // Resolved
  String firstName;
  String lastName;
  DateTime? hireDate;
  int? militaryRankId;
  String militaryRankName;
  bool isExisting;

  CsvEmployeeRow({
    required this.rawName,
    required this.rankCode,
    required this.hireDateRaw,
    required this.salary,
    this.firstName = '',
    this.lastName = '',
    this.hireDate,
    this.militaryRankId,
    this.militaryRankName = '',
    this.isExisting = false,
  });
}

List<CsvEmployeeRow> parseCsvEmployees(String content) {
  if (content.startsWith('﻿')) content = content.substring(1);
  final lines = content.split('\n');
  final rows = <CsvEmployeeRow>[];
  for (final raw in lines) {
    final line = raw.trimRight();
    if (line.isEmpty) continue;
    final cols = _parseCsvLine(line);
    if (cols.isEmpty) continue;
    final seq = int.tryParse(cols[0].trim());
    if (seq == null || seq <= 0) continue;
    if (cols.length < 6) continue;
    // Skip column-number header row (col[1] is a bare integer like "2")
    if (int.tryParse(cols[1].trim()) != null) continue;
    rows.add(CsvEmployeeRow(
      rawName: _str(cols, 2),
      rankCode: _str(cols, 1),
      hireDateRaw: _str(cols, 3),
      salary: _num(cols, 5),
    ));
  }
  return rows;
}

/// Resolve names, hire dates, rank IDs, and flag existing employees.
void resolveEmployeeRows(
  List<CsvEmployeeRow> rows,
  List<MilitaryRank> ranks,
  List<Employee> existing,
) {
  for (final row in rows) {
    // ── Name split ──────────────────────────────────────────────────
    final clean = _normaliseName(row.rawName);
    final parts = clean.split(' ');
    row.firstName = parts.isNotEmpty ? parts.first : clean;
    row.lastName = parts.length > 1 ? parts.skip(1).join(' ') : '';

    // ── Hire date ───────────────────────────────────────────────────
    final dateParts = row.hireDateRaw.split('.');
    if (dateParts.length == 2) {
      final month = int.tryParse(dateParts[0]) ?? 1;
      var yearStr = dateParts[1].trim();
      // Fix truncated 3-digit years starting with "2" (202 → 2020)
      if (yearStr.length == 3 && yearStr.startsWith('2')) yearStr += '0';
      var year = int.tryParse(yearStr) ?? 0;
      if (year < 100) year += 2000;
      if (year >= 1900 && month >= 1 && month <= 12) {
        row.hireDate = DateTime(year, month, 1);
      }
    }

    // ── Military rank ───────────────────────────────────────────────
    final code = row.rankCode.trim();
    final rank = ranks.where((r) => r.code.trim() == code).firstOrNull;
    row.militaryRankId = rank?.id;
    row.militaryRankName = rank?.name ?? code;

    // ── Duplicate check ─────────────────────────────────────────────
    final fullName = '${row.firstName} ${row.lastName}'.trim();
    row.isExisting = existing.any((e) =>
        '${e.firstName} ${e.lastName}'.trim() == fullName);
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

/// Strip known Lao title prefixes and rank suffixes from a name string.
String _normaliseName(String raw) {
  var s = raw.trim();
  // Remove rank suffix in parentheses: "(ທ/ນ)", "(ທ/ອ)", etc.
  s = s.replaceAll(RegExp(r'\([^)]*\)'), '');
  // Remove common title prefixes
  for (final prefix in ['ທ.', 'ນ.', 'ທ/ນ.', 'ວ/ດ.', 'ທ/', 'ວ/', 'ສ/', 'ທທ']) {
    if (s.startsWith(prefix)) {
      s = s.substring(prefix.length);
    }
  }
  // Collapse multiple spaces
  return s.trim().replaceAll(RegExp(r'\s+'), ' ');
}

String _str(List<String> cols, int i) =>
    i < cols.length ? cols[i].trim() : '';

double _num(List<String> cols, int i) {
  if (i >= cols.length) return 0.0;
  final s = cols[i].replaceAll(RegExp(r'[\s,]'), '').trim();
  return double.tryParse(s) ?? 0.0;
}

int _int(List<String> cols, int i) {
  if (i >= cols.length) return 0;
  final s = cols[i].replaceAll(RegExp(r'[\s,]'), '').trim();
  return int.tryParse(s) ?? 0;
}

/// Minimal CSV line parser that respects double-quoted fields.
List<String> _parseCsvLine(String line) {
  final result = <String>[];
  final buf = StringBuffer();
  bool inQuotes = false;

  for (int i = 0; i < line.length; i++) {
    final ch = line[i];
    if (ch == '"') {
      if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
        // Escaped quote inside quoted field
        buf.write('"');
        i++;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (ch == ',' && !inQuotes) {
      result.add(buf.toString());
      buf.clear();
    } else {
      buf.write(ch);
    }
  }
  result.add(buf.toString());
  return result;
}
