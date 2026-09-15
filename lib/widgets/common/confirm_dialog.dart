import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    super.key,
    this.title = AppStrings.deleteConfirmTitle,
    this.content = AppStrings.confirmDelete,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    String title = AppStrings.deleteConfirmTitle,
    String content = AppStrings.confirmDelete,
    required VoidCallback onConfirm,
  }) async {
    await showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        content: content,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text(AppStrings.deleteAction,
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
