import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../database/daos/employee_dao.dart';
import '../../providers/employee_provider.dart';

class OrgChartScreen extends StatelessWidget {
  const OrgChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navOrgChart),
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final active = provider.employees
              .where((e) => e.employee.status == 'active')
              .toList();

          final grouped = <String, List<EmployeeWithDetails>>{};
          for (final e in active) {
            final key = e.positionName ?? AppStrings.orgNoPosition;
            grouped.putIfAbsent(key, () => []).add(e);
          }

          // Sort: named positions first (alphabetically), unassigned last
          final sortedKeys = grouped.keys.toList()
            ..sort((a, b) {
              if (a == AppStrings.orgNoPosition) return 1;
              if (b == AppStrings.orgNoPosition) return -1;
              return a.compareTo(b);
            });

          if (active.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_tree_rounded,
                      size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text('ບໍ່ມີຂໍ້ມູນພະນັກງານ',
                      style: TextStyle(color: Colors.grey[500], fontSize: 15)),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OrgHeader(totalActive: active.length),
                const SizedBox(height: 24),
                ...sortedKeys.map(
                  (pos) => _PositionGroup(
                    positionName: pos,
                    employees: grouped[pos]!,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OrgHeader extends StatelessWidget {
  final int totalActive;
  const _OrgHeader({required this.totalActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.account_tree_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.navOrgChart,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ພະນັກງານທີ່ເຮັດວຽກຢູ່: $totalActive ຄົນ',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionGroup extends StatelessWidget {
  final String positionName;
  final List<EmployeeWithDetails> employees;

  const _PositionGroup({
    required this.positionName,
    required this.employees,
  });

  @override
  Widget build(BuildContext context) {
    final isUnassigned = positionName == AppStrings.orgNoPosition;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Position header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isUnassigned
                      ? Colors.grey[100]
                      : AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isUnassigned
                        ? Colors.grey[300]!
                        : AppColors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUnassigned
                          ? Icons.person_off_rounded
                          : Icons.badge_rounded,
                      size: 16,
                      color: isUnassigned
                          ? Colors.grey[500]
                          : AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      positionName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isUnassigned
                            ? Colors.grey[600]
                            : AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isUnassigned
                            ? Colors.grey[300]
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${employees.length}',
                        style: TextStyle(
                          color: isUnassigned ? Colors.grey[700] : Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 1,
                  color: isUnassigned
                      ? Colors.grey[200]
                      : AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Employee cards grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: employees
                .map((e) => _EmployeeCard(data: e))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final EmployeeWithDetails data;
  const _EmployeeCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final emp = data.employee;
    final fullName = '${emp.firstName} ${emp.lastName}';

    return InkWell(
      onTap: () => context.go('/employees/${emp.id}'),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Avatar(photoPath: emp.photoPath, name: fullName),
            const SizedBox(height: 10),
            Text(
              fullName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            if (data.militaryRankName != null) ...[
              const SizedBox(height: 4),
              Text(
                data.militaryRankName!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                emp.employeeCode,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.success,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? photoPath;
  final String name;
  const _Avatar({required this.photoPath, required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isNotEmpty
        ? name.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join()
        : '?';

    if (photoPath != null && photoPath!.isNotEmpty) {
      final file = File(photoPath!);
      if (file.existsSync()) {
        return CircleAvatar(
          radius: 30,
          backgroundImage: FileImage(file),
        );
      }
    }

    return CircleAvatar(
      radius: 30,
      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
      child: Text(
        initials.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
