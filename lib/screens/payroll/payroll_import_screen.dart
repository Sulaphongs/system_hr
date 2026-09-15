import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/csv_parser.dart';
import '../../core/utils/currency_utils.dart';
import '../../providers/employee_provider.dart';
import '../../providers/payroll_provider.dart';

class PayrollImportScreen extends StatefulWidget {
  final int initialMonth;
  final int initialYear;

  const PayrollImportScreen({
    super.key,
    required this.initialMonth,
    required this.initialYear,
  });

  @override
  State<PayrollImportScreen> createState() => _PayrollImportScreenState();
}

class _PayrollImportScreenState extends State<PayrollImportScreen> {
  late int _month;
  late int _year;
  List<CsvPayrollRow>? _rows;
  String? _fileName;
  bool _importing = false;

  @override
  void initState() {
    super.initState();
    _month = widget.initialMonth;
    _year = widget.initialYear;
  }

  int get _matched => _rows?.where((r) => r.employeeId != null).length ?? 0;
  int get _total => _rows?.length ?? 0;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;

    // Prefer in-memory bytes; fall back to path on desktop
    List<int> bytes;
    if (file.bytes != null) {
      bytes = file.bytes!;
    } else if (file.path != null) {
      bytes = await File(file.path!).readAsBytes();
    } else {
      return;
    }

    final content = utf8.decode(bytes, allowMalformed: true);

    if (!mounted) return;
    final employees = context.read<EmployeeProvider>().employees;
    final allEmployees = employees.map((e) => e.employee).toList();

    final rows = parseCsvPayroll(content);
    matchEmployees(rows, allEmployees);

    setState(() {
      _rows = rows;
      _fileName = file.name;
    });
  }

  Future<void> _import() async {
    final rows = _rows;
    if (rows == null) return;
    setState(() => _importing = true);
    try {
      final provider = context.read<PayrollProvider>();
      final count = await provider.importFromCsv(rows, _month, _year);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('ນຳເຂົ້າສຳເລັດ $count ລາຍການ'),
        backgroundColor: AppColors.success,
      ));
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ນຳເຂົ້າເງິນເດືອນ CSV')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildToolbar(),
          const Divider(height: 1),
          Expanded(child: _rows == null ? _buildEmpty() : _buildPreview()),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.upload_file),
            label: const Text('ເລືອກໄຟລ໌ CSV'),
            onPressed: _pickFile,
          ),
          if (_fileName != null) ...[
            const SizedBox(width: 12),
            Text(_fileName!,
                style: const TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.grey)),
          ],
          const SizedBox(width: 24),
          const Text(AppStrings.month,
              style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: _month,
            items: List.generate(12, (i) => i + 1)
                .map((m) => DropdownMenuItem(
                    value: m, child: Text(AppStrings.months[m - 1])))
                .toList(),
            onChanged: (v) => setState(() => _month = v!),
          ),
          const SizedBox(width: 16),
          const Text(AppStrings.year,
              style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: _year,
            items: List.generate(5, (i) => DateTime.now().year - 2 + i)
                .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                .toList(),
            onChanged: (v) => setState(() => _year = v!),
          ),
          const Spacer(),
          if (_rows != null)
            Text(
              'ພົບ $_matched / $_total ພະນັກງານ',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      _matched == _total ? AppColors.success : AppColors.warning),
            ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            icon: _importing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.download_done),
            label: const Text('ນຳເຂົ້າ'),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white),
            onPressed: (_rows != null && _matched > 0 && !_importing)
                ? _import
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.upload_file, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('ກະລຸນາເລືອກໄຟລ໌ CSV ເງິນເດືອນ',
              style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final rows = _rows!;
    final matched = rows.where((r) => r.employeeId != null).toList();
    final unmatched = rows.where((r) => r.employeeId == null).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (unmatched.isNotEmpty) ...[
            _sectionHeader(
                'ບໍ່ພົບໃນລະບົບ (${unmatched.length} ລາຍການ — ຈະຖືກຂ້າມ)',
                Colors.red.shade700),
            const SizedBox(height: 4),
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: unmatched
                      .map((r) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(children: [
                              const Icon(Icons.warning_amber,
                                  size: 16, color: Colors.red),
                              const SizedBox(width: 6),
                              Text(r.rawName,
                                  style: const TextStyle(color: Colors.red)),
                            ]),
                          ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _sectionHeader(
              'ຈະນຳເຂົ້າ (${matched.length} ລາຍການ)', AppColors.success),
          const SizedBox(height: 4),
          Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                headingRowColor: WidgetStateProperty.all(
                    AppColors.primary.withValues(alpha: 0.08)),
                columns: const [
                  DataColumn(label: Text('ຊື່-ນາມສະກຸນ')),
                  DataColumn(label: Text('ເງິນຍົດ'), numeric: true),
                  DataColumn(label: Text('ໜ້າທີ'), numeric: true),
                  DataColumn(label: Text('ອາວຸໂສ'), numeric: true),
                  DataColumn(label: Text('30%'), numeric: true),
                  DataColumn(label: Text('ວິຊາສະ'), numeric: true),
                  DataColumn(label: Text('ໂພ'), numeric: true),
                  DataColumn(label: Text('ຄ.ດ.'), numeric: true),
                  DataColumn(label: Text('ກິດ'), numeric: true),
                  DataColumn(label: Text('ລູກ'), numeric: true),
                  DataColumn(label: Text('ລວມຮັບ'), numeric: true),
                  DataColumn(label: Text('8%'), numeric: true),
                  DataColumn(label: Text('5%'), numeric: true),
                  DataColumn(label: Text('10%'), numeric: true),
                  DataColumn(label: Text('ອ້ານ'), numeric: true),
                  DataColumn(label: Text('ລວມຫັກ'), numeric: true),
                  DataColumn(label: Text('ສຸດທິ'), numeric: true),
                ],
                rows: matched.map((r) {
                  return DataRow(cells: [
                    DataCell(Text(_normaliseName(r.rawName))),
                    DataCell(Text(_fmt(r.rankSalary))),
                    DataCell(Text(_fmt(r.dutyAllowance))),
                    DataCell(Text(_fmt(r.seniorityAllowance))),
                    DataCell(Text(_fmt(r.militaryBonus))),
                    DataCell(Text(_fmt(r.specialistAllowance))),
                    DataCell(Text(_fmt(r.nutritionAllowance))),
                    DataCell(Text(_fmt(r.costOfLivingAllowance))),
                    DataCell(Text(_fmt(r.wifeAllowance))),
                    DataCell(Text(_fmt(r.childrenAllowance))),
                    DataCell(Text(_fmt(r.totalIncome),
                        style: const TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(Text(_fmt(r.socialSecurity))),
                    DataCell(Text(_fmt(r.incomeTax))),
                    DataCell(Text(_fmt(r.tenPercentDeduction))),
                    DataCell(Text(_fmt(r.riceDeduction))),
                    DataCell(Text(_fmt(r.totalDeductions))),
                    DataCell(Text(_fmt(r.netPay),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary))),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text, Color color) => Text(text,
      style:
          TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14));

  String _fmt(double v) => v == 0 ? '-' : CurrencyUtils.formatCompact(v);

  String _normaliseName(String raw) {
    var s = raw.trim().replaceAll(RegExp(r'\([^)]*\)'), '');
    for (final p in ['ທ.', 'ນ.', 'ທ/ນ.', 'ວ/ດ.']) {
      if (s.startsWith(p)) s = s.substring(p.length);
    }
    return s.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
