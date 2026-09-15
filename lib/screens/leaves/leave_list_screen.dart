import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/leave_provider.dart';
import '../../providers/employee_provider.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/common/status_badge.dart';

class LeaveListScreen extends StatelessWidget {
  const LeaveListScreen({super.key});

  String _leaveTypeLabel(String type) {
    switch (type) {
      case 'sick':
        return AppStrings.sickLeave;
      case 'annual':
        return AppStrings.annualLeave;
      default:
        return AppStrings.unpaidLeave;
    }
  }

  String _empName(BuildContext context, int empId) {
    final all = context.read<EmployeeProvider>().filtered;
    final found =
        all.where((e) => e.employee.id == empId).firstOrNull;
    return found != null
        ? '${found.employee.firstName} ${found.employee.lastName}'
        : empId.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navLeaves),
        actions: [
          ElevatedButton.icon(
            onPressed: () => context.go('/leaves/new'),
            icon: const Icon(Icons.add),
            label: const Text(AppStrings.addLeave),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<LeaveProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text('ສະຖານະ: '),
                    const SizedBox(width: 8),
                    ...['all', 'pending', 'approved', 'rejected']
                        .map((s) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(s == 'all'
                                    ? AppStrings.all
                                    : s == 'pending'
                                        ? AppStrings.pending
                                        : s == 'approved'
                                            ? AppStrings.approved
                                            : AppStrings.rejected),
                                selected: provider.statusFilter == s,
                                onSelected: (_) =>
                                    provider.setStatusFilter(s),
                              ),
                            )),
                  ],
                ),
              ),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.filtered.isEmpty
                        ? const Center(
                            child: Text('ບໍ່ມີຂໍ້ມູນ',
                                style: TextStyle(color: Colors.grey)))
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24),
                            child: Card(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(
                                        label: Text('ພະນັກງານ')),
                                    DataColumn(
                                        label: Text(AppStrings.leaveType)),
                                    DataColumn(
                                        label: Text(AppStrings.startDate)),
                                    DataColumn(
                                        label: Text(AppStrings.endDate)),
                                    DataColumn(
                                        label: Text(AppStrings.totalDays)),
                                    DataColumn(
                                        label: Text(AppStrings.status)),
                                    DataColumn(label: Text('ຈັດການ')),
                                  ],
                                  rows: provider.filtered.map((leave) {
                                    return DataRow(cells: [
                                      DataCell(Text(_empName(
                                          context, leave.employeeId))),
                                      DataCell(Text(
                                          _leaveTypeLabel(leave.leaveType))),
                                      DataCell(Text(AppDateUtils.formatDate(
                                          leave.startDate))),
                                      DataCell(Text(AppDateUtils.formatDate(
                                          leave.endDate))),
                                      DataCell(
                                          Text('${leave.totalDays} ວັນ')),
                                      DataCell(StatusBadge.leave(
                                          leave.approvalStatus)),
                                      DataCell(Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (leave.approvalStatus ==
                                              'pending') ...[
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 20),
                                              tooltip: AppStrings.approve,
                                              onPressed: () => context
                                                  .read<LeaveProvider>()
                                                  .approve(leave.id),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                  size: 20),
                                              tooltip: AppStrings.reject,
                                              onPressed: () => context
                                                  .read<LeaveProvider>()
                                                  .reject(leave.id),
                                            ),
                                          ],
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                size: 18,
                                                color: Colors.grey),
                                            tooltip: AppStrings.deleteAction,
                                            onPressed: () =>
                                                ConfirmDialog.show(
                                              context,
                                              onConfirm: () => context
                                                  .read<LeaveProvider>()
                                                  .remove(leave.id),
                                            ),
                                          ),
                                        ],
                                      )),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
