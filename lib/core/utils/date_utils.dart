import 'package:intl/intl.dart';
import '../constants/app_strings.dart';

class AppDateUtils {
  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static final _timeFormat = DateFormat('HH:mm');
static String formatDate(DateTime? date) {
    if (date == null) return '-';
    return _dateFormat.format(date);
  }

  static String formatTime(DateTime? time) {
    if (time == null) return '-';
    return _timeFormat.format(time);
  }

  static String formatMonthYear(int month, int year) {
    return '${AppStrings.months[month - 1]} $year';
  }

  static DateTime toDateOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  static int daysBetween(DateTime from, DateTime to) {
    final f = toDateOnly(from);
    final t = toDateOnly(to);
    return t.difference(f).inDays + 1;
  }

  static String yearsOfService(DateTime hireDate) {
    final now = DateTime.now();
    int years = now.year - hireDate.year;
    int months = now.month - hireDate.month;
    if (months < 0) {
      years--;
      months += 12;
    }
    if (years < 0) return '-';
    return '$years ປີ';
  }

  static int yearsOfServiceInt(DateTime hireDate) {
    final now = DateTime.now();
    int years = now.year - hireDate.year;
    if (now.month < hireDate.month) years--;
    return years < 0 ? 0 : years;
  }

  /// ເງິນອາວຸໂສຕາມສູດ 4 ຂັ້ນ
  /// ປີ 1–5 = 10,000/ປີ, ປີ 6–15 = 20,000/ປີ,
  /// ປີ 16–25 = 30,000/ປີ, ປີ 26+ = 40,000/ປີ
  static double calcSeniorityAllowance(int years) {
    if (years <= 0) return 0;
    double total = 0;
    total += years.clamp(0, 5) * 10000;
    if (years > 5)  total += (years - 5).clamp(0, 10) * 20000;
    if (years > 15) total += (years - 15).clamp(0, 10) * 30000;
    if (years > 25) total += (years - 25) * 40000;
    return total;
  }
}
