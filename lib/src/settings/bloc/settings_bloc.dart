import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:device_policy_manager/device_policy_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleep_timer/src/app/services/background_tasks/background_tasks.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sleep_timer/src/settings/service/service.dart';
import 'package:sleep_timer/src/themes/app_theme.dart';
import 'package:sleep_timer/src/themes/dark_blue_theme.dart';
import 'package:sleep_timer/src/themes/light_teal_theme.dart';
import 'package:sound_mode/permission_handler.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService = SettingsService();

  SettingsBloc()
      : super(
          InitialSettingsState(
            appTheme: lightTealTheme,
            goToHome: true,
            languageCode: 'en',
            notification: true,
            runInBackground: true,
            silentMode: false,
            turnOffScreen: false,
            turnOffBluetooth: false,
            turnOffWifi: false,
          ),
        ) {
    on<ChangeThemeData>(_onThemDataChange);
    on<LoadSettings>(_onLoadingSettings);
    on<ChangeSilentMode>(_onSilentModeChanged);
    on<ChangeGoToHomeScreen>(_onGoToHomeScreenChanged);
    on<ChangeLanguage>(_onLanguageChanged);
    on<ChangeNotificationsOn>(_onNotificationsChanged);
    on<ChangeRunInBackground>(_onRunInBackgroundChanged);
    on<ResetToDefault>(_onResetToDefault);
    on<ChangeTurnOffScreen>(_onTurnOffScreenChanged);
    on<ChangeBluetooth>(_onTurnOffBluetoothChanged);
    on<ChangeWifi>(_onTurnOffWifiChanged);

    // Load the user's preferred theme while the splash screen is displayed.
    // This prevents a sudden theme change when the app is first displayed.
    add(LoadSettings());
  }

  List<AppTheme> themes = [lightTealTheme, darkBlueTheme];

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> _onLoadingSettings(
      LoadSettings event, Emitter<SettingsState> emit) async {
    final appTheme = await _settingsService.theme;
    final languageCode = await _settingsService.languageCode;
    final goToHome = await _settingsService.goToHome;
    final runInBackground = await _settingsService.runInBackground;
    final silentMode = await _settingsService.silentMode;
    final notificationsOn = await _settingsService.notificationsOn;
    final turnOffScreen = await _settingsService.turnOffScreen;
    final turnOffWifi = await _settingsService.turnOffWifi;
    final turnOffBluetooth = await _settingsService.turnOffBluetooth;
    // Important! Inform listeners a change has occurred.
    emit(
      state.copyWith(
          appTheme: appTheme,
          goToHome: goToHome,
          languageCode: languageCode,
          notification: notificationsOn,
          runInBackground: runInBackground,
          silentMode: silentMode,
          turnOffScreen: turnOffScreen,
          turnOffBluetooth: turnOffBluetooth,
          turnOffWifi: turnOffWifi),
    );
    log('loaded settings');
  }

  /// Update and persist the ThemeData based on the user's selection.
  FutureOr<void> _onThemDataChange(
      ChangeThemeData event, Emitter<SettingsState> emit) async {
    final newTheme = event.appTheme;

    // Do not perform any work if new and old ThemeMode are identical
    if (newTheme == state.appTheme) return;

    // Important! Inform listeners a change has occurred.
    emit(state.copyWith(
      appTheme: newTheme,
    ));
    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeData(newTheme);
    log('updating theme ${newTheme.key}');
  }

  List<String> languages = ['en', 'ar', 'ch'];

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  Future<void> _onSilentModeChanged(
      ChangeSilentMode event, Emitter<SettingsState> emit) async {
    // checks if permissions is granted!!
    bool isGranted = await PermissionHandler.permissionsGranted ?? false;
    if (!isGranted) {
      // dialog for user to give required permissions
      await Get.dialog<bool>(
        AlertDialog(
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () {
                Get.back(result: true);
              },
              child: const Text('Allow'),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: const Text('Dismiss'),
            ),
          ],
          title: const ListTile(
            leading: Icon(Icons.notification_important),
            title: Text('Permissions Required'),
          ),
          content: const FittedBox(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  '''To activate this feature, "Do not disturb" permission is required''',
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ),
        ),
      ).then(
        (allowed) async {
          if (allowed!) {
            // Opens the Do Not Disturb Access settings to grant the access
            await PermissionHandler.openDoNotDisturbSetting();
          }
        },
      );
    }
    if (isGranted) {
      _settingsService.updateSilentMode(event.silentMode);
      emit(
        state.copyWith(silentMode: event.silentMode),
      );
    }
  }

  void _onGoToHomeScreenChanged(
      ChangeGoToHomeScreen event, Emitter<SettingsState> emit) {
    _settingsService.updateGoToHomeScreen(event.goToHomeScreen);
    if (event.goToHomeScreen) {
      showSnackBar('Go to home feature is activated.');
    } else {
      showSnackBar('Go to home feature is deactivated.');
    }
    emit(state.copyWith(goToHome: event.goToHomeScreen));
  }

  void _onRunInBackgroundChanged(
      ChangeRunInBackground event, Emitter<SettingsState> emit) async {
    if (event.runInBackground) {
      try {
        await service.startService().then((value) {
          if (value) {
            _settingsService.updateRunInBackground(value);
            emit(state.copyWith(runInBackground: value));
          }
        });
        showSnackBar('App is running in background.');
      } catch (e) {
        showSnackBar('Failed to run in background');
      }
    } else {
      try {
        service.invoke('stopService');
        emit(state.copyWith(runInBackground: false));
        showSnackBar('Stopped running in background.');
      } catch (e) {
        showSnackBar('Failed to disable background execution');
      }
    }
  }

  void _onTurnOffScreenChanged(
      ChangeTurnOffScreen event, Emitter<SettingsState> emit) async {
    try {
      if (event.turnOffScreen) {
        await _requestTurnOffScreenPermission().then((value) {
          if (value) {
            _settingsService.updateTurnOffScreen(value);
          }
        });
      } else {
        _settingsService.updateTurnOffScreen(event.turnOffScreen);
      }
      emit(state.copyWith(turnOffScreen: event.turnOffScreen));
    } catch (e) {
      log(e.toString());
    }
  }

  void _onTurnOffWifiChanged(
      ChangeWifi event, Emitter<SettingsState> emit) async {
    try {
      _settingsService.updateTurnOffWifi(event.turnOffWifi);

      emit(state.copyWith(turnOffWifi: event.turnOffWifi));
    } catch (e) {
      log(e.toString());
    }
  }

  void _onTurnOffBluetoothChanged(
      ChangeBluetooth event, Emitter<SettingsState> emit) async {
    try {
      emit(state.copyWith(turnOffBluetooth: event.turnOffBluetooth));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onResetToDefault(
      ResetToDefault event, Emitter<SettingsState> emit) async {
    await _settingsService.resetToDefault();
    showSnackBar('Resetted to default,\nplease restart your app');
  }

  void _onNotificationsChanged(
      ChangeNotificationsOn event, Emitter<SettingsState> emit) {
    _settingsService.updateNotificationsOn(event.notificationsOn);
    emit(state.copyWith(notification: event.notificationsOn));
  }

  Future<void> _onLanguageChanged(
      ChangeLanguage event, Emitter<SettingsState> emit) async {
    await _settingsService.updateLanguageCode(event.languageCode);
    Get.updateLocale(Locale(event.languageCode));
  }

  Future<bool> _requestTurnOffScreenPermission() async {
    /// Return `true` if the given administrator component is currently active (enabled) in the system.
    final status = await DevicePolicyManager.isPermissionGranted();
    if (status) return true;

    /// request administrator permission
    /// it will open the adminstartor permission page and return `true` once the permission granted.
    /// An optional message providing additional explanation for why the admin is being added.
    return await DevicePolicyManager.requestPermession(
            'This feature requires Adminstration Permission to be granted else this would not be functtional')
        .then((value) => value);
  }
}
