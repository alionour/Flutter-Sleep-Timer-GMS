// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';

RxBool isDarkTheme = true.obs;
RxBool goToHome = true.obs;
RxBool silentMode = false.obs;
RxBool notification = true.obs;
Rx<String?> language = Rx(null);
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

void showSnackBar(String content) {
  Get.snackbar(
    "Notification",
    content,
    duration: const Duration(milliseconds: 4000),
    backgroundColor: Colors.grey,
    isDismissible: true,
    icon: const Icon(Icons.notification_important_outlined),
    colorText: Colors.white,
    borderRadius: 4,
    dismissDirection: DismissDirection.horizontal,
    margin: const EdgeInsets.all(0),
  );
}
