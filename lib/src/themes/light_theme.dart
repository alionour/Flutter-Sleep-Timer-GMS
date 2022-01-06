import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    switchTheme: const SwitchThemeData(
        // thumbColor: MaterialStateProperty.all(Colors.greenAccent)
        ),
    iconTheme: const IconThemeData(color: Colors.teal),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          Colors.teal,
        ),
      ),
    ),
  );
}
