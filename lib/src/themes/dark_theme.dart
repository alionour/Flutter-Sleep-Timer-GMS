import 'package:flutter/material.dart';

class MyDarkTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0x001b1e45).withOpacity(1),
    switchTheme: const SwitchThemeData(
        // thumbColor: MaterialStateProperty.all(Colors.pinkAccent)
        ),
    iconTheme: const IconThemeData(
      color: Colors.pinkAccent,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          Colors.pinkAccent,
        ),
      ),
    ),
  );
}
