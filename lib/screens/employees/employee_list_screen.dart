import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/employee_provider.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/common/table_helpers.dart';
import 'employee_import_screen.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navEmployees),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            tooltip: 'ລຶບພະນັກງານທັງໝົດ',
            color: Colors.red,
            onPressed: () => ConfirmDialog.show(
              context,
              title: 'ລຶບພະນັກງານທັງໝົດ?',
              content:
                  'ຂໍ້ມູນພະນັກງານທັງໝົດຈະຖືກລຶບອອກ. ການກະທຳນີ້ບໍ່ສາມາດຍ້ອນຄືນໄດ້.',
              onConfirm: () =>
                  context.read<EmployeeProvider>().removeAll(),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.upload_file_rounded),
            tooltip: 'ນຳເຂົ້າພະນັກງານ CSV',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const EmployeeImportScreen()),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => context.go('/employees/new'),
            icon: const Icon(Icons.person_add_rounded, size: 16),
            label: const Text(AppStrings.addEmployee),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // ── Toolbar ────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TableSearchField(
                        onChanged: provider.setSearch,
                        hint: 'ຄົ້ນຫາ ຊື່, ລະຫັດ...',
                      ),
                    ),
                    const SizedBox(width: 12),
                    _StatusChips(provider: provider),
                    const SizedBox(width: 8),
                    Text(
                      '${provider.filtered.length} ລາຍການ',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),

              // ── Table ──────────────────────────────────────────────
              if (provider.isLoading)
                const Expanded(
                    child: Center(child: CircularProgressIndicator()))
              else if (provider.filtered.isEmpty)
                const Expanded(
                  child: TableEmptyState(
                    icon: Icons.people_rounded,
                    label: 'ບໍ່ພົບພະນັກງານ',
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          child: DataTable(
                            headingRowColor: TableStyle.headingRowColor,
                            headingTextStyle: TableStyle.headingTextStyle,
                            dataRowMinHeight: TableStyle.rowHeight,
                            dataRowMaxHeight: TableStyle.rowHeight,
                            horizontalMargin: TableStyle.horizontalMargin,
                            columnSpacing: TableStyle.columnSpacing,
                            dividerThickness: TableStyle.dividerThickness,
                            columns: const [
                              DataColumn(
                                  label: Text(AppStrings.employeeCode)),
                              DataColumn(label: Text('ຊື່-ນາມສະກຸນ')),
                              DataColumn(label: Text(AppStrings.position)),
                              DataColumn(
                                  label: Text(AppStrings.militaryRank)),
                              DataColumn(label: Text('ປີການ')),
                              DataColumn(label: Text(AppStrings.status)),
                              DataColumn(label: Text('ຈັດການ')),
                            ],
                            rows: provider.filtered.map((e) {
                              final emp = e.employee;
                              return DataRow(cells: [
                                DataCell(Text(
                                  emp.employeeCode,
                                  style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 13),
                                )),
                                DataCell(Text(
                                    '${emp.firstName} ${emp.lastName}')),
                                DataCell(
                                    Text(e.positionName ?? '-')),
                                DataCell(
                                    Text(e.militaryRankName ?? '-')),
                                DataCell(Text(
                                  AppDateUtils.yearsOfService(emp.hireDate),
                                  style: const TextStyle(fontSize: 12),
                                )),
                                DataCell(
                                    StatusBadge.employee(emp.status)),
                                DataCell(_ActionRow(children: [
                                  _ActionBtn(
                                    icon: Icons.visibility_rounded,
                                    tooltip: AppStrings.view,
                                    color: Colors.blue,
                                    onTap: () => context
                                        .go('/employees/${emp.id}'),
                                  ),
                                  _ActionBtn(
                                    icon: Icons.edit_rounded,
                                    tooltip: AppStrings.edit,
                                    onTap: () => context.go(
                                        '/employees/${emp.id}/edit'),
                                  ),
                                  _ActionBtn(
                                    icon: Icons.delete_rounded,
                                    tooltip: AppStrings.deleteAction,
                                    color: Colors.red,
                                    onTap: () => ConfirmDialog.show(
                                      context,
                                      onConfirm: () => context
                                          .read<EmployeeProvider>()
                                          .remove(emp.id),
                                    ),
                                  ),
                                ])),
                              ]);
                            }).toList(),
                          ),
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

class _StatusChips extends StatelessWidget {
  final EmployeeProvider provider;
  const _StatusChips({required this.provider});

  @override
  Widget build(BuildContext context) {
    const options = [
      ('all', AppStrings.all),
      ('active', AppStrings.active),
      ('inactive', AppStrings.inactive),
    ];
    return Row(
      children: options.map((o) {
        final active = provider.statusFilter == o.$1;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: ChoiceChip(
            label: Text(o.$2, style: const TextStyle(fontSize: 12)),
            selected: active,
            onSelected: (_) => provider.setStatusFilter(o.$1),
            selectedColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            labelStyle: TextStyle(
              color: active
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[600],
              fontWeight:
                  active ? FontWeight.bold : FontWeight.normal,
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
            visualDensity: VisualDensity.compact,
          ),
        );
      }).toList(),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final List<Widget> children;
  const _ActionRow({required this.children});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.tooltip,
    this.color = const Color(0xFF546E7A),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      );
}
