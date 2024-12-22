import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../consts/consts.dart';

class ProfilePageButtonWidget extends StatelessWidget {
  final String buttonText;
  final IconData iconData;
  final int? fadeDuration;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onPressed;
  final bool hasTrailing;
  const ProfilePageButtonWidget({
    super.key,
    required this.buttonText,
    required this.iconData,
    this.iconColor = Consts.tertiaryAppColor,
    required this.onPressed,
    this.textColor = Colors.black87,
    this.hasTrailing = true,
    this.fadeDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: iconColor.withAlpha((255*0.2).toInt()),
                  radius: 24,
                  child: FaIcon(
                    iconData,
                    color: iconColor,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  buttonText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: textColor,
                  ),
                ),
              ],
            ),
            hasTrailing
                ? CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.shade500,
                      size: 18,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
