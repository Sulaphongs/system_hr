import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/employee_provider.dart';
import '../../database/app_database.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/common/form_fields/app_date_picker.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navAttendance),
        actions: [
          Consumer<AttendanceProvider>(
            builder: (_, provider, __) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.people_alt),
                label: const Text('ໝາຍທັງໝົດ'),
                onPressed: () =>
                    _markAllPresent(context, provider),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 220,
                      child: AppDatePicker(
                        label: AppStrings.attendanceDate,
                        value: provider.selectedDate,
                        onChanged: provider.changeDate,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'ວັນທີ: ${AppDateUtils.formatDate(provider.selectedDate)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _AttendanceTable(
                        records: provider.records,
                        selectedDate: provider.selectedDate,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _markAllPresent(
      BuildContext context, AttendanceProvider provider) async {
    final employees =
        await context.read<EmployeeProvider>().getActiveList();
    for (final emp in employees) {
      await provider.markPresent(emp.id);
    }
  }
}

class _AttendanceTable extends StatelessWidget {
  final List<AttendanceRecord> records;
  final DateTime selectedDate;

  const _AttendanceTable(
      {required this.records, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final employees = context.watch<EmployeeProvider>().filtered;

    if (employees.isEmpty) {
      return const Center(child: Text('ບໍ່ມີຂໍ້ມູນພະນັກງານ'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('ພະນັກງານ')),
              DataColumn(label: Text(AppStrings.checkIn)),
              DataColumn(label: Text(AppStrings.checkOut)),
              DataColumn(label: Text(AppStrings.status)),
              DataColumn(label: Text('ຈັດການ')),
            ],
            rows: employees.map((e) {
              final emp = e.employee;
              final record = records
                  .where((r) => r.employeeId == emp.id)
                  .firstOrNull;
              return DataRow(cells: [
                DataCell(Text('${emp.firstName} ${emp.lastName}')),
                DataCell(Text(AppDateUtils.formatTime(record?.checkIn))),
                DataCell(Text(AppDateUtils.formatTime(record?.checkOut))),
                DataCell(record != null
                    ? StatusBadge.attendance(record.status)
                    : const Text('-', style: TextStyle(color: Colors.grey))),
                DataCell(IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () =>
                      _showEditDialog(context, emp, record, selectedDate),
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Employee emp,
      AttendanceRecord? existing, DateTime date) {
    String status = existing?.status ?? 'present';
    DateTime? checkIn = existing?.checkIn;
    DateTime? checkOut = existing?.checkOut;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('${emp.firstName} ${emp.lastName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: status,
                decoration:
                    const InputDecoration(labelText: AppStrings.status),
                items: const [
                  DropdownMenuItem(
                      value: 'present', child: Text(AppStrings.present)),
                  DropdownMenuItem(
                      value: 'absent', child: Text(AppStrings.absent)),
                  DropdownMenuItem(
                      value: 'late', child: Text(AppStrings.late)),
                  DropdownMenuItem(
                      value: 'half_day', child: Text(AppStrings.halfDay)),
                ],
                onChanged: (v) =>
                    setDialogState(() => status = v ?? 'present'),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(checkIn != null
                        ? AppDateUtils.formatTime(checkIn)
                        : AppStrings.checkIn),
                    onPressed: () async {
                      final t = await showTimePicker(
                        context: ctx,
                        initialTime: checkIn != null
                            ? TimeOfDay.fromDateTime(checkIn!)
                            : TimeOfDay.now(),
                      );
                      if (t != null) {
                        setDialogState(() => checkIn = DateTime(
                            date.year, date.month, date.day, t.hour, t.minute));
                      }
                    },
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.access_time_filled),
                    label: Text(checkOut != null
                        ? AppDateUtils.formatTime(checkOut)
                        : AppStrings.checkOut),
                    onPressed: () async {
                      final t = await showTimePicker(
                        context: ctx,
                        initialTime: checkOut != null
                            ? TimeOfDay.fromDateTime(checkOut!)
                            : TimeOfDay.now(),
                      );
                      if (t != null) {
                        setDialogState(() => checkOut = DateTime(
                            date.year, date.month, date.day, t.hour, t.minute));
                      }
                    },
                  ),
                ),
              ]),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                context.read<AttendanceProvider>().save(
                      AttendanceCompanion(
                        employeeId: drift.Value(emp.id),
                        date: drift.Value(date),
                        status: drift.Value(status),
                        checkIn: drift.Value(checkIn),
                        checkOut: drift.Value(checkOut),
                      ),
                    );
              },
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );
  }
}
