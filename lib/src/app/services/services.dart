import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sleep_timer/src/app/services/ads/ads.dart';
import 'package:sleep_timer/src/app/services/notifications/notifications.dart';
import 'package:sleep_timer/src/app/services/shared_preferences/local_storage.dart';
import 'package:sleep_timer/src/app/services/work_manager/work_manager.dart';

export './ads/ads.dart';
export './background_tasks/background_tasks.dart';
export './notifications/notifications.dart';
export './work_manager/work_manager.dart';
export 'shared_preferences/local_storage.dart';

Future<void> initializeServices() async {
  await initializeLocalStorage();
  await initializeNotifications();
  await initializeWorkManager();
  // await initializeBackgroundTasks();
  await initializeAds();
}

void showBatteryOptimisationDialog() async {
  if (await Permission.ignoreBatteryOptimizations.isGranted) return;

  await Get.dialog<bool>(
    AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: true);
          },
          child: Text('Allow'.tr),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: false);
          },
          child: Text('Dismiss'.tr),
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
              '''To run app properly and efficiently , \nTurn off Battery optimization''',
              softWrap: true,
              overflow: TextOverflow.clip,
            ),
          ),
        ),
      ),
    ),
  ).then((allowed) async {
    if (allowed ?? false) {
      Permission.ignoreBatteryOptimizations.request();
      // // Opens the Do Not Disturb Access settings to grant the access
      // service.startService();
      // FlutterBackground.initialize(
      //         androidConfig: const FlutterBackgroundAndroidConfig(
      //             notificationIcon: AndroidResource(
      //                 name: 'launcher_icon', defType: 'drawable'),
      //             notificationTitle: 'Timer Notification',
      //             notificationText: ' Timer has Finished',
      //             notificationImportance: AndroidNotificationImportance.High))
      //     .then((value) async {});
    }
  });
}
