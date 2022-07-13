part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  // represnts global app theme used in app with a getter
  final AppTheme appTheme;
  final bool goToHome;
  final bool runInBackground;
  final bool turnOffScreen;
  final bool silentMode;
  final bool notification;
  final bool turnOffWifi;
  final bool turnOffBluetooth;
  final String languageCode;
  const SettingsState({
    required this.appTheme,
    required this.goToHome,
    required this.runInBackground,
    required this.turnOffScreen,
    required this.silentMode,
    required this.notification,
    required this.languageCode,
    required this.turnOffWifi,
    required this.turnOffBluetooth,
  });
  @override
  List<Object?> get props => [
        appTheme,
        goToHome,
        runInBackground,
        turnOffScreen,
        silentMode,
        notification,
        languageCode,
        turnOffWifi,
        turnOffBluetooth,
      ];

  SettingsState copyWith({
    AppTheme? appTheme,
    bool? goToHome,
    bool? runInBackground,
    bool? turnOffScreen,
    bool? silentMode,
    bool? notification,
    bool? turnOffWifi,
    bool? turnOffBluetooth,
    String? languageCode,
  });
}

class InitialSettingsState extends SettingsState {
  const InitialSettingsState(
      {required AppTheme appTheme,
      required bool goToHome,
      required bool runInBackground,
      required bool turnOffScreen,
      required bool silentMode,
      required bool notification,
      required String languageCode,
      required bool turnOffWifi,
      required bool turnOffBluetooth})
      : super(
            appTheme: appTheme,
            goToHome: goToHome,
            runInBackground: runInBackground,
            turnOffScreen: turnOffScreen,
            silentMode: silentMode,
            notification: notification,
            languageCode: languageCode,
            turnOffWifi: turnOffWifi,
            turnOffBluetooth: turnOffBluetooth);

  @override
  SettingsState copyWith(
      {AppTheme? appTheme,
      bool? goToHome,
      bool? runInBackground,
      bool? turnOffScreen,
      bool? silentMode,
      bool? notification,
      bool? turnOffWifi,
      bool? turnOffBluetooth,
      String? languageCode}) {
    return InitialSettingsState(
      appTheme: appTheme ?? this.appTheme,
      goToHome: goToHome ?? this.goToHome,
      runInBackground: runInBackground ?? this.runInBackground,
      turnOffScreen: turnOffScreen ?? this.turnOffScreen,
      silentMode: silentMode ?? this.silentMode,
      notification: notification ?? this.notification,
      languageCode: languageCode ?? this.languageCode,
      turnOffWifi: turnOffWifi ?? this.turnOffWifi,
      turnOffBluetooth: turnOffBluetooth ?? this.turnOffBluetooth,
    );
  }
}

class SettingsStateChanged extends SettingsState {
  const SettingsStateChanged(
      {required AppTheme appTheme,
      required bool goToHome,
      required bool runInBackground,
      required bool turnOffScreen,
      required bool silentMode,
      required bool notification,
      required String language,
      required bool turnOffWifi,
      required bool turnOffBluetooth})
      : super(
          appTheme: appTheme,
          goToHome: goToHome,
          runInBackground: runInBackground,
          turnOffScreen: turnOffScreen,
          silentMode: silentMode,
          notification: notification,
          languageCode: language,
          turnOffWifi: turnOffWifi,
          turnOffBluetooth: turnOffBluetooth,
        );

  @override
  SettingsState copyWith(
      {AppTheme? appTheme,
      bool? goToHome,
      bool? runInBackground,
      bool? turnOffScreen,
      bool? silentMode,
      bool? notification,
      String? languageCode,
      bool? turnOffWifi,
      bool? turnOffBluetooth}) {
    return SettingsStateChanged(
      appTheme: appTheme ?? this.appTheme,
      goToHome: goToHome ?? this.goToHome,
      language: languageCode ?? this.languageCode,
      runInBackground: runInBackground ?? this.runInBackground,
      turnOffScreen: turnOffScreen ?? this.turnOffScreen,
      notification: notification ?? this.notification,
      silentMode: silentMode ?? this.silentMode,
      turnOffWifi: turnOffWifi ?? this.turnOffWifi,
      turnOffBluetooth: turnOffBluetooth ?? this.turnOffBluetooth,
    );
  }
}
