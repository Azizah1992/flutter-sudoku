import 'package:flutter/material.dart';

class CustomStyles {
  static const Color black = Color(0xFF000000);

  static const int theme = 0xFF4c566a;

  // Polar Night
  static const nord3 = Color.fromARGB(255, 76, 106, 88);

  // Snow Storm
  static const nord6 = Color(0xFFeceff4);

  static const TextStyle titleText = TextStyle(
    fontSize: 30,
    color: nord6,
  );
  static ButtonStyle darkButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(CustomStyles.nord3),
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0))),
  );

  static ButtonStyle boardButtonStyle = ButtonStyle();
}
