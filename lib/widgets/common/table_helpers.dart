import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TableSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hint;

  const TableSearchField({
    super.key,
    required this.onChanged,
    this.hint = 'ຄົ້ນຫາ...',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon:
            Icon(Icons.search_rounded, color: Colors.grey[500], size: 20),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        isDense: true,
      ),
    );
  }
}

class TableEmptyState extends StatelessWidget {
  final IconData icon;
  final String label;

  const TableEmptyState({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(label,
              style: TextStyle(color: Colors.grey[400], fontSize: 15)),
        ],
      ),
    );
  }
}

abstract class TableStyle {
  static MaterialStateProperty<Color?> get headingRowColor =>
      WidgetStateProperty.all(AppColors.primary.withValues(alpha: 0.08));

  static const TextStyle headingTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    fontSize: 13,
  );

  static const double rowHeight = 52.0;
  static const double horizontalMargin = 20.0;
  static const double columnSpacing = 24.0;
  static const double dividerThickness = 0.5;
}
