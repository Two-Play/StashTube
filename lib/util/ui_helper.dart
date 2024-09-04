// snack bar helper haptic feedback bool
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void snackBarHelper(BuildContext context, String message, { bool hapticFeedback=true, color=Colors.red }) {
  if (hapticFeedback) {
    HapticFeedback.vibrate();
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
    ),
  );
}

Future<void> alertDialogHelperA(BuildContext context, String title, String content, {Function? onOk, Function? onCancel}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (onCancel != null) {
                onCancel();
              }
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (onOk != null) {
                onOk();
              }
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

// dialog alert with n buttons
void alertDialogHelper(BuildContext context, String title, String content, List<Widget> buttons, {bool barrierDismissible = false}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: buttons,
      );
    },
  );
}