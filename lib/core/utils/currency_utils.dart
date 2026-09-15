import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyUtils {
  static final _fmt = NumberFormat('#,##0', 'en_US');

  static String format(double amount) => '${_fmt.format(amount)} ກີບ';

  static String formatCompact(double amount) => _fmt.format(amount);
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static final _fmt = NumberFormat('#,##0', 'en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '0',
        selection: TextSelection.collapsed(offset: 1),
      );
    }

    final number = int.parse(digitsOnly);
    final formatted = _fmt.format(number);

    // Count digits before cursor in the raw new text, then find matching
    // position in the formatted string so the cursor lands in the right place.
    final rawCursor = newValue.selection.end.clamp(0, newValue.text.length);
    final digitsBeforeCursor = newValue.text
        .substring(0, rawCursor)
        .replaceAll(RegExp(r'[^\d]'), '')
        .length;

    int newCursor = formatted.length;
    int seen = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (seen == digitsBeforeCursor) {
        newCursor = i;
        break;
      }
      if (RegExp(r'\d').hasMatch(formatted[i])) seen++;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursor),
    );
  }
}
