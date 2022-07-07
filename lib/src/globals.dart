// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

/// converts String of duration to [Duration]
Duration parseDuration(String durationString) {
  // RegExp durationExpression = RegExp(r'source');
  int seconds = int.parse(durationString.split(':')[2].split('.')[0]);
  int minutes = int.parse(
    durationString.split('.')[0].split(':')[1].split(':')[0],
  );
  int hours = int.parse(durationString.split('.')[0].split(':')[0]);
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
void showSnackBar(String content) {
  final height =
      MediaQuery.of(scaffoldMessengerKey.currentContext!).size.height;
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Flexible(child: Icon(Icons.notification_important_outlined)),
          const Flexible(
            child: SizedBox(
              width: 5,
            ),
          ),
          Expanded(child: Text(content)),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      margin: const EdgeInsets.only(left: 4, right: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );

  // Get.snackbar(
  //   'Notification',
  //   content,
  //   duration: const Duration(milliseconds: 2000),
  //   backgroundColor: Colors.grey,
  //   isDismissible: true,
  //   icon: const Icon(Icons.notification_important_outlined),

  // ).snackbar;
}
