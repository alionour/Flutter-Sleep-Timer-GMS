import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_t/Globals.dart';

class NotificationHandler {
  static cancelTimerNotifications(timer, duration) async {
    if (notification) {
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails("2003", "Sleep Timer", "Timer is On",
              importance: Importance.min,
              priority: Priority.min,
              ongoing: false,
              showProgress: true,
              onlyAlertOnce: true,
              progress: timer.tick * 1000,
              maxProgress: duration.value.inMilliseconds,
              color: Colors.pinkAccent,
              sound: null,
              playSound: false);
      NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await FlutterLocalNotificationsPlugin().show(
          4,
          "Flutter Sleep Timer",
          "Timer is cancelled ${(timer.tick / 60).toStringAsFixed(2)} Minutes",
          notificationDetails,
          payload: "Item x");
    }
  }

  static notifyTimerNotifications(timer, duration) async {
    if (notification) {
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails("2003", "Sleep Timer", "Timer is On",
              importance: Importance.min,
              priority: Priority.min,
              ongoing: true,
              showProgress: true,
              onlyAlertOnce: true,
              progress: timer.tick * 1000,
              maxProgress: duration.value.inMilliseconds,
              color: Colors.pinkAccent,
              sound: null,
              playSound: false);
      NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await FlutterLocalNotificationsPlugin().show(
          4,
          "Flutter Sleep Timer",
          "Timer is On progress ${(timer.tick / 60).toStringAsFixed(2)} Minutes",
          notificationDetails,
          payload: "Item x");
    }
  }

  static void finishTimerNotifications(timer, duration) async {
    if (notification) {
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails("2003", "Sleep Timer", "Timer is On",
              importance: Importance.min,
              priority: Priority.min,
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
          4, "Flutter Sleep Timer", "Timer has finished", notificationDetails,
          payload: "Item x");
    }
  }
}
