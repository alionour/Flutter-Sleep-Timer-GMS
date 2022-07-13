import 'dart:async';
import 'dart:developer';

import 'package:audio_session/audio_session.dart';
import 'package:bloc/bloc.dart';
import 'package:device_policy_manager/device_policy_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:sleep_timer/src/app/services/background_tasks/services/timer_service.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sleep_timer/src/notifications/notification_handler.dart';
import 'package:sleep_timer/src/settings/bloc/settings_bloc.dart';
import 'package:sleep_timer/src/timer/bloc/timer_bloc.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:system_shortcuts/system_shortcuts.dart';
import 'package:volume_control/volume_control.dart';
import 'package:workmanager/workmanager.dart';

part 'home_widget_timer_event.dart';
part 'home_widget_timer_state.dart';

class HomeWidgetTimerBloc
    extends Bloc<HomeWidgetTimerEvent, HomeWidgetTimerState> {
  HomeWidgetTimerBloc()
      : super(HomeWidgetTimerInitial(
          timerStatus: TimerStatus.stopped,
          countdownDuration: const Duration(seconds: 30),
          countdownTimer: Timer(const Duration(seconds: 30), () {}),
          sleepTimer: PausableTimer(const Duration(seconds: 30), () {}),
          stopwatch: Stopwatch(),
        )) {
    on<StartHomeWidgetTimer>(_onStartTimer);
    on<StopHomeWidgetTimer>(_onStopTimer);
    on<PauseHomeWidgetTimer>(_onPauseTimer);
    on<StartHomeWidgetCountdown>(_onStarCountdown);
    on<StartHomeWidgetStopwatch>(_onStopwatchStarted);

    on<FinishHomeWidgetTimer>(_onTimerFinished);
    on<CancelHomeWidgetTimer>(_onTimerCanceled);
    on<ResetHomeWidgetTimer>(_onTimerReset);
    on<HomeWidgetSetSilent>(_onSetSilent);
    on<HomeWidgetTurnScreenOff>(_onTurnOffScreen);
    on<HomeWidgetGoToHome>(_onGoToHome);
    on<ResumeHomeWidgetTimer>(_onResumeTimer);

    on<ChangeHomeWidgetCountdownDuration>(_onCountdownDurationChanged);

    _startAudioSession();
    on<ChangeHomeWidgetTimerState>(_onTimerStateChanged);
    stream.listen((state) {
      add(const ChangeHomeWidgetTimerState());
    });
  }
  final HomeWidgetTimerService _timerService = HomeWidgetTimerService();
  // late TimerBloc timerBloc = TimerBloc(isRunningFromHomeWidget: true)
  //   ..stream.listen((timerState) {
  //     add(ChangeHomeWidgetTimerState(timerState: timerState));
  //   });

  void _onTimerStateChanged(ChangeHomeWidgetTimerState event,
      Emitter<HomeWidgetTimerState> emit) async {
    final currentDuration = state.sleepTimer.duration - state.countdownDuration;

    final progress = (currentDuration.inMilliseconds * 100) /
        state.sleepTimer.duration.inMilliseconds;

    _timerService.saveWidgetTimer(
      duration: state.countdownDuration,
      progress: progress,
      status: state.timerStatus,
      timerDuration: state.sleepTimer.duration,
    );

    _timerService.updateWidget();
    emit(
      state.copyWith(
        timerStatus: state.timerStatus,
        countdownDuration: state.countdownDuration,
        countdownTimer: state.countdownTimer,
        sleepTimer: state.sleepTimer,
        stopwatch: state.stopwatch,
      ),
    );
    log('''timer countdown ${state.countdownDuration}''');
    log('''timer active ${state.countdownTimer.isActive}''');
    log('''timer duration ${state.sleepTimer.duration}''');
    log('''timer current $currentDuration''');
    log('''timer status ${state.timerStatus}''');

    log('home timer state : timer duration =${state.sleepTimer.duration}');
    log('home timer state : current duration =${state.countdownDuration}');
  }

  final _homeWidgettimerService = HomeWidgetTimerService();

  void _onStartTimer(
      StartHomeWidgetTimer event, Emitter<HomeWidgetTimerState> emit) async {
    print('_onTimerStarted');
    if (state.timerStatus == TimerStatus.stopped ||
        state.timerStatus == TimerStatus.cancelled) {
      await _timerService.getWidgetTimer().then(
        (value) {
          print('home timervalue ${value.timerDuration}');
          if (value.duration.inSeconds < 1) {
            log('Cannot start timer, Timer duration should be bigger than 1 second');
            return;
          } else {
            log('Starting Home Widget Timer');

            add(const StartHomeWidgetStopwatch());
            add(StartHomeWidgetCountdown(value.duration));

            _startTimerBackground(value.duration, 'homeWidget');

            final sleepTimer = PausableTimer(value.duration, () async {
              logger.d('Timer has benn finished');
              add(FinishHomeWidgetTimer(
                duration: value.duration,
              ));
            })
              ..start();

            emit(
              state.copyWith(
                  sleepTimer: sleepTimer, timerStatus: TimerStatus.running),
            );
          }
        },
      );
    } else {
      add(const ResumeHomeWidgetTimer());
    }
    // Event source is used to determine if the timer
    // was started from the home widget or from the settings widget.
  }

  void _onPauseTimer(
      PauseHomeWidgetTimer event, Emitter<HomeWidgetTimerState> emit) {
    logger.d('Pausing timer');
    state.sleepTimer.pause();
    state.stopwatch.stop();
    state.countdownTimer.cancel();
    _cancelTimerBackgroundTask();
    emit(state.copyWith(
      timerStatus: TimerStatus.paused,
    ));
    logger.d('Puased timer');
    logger.d('Puased timer active ${state.countdownTimer.isActive}');
    logger.d('Puased timer');
    logger.d('Puased timer');
  }

  void _onResumeTimer(
      ResumeHomeWidgetTimer event, Emitter<HomeWidgetTimerState> emit) {
    state.sleepTimer.start();
    state.stopwatch.start();
    add(StartHomeWidgetCountdown(state.countdownDuration));
    emit(state.copyWith(timerStatus: TimerStatus.running));
  }

  void _onStopTimer(
      StopHomeWidgetTimer event, Emitter<HomeWidgetTimerState> emit) async {
    state.sleepTimer.cancel();
    _cancelTimerBackgroundTask();
    state.countdownTimer.cancel();
    state.stopwatch.reset();

    // showing timer cancellation notifications
    NotificationHandler.cancelTimerNotifications(
        _settingsBloc, state.sleepTimer, state.countdownDuration);

    add(const ResetHomeWidgetTimer());
    emit(
      state.copyWith(
        // enabling GaugeDragging again because the timer is free

        timerStatus: TimerStatus.stopped,
      ),
    );
    emit(state.copyWith(timerStatus: TimerStatus.stopped));
  }

  void _onStopwatchStarted(
      StartHomeWidgetStopwatch event, Emitter<HomeWidgetTimerState> emit) {
    state.stopwatch.start();
    emit(state.copyWith(
      stopwatch: state.stopwatch,
    ));
  }

  void _onStarCountdown(
      StartHomeWidgetCountdown event, Emitter<HomeWidgetTimerState> emit) {
    // To avoid milli and microseconds to avoid ruining animations
    // as this method does not convert milli and microseconds
    emit(
      state.copyWith(
        countdownDuration: event.duration,
        countdownTimer: Timer.periodic(
          const Duration(milliseconds: 1000),
          (timer) async {
            log('timer ticked');
            add(ChangeHomeWidgetCountdownDuration(
              const Duration(milliseconds: 1000),
              timer,
            ));
          },
        ),
      ),
    );
  }

  void _onCountdownDurationChanged(ChangeHomeWidgetCountdownDuration event,
      Emitter<HomeWidgetTimerState> emit) async {
    if (state.countdownDuration.inMilliseconds > 1000) {
      NotificationHandler.notifyTimerNotifications(
          _settingsBloc, event.timer, state.countdownDuration);
      final countdownDuration = state.countdownDuration - event.duration;
      emit(
        state.copyWith(
          countdownDuration: countdownDuration,
        ),
      );
    }
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

  void _onTimerFinished(
      FinishHomeWidgetTimer event, Emitter<HomeWidgetTimerState> emit) async {
    await fadeOutAudio();
    await session.setActive(true);
    logger.d('Sleeping');

    // resetting [countdownTimer] and  [stopWatch]
    state.countdownTimer.cancel();
    state.stopwatch.reset();

    _cancelTimerBackgroundTask();

    add(HomeWidgetGoToHome());
    add(const HomeWidgetSetSilent());
    add(const HomeWidgetTurnScreenOff());
    add(const ResetHomeWidgetTimer());
    turnOffBluetooth();
    turnOffWifi();
    // showing timer finished notifications
    NotificationHandler.finishTimerNotifications(
        _settingsBloc, state.sleepTimer, state.countdownDuration);
    emit(state.copyWith(
      timerStatus: TimerStatus.stopped,
    ));
  }

  void _cancelTimerBackgroundTask() {
    Workmanager().cancelByUniqueName('homeWidget');
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

  void _onTimerReset(
      ResetHomeWidgetTimer event, Emitter<HomeWidgetTimerState> emit) async {
    late final Duration duration;

    logger.i('Resetting timer from home widget');
    await _homeWidgettimerService.getWidgetTimer().then(
      (value) {
        duration = value.timerDuration;
      },
    );

    state.sleepTimer.reset();
    state.countdownTimer.cancel();
    state.stopwatch.reset();

    emit(
      state.copyWith(
        countdownDuration: duration,
        timerStatus: TimerStatus.stopped,
      ),
    );
  }

  @override
  void onEvent(event) {
    super.onEvent(event);
    log('EVENT: $event');
  }

  void _onTimerCanceled(
      CancelHomeWidgetTimer event, Emitter<HomeWidgetTimerState> emit) async {
    // resetting [countdownTimer] and  [stopWatch]
    state.countdownTimer.cancel();
    state.stopwatch.reset();
    state.sleepTimer.cancel();
    _cancelTimerBackgroundTask();
    // showing timer cancellation notifications
    NotificationHandler.cancelTimerNotifications(
        _settingsBloc, state.sleepTimer, state.countdownDuration);
    // final endValue = await _getGaugeEndValueFromLocalStorage();
    add(const ResetHomeWidgetTimer());
    emit(
      state.copyWith(
        // enabling GaugeDragging again because the timer is free

        timerStatus: TimerStatus.cancelled,
      ),
    );
  }

  final _settingsBloc = SettingsBloc();

  /// exit the app without closing and go to home
  void _onGoToHome(
      HomeWidgetGoToHome event, Emitter<HomeWidgetTimerState> emit) {
    if (_settingsBloc.state.goToHome) {
      SystemShortcuts.home();
    }
  }

  /// turn screen off
  void _onTurnOffScreen(
      HomeWidgetTurnScreenOff event, Emitter<HomeWidgetTimerState> emit) {
    if (_settingsBloc.state.turnOffScreen) {
      turnScreenOff();
    }
  }

  /// sets the phone to silent mode if the user choosed that
  void _onSetSilent(
      HomeWidgetSetSilent event, Emitter<HomeWidgetTimerState> emit) {
    if (_settingsBloc.state.silentMode) {
      try {
        SoundMode.setSoundMode(RingerModeStatus.silent);
      } on PlatformException {
        logger.d('Please enable permissions required');
      }
    }
  }
}
