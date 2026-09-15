import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/currency_utils.dart';
import '../../providers/employee_provider.dart';
import '../../providers/position_provider.dart';
import '../../providers/military_rank_provider.dart';
import '../../widgets/common/status_badge.dart';
import '../../database/app_database.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final int id;
  const EmployeeDetailScreen({super.key, required this.id});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  Employee? _employee;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final emp =
        await context.read<EmployeeProvider>().getById(widget.id);
    if (mounted) setState(() { _employee = emp; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }
    if (_employee == null) {
      return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                onPressed: () => context.go('/employees'))),
        body: const Center(child: Text('ບໍ່ພົບຂໍ້ມູນ')),
      );
    }
    final emp = _employee!;

    final positionName = context
        .read<PositionProvider>()
        .positions
        .where((p) => p.id == emp.positionId)
        .firstOrNull
        ?.name;

    final rankName = context
        .read<MilitaryRankProvider>()
        .ranks
        .where((r) => r.id == emp.militaryRankId)
        .firstOrNull
        ?.name;

    return Scaffold(
      appBar: AppBar(
        title: Text('${emp.firstName} ${emp.lastName}'),
        leading: BackButton(onPressed: () => context.go('/employees')),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: AppStrings.edit,
            onPressed: () => context.go('/employees/${emp.id}/edit'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundImage: emp.photoPath != null
                              ? FileImage(File(emp.photoPath!))
                              : null,
                          child: emp.photoPath == null
                              ? const Icon(Icons.person, size: 56)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${emp.firstName} ${emp.lastName}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(emp.employeeCode,
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        StatusBadge.employee(emp.status),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ຂໍ້ມູນລາຍລະອຽດ',
                            style:
                                Theme.of(context).textTheme.titleMedium),
                        const Divider(height: 24),
                        _row(AppStrings.gender,
                            emp.gender == 'male'
                                ? AppStrings.male
                                : emp.gender == 'female'
                                    ? AppStrings.female
                                    : AppStrings.other),
                        _row(AppStrings.birthDate,
                            AppDateUtils.formatDate(emp.birthDate)),
                        _row(AppStrings.phone, emp.phone ?? '-'),
                        _row(AppStrings.address, emp.address ?? '-'),
                        _row(AppStrings.position, positionName ?? '-'),
                        _row(AppStrings.militaryRank, rankName ?? '-'),
                        _row(AppStrings.hireDate,
                            AppDateUtils.formatDate(emp.hireDate)),
                        _row(AppStrings.salary,
                            CurrencyUtils.format(emp.salary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(label,
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
