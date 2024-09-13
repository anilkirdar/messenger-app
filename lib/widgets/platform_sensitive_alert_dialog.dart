import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'platform_sensitive_widget_base.dart';

class PlatformSensitiveAlertDialog extends PlatformSensitiveWidgetBase {
  final String title;
  final String content;
  final String mainButtonText;
  final String? cancelButtonText;

  const PlatformSensitiveAlertDialog(
      {required this.title,
      required this.content,
      required this.mainButtonText,
      this.cancelButtonText,
      super.key});

  Future<bool?> showAlertDialog(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false,
          )
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false,
          );
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButtons(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButtons(context),
    );
  }

  List<Widget> _dialogButtons(BuildContext context) {
    final List<Widget> buttons = [];

    if (Platform.isIOS) {
      if (cancelButtonText != null) {
        buttons.add(
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(cancelButtonText!),
          ),
        );
      }

      buttons.add(
        CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(mainButtonText),
        ),
      );
    } else {
      if (cancelButtonText != null) {
        buttons.add(
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(cancelButtonText!),
          ),
        );
      }

      buttons.add(
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(mainButtonText),
        ),
      );
    }

    return buttons;
  }
}
