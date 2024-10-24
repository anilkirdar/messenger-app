import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../consts/consts.dart';

class SignPageButtonWidget extends StatelessWidget {
  final Widget? buttonIcon;
  final int? fadeDuration;
  final String buttonText;
  final Color buttonColor;
  final Color buttonTextColor;
  final double extraHorizontalPadding;
  final bool hasBorder;
  final VoidCallback onPressed;

  const SignPageButtonWidget({
    super.key,
    this.buttonIcon,
    this.fadeDuration,
    required this.buttonText,
    this.buttonColor = Consts.inactiveColor,
    required this.onPressed,
    this.extraHorizontalPadding = 0,
    this.hasBorder = true,
    this.buttonTextColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: fadeDuration ?? 0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: extraHorizontalPadding),
        child: Container(
          padding: EdgeInsets.only(top: 3, left: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: hasBorder
                ? Border(
                    bottom: BorderSide(color: Colors.black),
                    top: BorderSide(color: Colors.black),
                    left: BorderSide(color: Colors.black),
                    right: BorderSide(color: Colors.black),
                  )
                : null,
          ),
          child: MaterialButton(
            minWidth: double.infinity,
            height: 60,
            onPressed: onPressed,
            color: buttonColor,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: Row(
              mainAxisAlignment: buttonIcon != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                if (buttonIcon != null) buttonIcon!,
                Center(
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: buttonTextColor,
                    ),
                  ),
                ),
                if (buttonIcon != null) SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
