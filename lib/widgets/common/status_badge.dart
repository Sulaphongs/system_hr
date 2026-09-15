import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({super.key, required this.label, required this.color});

  factory StatusBadge.attendance(String status) {
    final map = {
      'present': (label: 'ມາວຽກ', color: Colors.green),
      'absent': (label: 'ຂາດ', color: Colors.red),
      'late': (label: 'ມາຊ້າ', color: Colors.orange),
      'half_day': (label: 'ເຄິ່ງວັນ', color: Colors.blue),
    };
    final e = map[status] ?? (label: status, color: Colors.grey);
    return StatusBadge(label: e.label, color: e.color);
  }

  factory StatusBadge.leave(String status) {
    final map = {
      'pending': (label: 'ລໍຖ້າ', color: Colors.orange),
      'approved': (label: 'ອະນຸມັດ', color: Colors.green),
      'rejected': (label: 'ປະຕິເສດ', color: Colors.red),
    };
    final e = map[status] ?? (label: status, color: Colors.grey);
    return StatusBadge(label: e.label, color: e.color);
  }

  factory StatusBadge.employee(String status) {
    return StatusBadge(
      label: status == 'active' ? 'ເຮັດວຽກ' : 'ອອກວຽກ',
      color: status == 'active' ? Colors.green : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
