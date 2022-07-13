import 'package:sleep_timer/src/timer/bloc/timer_bloc.dart';

class HomeWidgetTimerModel {
  final Duration duration;
  final Duration timerDuration;
  final TimerStatus status;
  final double progress;
  HomeWidgetTimerModel(
      {required this.duration,
      required this.status,
      required this.timerDuration,
      required this.progress});

  HomeWidgetTimerModel copyWith(
      {Duration? duration,
      TimerStatus? status,
      Duration? timerduration,
      double? progress}) {
    return HomeWidgetTimerModel(
      duration: duration ?? this.duration,
      status: status ?? this.status,
      timerDuration: timerduration ?? timerDuration,
      progress: progress ?? this.progress,
    );
  }
}
