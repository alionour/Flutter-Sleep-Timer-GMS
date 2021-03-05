import 'package:flutter/material.dart';

class MyDarkTheme {
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Color(0x1B1E45).withOpacity(1),
      switchTheme: SwitchThemeData(),
      iconTheme: IconThemeData(color: Colors.pinkAccent));
}
