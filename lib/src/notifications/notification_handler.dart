import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sleep_timer/src/settings/bloc/settings_bloc.dart';

class NotificationHandler {
  static void cancelTimerNotifications(
      SettingsBloc settingsBloc, Timer timer, Duration duration) async {
    if (settingsBloc.state.notification) {
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('2003', 'Sleep Timer',
              channelDescription: 'Timer is On',
              importance: Importance.high,
              priority: Priority.high,
              ongoing: false,
              showProgress: true,
              onlyAlertOnce: true,
              progress: timer.tick * 1000,
              maxProgress: duration.inMilliseconds,
              color: Colors.pinkAccent,
              sound: null,
              playSound: false);
      NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await FlutterLocalNotificationsPlugin().show(
          4,
          'Sleep Timer',
          'Timer is cancelled ${(timer.tick / 60).toStringAsFixed(2)} Minutes',
          notificationDetails,
          payload: 'Item x');
    }
  }

  static void notifyTimerNotifications(
      SettingsBloc settingsBloc, Timer timer, Duration duration) async {
    if (settingsBloc.state.notification) {
      // log('${timer.tick}  ${duration.inSeconds}');
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('2003', 'Sleep Timer',
              channelDescription: 'Timer is On',
              importance: Importance.high,
              priority: Priority.high,
              ongoing: true,
              showProgress: true,
              onlyAlertOnce: true,
              progress: timer.tick,
              maxProgress: duration.inSeconds,
              styleInformation: BigTextStyleInformation(
                  "Remaining ${duration.toString().split('.')[0]}"),
              largeIcon:
                  const DrawableResourceAndroidBitmap('mipmap/launcher_icon'),
              // ticker: duration.toString().split('.')[0],
              enableLights: true,
              color: Colors.pinkAccent,
              sound: null,
              playSound: false);
      NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await FlutterLocalNotificationsPlugin().show(4, 'Sleep Timer',
          "Remaining ${duration.toString().split('.')[0]}", notificationDetails,
          payload: 'Item x');
    }
  }

  static void finishTimerNotifications(
      SettingsBloc settingsBloc, Timer timer, Duration duration) async {
    if (settingsBloc.state.notification) {
      AndroidNotificationDetails androidNotificationDetails =
          const AndroidNotificationDetails('2003', 'Sleep Timer',
              channelDescription: 'Timer is On',
              importance: Importance.high,
              priority: Priority.high,
              ongoing: false,
              showProgress: true,
              onlyAlertOnce: true,
              progress: 100,
              maxProgress: 100,
              color: Colors.pinkAccent,
              sound: null,
              playSound: false);
      NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await FlutterLocalNotificationsPlugin().show(
          4, 'Sleep Timer', 'Timer has finished', notificationDetails,
          payload: 'Item x');
    }
  }

  /// cancelling all scheduled and current notifications
  static Future<void> cancelAllNotifications() async {
    await FlutterLocalNotificationsPlugin().cancelAll();
  }
}
