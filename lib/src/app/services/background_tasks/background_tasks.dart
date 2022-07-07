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
