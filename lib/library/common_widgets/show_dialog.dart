import 'package:flutter/material.dart';

class ReusableDialog {
  static Future<void> showMyDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required VoidCallback onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            if (cancelText != null && onCancel != null)
              TextButton(
                onPressed: onCancel,
                child: Text(cancelText),
              ),
            TextButton(
              onPressed: onConfirm,
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
