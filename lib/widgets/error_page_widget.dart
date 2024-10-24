import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ErrorPageWidget extends StatelessWidget {
  final String text;
  final IconData? iconData;
  const ErrorPageWidget({super.key, required this.text, this.iconData});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconData != null)
            FaIcon(
              iconData,
              size: MediaQuery.of(context).size.height / 10,
              color: Colors.black54,
            ),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
