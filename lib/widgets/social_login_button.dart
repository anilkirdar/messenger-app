import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final Color buttonTextColor;
  final Color buttonColor;
  final Widget? buttonIcon;
  final VoidCallback onPressed;
  final double? radius;
  const SocialLoginButton(
      {super.key,
      required this.buttonText,
      required this.buttonColor,
      this.buttonIcon,
      required this.onPressed,
      required this.buttonTextColor,
      this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      height: MediaQuery.sizeOf(context).height / 14,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buttonIcon ?? const SizedBox(),
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: buttonTextColor,
                ),
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
