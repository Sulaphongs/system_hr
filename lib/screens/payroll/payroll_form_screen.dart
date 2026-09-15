import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/payroll_provider.dart';
import '../../database/app_database.dart';

class PayrollFormScreen extends StatefulWidget {
  final int payrollId;
  const PayrollFormScreen({super.key, required this.payrollId});

  @override
  State<PayrollFormScreen> createState() => _PayrollFormScreenState();
}

class _PayrollFormScreenState extends State<PayrollFormScreen> {
  // ── Income ──────────────────────────────────────────────────────────────────
  final _rankSalaryCtrl       = TextEditingController(text: '0');
  final _dutyAllowanceCtrl    = TextEditingController(text: '0');
  final _seniorityCtrl        = TextEditingController(text: '0');
  final _militaryBonusCtrl    = TextEditingController(text: '0');
  final _specialistCtrl       = TextEditingController(text: '0');
  final _nutritionCtrl        = TextEditingController(text: '0');
  final _childrenCtrl         = TextEditingController(text: '0');
  final _wifeCtrl             = TextEditingController(text: '0');
  final _costOfLivingCtrl     = TextEditingController(text: '0');
  final _professionalCtrl     = TextEditingController(text: '0');
  final _certificateCtrl      = TextEditingController(text: '0');
  final _extraMealCtrl        = TextEditingController(text: '0');

  // ── Deductions (manual only) ────────────────────────────────────────────────
  final _riceCtrl = TextEditingController(text: '0');

  final _noteCtrl = TextEditingController();

  bool _saving = false;
  PayrollRecord? _record;
  Employee? _employee;

  double _v(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '')) ?? 0.0;

  // ກຸ່ມ 1: ຮັບຫຼັກ
  double get _subtotal1 =>
      _v(_rankSalaryCtrl) + _v(_dutyAllowanceCtrl) +
      _v(_seniorityCtrl) + _v(_militaryBonusCtrl);

  // ກຸ່ມ 2: ເງິນອຸດຫນູດ + ອື່ນໆ
  double get _subtotal2 =>
      _v(_childrenCtrl) + _v(_wifeCtrl) + _v(_certificateCtrl) +
      _v(_extraMealCtrl) + _v(_specialistCtrl) + _v(_nutritionCtrl) +
      _v(_costOfLivingCtrl) + _v(_professionalCtrl);

  double get _totalIncome => _subtotal1 + _subtotal2;

  // ── Computed deductions ─────────────────────────────────────────────────────
  double get _socialSecurity => _subtotal1 * 0.08;
  double get _incomeTax5 =>
      (_subtotal1 - _socialSecurity).clamp(0.0, 2500000.0) * 0.05;
  double get _incomeTax10 =>
      math.max(0.0, _subtotal1 - _socialSecurity - 5000000.0) * 0.10;
  double get _totalDeductions =>
      _socialSecurity + _incomeTax5 + _incomeTax10 + _v(_riceCtrl);

  double get _netPay => _totalIncome - _totalDeductions;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final found = context
        .read<PayrollProvider>()
        .records
        .where((r) => r.payroll.id == widget.payrollId)
        .firstOrNull;
    if (found == null) return;
    final pay = found.payroll;
    _record = pay;
    _employee = found.employee;

    _rankSalaryCtrl.text      = CurrencyUtils.formatCompact(pay.rankSalary);
    _dutyAllowanceCtrl.text   = CurrencyUtils.formatCompact(pay.dutyAllowance);
    _seniorityCtrl.text       = CurrencyUtils.formatCompact(pay.seniorityAllowance);
    _militaryBonusCtrl.text   = CurrencyUtils.formatCompact(pay.militaryBonus);
    _specialistCtrl.text      = CurrencyUtils.formatCompact(pay.specialistAllowance);
    _nutritionCtrl.text       = CurrencyUtils.formatCompact(pay.nutritionAllowance);
    _childrenCtrl.text        = CurrencyUtils.formatCompact(pay.childrenAllowance);
    _wifeCtrl.text            = CurrencyUtils.formatCompact(pay.wifeAllowance);
    _costOfLivingCtrl.text    = CurrencyUtils.formatCompact(pay.costOfLivingAllowance);
    _professionalCtrl.text    = CurrencyUtils.formatCompact(pay.professionalAllowance);
    _certificateCtrl.text     = CurrencyUtils.formatCompact(pay.certificateAllowance);
    _extraMealCtrl.text       = CurrencyUtils.formatCompact(pay.extraMealAllowance);

    _riceCtrl.text            = CurrencyUtils.formatCompact(pay.riceDeduction);

    _noteCtrl.text = pay.note ?? '';
  }

  Future<void> _save() async {
    if (_record == null) return;
    setState(() => _saving = true);
    try {
      await context.read<PayrollProvider>().upsert(PayrollCompanion(
            id: drift.Value(_record!.id),
            employeeId: drift.Value(_record!.employeeId),
            month: drift.Value(_record!.month),
            year: drift.Value(_record!.year),
            rankSalary: drift.Value(_v(_rankSalaryCtrl)),
            dutyAllowance: drift.Value(_v(_dutyAllowanceCtrl)),
            seniorityAllowance: drift.Value(_v(_seniorityCtrl)),
            militaryBonus: drift.Value(_v(_militaryBonusCtrl)),
            specialistAllowance: drift.Value(_v(_specialistCtrl)),
            nutritionAllowance: drift.Value(_v(_nutritionCtrl)),
            childrenAllowance: drift.Value(_v(_childrenCtrl)),
            wifeAllowance: drift.Value(_v(_wifeCtrl)),
            costOfLivingAllowance: drift.Value(_v(_costOfLivingCtrl)),
            // professionalAllowance: drift.Value(_v(_professionalCtrl)),
            certificateAllowance: drift.Value(_v(_certificateCtrl)),
            extraMealAllowance: drift.Value(_v(_extraMealCtrl)),
            totalIncome: drift.Value(_totalIncome),
            socialSecurity: drift.Value(_socialSecurity),
            incomeTax: drift.Value(_incomeTax5),
            riceDeduction: drift.Value(_v(_riceCtrl)),
            tenPercentDeduction: drift.Value(_incomeTax10),
            totalDeductions: drift.Value(_totalDeductions),
            netPay: drift.Value(_netPay),
            note: drift.Value(
                _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim()),
          ));
      if (mounted) context.go('/payroll');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    for (final c in [
      _rankSalaryCtrl, _dutyAllowanceCtrl, _seniorityCtrl, _militaryBonusCtrl,
      _specialistCtrl, _nutritionCtrl, _childrenCtrl, _wifeCtrl, _costOfLivingCtrl,
      _professionalCtrl, _certificateCtrl, _extraMealCtrl,
      _riceCtrl, _noteCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _recalc() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final monthName = _record != null
        ? '${AppStrings.months[_record!.month - 1]} ${_record!.year}'
        : '';
    final empName = _employee != null
        ? '${_employee!.firstName} ${_employee!.lastName}'
        : 'ແກ້ໄຂເງິນເດືອນ';
    final yearsOfService = _employee != null
        ? AppDateUtils.yearsOfService(_employee!.hireDate)
        : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(empName),
        leading: BackButton(onPressed: () => context.go('/payroll')),
        actions: [
          if (monthName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Chip(
                label: Text('ເດືອນ $monthName',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                backgroundColor: Colors.white24,
                side: BorderSide.none,
              ),
            ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── LEFT: Scrollable form ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _IncomeCard(
                    subtotal1: _subtotal1,
                    subtotal2: _subtotal2,
                    total: _totalIncome,
                    group1: [
                      ('ເງິນພື້ນຖານຕາມຊັ້ນ', _rankSalaryCtrl),
                      ('ເງິນໜ້າທີ່',           _dutyAllowanceCtrl),
                      ('ເງິນປີການ',             _seniorityCtrl),
                      ('ເງິນສົ່ງເສີມກອງທັບ',   _militaryBonusCtrl),
                    ],
                    group2: [
                      ('ເງິນອຸດໜູນລູກ',         _childrenCtrl),
                      ('ເງິນອຸດໜູນເມຍ',         _wifeCtrl),
                      ('ເງິນໃບປະກາດ',           _certificateCtrl),
                      ('ເງິນກິນເພີ່ມ',           _extraMealCtrl),
                      (AppStrings.specialistAllowance,  _specialistCtrl),
                      (AppStrings.nutritionAllowance,   _nutritionCtrl),
                      (AppStrings.costOfLivingAllowance,_costOfLivingCtrl),
                    ],
                    onChanged: _recalc,
                  ),
                  const SizedBox(height: 16),
                  _DeductionCard(
                    subtotal1: _subtotal1,
                    socialSecurity: _socialSecurity,
                    incomeTax5: _incomeTax5,
                    incomeTax10: _incomeTax10,
                    totalDeductions: _totalDeductions,
                    riceCtrl: _riceCtrl,
                    onChanged: _recalc,
                  ),
                  const SizedBox(height: 16),
                  // Notes field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _noteCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: AppStrings.note,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: AppColors.background,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── RIGHT: Summary panel ────────────────────────────────────────────
          _SummaryPanel(
            empName: empName,
            empCode: _employee?.employeeCode ?? '',
            monthName: monthName,
            yearsOfService: yearsOfService,
            totalIncome: _totalIncome,
            totalDeductions: _totalDeductions,
            netPay: _netPay,
            saving: _saving,
            onSave: _save,
            onCancel: () => context.go('/payroll'),
          ),
        ],
      ),
    );
  }
}

// ── Individual field ───────────────────────────────────────────────────────────

class _PayField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final VoidCallback onChanged;

  const _PayField({
    required this.label,
    required this.ctrl,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11.5, color: Color(0xFF4A5568)),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          inputFormatters: [ThousandsSeparatorInputFormatter()],
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            suffixText: 'ກີບ',
            suffixStyle: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

// ── Summary panel ──────────────────────────────────────────────────────────────

class _SummaryPanel extends StatelessWidget {
  final String empName;
  final String empCode;
  final String monthName;
  final String yearsOfService;
  final double totalIncome;
  final double totalDeductions;
  final double netPay;
  final bool saving;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const _SummaryPanel({
    required this.empName,
    required this.empCode,
    required this.monthName,
    required this.yearsOfService,
    required this.totalIncome,
    required this.totalDeductions,
    required this.netPay,
    required this.saving,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey[200]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Employee header ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      child: Text(
                        empName.isNotEmpty ? empName[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            empName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (empCode.isNotEmpty)
                            Text(
                              empCode,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (monthName.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _InfoChip(monthName),
                      if (yearsOfService.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        _InfoChip(yearsOfService),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),

          // ── Totals ──────────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TotalRow(
                    icon: Icons.arrow_circle_up_rounded,
                    label: 'ລວມພາກສ່ວນຮັບ',
                    amount: totalIncome,
                    color: const Color(0xFF1565C0),
                  ),
                  const SizedBox(height: 12),
                  _TotalRow(
                    icon: Icons.arrow_circle_down_rounded,
                    label: 'ລວມພາກສ່ວນຫັກ',
                    amount: totalDeductions,
                    color: const Color(0xFFC62828),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: Colors.grey[200], thickness: 1.5),
                  ),
                  // Net pay — prominent
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFF2E7D32).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.payments_rounded,
                                color: Color(0xFF2E7D32), size: 16),
                            SizedBox(width: 6),
                            Text(
                              AppStrings.netPay,
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Flexible(
                              child: Text(
                                CurrencyUtils.formatCompact(netPay),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF1B5E20),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'ກີບ',
                              style: TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),

          // ── Actions ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: saving ? null : onSave,
                    icon: saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.save_rounded, size: 18),
                    label: Text(saving ? 'ກຳລັງບັນທຶກ...' : AppStrings.save),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    child: const Text(AppStrings.cancel),
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

// ── Info chip (month / years) ──────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final String text;
  const _InfoChip(this.text);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
      );
}

// ── Income card (2-group) ─────────────────────────────────────────────────────

class _IncomeCard extends StatelessWidget {
  final List<(String, TextEditingController)> group1;
  final List<(String, TextEditingController)> group2;
  final double subtotal1;
  final double subtotal2;
  final double total;
  final VoidCallback onChanged;

  const _IncomeCard({
    required this.group1,
    required this.group2,
    required this.subtotal1,
    required this.subtotal2,
    required this.total,
    required this.onChanged,
  });

  Widget _fields(List<(String, TextEditingController)> items) {
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      final l = items[i];
      final r = i + 1 < items.length ? items[i + 1] : null;
      rows.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Expanded(child: _PayField(label: l.$1, ctrl: l.$2, onChanged: onChanged)),
          const SizedBox(width: 14),
          Expanded(
              child: r != null
                  ? _PayField(label: r.$1, ctrl: r.$2, onChanged: onChanged)
                  : const SizedBox()),
        ]),
      ));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF1565C0);
    const bg = Color(0xFFEEF2FF);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          color: bg,
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.arrow_circle_up_rounded, color: accent, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('ພາກສ່ວນຮັບ', style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 14)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Group 1
            _fields(group1),
            _SubtotalRow(label: 'ລວມ', amount: subtotal1, color: accent),
            const SizedBox(height: 4),
            // Group 2
            _fields(group2),
          ]),
        ),
        // Grand total footer
        Container(
          margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: accent.withValues(alpha: 0.2)),
          ),
          child: Row(children: [
            Expanded(child: Text(AppStrings.totalIncome,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: accent))),
            Text(CurrencyUtils.format(total),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: accent)),
          ]),
        ),
      ]),
    );
  }
}

// ── Subtotal row ──────────────────────────────────────────────────────────────

class _SubtotalRow extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  const _SubtotalRow({required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: color)),
          const Spacer(),
          Text(CurrencyUtils.formatCompact(amount),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
          const SizedBox(width: 4),
          Text('ກີບ', style: TextStyle(fontSize: 10, color: color)),
        ]),
      );
}

// ── Deduction card (auto-computed + manual rice) ──────────────────────────────

class _DeductionCard extends StatelessWidget {
  final double subtotal1;
  final double socialSecurity;
  final double incomeTax5;
  final double incomeTax10;
  final double totalDeductions;
  final TextEditingController riceCtrl;
  final VoidCallback onChanged;

  const _DeductionCard({
    required this.subtotal1,
    required this.socialSecurity,
    required this.incomeTax5,
    required this.incomeTax10,
    required this.totalDeductions,
    required this.riceCtrl,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFC62828);
    const bg = Color(0xFFFFF1F0);

    Widget readOnlyRow(String label, double amount) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11.5, color: Color(0xFF4A5568))),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          CurrencyUtils.formatCompact(amount),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('ກີບ',
                          style: TextStyle(
                              fontSize: 10, color: Color(0xFF9CA3AF))),
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(child: SizedBox()),
          ]),
        );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Header
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          color: bg,
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.arrow_circle_down_rounded,
                  color: accent, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('ພາກສ່ວນຫັກ',
                style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ]),
        ),
        // Fields
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                readOnlyRow('ຫັກ 8% (ປະກັນສັງຄົມ)', socialSecurity),
                readOnlyRow('ຫັກ 5% (ອາກອນລາຍໄດ້)', incomeTax5),
                readOnlyRow('ຫັກ 10% (ອາກອນເພີ່ມ)', incomeTax10),
                // Manual rice deduction
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(children: [
                    Expanded(
                        child: _PayField(
                            label: AppStrings.riceDeduction,
                            ctrl: riceCtrl,
                            onChanged: onChanged)),
                    const SizedBox(width: 14),
                    const Expanded(child: SizedBox()),
                  ]),
                ),
              ]),
        ),
        // Total footer
        Container(
          margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: accent.withValues(alpha: 0.2)),
          ),
          child: Row(children: [
            Expanded(
                child: Text(AppStrings.totalDeductions,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: accent))),
            Text(CurrencyUtils.format(totalDeductions),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: accent)),
          ]),
        ),
      ]),
    );
  }
}

// ── Total row ─────────────────────────────────────────────────────────────────

class _TotalRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;
  final Color color;

  const _TotalRow({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 11.5, color: color, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            '${CurrencyUtils.formatCompact(amount)} ກີບ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
