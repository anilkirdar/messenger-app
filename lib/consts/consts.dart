import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Consts {
  static const String initialEmail = 'test1@gmail.com';
  static const String initialPass = '123456';

  static const Color primaryAppColor = Color(0xFFF4CE14);
  // static const Color primaryAppColor = Colors.blue;
  static const Color secondaryAppColor = Colors.greenAccent;
  static const Color tertiaryAppColor = Color(0xFF8FD14F);
  static const Color quaternaryAppColor = Color.fromARGB(255, 108, 179, 37);
  static const Color inactiveColor = CupertinoColors.inactiveGray;

  static const Color backgroundColor = Colors.white;

  static TextStyle titleTextStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 30,
    color: Colors.black,
  );
}
