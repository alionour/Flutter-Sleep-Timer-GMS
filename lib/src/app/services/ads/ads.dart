import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> initializeAds() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  final config = RequestConfiguration(testDeviceIds: [
    '0e69b376-e911-482b-a9c1-3cc0b6053428',
  ]);
  MobileAds.instance.updateRequestConfiguration(config);
}
