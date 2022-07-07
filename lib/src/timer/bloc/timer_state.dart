part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final TimerStatus timerStatus;
  final Duration countdownDuration;
  final double gaugeEndValue;
  final bool dragEnabled;
  final Timer countdownTimer;
  final PausableTimer sleepTimer;
  final Stopwatch stopwatch;

  /// needle pinter
  final ValueChangingArgs valueChangingArgs;
  const TimerState(
      {required this.timerStatus,
      required this.countdownDuration,
      required this.gaugeEndValue,
      required this.countdownTimer,
      required this.sleepTimer,
      required this.stopwatch,
      required this.dragEnabled,
      required this.valueChangingArgs});

  @override
  List<Object> get props => [
        timerStatus,
        countdownDuration,
        gaugeEndValue,
        sleepTimer,
        countdownTimer,
        stopwatch,
        dragEnabled,
        valueChangingArgs
      ];

  TimerState copyWith({
    TimerStatus? timerStatus,
    Duration? countdownDuration,
    double? gaugeEndValue,
    Stopwatch? stopwatch,
    PausableTimer? sleepTimer,
    Timer? countdownTimer,
    bool? dragEnabled,
    ValueChangingArgs? valueChangingArgs,
  });
}

class HomeInitial extends TimerState {
  const HomeInitial({
    required TimerStatus timerStatus,
    required Duration countdownDuration,
    required double gaugeEndValue,
    required Timer countdownTimer,
    required PausableTimer sleepTimer,
    required Stopwatch stopwatch,
    required bool dragEnabled,
    required ValueChangingArgs valueChangingArgs,
  }) : super(
            timerStatus: timerStatus,
            countdownDuration: countdownDuration,
            gaugeEndValue: gaugeEndValue,
            countdownTimer: countdownTimer,
            sleepTimer: sleepTimer,
            stopwatch: stopwatch,
            dragEnabled: dragEnabled,
            valueChangingArgs: valueChangingArgs);

  @override
  TimerState copyWith(
      {TimerStatus? timerStatus,
      Duration? countdownDuration,
      double? gaugeEndValue,
      Stopwatch? stopwatch,
      PausableTimer? sleepTimer,
      Timer? countdownTimer,
      bool? dragEnabled,
      ValueChangingArgs? valueChangingArgs}) {
    return HomeInitial(
        timerStatus: timerStatus ?? this.timerStatus,
        countdownDuration: countdownDuration ?? this.countdownDuration,
        gaugeEndValue: gaugeEndValue ?? this.gaugeEndValue,
        countdownTimer: countdownTimer ?? this.countdownTimer,
        sleepTimer: sleepTimer ?? this.sleepTimer,
        stopwatch: stopwatch ?? this.stopwatch,
        dragEnabled: dragEnabled ?? this.dragEnabled,
        valueChangingArgs: valueChangingArgs ?? this.valueChangingArgs);
  }
}

class HomeStateChanged extends TimerState {
  const HomeStateChanged({
    required TimerStatus timerStatus,
    required Duration countdownDuration,
    required double gaugeEndValue,
    required Timer countdownTimer,
    required PausableTimer sleepTimer,
    required Stopwatch stopwatch,
    required bool dragEnabled,
    required ValueChangingArgs valueChangingArgs,
  }) : super(
            timerStatus: timerStatus,
            countdownDuration: countdownDuration,
            gaugeEndValue: gaugeEndValue,
            countdownTimer: countdownTimer,
            sleepTimer: sleepTimer,
            stopwatch: stopwatch,
            dragEnabled: dragEnabled,
            valueChangingArgs: valueChangingArgs);

  @override
  TimerState copyWith({
    TimerStatus? timerStatus,
    Duration? countdownDuration,
    double? gaugeEndValue,
    Stopwatch? stopwatch,
    PausableTimer? sleepTimer,
    Timer? countdownTimer,
    bool? dragEnabled,
    ValueChangingArgs? valueChangingArgs,
  }) {
    return HomeStateChanged(
        timerStatus: timerStatus ?? this.timerStatus,
        countdownDuration: countdownDuration ?? this.countdownDuration,
        gaugeEndValue: gaugeEndValue ?? this.gaugeEndValue,
        countdownTimer: countdownTimer ?? this.countdownTimer,
        sleepTimer: sleepTimer ?? this.sleepTimer,
        stopwatch: stopwatch ?? this.stopwatch,
        dragEnabled: dragEnabled ?? this.dragEnabled,
        valueChangingArgs: valueChangingArgs ?? this.valueChangingArgs);
  }
}
