part of 'home_widget_timer_bloc.dart';

abstract class HomeWidgetTimerEvent extends Equatable {
  const HomeWidgetTimerEvent();

  @override
  List<Object> get props => [];
}

class ChangeHomeWidgetTimerState extends HomeWidgetTimerEvent {
  const ChangeHomeWidgetTimerState();
  @override
  List<Object> get props => [];
}

class StartHomeWidgetTimer extends HomeWidgetTimerEvent {
  const StartHomeWidgetTimer();
  @override
  List<Object> get props => [];
}

class FinishHomeWidgetTimer extends HomeWidgetTimerEvent {
  final Duration duration;

  const FinishHomeWidgetTimer({
    required this.duration,
  });
  @override
  List<Object> get props => [duration];
}

class PauseHomeWidgetTimer extends HomeWidgetTimerEvent {
  const PauseHomeWidgetTimer();
}

class ResumeHomeWidgetTimer extends HomeWidgetTimerEvent {
  const ResumeHomeWidgetTimer();
}

class CancelHomeWidgetTimer extends HomeWidgetTimerEvent {
  const CancelHomeWidgetTimer();
}

class ResetHomeWidgetTimer extends HomeWidgetTimerEvent {
  const ResetHomeWidgetTimer();
}

class HomeWidgetGoToHome extends HomeWidgetTimerEvent {}

class HomeWidgetTurnScreenOff extends HomeWidgetTimerEvent {
  const HomeWidgetTurnScreenOff();
}

class HomeWidgetSetSilent extends HomeWidgetTimerEvent {
  const HomeWidgetSetSilent();
}

class StopHomeWidgetTimer extends HomeWidgetTimerEvent {
  const StopHomeWidgetTimer();
}

class HomeWidgetExtendTimer extends HomeWidgetTimerEvent {
  final Duration duration;

  const HomeWidgetExtendTimer(this.duration);
}

class StartHomeWidgetCountdown extends HomeWidgetTimerEvent {
  final Duration duration;

  const StartHomeWidgetCountdown(
    this.duration,
  );
  @override
  List<Object> get props => [duration];
}

class StartHomeWidgetStopwatch extends HomeWidgetTimerEvent {
  const StartHomeWidgetStopwatch();

  @override
  List<Object> get props => [];
}

class ChangeHomeWidgetCountdownDuration extends HomeWidgetTimerEvent {
  final Duration duration;
  final Timer timer;

  const ChangeHomeWidgetCountdownDuration(
    this.duration,
    this.timer,
  );
  @override
  List<Object> get props => [duration, timer];
}
