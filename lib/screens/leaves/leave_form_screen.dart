import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/leave_provider.dart';
import '../../providers/employee_provider.dart';
import '../../database/app_database.dart';
import '../../widgets/common/form_fields/app_date_picker.dart';
import '../../widgets/common/form_fields/app_text_field.dart';
import '../../widgets/common/form_fields/app_dropdown.dart';

class LeaveFormScreen extends StatefulWidget {
  const LeaveFormScreen({super.key});

  @override
  State<LeaveFormScreen> createState() => _LeaveFormScreenState();
}

class _LeaveFormScreenState extends State<LeaveFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonCtrl = TextEditingController();

  int? _employeeId;
  String _leaveType = 'sick';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool _saving = false;

  int get _totalDays =>
      AppDateUtils.daysBetween(_startDate, _endDate);

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_employeeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ກະລຸນາເລືອກພະນັກງານ')));
      return;
    }
    setState(() => _saving = true);
    try {
      await context.read<LeaveProvider>().add(LeavesCompanion(
            employeeId: drift.Value(_employeeId!),
            leaveType: drift.Value(_leaveType),
            startDate: drift.Value(_startDate),
            endDate: drift.Value(_endDate),
            totalDays: drift.Value(_totalDays),
            reason: drift.Value(
                _reasonCtrl.text.trim().isEmpty
                    ? null
                    : _reasonCtrl.text.trim()),
          ));
      if (mounted) context.go('/leaves');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final employees = context.watch<EmployeeProvider>().filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addLeave),
        leading: BackButton(onPressed: () => context.go('/leaves')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppDropdown<int?>(
                        label: AppStrings.employee,
                        value: _employeeId,
                        items: [
                          const DropdownMenuItem(
                              value: null, child: Text('-- ເລືອກ --')),
                          ...employees.map((e) => DropdownMenuItem(
                                value: e.employee.id,
                                child: Text(
                                    '${e.employee.firstName} ${e.employee.lastName}'),
                              )),
                        ],
                        onChanged: (v) =>
                            setState(() => _employeeId = v),
                        validator: (v) =>
                            v == null ? 'ກະລຸນາເລືອກພະນັກງານ' : null,
                      ),
                      const SizedBox(height: 16),
                      AppDropdown<String>(
                        label: AppStrings.leaveType,
                        value: _leaveType,
                        items: const [
                          DropdownMenuItem(
                              value: 'sick',
                              child: Text(AppStrings.sickLeave)),
                          DropdownMenuItem(
                              value: 'annual',
                              child: Text(AppStrings.annualLeave)),
                          DropdownMenuItem(
                              value: 'unpaid',
                              child: Text(AppStrings.unpaidLeave)),
                        ],
                        onChanged: (v) =>
                            setState(() => _leaveType = v ?? 'sick'),
                      ),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(
                          child: AppDatePicker(
                            label: AppStrings.startDate,
                            value: _startDate,
                            onChanged: (d) {
                              setState(() {
                                _startDate = d;
                                if (_endDate.isBefore(_startDate)) {
                                  _endDate = _startDate;
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppDatePicker(
                            label: AppStrings.endDate,
                            value: _endDate,
                            firstDate: _startDate,
                            onChanged: (d) =>
                                setState(() => _endDate = d),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${AppStrings.totalDays}: $_totalDays ວັນ',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: AppStrings.reason,
                        controller: _reasonCtrl,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => context.go('/leaves'),
                            child: const Text(AppStrings.cancel),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _saving ? null : _save,
                            child: _saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : const Text(AppStrings.save),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
