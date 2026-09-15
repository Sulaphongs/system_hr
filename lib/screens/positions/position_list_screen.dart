import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/position_provider.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/common/table_helpers.dart';

class PositionListScreen extends StatelessWidget {
  const PositionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navPositions),
        actions: [
          ElevatedButton.icon(
            onPressed: () => context.go('/positions/new'),
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text(AppStrings.addPosition),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<PositionProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // ── Toolbar ────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(bottom: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TableSearchField(
                        onChanged: provider.setSearch,
                        hint: 'ຄົ້ນຫາ ຊື່ຕຳແໜ່ງ...',
                      ),
                    ),
                    const SizedBox(width: 16),
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
                    icon: Icons.work_rounded,
                    label: 'ບໍ່ພົບຕຳແໜ່ງ',
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
                              DataColumn(label: Text('ລະຫັດ')),
                              DataColumn(label: Text(AppStrings.positionName)),
                              DataColumn(label: Text(AppStrings.description)),
                              DataColumn(label: Text('ຈັດການ')),
                            ],
                            rows: provider.filtered.map((pos) {
                              final code =
                                  'P${pos.id.toString().padLeft(3, '0')}';
                              return DataRow(cells: [
                                DataCell(Text(
                                  code,
                                  style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 13),
                                )),
                                DataCell(Text(
                                  pos.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                )),
                                DataCell(Text(
                                  pos.description ?? '-',
                                  style:
                                      TextStyle(color: Colors.grey[600]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                DataCell(Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _ActionBtn(
                                      icon: Icons.edit_rounded,
                                      tooltip: AppStrings.edit,
                                      onTap: () => context
                                          .go('/positions/${pos.id}/edit'),
                                    ),
                                    _ActionBtn(
                                      icon: Icons.delete_rounded,
                                      tooltip: AppStrings.deleteAction,
                                      color: Colors.red,
                                      onTap: () => ConfirmDialog.show(
                                        context,
                                        onConfirm: () => context
                                            .read<PositionProvider>()
                                            .remove(pos.id),
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
                ),
            ],
          );
        },
      ),
    );
  }
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
