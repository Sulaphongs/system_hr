import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../providers/military_rank_provider.dart';
import '../../widgets/common/form_fields/app_text_field.dart';

class MilitaryRankFormScreen extends StatefulWidget {
  final int? rankId;
  const MilitaryRankFormScreen({super.key, this.rankId});

  @override
  State<MilitaryRankFormScreen> createState() => _MilitaryRankFormScreenState();
}

class _MilitaryRankFormScreenState extends State<MilitaryRankFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _levelCtrl = TextEditingController(text: '1');
  bool _saving = false;

  bool get _isEdit => widget.rankId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final rank = context
          .read<MilitaryRankProvider>()
          .ranks
          .where((r) => r.id == widget.rankId)
          .firstOrNull;
      if (rank != null) {
        _nameCtrl.text = rank.name;
        _codeCtrl.text = rank.code;
        _descCtrl.text = rank.description ?? '';
        _levelCtrl.text = rank.level.toString();
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _descCtrl.dispose();
    _levelCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final provider = context.read<MilitaryRankProvider>();
      final code = _codeCtrl.text.trim();
      final desc = _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();
      final level = int.tryParse(_levelCtrl.text) ?? 1;
      if (_isEdit) {
        await provider.edit(widget.rankId!, _nameCtrl.text.trim(), code, desc, level);
      } else {
        await provider.add(_nameCtrl.text.trim(), code, desc, level);
      }
      if (mounted) context.go('/military-ranks');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _isEdit ? AppStrings.editMilitaryRank : AppStrings.addMilitaryRank),
        leading: BackButton(onPressed: () => context.go('/military-ranks')),
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
                        Row(children: [
                        Expanded(
                          child: AppTextField(
                            label: AppStrings.militaryRankName,
                            controller: _nameCtrl,
                            validator: (v) => Validators.required(
                                v, AppStrings.militaryRankName),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 140,
                          child: AppTextField(
                            label: AppStrings.militaryRankCode,
                            controller: _codeCtrl,
                            validator: (v) => Validators.required(
                                v, AppStrings.militaryRankCode),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 110,
                          child: AppTextField(
                            label: AppStrings.militaryRankLevel,
                            controller: _levelCtrl,
                            keyboardType: TextInputType.number,
                            validator: (v) => Validators.positiveNumber(
                                v, AppStrings.militaryRankLevel),
                          ),
                        ),
                      ]),
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
                            onPressed: () => context.go('/military-ranks'),
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
