import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePageInputWidget extends StatelessWidget {
  final TextEditingController? controller;
  final bool obscureText;
  final String? initialValue;
  final String? errorText;
  final String? labelText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final bool readOnly;
  final Color? fillColor;
  final Color labelTextColor;
  final FocusNode? focusNode;

  const ProfilePageInputWidget({
    super.key,
    this.obscureText = false,
    this.initialValue,
    this.keyboardType,
    this.onChanged,
    this.errorText,
    this.prefixIcon,
    this.labelText,
    this.readOnly = false,
    this.fillColor,
    this.labelTextColor = CupertinoColors.inactiveGray,
    this.focusNode,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onChanged: onChanged,
      initialValue: initialValue,
      obscureText: obscureText,
      canRequestFocus: readOnly ? false : true,
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: fillColor != null ? true : false,
        prefixIcon: prefixIcon,
        prefixIconConstraints: BoxConstraints(maxWidth: 50),
        label: labelText != null ? Text(labelText!) : null,
        labelStyle:
            TextStyle(color: labelTextColor, fontWeight: FontWeight.bold),
        errorText: errorText,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
