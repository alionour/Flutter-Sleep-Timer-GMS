import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_timer/src/themes/palettes/blue_palette.dart';

final tajawal = GoogleFonts.tajawal();

// this class represents app theme with identifier to easily access theme
abstract class AppTheme extends Equatable {
  late final ThemeData theme;
  final String key;
  final Palette palette;
  AppTheme({
    required ThemeData theme,
    required this.key,
    required this.palette,
  }) {
    /// this part to make some characteristics same between all themes
    this.theme = theme.copyWith(
      cardColor: palette.cardColor,
      dialogTheme: DialogTheme(
          backgroundColor: palette.appBarColor,
          titleTextStyle: const TextStyle(
            color: Colors.white,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.white,
          )),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return palette.switchColor;
          }
          return palette.switchTrackColorActive;
        }),
        overlayColor: MaterialStateProperty.all(palette.switchTrackColorActive),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return palette.switchColor.withOpacity(0.8);
          }
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          }
          return palette.switchTrackInactiveColor;
        }),
      ),
      iconTheme: IconThemeData(
        color: palette.iconColor,
      ),
      textTheme: const TextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.appBarColor,
        centerTitle: true,
        // foregroundColor: BluePalette.appBarTextColor,
        titleTextStyle: TextStyle(
          color: palette.appBarTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: tajawal.fontFamily,
        ),

        toolbarTextStyle: TextStyle(
          color: palette.appBarTextColor,
          fontSize: 20,
          fontFamily: tajawal.fontFamily,
          fontWeight: FontWeight.w600,
        ),
        actionsIconTheme: IconThemeData(
          color: palette.appBarIconColor,
        ),
        iconTheme: IconThemeData(
          color: palette.appBarIconColor,
        ),
      ),
    );
  }

  @override
  String toString() {
    return '$key:$theme';
  }

  @override
  List<Object?> get props => [theme, key, palette];
}
