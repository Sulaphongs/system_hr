import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/currency_utils.dart';
import '../../providers/employee_provider.dart';
import '../../providers/payroll_provider.dart';
import '../../providers/finance_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.navReports),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'ລາຍຊື່ພະນັກງານ'),
              Tab(text: 'ສະຫຼຸບເງິນເດືອນ'),
              Tab(text: 'ສະຫຼຸບລາຍຮັບ-ລາຍຈ່າຍ'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _EmployeeReport(),
            _PayrollSummaryReport(),
            _FinanceSummaryReport(),
          ],
        ),
      ),
    );
  }
}

// ─── Employee Report ──────────────────────────────────────────────────────────

class _EmployeeReport extends StatelessWidget {
  const _EmployeeReport();

  Future<void> _export(BuildContext context) async {
    final employees = context.read<EmployeeProvider>().filtered;
    final fontData = await rootBundle.load('assets/fonts/Phetsarath OT.ttf');
    final font = pw.Font.ttf(fontData);
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(base: font, bold: font),
      build: (_) => [
        pw.Header(
            level: 0,
            child: pw.Text('ລາຍຊື່ພະນັກງານ',
                style: pw.TextStyle(
                    font: font, fontSize: 18, fontWeight: pw.FontWeight.bold))),
        pw.SizedBox(height: 12),
        pw.TableHelper.fromTextArray(
          headers: [
            'ລະຫັດ',
            'ຊື່-ນາມສະກຸນ',
            'ຕຳແໜ່ງ',
            'ຍົດທະການ',
            'ວັນທີເຂົ້າວຽກ',
            'ເງິນເດືອນ',
            'ສະຖານະ'
          ],
          data: employees
              .map((e) => [
                    e.employee.employeeCode,
                    '${e.employee.firstName} ${e.employee.lastName}',
                    e.positionName ?? '-',
                    e.militaryRankName ?? '-',
                    AppDateUtils.formatDate(e.employee.hireDate),
                    CurrencyUtils.formatCompact(e.employee.salary),
                    e.employee.status == 'active' ? 'ເຮັດວຽກ' : 'ອອກວຽກ',
                  ])
              .toList(),
          headerStyle: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
          cellStyle: pw.TextStyle(font: font),
          headerDecoration:
              const pw.BoxDecoration(color: PdfColors.blueGrey100),
        ),
      ],
    ));
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeProvider>(
      builder: (context, provider, _) {
        final employees = provider.filtered;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text('ພະນັກງານທັງໝົດ: ${employees.length} ຄົນ'),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text(AppStrings.export),
                    onPressed:
                        employees.isEmpty ? null : () => _export(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Card(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text(AppStrings.employeeCode)),
                        DataColumn(label: Text('ຊື່ - ນາມສະກຸນ')),
                        DataColumn(label: Text(AppStrings.position)),
                        DataColumn(label: Text(AppStrings.militaryRank)),
                        DataColumn(label: Text(AppStrings.hireDate)),
                        DataColumn(label: Text(AppStrings.salary)),
                        DataColumn(label: Text(AppStrings.status)),
                      ],
                      rows: employees.map((e) {
                        final emp = e.employee;
                        return DataRow(cells: [
                          DataCell(Text(emp.employeeCode)),
                          DataCell(
                              Text('${emp.firstName} ${emp.lastName}')),
                          DataCell(Text(e.positionName ?? '-')),
                          DataCell(Text(e.militaryRankName ?? '-')),
                          DataCell(Text(
                              AppDateUtils.formatDate(emp.hireDate))),
                          DataCell(Text(
                              CurrencyUtils.formatCompact(emp.salary))),
                          DataCell(Text(emp.status == 'active'
                              ? AppStrings.active
                              : AppStrings.inactive)),
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
    );
  }
}

// ─── Payroll Summary Report ───────────────────────────────────────────────────

class _PayrollSummaryReport extends StatelessWidget {
  const _PayrollSummaryReport();

  static const _months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  @override
  Widget build(BuildContext context) {
    return Consumer<PayrollProvider>(
      builder: (context, provider, _) {
        final records = provider.records;
        final totalNet =
            records.fold(0.0, (s, r) => s + r.payroll.netPay);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
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
                  const Spacer(),
                  if (records.isNotEmpty)
                    Text(
                      'ລວມສຸດທິ: ${CurrencyUtils.format(totalNet)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : records.isEmpty
                      ? const Center(
                          child: Text('ຍັງບໍ່ມີຂໍ້ມູນເງິນເດືອນ',
                              style: TextStyle(color: Colors.grey)))
                      : SingleChildScrollView(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 24),
                          child: Card(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 20,
                                columns: const [
                                  DataColumn(
                                      label: Text('ຊື່-ນາມສະກຸນ')),
                                  DataColumn(
                                      label:
                                          Text(AppStrings.totalIncome),
                                      numeric: true),
                                  DataColumn(
                                      label: Text(
                                          AppStrings.totalDeductions),
                                      numeric: true),
                                  DataColumn(
                                      label: Text(AppStrings.netPay),
                                      numeric: true),
                                ],
                                rows: records.map((r) {
                                  return DataRow(cells: [
                                    DataCell(Text(
                                        '${r.employee.firstName} ${r.employee.lastName}')),
                                    DataCell(Text(
                                        CurrencyUtils.formatCompact(
                                            r.payroll.totalIncome))),
                                    DataCell(Text(
                                        CurrencyUtils.formatCompact(
                                            r.payroll.totalDeductions))),
                                    DataCell(Text(
                                      CurrencyUtils.formatCompact(
                                          r.payroll.netPay),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
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
    );
  }
}

// ─── Finance Summary Report ───────────────────────────────────────────────────

class _FinanceSummaryReport extends StatelessWidget {
  const _FinanceSummaryReport();

  static const _months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceProvider>(
      builder: (context, provider, _) {
        final transactions = provider.transactions;

        // Group by category
        final Map<String, double> incomeByCategory = {};
        final Map<String, double> expenseByCategory = {};
        for (final tx in transactions) {
          if (tx.type == 'income') {
            incomeByCategory[tx.category] =
                (incomeByCategory[tx.category] ?? 0) + tx.amount;
          } else {
            expenseByCategory[tx.category] =
                (expenseByCategory[tx.category] ?? 0) + tx.amount;
          }
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
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

            // Totals banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _TotalChip(
                    label: AppStrings.financeIncome,
                    value: CurrencyUtils.format(provider.totalIncome),
                    color: Colors.green,
                  ),
                  const SizedBox(width: 12),
                  _TotalChip(
                    label: AppStrings.financeExpense,
                    value: CurrencyUtils.format(provider.totalExpense),
                    color: Colors.red,
                  ),
                  const SizedBox(width: 12),
                  _TotalChip(
                    label: AppStrings.netBalance,
                    value: CurrencyUtils.format(provider.netBalance),
                    color: provider.netBalance >= 0
                        ? Colors.blue
                        : Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : transactions.isEmpty
                      ? const Center(
                          child: Text('ຍັງບໍ່ມີລາຍການ',
                              style: TextStyle(color: Colors.grey)))
                      : SingleChildScrollView(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Income breakdown
                              Expanded(
                                child: _CategoryTable(
                                  title: AppStrings.financeIncome,
                                  data: incomeByCategory,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Expense breakdown
                              Expanded(
                                child: _CategoryTable(
                                  title: AppStrings.financeExpense,
                                  data: expenseByCategory,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        );
      },
    );
  }
}

class _TotalChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TotalChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontSize: 12, color: color)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: color)),
          ],
        ),
      ),
    );
  }
}

class _CategoryTable extends StatelessWidget {
  final String title;
  final Map<String, double> data;
  final Color color;

  const _CategoryTable(
      {required this.title, required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: color)),
          ),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child:
                  Text('ບໍ່ມີລາຍການ', style: TextStyle(color: Colors.grey)),
            )
          else
            ...entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(child: Text(e.key)),
                      Text(
                        CurrencyUtils.formatCompact(e.value),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: color),
                      ),
                    ],
                  ),
                )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
