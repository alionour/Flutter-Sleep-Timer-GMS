import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sleep_timer/src/app/services/navigation/navigator_service.dart';
import 'package:sleep_timer/src/home/view/home.dart';

Future<void> initializeNotifications() async {
  // Notifications
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('mipmap/launcher_icon');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  await FlutterLocalNotificationsPlugin().initialize(initializationSettings,
      onSelectNotification: onSelectionNotification);
}

Future onSelectionNotification(payload) async {
  NavigatorService.go(HomePage.routeName);
}
