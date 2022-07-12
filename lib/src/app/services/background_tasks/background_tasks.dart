import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:sleep_timer/src/app/services/navigation/navigation.dart';

final service = FlutterBackgroundService();

Future<void> initializeBackgroundTasks() async {
  // const androidConfig = FlutterBackgroundAndroidConfig(
  //   notificationIcon: AndroidResource(name: 'ic_launcher', defType: 'mipmap'),
  //   notificationTitle: 'Sleep Timer is On',
  //   notificationImportance: AndroidNotificationImportance.Default,
  //   notificationText: 'Help app to stay awake if system ram is low',
  // );
  // // To keep app running and losing activity on android
  // await FlutterBackground.initialize(androidConfig: androidConfig);
  // if (runInBackground.value) {
  //   await FlutterBackground.enableBackgroundExecution();
  // }
  WidgetsFlutterBinding.ensureInitialized();
  service.configure(
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: false,
      isForegroundMode: true,
    ),
  );

  if (NavigatorService.settingsBloc.state.runInBackground) {
    await service.startService();
  }
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
  return true;
}

void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    print('stop Service');
    service.stopSelf();
  });

  // bring to foreground
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

/// Called when Doing Background Work initiated from Widget
void backgroundCallback(Uri? data) async {
  print('data$data');
  switch (HomeTimerWidgetAction.action(data?.host)) {
    case HomeTimerWidgetAction.start:
      break;

    case HomeTimerWidgetAction.pause:
      break;

    case HomeTimerWidgetAction.reset:
      break;
    default:
  }
  // if (HomeTimerWidgetAction.action(data?.host) == HomeTimerWidgetAction.start) {
  //   await HomeWidget.saveWidgetData<String>('title', '');
  //   await HomeWidget.updateWidget(
  //       name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
  // }
}

/// Used for Background Updates using Workmanager Plugin
// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) {
//     final now = DateTime.now();
//     return Future.wait<bool>([
//       HomeWidget.saveWidgetData(
//         'title',
//         'Updated from Background',
//       ) as Future<bool>,
//       HomeWidget.saveWidgetData(
//         'message',
//         '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
//       ) as Future<bool>,
//       HomeWidget.updateWidget(
//         name: 'HomeWidgetExampleProvider',
//         iOSName: 'HomeWidgetExample',
//       ) as Future<bool>,
//     ]).then((value) {
//       return !value.contains(false);
//     });
//   });
// }
