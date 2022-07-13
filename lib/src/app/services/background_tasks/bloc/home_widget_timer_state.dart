part of 'home_widget_timer_bloc.dart';

abstract class HomeWidgetTimerState extends Equatable {
  final TimerStatus timerStatus;
  final Duration countdownDuration;
  final Timer countdownTimer;
  final PausableTimer sleepTimer;
  final Stopwatch stopwatch;

  const HomeWidgetTimerState({
    required this.timerStatus,
    required this.countdownDuration,
    required this.countdownTimer,
    required this.sleepTimer,
    required this.stopwatch,
  });

  @override
  List<Object> get props => [
        timerStatus,
        countdownDuration,
        countdownTimer,
        sleepTimer,
        stopwatch,
      ];

  HomeWidgetTimerState copyWith({
    TimerStatus? timerStatus,
    Duration? countdownDuration,
    Timer? countdownTimer,
    PausableTimer? sleepTimer,
    Stopwatch? stopwatch,
  });
}

class HomeWidgetTimerInitial extends HomeWidgetTimerState {
  const HomeWidgetTimerInitial(
      {required super.timerStatus,
      required super.countdownDuration,
      required super.countdownTimer,
      required super.sleepTimer,
      required super.stopwatch});

  @override
  HomeWidgetTimerState copyWith(
      {TimerStatus? timerStatus,
      Duration? countdownDuration,
      Timer? countdownTimer,
      PausableTimer? sleepTimer,
      Stopwatch? stopwatch}) {
    return HomeWidgetTimerInitial(
      timerStatus: timerStatus ?? this.timerStatus,
      countdownDuration: countdownDuration ?? this.countdownDuration,
      countdownTimer: countdownTimer ?? this.countdownTimer,
      sleepTimer: sleepTimer ?? this.sleepTimer,
      stopwatch: stopwatch ?? this.stopwatch,
    );
  }
}
