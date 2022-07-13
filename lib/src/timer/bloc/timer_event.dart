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
  List<Object> get props => [
        duration,
      ];
}

class FinishTimer extends TimerEvent {
  final Duration duration;

  const FinishTimer({
    required this.duration,
  });
  @override
  List<Object> get props => [duration];
}

class PauseTimer extends TimerEvent {
  const PauseTimer();
}

class ResumeTimer extends TimerEvent {
  const ResumeTimer();
}

class CancelTimer extends TimerEvent {
  const CancelTimer();
}

class ResetTimer extends TimerEvent {
  const ResetTimer();
}

class GoToHome extends TimerEvent {
  const GoToHome();
}

class TurnScreenOff extends TimerEvent {
  const TurnScreenOff();
}

class SetSilent extends TimerEvent {
  const SetSilent();
}

class StopTimer extends TimerEvent {
  const StopTimer();
}

class ExtendTimer extends TimerEvent {
  final Duration duration;

  const ExtendTimer(this.duration);
}

class StartCountdown extends TimerEvent {
  final Duration duration;

  const StartCountdown(
    this.duration,
  );
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

  const ChangeCountdownDuration(
    this.duration,
    this.timer,
  );
  @override
  List<Object> get props => [duration, timer];
}
