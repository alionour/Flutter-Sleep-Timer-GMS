import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_timer/src/themes/app_theme.dart';
import 'package:sleep_timer/src/themes/palettes/blue_palette.dart';
import 'package:sleep_timer/src/themes/palettes/teal_palette.dart';

final lightTealTheme = LightTealTheme(
  theme: ThemeData(
    textTheme: GoogleFonts.tajawalTextTheme(
      const TextTheme(
          caption: TextStyle(
        color: Color(0xFF248EA6),
      )),
    ),
    scaffoldBackgroundColor: const Color(0xFFF0F2F2),
    listTileTheme: const ListTileThemeData(
      textColor: Color(0xFF248EA6),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
    ).copyWith(
      secondary: const Color(0xFF248ea6),
      brightness: Brightness.light,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white),
      helperStyle: TextStyle(color: Colors.white),
      hintStyle: TextStyle(color: Colors.white),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    ),
    useMaterial3: true,
  ),
  key: 'teal',
  palette: TealPalette(),
);

class LightTealTheme extends AppTheme {
  LightTealTheme(
      {required ThemeData theme, required String key, required Palette palette})
      : super(theme: theme, key: key, palette: palette);
}
