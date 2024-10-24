import 'package:flutter/material.dart';

class SignPageInputWidget extends StatelessWidget {
  final String label;
  final bool obscureText;
  final String? initialValue;
  final String? errorText;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const SignPageInputWidget(
      {super.key,
      required this.label,
      this.obscureText = false,
      this.initialValue,
      this.keyboardType,
      required this.onChanged,
      this.errorText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          keyboardType: keyboardType,
          onChanged: onChanged,
          initialValue: initialValue,
          obscureText: obscureText,
          decoration: InputDecoration(
            errorText: errorText,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
