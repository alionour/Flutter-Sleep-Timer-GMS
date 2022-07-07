part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  // represnts global app theme used in app with a getter
  final AppTheme appTheme;
  final bool goToHome;
  final bool runInBackground;
  final bool turnOffScreen;
  final bool silentMode;
  final bool notification;
  final String languageCode;
  const SettingsState({
    required this.appTheme,
    required this.goToHome,
    required this.runInBackground,
    required this.turnOffScreen,
    required this.silentMode,
    required this.notification,
    required this.languageCode,
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
      ];

  SettingsState copyWith({
    AppTheme? appTheme,
    bool? goToHome,
    bool? runInBackground,
    bool? turnOffScreen,
    bool? silentMode,
    bool? notification,
    String? languageCode,
  });
}

class InitialSettingsState extends SettingsState {
  const InitialSettingsState({
    required AppTheme appTheme,
    required bool goToHome,
    required bool runInBackground,
    required bool turnOffScreen,
    required bool silentMode,
    required bool notification,
    required String languageCode,
  }) : super(
            appTheme: appTheme,
            goToHome: goToHome,
            notification: notification,
            runInBackground: runInBackground,
            silentMode: silentMode,
            turnOffScreen: turnOffScreen,
            languageCode: languageCode);

  @override
  SettingsState copyWith(
      {AppTheme? appTheme,
      bool? goToHome,
      bool? runInBackground,
      bool? turnOffScreen,
      bool? silentMode,
      bool? notification,
      String? languageCode}) {
    return InitialSettingsState(
      appTheme: appTheme ?? this.appTheme,
      goToHome: goToHome ?? this.goToHome,
      languageCode: languageCode ?? this.languageCode,
      runInBackground: runInBackground ?? this.runInBackground,
      turnOffScreen: turnOffScreen ?? this.turnOffScreen,
      notification: notification ?? this.notification,
      silentMode: silentMode ?? this.silentMode,
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
      required String language})
      : super(
            appTheme: appTheme,
            goToHome: goToHome,
            runInBackground: runInBackground,
            turnOffScreen: turnOffScreen,
            silentMode: silentMode,
            notification: notification,
            languageCode: language);

  @override
  SettingsState copyWith(
      {AppTheme? appTheme,
      bool? goToHome,
      bool? runInBackground,
      bool? turnOffScreen,
      bool? silentMode,
      bool? notification,
      String? languageCode}) {
    return SettingsStateChanged(
      appTheme: appTheme ?? this.appTheme,
      goToHome: goToHome ?? this.goToHome,
      language: languageCode ?? this.languageCode,
      runInBackground: runInBackground ?? this.runInBackground,
      turnOffScreen: turnOffScreen ?? this.turnOffScreen,
      notification: notification ?? this.notification,
      silentMode: silentMode ?? this.silentMode,
    );
  }
}
