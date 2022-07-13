part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ChangeThemeData extends SettingsEvent {
  final AppTheme appTheme;
  const ChangeThemeData(this.appTheme);
  @override
  List<Object?> get props => [appTheme];
}

/// Reset settings to default
class ResetToDefault extends SettingsEvent {
  @override
  List<Object?> get props => [];
}

class ChangeSilentMode extends SettingsEvent {
  final bool silentMode;
  const ChangeSilentMode(this.silentMode);
  @override
  List<Object?> get props => [silentMode];
}

class ChangeLanguage extends SettingsEvent {
  final String languageCode;
  const ChangeLanguage(this.languageCode);
  @override
  List<Object?> get props => [languageCode];
}

class ChangeRunInBackground extends SettingsEvent {
  final bool runInBackground;
  const ChangeRunInBackground(this.runInBackground);
  @override
  List<Object?> get props => [runInBackground];
}

class ChangeGoToHomeScreen extends SettingsEvent {
  final bool goToHomeScreen;
  const ChangeGoToHomeScreen(this.goToHomeScreen);
  @override
  List<Object?> get props => [goToHomeScreen];
}

class ChangeTurnOffScreen extends SettingsEvent {
  final bool turnOffScreen;
  const ChangeTurnOffScreen(this.turnOffScreen);
  @override
  List<Object?> get props => [turnOffScreen];
}

class ChangeNotificationsOn extends SettingsEvent {
  final bool notificationsOn;
  const ChangeNotificationsOn(this.notificationsOn);
  @override
  List<Object?> get props => [notificationsOn];
}

class ChangeWifi extends SettingsEvent {
  final bool turnOffWifi;
  const ChangeWifi(this.turnOffWifi);
  @override
  List<Object?> get props => [turnOffWifi];
}

class ChangeBluetooth extends SettingsEvent {
  final bool turnOffBluetooth;
  const ChangeBluetooth(this.turnOffBluetooth);
  @override
  List<Object?> get props => [turnOffBluetooth];
}
