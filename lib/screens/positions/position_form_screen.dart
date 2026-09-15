import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../providers/position_provider.dart';
import '../../widgets/common/form_fields/app_text_field.dart';

class PositionFormScreen extends StatefulWidget {
  final int? positionId;
  const PositionFormScreen({super.key, this.positionId});

  @override
  State<PositionFormScreen> createState() => _PositionFormScreenState();
}

class _PositionFormScreenState extends State<PositionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _saving = false;

  bool get _isEdit => widget.positionId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final pos = context
          .read<PositionProvider>()
          .positions
          .where((p) => p.id == widget.positionId)
          .firstOrNull;
      if (pos != null) {
        _nameCtrl.text = pos.name;
        _descCtrl.text = pos.description ?? '';
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final provider = context.read<PositionProvider>();
      final desc =
          _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();
      if (_isEdit) {
        await provider.edit(widget.positionId!, _nameCtrl.text.trim(), desc);
      } else {
        await provider.add(_nameCtrl.text.trim(), desc);
      }
      if (mounted) context.go('/positions');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? AppStrings.editPosition : AppStrings.addPosition),
        leading: BackButton(onPressed: () => context.go('/positions')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Auto-code display
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.tag,
                                size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 8),
                            Text(
                              _isEdit
                                  ? 'ລະຫັດ: P${widget.positionId.toString().padLeft(3, '0')}'
                                  : 'ລະຫັດ: (ອັດຕະໂນມັດ)',
                              style: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: AppStrings.positionName,
                        controller: _nameCtrl,
                        validator: (v) =>
                            Validators.required(v, AppStrings.positionName),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: AppStrings.description,
                        controller: _descCtrl,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => context.go('/positions'),
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
                                        strokeWidth: 2),
                                  )
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
