import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_utils.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/common/summary_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<DashboardProvider>().refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navDashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'ໂຫຼດໃໝ່',
            onPressed: () => context.read<DashboardProvider>().refresh(),
          ),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Header ────────────────────────────────────────────
                Text(
                  AppStrings.appTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'ຂໍ້ມູນສະຫຼຸບ — ${AppStrings.months[DateTime.now().month - 1]} ${DateTime.now().year}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // ─── Row 1: 3 cards ────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: AppStrings.totalEmployees,
                        value: provider.totalEmployees.toString(),
                        icon: Icons.people_rounded,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        title: AppStrings.totalPositions,
                        value: provider.totalPositions.toString(),
                        icon: Icons.work_rounded,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        title: AppStrings.monthlyIncome,
                        value: CurrencyUtils.format(provider.monthlyIncome),
                        icon: Icons.arrow_downward_rounded,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ─── Row 2: 2 cards + empty spacer ────────────────────
                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: AppStrings.monthlyExpense,
                        value: CurrencyUtils.format(provider.monthlyExpense),
                        icon: Icons.arrow_upward_rounded,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        title: AppStrings.netBalance,
                        value: CurrencyUtils.format(provider.netBalance),
                        icon: Icons.account_balance_rounded,
                        color: provider.netBalance >= 0
                            ? Colors.teal
                            : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(child: SizedBox.shrink()),
                  ],
                ),

                const SizedBox(height: 32),

                // ─── Chart section ─────────────────────────────────────
                _ChartSection(data: provider.chartData),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Chart Section ────────────────────────────────────────────────────────────

class _ChartSection extends StatelessWidget {
  final List<MonthlyFinanceData> data;

  const _ChartSection({required this.data});

  static String _compact(double v) {
    final abs = v.abs();
    if (abs >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (abs >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final n = data.length;
    if (n == 0) return const SizedBox.shrink();

    // Compute Y range
    final maxBar = data.fold(0.0, (m, d) => max(m, max(d.income, d.expense)));
    final minNet = data.fold(0.0, (m, d) => min(m, d.net));
    final chartMaxY = max(maxBar, 1.0) * 1.25;
    final chartMinY = min(minNet < 0 ? minNet * 1.15 : 0.0, 0.0);

    const leftSize = 56.0;
    const bottomSize = 28.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Title + legend
        Row(
          children: [
            Text(
              'ສະຫຼຸບ 6 ເດືອນທີ່ຜ່ານມາ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            _Legend(color: Colors.green[400]!, label: AppStrings.financeIncome, isBar: true),
            const SizedBox(width: 16),
            _Legend(color: Colors.red[400]!, label: AppStrings.financeExpense, isBar: true),
            const SizedBox(width: 16),
            _Legend(color: Colors.blue[700]!, label: AppStrings.netBalance, isBar: false),
          ],
        ),
        const SizedBox(height: 12),

        // ─── Chart card
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 20, 8),
            child: SizedBox(
              height: 300,
              child: Stack(
                children: [
                  // ── Bar chart (income green, expense red) ──
                  BarChart(
                    BarChartData(
                      maxY: chartMaxY,
                      minY: chartMinY,
                      groupsSpace: 20,
                      barGroups: List.generate(n, (i) {
                        final d = data[i];
                        return BarChartGroupData(
                          x: i,
                          groupVertically: false,
                          barsSpace: 4,
                          barRods: [
                            BarChartRodData(
                              toY: d.income,
                              color: Colors.green[400]!,
                              width: 18,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                            ),
                            BarChartRodData(
                              toY: d.expense,
                              color: Colors.red[400]!,
                              width: 18,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                            ),
                          ],
                        );
                      }),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: leftSize,
                            interval: chartMaxY / 4,
                            getTitlesWidget: (v, _) => Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                _compact(v),
                                style: const TextStyle(fontSize: 10),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: bottomSize,
                            getTitlesWidget: (v, _) {
                              final idx = v.toInt();
                              if (idx < 0 || idx >= n) return const SizedBox.shrink();
                              final label = AppStrings.months[data[idx].month - 1];
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  label.length > 3 ? label.substring(0, 3) : label,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: chartMaxY / 4,
                        getDrawingHorizontalLine: (v) => FlLine(
                          color: Colors.grey[200]!,
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                    ),
                  ),

                  // ── Line chart overlay (net balance) ──
                  IgnorePointer(
                    child: LineChart(
                      LineChartData(
                        maxY: chartMaxY,
                        minY: chartMinY,
                        minX: -0.5,
                        maxX: n - 0.5,
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(n, (i) =>
                                FlSpot(i.toDouble(), data[i].net)),
                            color: Colors.blue[700]!,
                            isCurved: true,
                            curveSmoothness: 0.3,
                            barWidth: 2.5,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (s, f, b, i) =>
                                  FlDotCirclePainter(
                                radius: 4,
                                color: Colors.blue[700]!,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              ),
                            ),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: false, reservedSize: leftSize),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: false, reservedSize: bottomSize),
                          ),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(enabled: false),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  final bool isBar;

  const _Legend(
      {required this.color, required this.label, required this.isBar});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        isBar
            ? Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(2)),
              )
            : Container(
                width: 20,
                height: 3,
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2)),
              ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
