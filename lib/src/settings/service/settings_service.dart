import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:sleep_timer/src/themes/app_theme.dart';
import 'package:sleep_timer/src/themes/dark_blue_theme.dart';
import 'package:sleep_timer/src/themes/light_teal_theme.dart';

const runInBackgroundKey = 'runInBackground';
const goToHomeKey = 'goToHome';
const silentModeKey = 'silentMode';
const languageCodeKey = 'languageCode';
const notificationsOnKey = 'notificationsOn';
const turnOffScreenKey = 'turnOffScreen';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// local storage box that contains data stored locally
  /// which is specific for settings
  final _settingsBox = Hive.box('settings');
  SettingsService();

  /// Loads the User's preferred themeData from local or remote storage.
  Future<AppTheme> get theme async {
    final themeKey = await _settingsBox.get('theme_data') as String?;
    log('theme key$themeKey');
    late AppTheme theme;
    switch (themeKey) {
      case 'teal':
        theme = lightTealTheme;
        break;
      case 'blue':
        theme = darkBlueTheme;
        break;
      default:
        theme = lightTealTheme;
    }
    return theme;
  }

  Future<bool> get notificationsOn async {
    final notificationsOn =
        await _settingsBox.get(notificationsOnKey) as bool? ?? true;
    log('notifications on$notificationsOn');
    return notificationsOn;
  }

  /// Persists the user's preferred ThemeData to local or remote storage.
  Future<void> updateNotificationsOn(bool value) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    await _settingsBox.put(notificationsOnKey, value);
  }

  Future<bool> get turnOffScreen async {
    final notificationsOn =
        await _settingsBox.get(turnOffScreenKey) as bool? ?? true;
    log('notifications on$notificationsOn');
    return notificationsOn;
  }

  /// Persists the user's preferred ThemeData to local or remote storage.
  Future<void> updateTurnOffScreen(bool value) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    await _settingsBox.put(turnOffScreenKey, value);
  }

  Future<bool> get runInBackground async {
    final runInBackground =
        await _settingsBox.get(runInBackgroundKey) as bool? ?? true;
    log('notifications on$runInBackground');
    return runInBackground;
  }

  /// Persists the user's preferred ThemeData to local or remote storage.
  Future<void> updateRunInBackground(bool value) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    await _settingsBox.put(runInBackgroundKey, value);
  }

  Future<bool> get goToHome async {
    final runInBackground =
        await _settingsBox.get(goToHomeKey) as bool? ?? true;
    log('notifications on$runInBackground');
    return runInBackground;
  }

  /// Persists the user's preferred ThemeData to local or remote storage.
  Future<void> updateGoToHomeScreen(bool value) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    await _settingsBox.put(goToHomeKey, value);
  }

  Future<bool> get silentMode async {
    final runInBackground =
        await _settingsBox.get(silentModeKey) as bool? ?? false;
    log('notifications on$runInBackground');
    return runInBackground;
  }

  /// Persists the user's preferred ThemeData to local or remote storage.
  Future<void> updateSilentMode(bool value) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    await _settingsBox.put(silentModeKey, value);
  }

  Future<String> get languageCode async {
    final runInBackground =
        await _settingsBox.get(languageCodeKey) as String? ?? 'en';
    log('notifications on$runInBackground');
    return runInBackground;
  }

  /// Persists the user's preferred ThemeData to local or remote storage.
  Future<void> updateLanguageCode(String value) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    await _settingsBox.put(languageCodeKey, value);
  }

  /// Persists the user's preferred ThemeData to local or remote storage.
  Future<void> updateThemeData(AppTheme theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    _settingsBox.put('theme_data', theme.key);
    log('Theme saved ${await _settingsBox.get('theme_data')}');
  }

  Future<void> resetToDefault() async {
    await _settingsBox.clear();
  }
}
