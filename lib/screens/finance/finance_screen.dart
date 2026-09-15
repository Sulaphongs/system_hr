import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/finance_provider.dart';
import '../../database/app_database.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/common/table_helpers.dart';

const _incomeCategories = [
  'ເງິນກະຊວງ',
  'ການຕະຫລາດ',
];

const _expenseCategories = [
  'ເງິນເດືອນ',
  'ຄ່ານ້ຳ-ໄຟ',
  'ຄ່ານ້ຳມັນ',
  'ຄ່າຊ່ອມແປງ',
  'ຄ່າວັດສະດຸ-ອຸປະກອນ',
  'ຄ່າໃຊ້ຈ່າຍອື່ນໆ',
];

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  static const _months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  void _openDialog(BuildContext context, {FinanceTransaction? tx}) {
    showDialog(
      context: context,
      builder: (_) => _FinanceDialog(transaction: tx),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navFinance),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add, size: 16),
            label: const Text(AppStrings.addTransaction),
            onPressed: () => _openDialog(context),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // Month / year selector
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    const Text(AppStrings.month,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: provider.selectedMonth,
                      items: _months
                          .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(AppStrings.months[m - 1])))
                          .toList(),
                      onChanged: (m) => provider.changeMonthYear(
                          m!, provider.selectedYear),
                    ),
                    const SizedBox(width: 16),
                    const Text(AppStrings.year,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: provider.selectedYear,
                      items: List.generate(
                              5, (i) => DateTime.now().year - 2 + i)
                          .map((y) => DropdownMenuItem(
                              value: y, child: Text('$y')))
                          .toList(),
                      onChanged: (y) => provider.changeMonthYear(
                          provider.selectedMonth, y!),
                    ),
                  ],
                ),
              ),

              // Summary cards
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Row(
                  children: [
                    _SummaryCard(
                      label: AppStrings.financeIncome,
                      value: CurrencyUtils.format(provider.totalIncome),
                      color: Colors.green,
                      icon: Icons.arrow_downward_rounded,
                    ),
                    const SizedBox(width: 12),
                    _SummaryCard(
                      label: AppStrings.financeExpense,
                      value: CurrencyUtils.format(provider.totalExpense),
                      color: Colors.red,
                      icon: Icons.arrow_upward_rounded,
                    ),
                    const SizedBox(width: 12),
                    _SummaryCard(
                      label: AppStrings.netBalance,
                      value: CurrencyUtils.format(provider.netBalance),
                      color: provider.netBalance >= 0
                          ? Colors.blue
                          : Colors.orange,
                      icon: Icons.account_balance_rounded,
                    ),
                  ],
                ),
              ),

              // ── Search + Filter toolbar ──────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TableSearchField(
                        onChanged: provider.setSearch,
                        hint: 'ຄົ້ນຫາ ໝວດ, ລາຍລະອຽດ...',
                      ),
                    ),
                    const SizedBox(width: 16),
                    _filterChip(context, provider, 'all', AppStrings.all),
                    const SizedBox(width: 6),
                    _filterChip(context, provider, 'income',
                        AppStrings.financeIncome),
                    const SizedBox(width: 6),
                    _filterChip(context, provider, 'expense',
                        AppStrings.financeExpense),
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
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'ຍັງບໍ່ມີລາຍການ',
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
                                  label: Text(AppStrings.financeDate)),
                              DataColumn(
                                  label: Text(AppStrings.financeType)),
                              DataColumn(
                                  label:
                                      Text(AppStrings.financeCategory)),
                              DataColumn(
                                  label: Text(AppStrings.financeAmount),
                                  numeric: true),
                              DataColumn(
                                  label: Text(
                                      AppStrings.financeDescription)),
                              DataColumn(label: Text('ຈັດການ')),
                            ],
                            rows: provider.filtered.map((tx) {
                              final isIncome = tx.type == 'income';
                              return DataRow(cells: [
                                DataCell(Text(
                                    AppDateUtils.formatDate(
                                        tx.transactionDate),
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13))),
                                DataCell(_TypeBadge(isIncome: isIncome)),
                                DataCell(Text(tx.category,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500))),
                                DataCell(Text(
                                  CurrencyUtils.formatCompact(tx.amount),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isIncome
                                        ? Colors.green[700]
                                        : Colors.red[700],
                                  ),
                                )),
                                DataCell(Text(tx.description ?? '-',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey[600]))),
                                DataCell(Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _ActionBtn(
                                      icon: Icons.edit_rounded,
                                      tooltip: AppStrings.edit,
                                      onTap: () =>
                                          _openDialog(context, tx: tx),
                                    ),
                                    _ActionBtn(
                                      icon: Icons.delete_rounded,
                                      tooltip: AppStrings.deleteAction,
                                      color: Colors.red,
                                      onTap: () => ConfirmDialog.show(
                                        context,
                                        onConfirm: () => context
                                            .read<FinanceProvider>()
                                            .remove(tx.id),
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

  Widget _filterChip(BuildContext context, FinanceProvider provider,
      String value, String label) {
    final active = provider.typeFilter == value;
    return FilterChip(
      label: Text(label),
      selected: active,
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      checkmarkColor: AppColors.primary,
      onSelected: (_) => provider.setTypeFilter(value),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 2),
                    Text(value,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: color)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinanceDialog extends StatefulWidget {
  final FinanceTransaction? transaction;

  const _FinanceDialog({this.transaction});

  @override
  State<_FinanceDialog> createState() => _FinanceDialogState();
}

class _FinanceDialogState extends State<_FinanceDialog> {
  late String _type;
  late String _category;
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  late DateTime _date;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  bool get _isEdit => widget.transaction != null;
  bool get _isIncome => _type == 'income';

  List<String> get _categories =>
      _isIncome ? _incomeCategories : _expenseCategories;

  Color get _typeColor => _isIncome ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
  Color get _typeColorLight => _isIncome ? const Color(0xFF43A047) : const Color(0xFFE53935);
  IconData get _typeIcon =>
      _isIncome ? Icons.south_rounded : Icons.north_rounded;

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    _type = tx?.type ?? 'income';
    _category = tx?.category ?? _incomeCategories.first;
    _amountCtrl.text = tx != null ? tx.amount.toStringAsFixed(0) : '';
    _descCtrl.text = tx?.description ?? '';
    _date = tx?.transactionDate ?? DateTime.now();
    if (tx != null && !_categories.contains(tx.category)) {
      _category = _categories.first;
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final amount = double.parse(_amountCtrl.text.replaceAll(',', ''));
    final desc = _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();
    final provider = context.read<FinanceProvider>();
    if (_isEdit) {
      await provider.edit(
        id: widget.transaction!.id,
        type: _type,
        category: _category,
        amount: amount,
        description: desc,
        date: _date,
      );
    } else {
      await provider.add(
        type: _type,
        category: _category,
        amount: amount,
        description: desc,
        date: _date,
      );
    }
    if (mounted) Navigator.pop(context);
  }

  void _setType(String type) {
    setState(() {
      _type = type;
      _category = _categories.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Animated header banner ──────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              height: 96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_typeColor, _typeColorLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // close button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  // icon + title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 56, 0),
                    child: Row(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Container(
                            key: ValueKey(_type),
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(_typeIcon,
                                color: Colors.white, size: 26),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEdit
                                  ? AppStrings.editTransaction
                                  : AppStrings.addTransaction,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isIncome
                                  ? AppStrings.financeIncome
                                  : AppStrings.financeExpense,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Form body ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type toggle
                    Row(
                      children: [
                        Expanded(
                          child: _TypeButton(
                            label: AppStrings.financeIncome,
                            icon: Icons.south_rounded,
                            color: const Color(0xFF2E7D32),
                            selected: _isIncome,
                            onTap: () => _setType('income'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _TypeButton(
                            label: AppStrings.financeExpense,
                            icon: Icons.north_rounded,
                            color: const Color(0xFFC62828),
                            selected: !_isIncome,
                            onTap: () => _setType('expense'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Amount — large, centered
                    _Label(AppStrings.financeAmount),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _typeColor,
                      ),
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(
                            fontSize: 28,
                            color: Colors.grey[300],
                            fontWeight: FontWeight.bold),
                        suffixText: 'ກີບ',
                        suffixStyle: TextStyle(
                            fontSize: 14, color: Colors.grey[500]),
                        filled: true,
                        fillColor: _typeColor.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: _typeColor.withValues(alpha: 0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: _typeColor.withValues(alpha: 0.25)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: _typeColor, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'ກະລຸນາໃສ່ຈຳນວນເງິນ';
                        if (double.tryParse(v) == null) return 'ຮູບແບບບໍ່ຖືກຕ້ອງ';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Category + Date — 2 columns
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category (flex 3)
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Label(AppStrings.financeCategory),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: _categories.contains(_category)
                                    ? _category
                                    : _categories.first,
                                items: _categories
                                    .map((c) => DropdownMenuItem(
                                        value: c, child: Text(c)))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _category = v!),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8)),
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Date (flex 2)
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Label(AppStrings.financeDate),
                              const SizedBox(height: 6),
                              OutlinedButton.icon(
                                onPressed: _pickDate,
                                icon: Icon(Icons.calendar_month_rounded,
                                    size: 16, color: _typeColor),
                                label: Text(
                                  AppDateUtils.formatDate(_date),
                                  style: const TextStyle(fontSize: 13),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black87,
                                  side: BorderSide(
                                      color: Colors.grey[350]!),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8)),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description
                    _Label(AppStrings.financeDescription),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _descCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                        hintText: 'ລາຍລະອຽດ (ບໍ່ບັງຄັບ)',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Action buttons ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    child: const Text(AppStrings.cancel),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.check_rounded, size: 18),
                      label: Text(_saving
                          ? 'ກຳລັງບັນທຶກ...'
                          : AppStrings.save),
                      style: FilledButton.styleFrom(
                        backgroundColor: _typeColor,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black54),
      );
}

class _TypeBadge extends StatelessWidget {
  final bool isIncome;
  const _TypeBadge({required this.isIncome});

  @override
  Widget build(BuildContext context) {
    final color = isIncome ? Colors.green : Colors.red;
    final label =
        isIncome ? AppStrings.financeIncome : AppStrings.financeExpense;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.shade700,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
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

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected ? color.withValues(alpha: 0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? color : Colors.grey[300]!,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: selected ? color : Colors.grey[500]),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? color : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
