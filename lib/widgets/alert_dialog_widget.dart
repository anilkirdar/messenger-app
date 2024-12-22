import 'package:flutter/material.dart';

import '../consts/consts.dart';

class AlertDialogWidget extends StatelessWidget {
  final String content;
  final String mainButtonText;
  final String? cancelButtonText;
  final Color mainButtonTextColor;
  const AlertDialogWidget(
      {super.key,
      required this.content,
      required this.mainButtonText,
      this.cancelButtonText,
      required this.mainButtonTextColor});

  Future<bool?> showAlertDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => this,
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Consts.backgroundColor,
      actionsPadding: EdgeInsets.zero,
      title: Text(
        content,
        maxLines: 2,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        textAlign: TextAlign.center,
      ),
      actions: _dialogButtons(context),
    );
  }

  List<Widget> _dialogButtons(BuildContext context) {
    final List<Widget> buttons = [];

    buttons.add(const Divider(height: 0, color: Colors.black12));
    buttons.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: Center(
            child: Text(
              mainButtonText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: mainButtonTextColor,
              ),
            ),
          ),
        ),
      ),
    );

    if (cancelButtonText != null) {
      buttons.add(const Divider(height: 0, color: Colors.black12));
      buttons.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context, false);
            },
            child: Center(
              child: Text(
                cancelButtonText!,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
          ),
        ),
      );
    }

    return buttons;
  }
}
