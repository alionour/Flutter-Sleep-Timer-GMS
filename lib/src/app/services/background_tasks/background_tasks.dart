import 'dart:async';
import 'dart:ui';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:sleep_timer/src/app/services/background_tasks/bloc/home_widget_timer_bloc.dart';
import 'package:sleep_timer/src/app/services/navigation/navigation.dart';
import 'package:sleep_timer/src/app/services/services.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sleep_timer/src/timer/bloc/timer_bloc.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:system_shortcuts/system_shortcuts.dart';

final service = FlutterBackgroundService();

Future<void> initializeBackgroundTasks() async {
  WidgetsFlutterBinding.ensureInitialized();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
    ),
  );
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  service.on('startTimer').listen((event) async {
    final seconds = event?['seconds'];
    if (seconds != null) {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      Timer(Duration(seconds: seconds), () async {
        if (await session.setActive(true,
            avAudioSessionSetActiveOptions:
                const AVAudioSessionSetActiveOptions(1),
            androidAudioFocusGainType: AndroidAudioFocusGainType.gain)) {
          await session.setActive(false);
          NavigatorService.settingsBloc.state.goToHome
              ? await SystemShortcuts.home()
              : logger.d('Not going to home');
          NavigatorService.settingsBloc.state.notification
              ? TimerBloc.turnScreenOff()
              : logger.d('Failed to turn screen off');
          if (NavigatorService.settingsBloc.state.silentMode) {
            try {
              await SoundMode.setSoundMode(RingerModeStatus.silent);
            } on PlatformException {
              logger.d('Please enable permissions required');
            }
          }
        }
        service.stopSelf();
      });
    }
  });

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: 'Sleep Timer is On',
        content: 'To stay awake when the system ram becomes low',
      );
    }
  });
}

enum HomeTimerWidgetAction {
  start,
  reset,
  pause,
  idle;

  static HomeTimerWidgetAction action(String? value) {
    switch (value) {
      case 'start_timer':
        return HomeTimerWidgetAction.start;
      case 'reset_timer':
        return HomeTimerWidgetAction.reset;
      case 'pause_timer':
        return HomeTimerWidgetAction.pause;
      default:
        return HomeTimerWidgetAction.idle;
    }
  }
}

final HomeWidgetTimerBloc homeWidgetTimerBloc = HomeWidgetTimerBloc();

void homeWidgetBackgroundCallback(Uri? data) async {
  await initializeLocalStorage();

  switch (HomeTimerWidgetAction.action(data?.host)) {
    case HomeTimerWidgetAction.start:
      logger.i('HomeWidgetBackgroundCallback: start');
      homeWidgetTimerBloc.add(const StartHomeWidgetTimer());
      break;
    case HomeTimerWidgetAction.pause:
      logger.i('HomeWidgetBackgroundCallback: pause');
      homeWidgetTimerBloc.add(const PauseHomeWidgetTimer());
      break;
    case HomeTimerWidgetAction.reset:
      logger.i('HomeWidgetBackgroundCallback: reset');
      homeWidgetTimerBloc.add(const CancelHomeWidgetTimer());
      break;
    default:
  }
}
