part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class StartTimer extends TimerEvent {
  final Duration duration;

  const StartTimer({
    required this.duration,
  });
  @override
  List<Object> get props => [duration];
}

class FinishTimer extends TimerEvent {
  final Duration duration;

  const FinishTimer({
    required this.duration,
  });
  @override
  List<Object> get props => [duration];
}

class PauseTimer extends TimerEvent {}

class ResumeTimer extends TimerEvent {}

class CancelTimer extends TimerEvent {}

class GoToHome extends TimerEvent {}

class TurnScreenOff extends TimerEvent {}

class SetSilent extends TimerEvent {}

class StopTimer extends TimerEvent {}

class ExtendTimer extends TimerEvent {
  final Duration duration;

  const ExtendTimer(this.duration);
}

class StartCountdown extends TimerEvent {
  final Duration duration;

  const StartCountdown(this.duration);
  @override
  List<Object> get props => [duration];
}

class StartStopwatch extends TimerEvent {
  const StartStopwatch();

  @override
  List<Object> get props => [];
}

class SetGaugeEndValue extends TimerEvent {
  final Duration duration;

  const SetGaugeEndValue(this.duration);
  @override
  List<Object> get props => [duration];
}

class ChangeGaugeRange extends TimerEvent {
  final ValueChangingArgs valueChangingArgs;

  const ChangeGaugeRange(this.valueChangingArgs);

  @override
  List<Object> get props => [valueChangingArgs];
}

class ChangeCountdownDuration extends TimerEvent {
  final Duration duration;
  final Timer timer;

  const ChangeCountdownDuration(this.duration, this.timer);
  @override
  List<Object> get props => [duration, timer];
}
