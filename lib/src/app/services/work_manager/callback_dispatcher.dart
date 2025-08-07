import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:workmanager/workmanager.dart';

void callBackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case 'request_audio_focus':
        final service = FlutterBackgroundService();
        final isRunning = await service.isRunning();
        if (!isRunning) {
          await service.startService();
        }
        service.invoke('startTimer', {'seconds': inputData?['seconds']});
        break;
      default:
    }
    return Future.value(true);
  });
}
