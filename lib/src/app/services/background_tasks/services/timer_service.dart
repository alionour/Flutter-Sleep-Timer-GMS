import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:sleep_timer/src/app/services/background_tasks/model/widget_timer_model.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sleep_timer/src/timer/bloc/timer_bloc.dart';

class HomeWidgetTimerService {
  static const Duration initialDuration = Duration(seconds: 30);

  Future<void> saveWidgetTimer(
      {required Duration duration,
      required Duration timerDuration,
      required TimerStatus status,
      required double progress}) async {
    try {
      Future.wait([
        HomeWidget.saveWidgetData<String>(
            'duration', duration.toString().split('.')[0]),
        HomeWidget.saveWidgetData<String>(
            'timer_duration', timerDuration.toString().split('.')[0]),
        HomeWidget.saveWidgetData<String>(
            'timer_status', status.statusToString),
        HomeWidget.saveWidgetData<int>('progress', progress.toInt())
      ]);
    } on Exception catch (exception) {
      debugPrint('Error saving timer data. $exception');
    }
  }

  Future<void> updateWidget() async {
    try {
      HomeWidget.updateWidget(
        name: 'HomeTimerWidget',
        androidName: 'com.ali.nourmed.sleep_timer.HomeTimerWidget',
        // iOSName: 'HomeWidgetExample',
        qualifiedAndroidName: 'com.ali.nourmed.sleep_timer.HomeTimerWidget',
      );
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  Future<HomeWidgetTimerModel> getWidgetTimer() async {
    Duration duration = const Duration();
    Duration timerDuration = initialDuration;
    TimerStatus status = TimerStatus.stopped;
    int progress = 0;
    try {
      final durationAsString =
          await HomeWidget.getWidgetData<String?>('duration') ?? '00:00:00';
      duration = parseDuration(durationAsString);
      final timerDurationAsString =
          await HomeWidget.getWidgetData<String?>('timer_duration') ??
              '00:00:30';
      timerDuration = parseDuration(timerDurationAsString);
      final statusAsString =
          await HomeWidget.getWidgetData<String>('timer_status') ?? 'stopped';
      status = TimerStatus.status(statusAsString);
      progress = await HomeWidget.getWidgetData<int>('progress') ?? 0;
    } on Exception catch (exception) {
      debugPrint('Error getting timer data. $exception');
    }
    return HomeWidgetTimerModel(
        duration: duration,
        status: status,
        timerDuration: timerDuration,
        progress: progress.toDouble());
  }

  Future<void> updateDuration(Duration duration) async {
    await HomeWidget.saveWidgetData<String>(
        'timer_duration', duration.toString().split('.')[0]);
    updateWidget();
  }
}
