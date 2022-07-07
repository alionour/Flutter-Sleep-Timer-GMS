import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_timer/src/themes/app_theme.dart';
import 'package:sleep_timer/src/themes/palettes/blue_palette.dart';

final darkBlueTheme = DarkBlueTheme(
  theme: ThemeData(
    textTheme: GoogleFonts.tajawalTextTheme(
      const TextTheme(
          caption: TextStyle(
        color: Color(0xFF381659),
      )),
    ),
    scaffoldBackgroundColor: BluePalette().globalScaffoldBackgroundcolor,
    listTileTheme: const ListTileThemeData(
      textColor: Color(0xFF381659),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF381659),
    ).copyWith(
      secondary: const Color(0xFF381659),
      brightness: Brightness.dark,
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
  key: 'blue',
  palette: BluePalette(),
);

class DarkBlueTheme extends AppTheme {
  DarkBlueTheme(
      {required ThemeData theme, required String key, required Palette palette})
      : super(theme: theme, key: key, palette: palette);
}
