import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _presets = [
    (label: 'ນ້ອຍ', scale: 0.85),
    (label: 'ປົກກະຕິ', scale: 1.00),
    (label: 'ໃຫຍ່', scale: 1.15),
    (label: 'ໃຫຍ່ຫຼາຍ', scale: 1.30),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ຕັ້ງຄ່າລະບົບ')),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          final pct = (settings.fontScale * 100).round();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Font size card ───────────────────────────
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(Icons.text_fields_rounded,
                                  color: AppColors.primary, size: 22),
                              const SizedBox(width: 10),
                              Text('ຂະໜາດຕົວໜັງສື',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold)),
                            ]),
                            const SizedBox(height: 20),

                            // Preview box
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppColors.divider, width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ຕົວຢ່າງຂໍ້ຄວາມ — Preview Text',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'ລະບົບຈັດການພະນັກງານ HR System',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'ຊື່ / ນາມສະກຸນ / ຕຳແໜ່ງ / ເງິນເດືອນ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Preset buttons
                            Row(
                              children:
                                  _presets.map((p) {
                                final selected =
                                    (settings.fontScale - p.scale).abs() <
                                        0.01;
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: selected
                                            ? AppColors.primary
                                            : Colors.grey.shade200,
                                        foregroundColor: selected
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () =>
                                          settings.setFontScale(p.scale),
                                      child: Text(p.label,
                                          style: TextStyle(
                                              fontSize: 11 * p.scale,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),

                            // Slider
                            Row(
                              children: [
                                const Icon(Icons.text_decrease,
                                    size: 18, color: Colors.grey),
                                Expanded(
                                  child: Slider(
                                    value: settings.fontScale,
                                    min: SettingsProvider.minScale,
                                    max: SettingsProvider.maxScale,
                                    divisions: 15,
                                    activeColor: AppColors.primary,
                                    onChanged: settings.setFontScale,
                                  ),
                                ),
                                const Icon(Icons.text_increase,
                                    size: 22, color: Colors.grey),
                              ],
                            ),

                            // Percentage label + reset
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '$pct%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: settings.reset,
                                  icon: const Icon(Icons.refresh, size: 16),
                                  label: const Text('ຄືນຄ່າເດີມ'),
                                  style: TextButton.styleFrom(
                                      foregroundColor:
                                          AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
