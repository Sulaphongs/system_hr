import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/military_rank_provider.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/common/table_helpers.dart';

class MilitaryRankListScreen extends StatelessWidget {
  const MilitaryRankListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navMilitaryRanks),
        actions: [
          ElevatedButton.icon(
            onPressed: () => context.go('/military-ranks/new'),
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text(AppStrings.addMilitaryRank),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<MilitaryRankProvider>(
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
                        hint: 'ຄົ້ນຫາ ຊື່, ລະຫັດ...',
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
                    icon: Icons.military_tech_rounded,
                    label: 'ບໍ່ພົບຊັ້ນທະຫານ',
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
                                  label: Text(
                                      AppStrings.militaryRankLevel),
                                  numeric: true),
                              DataColumn(
                                  label: Text(
                                      AppStrings.militaryRankCode)),
                              DataColumn(
                                  label: Text(
                                      AppStrings.militaryRankName)),
                              DataColumn(
                                  label: Text(AppStrings.description)),
                              DataColumn(label: Text('ຈັດການ')),
                            ],
                            rows: provider.filtered.map((rank) {
                              return DataRow(cells: [
                                DataCell(Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.1),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${rank.level}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                )),
                                DataCell(Text(
                                  rank.code,
                                  style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 13),
                                )),
                                DataCell(Text(
                                  rank.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                )),
                                DataCell(Text(
                                  rank.description ?? '-',
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
                                      onTap: () => context.go(
                                          '/military-ranks/${rank.id}/edit'),
                                    ),
                                    _ActionBtn(
                                      icon: Icons.delete_rounded,
                                      tooltip: AppStrings.deleteAction,
                                      color: Colors.red,
                                      onTap: () => ConfirmDialog.show(
                                        context,
                                        onConfirm: () => context
                                            .read<MilitaryRankProvider>()
                                            .remove(rank.id),
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
