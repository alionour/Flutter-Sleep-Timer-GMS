import 'dart:async';
import 'dart:developer';

import 'package:audio_session/audio_session.dart';
import 'package:bloc/bloc.dart';
import 'package:device_policy_manager/device_policy_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/src/app/services/navigation/navigator_service.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sleep_timer/src/notifications/notification_handler.dart';
import 'package:sleep_timer/src/settings/bloc/settings_bloc.dart';
import 'package:sleep_timer/src/timer/services/timer_local_storage.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:system_shortcuts/system_shortcuts.dart';
import 'package:volume_control/volume_control.dart';
import 'package:workmanager/workmanager.dart';

part 'timer_event.dart';
part 'timer_state.dart';

enum TimerStatus {
  running,
  stopped,
  paused,
  cancelled;

  static TimerStatus status(String value) {
    switch (value) {
      case 'running':
        return TimerStatus.running;
      case 'stopped':
        return TimerStatus.stopped;
      case 'paused':
        return TimerStatus.paused;
      case 'cancelled':
        return TimerStatus.cancelled;
      default:
        return TimerStatus.stopped;
    }
  }

  String get statusToString {
    switch (this) {
      case TimerStatus.running:
        return 'running';
      case TimerStatus.stopped:
        return 'stopped';
      case TimerStatus.paused:
        return 'paused';
      case TimerStatus.cancelled:
        return 'cancelled';
      default:
        return 'stopped';
    }
  }
}

const initialDuration = Duration(minutes: 91);

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  bool isRunningFromHomeWidget;
  TimerBloc({this.isRunningFromHomeWidget = false})
      : super(
          HomeInitial(
            timerStatus: TimerStatus.stopped,
            countdownDuration: initialDuration,
            dragEnabled: true,
            stopwatch: Stopwatch(),
            gaugeEndValue: initialDuration.inSeconds.toDouble() / 60,
            countdownTimer: Timer(initialDuration, () {}),
            sleepTimer: PausableTimer(initialDuration, () {}),
            valueChangingArgs: ValueChangingArgs(),
          ),
        ) {
    on<StartTimer>(_onStartTimer);
    on<StopTimer>(_onStopTimer);
    on<PauseTimer>(_onPauseTimer);
    on<StartCountdown>(_onStarCountdown);
    on<StartStopwatch>(_onStopwatchStarted);
    on<SetGaugeEndValue>(_onSettingGaugeEndValue);
    on<FinishTimer>(_onTimerFinished);
    on<CancelTimer>(_onTimerCanceled);
    on<ResetTimer>(_onTimerReset);
    on<SetSilent>(_onSetSilent);
    on<TurnScreenOff>(_onTurnOffScreen);
    on<GoToHome>(_onGoToHome);
    on<ResumeTimer>(_onResumeTimer);
    on<ChangeGaugeRange>(_onGaugeRangeChanged);
    on<ExtendTimer>(_onTimerExtend);
    on<ChangeCountdownDuration>(_onCountdownDurationChanged);

    _startAudioSession();
  }

  final _timerService = TimerService();

  void _onStartTimer(StartTimer event, Emitter<TimerState> emit) async {
    if (event.duration.inSeconds < 1) {
      showSnackBar('TimerCannotBeStarted'.tr);
    } else {
      NotificationHandler.cancelAllNotifications();

      /// save duration of timer to local storage
      _timerService.updateDuration(event.duration);

      add(const StartStopwatch());
      add(StartCountdown(
        event.duration,
      ));

      _startTimerBackground(event.duration, 'app');

      final sleepTimer = PausableTimer(event.duration, () async {
        logger.d('Timer has been finished');
        add(FinishTimer(
          duration: event.duration,
        ));
      })
        ..start();
      emit(
        state.copyWith(
            sleepTimer: sleepTimer,
            dragEnabled: false,
            timerStatus: TimerStatus.running),
      );
    }
  }

  void _onPauseTimer(PauseTimer event, Emitter<TimerState> emit) {
    logger.d('Pausing timer');
    state.sleepTimer.pause();
    state.stopwatch.stop();
    state.countdownTimer.cancel();
    _cancelTimerBackgroundTask();
    emit(state.copyWith(
      dragEnabled: false,
      timerStatus: TimerStatus.paused,
    ));
    logger.d('Puased timer');
    logger.d('Puased timer active ${state.countdownTimer.isActive}');
    logger.d('Puased timer');
    logger.d('Puased timer');
  }

  void _onResumeTimer(ResumeTimer event, Emitter<TimerState> emit) {
    state.sleepTimer.start();
    state.stopwatch.start();
    add(StartCountdown(
      state.countdownDuration,
    ));
    emit(state.copyWith(timerStatus: TimerStatus.running));
  }

  void _onStopTimer(StopTimer event, Emitter<TimerState> emit) async {
    state.sleepTimer.cancel();
    _cancelTimerBackgroundTask();
    state.countdownTimer.cancel();
    state.stopwatch.reset();

    // showing timer cancellation notifications
    NotificationHandler.cancelTimerNotifications(
        _settingsBloc, state.sleepTimer, state.countdownDuration);

    add(const ResetTimer());
    emit(
      state.copyWith(
        // enabling GaugeDragging again because the timer is free
        dragEnabled: true,
        timerStatus: TimerStatus.stopped,
      ),
    );
    emit(state.copyWith(timerStatus: TimerStatus.stopped));
  }

  void _onStopwatchStarted(StartStopwatch event, Emitter<TimerState> emit) {
    state.stopwatch.start();
    emit(state.copyWith(
      stopwatch: state.stopwatch,
    ));
  }

  void _onStarCountdown(StartCountdown event, Emitter<TimerState> emit) {
    // To avoid milli and microseconds to avoid ruining animations
    // as this method does not convert milli and microseconds
    emit(
      state.copyWith(
        countdownDuration: event.duration,
        countdownTimer: Timer.periodic(
          const Duration(milliseconds: 1000),
          (timer) async {
            add(ChangeCountdownDuration(
              const Duration(milliseconds: 1000),
              timer,
            ));
          },
        ),
      ),
    );
  }

  void _onCountdownDurationChanged(
      ChangeCountdownDuration event, Emitter<TimerState> emit) async {
    if (state.countdownDuration.inMilliseconds > 1000) {
      NotificationHandler.notifyTimerNotifications(
          _settingsBloc, event.timer, state.countdownDuration);
      emit(
        state.copyWith(
          countdownDuration: state.countdownDuration - event.duration,
        ),
      );
    }
  }

  void _onSettingGaugeEndValue(
      SetGaugeEndValue event, Emitter<TimerState> emit) {
    emit(state.copyWith(
        gaugeEndValue: event.duration.inSeconds.toDouble() / 60));
  }

  void _startTimerBackground(Duration duration, String taskId) {
    Workmanager().registerOneOffTask(
      taskId,
      'request_audio_focus',
      inputData: {'seconds': duration.inSeconds},
    );
  }

  Future<void> fadeOutAudio() async {
    late Timer fadeoutTimer;
    fadeoutTimer =
        Timer.periodic(const Duration(milliseconds: 2000), (timer) async {
      double currentVolume = await VolumeControl.volume;
      if (currentVolume <= 10) {
        VolumeControl.setVolume(0);
        fadeoutTimer.cancel();
      } else {
        VolumeControl.setVolume(currentVolume - 10);
      }
    });
  }

  late final AudioSession session;
  Future<void> _startAudioSession() async {
    session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  void _onTimerFinished(FinishTimer event, Emitter<TimerState> emit) async {
    await fadeOutAudio();
    await session.setActive(true);
    logger.d('Sleeping');

    // resetting [countdownTimer] and  [stopWatch]
    state.countdownTimer.cancel();
    state.stopwatch.reset();

    // on cancelling Timer we will need to get the stored [end_value] stored in [GetStorage]
    await _getGaugeEndValueFromLocalStorage();

    _cancelTimerBackgroundTask();

    add(const GoToHome());
    add(const SetSilent());
    add(const TurnScreenOff());
    add(const ResetTimer());
    turnOffBluetooth();
    turnOffWifi();
    // showing timer finished notifications
    NotificationHandler.finishTimerNotifications(
        _settingsBloc, state.sleepTimer, state.countdownDuration);
    emit(state.copyWith(
      dragEnabled: true,
      timerStatus: TimerStatus.stopped,
    ));
  }

  void _cancelTimerBackgroundTask() {
    Workmanager().cancelByUniqueName('app');
  }

  /// get the stored [end_value] stored in [GetStorage] to reset the [GaugeRange]
  /// returns 91 if null
  Future<double> _getGaugeEndValueFromLocalStorage() async {
    final duration = await _timerService.duration;
    return duration.inSeconds.toDouble() / 60;
  }

  static void turnScreenOff() async {
    log('turning screen off');

    /// Return `true` if the given administrator component is currently active (enabled) in the system.
    final status = await DevicePolicyManager.isPermissionGranted();
    log('status: $status');
    if (status) {
      /// Make the device lock immediately, as if the lock screen timeout has expired at the point of this call.
      /// After this method is called, the device must be unlocked using strong authentication (PIN, pattern, or password).
      await DevicePolicyManager.lockNow().then((value) => log('locked'));
    }
  }

  void turnOffWifi() async {
    log('turning screen off');
    try {
      if (_settingsBloc.state.turnOffWifi) {
        final isChecked = await SystemShortcuts.checkWifi;
        if (isChecked ?? false) {
          await SystemShortcuts.wifi();
        }
      }
    } catch (e) {
      log('error while turning off wifi: $e');
    }
  }

  void turnOffBluetooth() async {
    log('turning bluetooth screen off');
    try {
      if (_settingsBloc.state.turnOffBluetooth) {
        final isChecked = await SystemShortcuts.checkBluetooth;
        if (isChecked ?? false) {
          await SystemShortcuts.bluetooth();
        }
      }
    } catch (e) {
      log('error while turning off bluetooth: $e');
    }
  }

  void _onTimerReset(ResetTimer event, Emitter<TimerState> emit) async {
    final Duration duration = await _timerService.duration;

    state.sleepTimer.reset();
    state.countdownTimer.cancel();
    state.stopwatch.reset();

    emit(
      state.copyWith(
        countdownDuration: duration,
        timerStatus: TimerStatus.stopped,
        dragEnabled: true,
      ),
    );
  }

  @override
  void onEvent(TimerEvent event) {
    super.onEvent(event);
    log('EVENT: $event');
  }

  void _onTimerCanceled(CancelTimer event, Emitter<TimerState> emit) async {
    // resetting [countdownTimer] and  [stopWatch]
    state.countdownTimer.cancel();
    state.stopwatch.reset();
    state.sleepTimer.cancel();
    _cancelTimerBackgroundTask();
    // showing timer cancellation notifications
    NotificationHandler.cancelTimerNotifications(
        _settingsBloc, state.sleepTimer, state.countdownDuration);
    // final endValue = await _getGaugeEndValueFromLocalStorage();
    add(const ResetTimer());
    emit(
      state.copyWith(
        // enabling GaugeDragging again because the timer is free
        dragEnabled: true,
        timerStatus: TimerStatus.cancelled,
      ),
    );
  }

  late final _settingsBloc = isRunningFromHomeWidget
      ? SettingsBloc()
      : NavigatorService.context.read<SettingsBloc>();

  /// exit the app without closing and go to home
  void _onGoToHome(GoToHome event, Emitter<TimerState> emit) {
    if (_settingsBloc.state.goToHome) {
      SystemShortcuts.home();
    }
  }

  /// turn screen off
  void _onTurnOffScreen(TurnScreenOff event, Emitter<TimerState> emit) {
    if (_settingsBloc.state.turnOffScreen) {
      turnScreenOff();
    }
  }

  /// sets the phone to silent mode if the user choosed that
  void _onSetSilent(SetSilent event, Emitter<TimerState> emit) {
    if (_settingsBloc.state.silentMode) {
      try {
        SoundMode.setSoundMode(RingerModeStatus.silent);
      } on PlatformException {
        logger.d('Please enable permissions required');
      }
    }
  }

  void _onGaugeRangeChanged(ChangeGaugeRange event, Emitter<TimerState> emit) {
    final duration = _calculateDuration(event.valueChangingArgs);
    emit(state.copyWith(
        countdownDuration: duration,
        valueChangingArgs: event.valueChangingArgs));
  }

  Duration _calculateDuration(ValueChangingArgs args) {
    // Duration does not accept minutes as double
    return Duration(
      minutes: args.value.toInt(),
      seconds:
          ((double.parse("0.${args.value.toString().split('.').elementAt(1)}") *
                  60)
              .round()),
    );
  }

  void _onTimerExtend(ExtendTimer event, Emitter<TimerState> emit) {
    if (event.duration.isNegative) {
      logger.d('Shrinking Timer');
      bool canShrink =
          (state.countdownDuration - event.duration).isNegative == true
              ? false
              : true;
      if (canShrink) {
        final duration = state.countdownDuration + event.duration;
        emit(
          state.copyWith(countdownDuration: duration),
        );
        if (duration > const Duration(minutes: 90)) {
          add(SetGaugeEndValue(duration));
        }
      } else {
        showSnackBar('TimerCannotBeSetted'.tr);
      }
    } else {
      logger.d('Extending Timer');
      final duration = state.countdownDuration + event.duration;

      emit(state.copyWith(countdownDuration: duration));
      if (duration.inMinutes <= 90) {
        /// this condition only extending timer but not with timer is running
        add(const SetGaugeEndValue(Duration(minutes: 90)));
      } else {
        add(SetGaugeEndValue(duration));
      }
    }
  }

  double getInterval() {
    final minutes = state.countdownDuration.inMinutes;
    if (minutes > 1) {
      return 10;
    } else if (minutes <= 50) {
      return 50;
    } else if (minutes <= 90) {
      return 10;
    }
    return 10;
  }
}
