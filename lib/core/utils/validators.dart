class Validators {
  static String? required(String? value, [String label = 'ຂໍ້ມູນ']) {
    if (value == null || value.trim().isEmpty) {
      return 'ກະລຸນາປ້ອນ $label';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!RegExp(r'^\+?[\d\s\-]{7,15}$').hasMatch(value.trim())) {
      return 'ເບີໂທບໍ່ຖືກຕ້ອງ';
    }
    return null;
  }

  static String? positiveNumber(String? value, [String label = 'ຈຳນວນ']) {
    if (value == null || value.trim().isEmpty) return null;
    final n = double.tryParse(value.replaceAll(',', ''));
    if (n == null || n < 0) return '$label ຕ້ອງເປັນຕົວເລກ >= 0';
    return null;
  }
}
