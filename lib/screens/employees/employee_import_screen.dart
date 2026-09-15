import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/csv_parser.dart';
import '../../core/utils/currency_utils.dart';
import '../../database/app_database.dart';
import '../../providers/employee_provider.dart';
import '../../providers/military_rank_provider.dart';

class EmployeeImportScreen extends StatefulWidget {
  const EmployeeImportScreen({super.key});

  @override
  State<EmployeeImportScreen> createState() => _EmployeeImportScreenState();
}

class _EmployeeImportScreenState extends State<EmployeeImportScreen> {
  List<CsvEmployeeRow>? _rows;
  String? _fileName;
  bool _importing = false;

  int get _newCount => _rows?.where((r) => !r.isExisting).length ?? 0;
  int get _existingCount => _rows?.where((r) => r.isExisting).length ?? 0;
  int get _total => _rows?.length ?? 0;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;

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
    final empProvider = context.read<EmployeeProvider>();
    final rankProvider = context.read<MilitaryRankProvider>();

    // Ensure providers have finished their async load before matching
    if (empProvider.employees.isEmpty) await empProvider.load();
    if (rankProvider.ranks.isEmpty) await rankProvider.load();

    final allEmployees = empProvider.employees.map((e) => e.employee).toList();
    final ranks = rankProvider.ranks;

    final rows = parseCsvEmployees(content);
    resolveEmployeeRows(rows, ranks, allEmployees);

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
      final provider = context.read<EmployeeProvider>();
      await provider.load();
      int maxCode = _parseMaxCode(provider);

      final entries = <EmployeesCompanion>[];
      for (final row in rows) {
        if (row.isExisting) continue;
        maxCode++;
        final code = 'EMP${maxCode.toString().padLeft(3, '0')}';
        // lastName requires min length 1 — use '-' as placeholder if single-word name
        final lastName = row.lastName.isEmpty ? '-' : row.lastName;
        entries.add(EmployeesCompanion(
          employeeCode: drift.Value(code),
          firstName: drift.Value(row.firstName),
          lastName: drift.Value(lastName),
          gender: const drift.Value('male'),
          hireDate: drift.Value(row.hireDate ?? DateTime(2000, 1, 1)),
          militaryRankId: drift.Value(row.militaryRankId),
          salary: drift.Value(row.salary),
          status: const drift.Value('active'),
        ));
      }

      await provider.importBatch(entries);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('ນຳເຂົ້າສຳເລັດ ${entries.length} ພະນັກງານ'),
        backgroundColor: AppColors.success,
      ));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('ເກີດຂໍ້ຜິດພາດ: $e'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 8),
      ));
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  int _parseMaxCode(EmployeeProvider provider) {
    int max = 0;
    for (final e in provider.employees) {
      final match = RegExp(r'EMP(\d+)').firstMatch(e.employee.employeeCode);
      if (match != null) {
        final n = int.tryParse(match.group(1)!) ?? 0;
        if (n > max) max = n;
      }
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ນຳເຂົ້າພະນັກງານ CSV')),
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
          const Spacer(),
          if (_rows != null) ...[
            _statChip('ໃໝ່: $_newCount', AppColors.success),
            const SizedBox(width: 8),
            if (_existingCount > 0)
              _statChip('ມີຢູ່ແລ້ວ: $_existingCount (ຂ້າມ)', Colors.orange),
            const SizedBox(width: 8),
            _statChip('ທັງໝົດ: $_total', Colors.blueGrey),
            const SizedBox(width: 16),
          ],
          ElevatedButton.icon(
            icon: _importing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.person_add_rounded),
            label: const Text('ນຳເຂົ້າ'),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white),
            onPressed: (_rows != null && _newCount > 0 && !_importing)
                ? _import
                : null,
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      );

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.group_add_rounded, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('ກະລຸນາເລືອກໄຟລ໌ CSV ພະນັກງານ',
              style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final rows = _rows!;
    final newRows = rows.where((r) => !r.isExisting).toList();
    final existingRows = rows.where((r) => r.isExisting).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (existingRows.isNotEmpty) ...[
            _sectionHeader(
                'ມີຢູ່ລະບົບແລ້ວ (${existingRows.length} ລາຍການ — ຈະຖືກຂ້າມ)',
                Colors.orange.shade700),
            const SizedBox(height: 4),
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: existingRows
                      .map((r) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(children: [
                              Icon(Icons.info_outline,
                                  size: 16, color: Colors.orange.shade700),
                              const SizedBox(width: 6),
                              Text(
                                  '${r.firstName} ${r.lastName} (${r.rawName})',
                                  style: TextStyle(
                                      color: Colors.orange.shade700)),
                            ]),
                          ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _sectionHeader(
              'ຈະນຳເຂົ້າ (${newRows.length} ລາຍການ)', AppColors.success),
          const SizedBox(height: 4),
          Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                headingRowColor: WidgetStateProperty.all(
                    AppColors.primary.withValues(alpha: 0.08)),
                columns: const [
                  DataColumn(label: Text('ຊື່')),
                  DataColumn(label: Text('ນາມສະກຸນ')),
                  DataColumn(label: Text('ຊັ້ນທະຫານ')),
                  DataColumn(label: Text('ວັນເລີ່ມວຽກ')),
                  DataColumn(label: Text('ເງິນເດືອນ'), numeric: true),
                ],
                rows: newRows.map((r) {
                  final hasRank = r.militaryRankId != null;
                  final hasDate = r.hireDate != null;
                  return DataRow(cells: [
                    DataCell(Text(r.firstName)),
                    DataCell(Text(r.lastName)),
                    DataCell(Row(children: [
                      if (!hasRank)
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(Icons.warning_amber,
                              size: 14, color: Colors.orange),
                        ),
                      Text(r.militaryRankName,
                          style: TextStyle(
                              color: hasRank ? null : Colors.orange)),
                    ])),
                    DataCell(Text(
                      hasDate
                          ? '${r.hireDate!.month}/${r.hireDate!.year}'
                          : r.hireDateRaw,
                      style: TextStyle(
                          color: hasDate ? null : Colors.orange),
                    )),
                    DataCell(Text(r.salary == 0
                        ? '-'
                        : CurrencyUtils.formatCompact(r.salary))),
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
}
