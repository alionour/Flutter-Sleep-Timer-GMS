import 'package:flutter/material.dart';
import 'package:sleep_timer/src/themes/palettes/blue_palette.dart';

/// This Palette is used to define the colors used in the app.
/// and is generated by coolers.co
/// ["526DA1","D7DCE2","070D6C","03034B","383294"]
class TealPalette extends Palette {
  TealPalette._private();
  static final _instance = TealPalette._private();
  factory TealPalette() {
    return _instance;
  }
  @override
  Color get appBarColor => const Color(0xFF4A7C59);
  @override
  Color get appBarTextColor => const Color(0xFFD7DCE2);
  @override
  Color get appBarIconColor => const Color(0xFFD7DCE2);

  @override
  Color get globalScaffoldBackgroundcolor => const Color(0xFFFAF3DD);

  @override
  Color get cardColor => const Color(0xFF4A7C59);

  @override
  Color get switchColor => const Color(0xFF4A7C59);

  @override
  Color get iconColor => const Color(0xFF4A7C59);

  @override
  Color get switchTrackColorActive => const Color(0xFF8FC0A9);

  @override
  Color get switchTrackInactiveColor => const Color(0xFFD7DCE2);

  @override
  Color get answerCorrectColor => Colors.greenAccent;

  @override
  Color get answerIncorrectColor => Colors.redAccent;

  @override
  Color get answerSelectedColor => appBarColor;
}
