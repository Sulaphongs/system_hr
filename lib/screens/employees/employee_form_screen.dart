import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../database/app_database.dart';
import '../../providers/employee_provider.dart';
import '../../providers/position_provider.dart';
import '../../providers/military_rank_provider.dart';
import '../../widgets/common/form_fields/app_text_field.dart';
import '../../widgets/common/form_fields/app_date_picker.dart';
import '../../widgets/common/form_fields/app_dropdown.dart';

class EmployeeFormScreen extends StatefulWidget {
  final int? employeeId;
  const EmployeeFormScreen({super.key, this.employeeId});

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _salaryCtrl = TextEditingController(text: '0');

  String _gender = 'male';
  DateTime? _birthDate;
  DateTime _hireDate = DateTime.now();
  int? _positionId;
  int? _militaryRankId;
  String _status = 'active';
  String? _photoPath;
  bool _saving = false;

  bool get _isEdit => widget.employeeId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _loadExisting();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _codeCtrl.text =
                context.read<EmployeeProvider>().nextCode;
          });
        }
      });
    }
  }

  Future<void> _loadExisting() async {
    final emp =
        await context.read<EmployeeProvider>().getById(widget.employeeId!);
    if (emp == null || !mounted) return;
    setState(() {
      _codeCtrl.text = emp.employeeCode;
      _firstCtrl.text = emp.firstName;
      _lastCtrl.text = emp.lastName;
      _gender = const ['male', 'female', 'other'].contains(emp.gender)
            ? emp.gender
            : 'male';
      _birthDate = emp.birthDate;
      _phoneCtrl.text = emp.phone ?? '';
      _addressCtrl.text = emp.address ?? '';
      _positionId = emp.positionId;
      _militaryRankId = emp.militaryRankId;
      _hireDate = emp.hireDate;
      _salaryCtrl.text = emp.salary.toStringAsFixed(0);
      _status = emp.status;
      _photoPath = emp.photoPath;
    });
  }

  Future<void> _pickPhoto() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result == null || result.files.isEmpty) return;
    final src = result.files.first.path;
    if (src == null) return;
    final dir = await getApplicationSupportDirectory();
    final photosDir = Directory(p.join(dir.path, 'photos'));
    await photosDir.create(recursive: true);
    final dest = p.join(photosDir.path,
        '${DateTime.now().millisecondsSinceEpoch}${p.extension(src)}');
    await File(src).copy(dest);
    if (mounted) setState(() => _photoPath = dest);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final salary =
          double.tryParse(_salaryCtrl.text.replaceAll(',', '')) ?? 0;
      final entry = EmployeesCompanion(
        id: _isEdit
            ? drift.Value(widget.employeeId!)
            : const drift.Value.absent(),
        employeeCode: drift.Value(_codeCtrl.text.trim()),
        firstName: drift.Value(_firstCtrl.text.trim()),
        lastName: drift.Value(_lastCtrl.text.trim()),
        gender: drift.Value(_gender),
        birthDate: drift.Value(_birthDate),
        phone: drift.Value(
            _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim()),
        address: drift.Value(_addressCtrl.text.trim().isEmpty
            ? null
            : _addressCtrl.text.trim()),
        positionId: drift.Value(_positionId),
        militaryRankId: drift.Value(_militaryRankId),
        hireDate: drift.Value(_hireDate),
        salary: drift.Value(salary),
        status: drift.Value(_status),
        photoPath: drift.Value(_photoPath),
        updatedAt: drift.Value(DateTime.now()),
      );
      final provider = context.read<EmployeeProvider>();
      if (_isEdit) {
        await provider.edit(entry);
      } else {
        await provider.add(entry);
      }
      if (mounted) context.go('/employees');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _salaryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final positions = context.watch<PositionProvider>().positions;
    final ranks = context.watch<MilitaryRankProvider>().ranks;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(_isEdit ? AppStrings.editEmployee : AppStrings.addEmployee),
        leading: BackButton(onPressed: () => context.go('/employees')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: _photoPath != null
                              ? FileImage(File(_photoPath!))
                              : null,
                          child: _photoPath == null
                              ? const Icon(Icons.person, size: 48)
                              : null,
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _pickPhoto,
                          icon: const Icon(Icons.photo_camera, size: 16),
                          label: const Text(AppStrings.photo),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ຂໍ້ມູນສ່ວນຕົວ',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 16),
                          Row(children: [
                            Expanded(
                                child: AppTextField(
                              label: AppStrings.employeeCode,
                              controller: _codeCtrl,
                              readOnly: !_isEdit,
                              suffixIcon: !_isEdit
                                  ? Tooltip(
                                      message: 'ລະຫັດ auto',
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withValues(
                                              alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Text('AUTO',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue)),
                                      ),
                                    )
                                  : null,
                              validator: (v) => Validators.required(
                                  v, AppStrings.employeeCode),
                            )),
                            const SizedBox(width: 16),
                            Expanded(
                                child: AppDropdown<String>(
                              label: AppStrings.gender,
                              value: _gender,
                              items: const [
                                DropdownMenuItem(
                                    value: 'male',
                                    child: Text(AppStrings.male)),
                                DropdownMenuItem(
                                    value: 'female',
                                    child: Text(AppStrings.female)),
                                DropdownMenuItem(
                                    value: 'other',
                                    child: Text(AppStrings.other)),
                              ],
                              onChanged: (v) =>
                                  setState(() => _gender = v ?? 'male'),
                            )),
                          ]),
                          const SizedBox(height: 16),
                          Row(children: [
                            Expanded(
                                child: AppTextField(
                              label: AppStrings.firstName,
                              controller: _firstCtrl,
                              validator: (v) => Validators.required(
                                  v, AppStrings.firstName),
                            )),
                            const SizedBox(width: 16),
                            Expanded(
                                child: AppTextField(
                              label: AppStrings.lastName,
                              controller: _lastCtrl,
                              validator: (v) => Validators.required(
                                  v, AppStrings.lastName),
                            )),
                          ]),
                          const SizedBox(height: 16),
                          Row(children: [
                            Expanded(
                                child: AppDatePicker(
                              label: AppStrings.birthDate,
                              value: _birthDate,
                              onChanged: (d) =>
                                  setState(() => _birthDate = d),
                            )),
                            const SizedBox(width: 16),
                            Expanded(
                                child: AppTextField(
                              label: AppStrings.phone,
                              controller: _phoneCtrl,
                              validator: Validators.phone,
                              keyboardType: TextInputType.phone,
                            )),
                          ]),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: AppStrings.address,
                            controller: _addressCtrl,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ຂໍ້ມູນການວຽກ',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 16),
                          Row(children: [
                            Expanded(
                                child: AppDropdown<int?>(
                              label: AppStrings.position,
                              value: _positionId,
                              items: [
                                const DropdownMenuItem(
                                    value: null, child: Text('-')),
                                ...positions.map((pos) => DropdownMenuItem(
                                    value: pos.id, child: Text(pos.name))),
                              ],
                              onChanged: (v) =>
                                  setState(() => _positionId = v),
                            )),
                            const SizedBox(width: 16),
                            Expanded(
                                child: AppDropdown<int?>(
                              label: AppStrings.militaryRank,
                              value: _militaryRankId,
                              items: [
                                const DropdownMenuItem(
                                    value: null, child: Text('-')),
                                ...ranks.map((r) => DropdownMenuItem(
                                    value: r.id,
                                    child: Text('${r.code} - ${r.name}'))),
                              ],
                              onChanged: (v) =>
                                  setState(() => _militaryRankId = v),
                            )),
                          ]),
                          const SizedBox(height: 16),
                          Row(children: [
                            Expanded(
                                child: AppDatePicker(
                              label: AppStrings.hireDate,
                              value: _hireDate,
                              onChanged: (d) =>
                                  setState(() => _hireDate = d),
                            )),
                            const SizedBox(width: 16),
                            Expanded(
                                child: AppTextField(
                              label: '${AppStrings.salary} (ກີບ)',
                              controller: _salaryCtrl,
                              keyboardType: TextInputType.number,
                              validator: (v) => Validators.positiveNumber(
                                  v, AppStrings.salary),
                            )),
                          ]),
                          const SizedBox(height: 16),
                          AppDropdown<String>(
                            label: AppStrings.status,
                            value: _status,
                            items: const [
                              DropdownMenuItem(
                                  value: 'active',
                                  child: Text(AppStrings.active)),
                              DropdownMenuItem(
                                  value: 'inactive',
                                  child: Text(AppStrings.inactive)),
                            ],
                            onChanged: (v) =>
                                setState(() => _status = v ?? 'active'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => context.go('/employees'),
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
    );
  }
}
