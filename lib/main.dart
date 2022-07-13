import 'package:flutter/material.dart';
import 'package:sleep_timer/src/app/app.dart';
import 'package:sleep_timer/src/app/services/services.dart';

void main() async {
  await initializeServices();
  runApp(const MyApp());

  showBatteryOptimisationDialog();

  // Admob.initialize(testDeviceIds: ["0e69b376-e911-482b-a9c1-3cc0b6053428"]);
}
