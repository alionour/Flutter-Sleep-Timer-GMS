import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sleep_timer/src/notifications/notification_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:volume_control/volume_control.dart';
import 'package:audio_session/audio_session.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:system_shortcuts/system_shortcuts.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workmanager/workmanager.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  // represents an identifier for all [scaffold]s related to this view
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  // app data that is persisted
  GetStorage appData = GetStorage();

  // Durations
  Duration initialTimerDuration = const Duration(minutes: 3);
  late Rx<Duration> timerDuration = initialTimerDuration.obs;
  late Rx<Duration> countdownDuration = timerDuration;

  late Rx<PausableTimer> sleepTimer =
      Rx(PausableTimer(timerDuration.value, () {}))..value.cancel();

  Timer? countdownTimer;
  Rx<Stopwatch> stopwatch = Stopwatch().obs;
  // Rx<Duration> durationInMilliseconds = const Duration().obs;
  var gaugeEndValue = 91.0.obs;
  RxBool enableDragging = true.obs;

  /// starts the sleep timer
  void startSleepTimer() {
    if (timerDuration.value.inSeconds < 1) {
      showSnackBar("TimerCannotBeStarted".tr);
    } else {
      _startSleepTimer(timerDuration.value);
    }
  }

  @override
  void onInit() {
    // starting Audio Session before starting Timer
    _startAudioSession();
    sleepTimer.listen((event) {
      if (sleepTimer.value.isActive) {
        enableDragging.value = false;
      } else {
        enableDragging.value = true;
      }
    });
    stopwatch.listen((stopwatch) {
      getCurrentCountdown();
      printInfo(info: "running" + stopwatch.isRunning.toString());
    });
    timerDuration.value = parseDuration(
      appData.read("duration") ?? initialTimerDuration.toString(),
    );
    // durationInMilliseconds.value = duration.value;
    countdownDuration.value = timerDuration.value;
    gaugeEndValue.value = appData.read("end_value") ?? 91;
    super.onInit();
  }

  /// used to start sleep timer and do sleeping actions when finished
  Future<void> _startSleepTimer(Duration duration) async {
    NotificationHandler.cancelAllNotifications();
    _saveTimerDurationToLocalStorage();
    // durationInMilliseconds.value = duration.value;
    // countdownDuration.value = timerDuration.value;
    // logger.d(durationInMilliseconds.value);
    stopwatch.value.start();
    startCountdownTimer();
    setGaugeEndValue(timerDuration.value);
    _startTimerBackground(timerDuration.value);
    sleepTimer.value = PausableTimer(duration, () async {
      await fadeOutAudio();
      if (await session.setActive(true,
          avAudioSessionSetActiveOptions:
              const AVAudioSessionSetActiveOptions(1),
          androidAudioFocusGainType: AndroidAudioFocusGainType.gain)) {
        _onTimerFinished(duration);
      }
    })
      ..start();
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

  void _startTimerBackground(Duration duration) {
    Workmanager().registerOneOffTask(
      "start",
      "request_audio_focus",
      inputData: {"seconds": duration.inSeconds},
    );
  }

  void _cancelTimerBackgroundTask(String taskName) {
    Workmanager().cancelByUniqueName(taskName);
  }

  late final AudioSession session;
  Future<void> _startAudioSession() async {
    session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  void _saveTimerDurationToLocalStorage() {
    appData.write("duration", timerDuration.value.toString());
  }

  void openMyAppsOnPlayStore() {
    const String googlePlayAccountUrl =
        "https://play.google.com/store/apps/dev?id=8497930826259194359";
    launch(googlePlayAccountUrl);
  }

  Future<bool> moveTaskToBackground() async {
    MoveToBackground.moveTaskToBack();
    return false;
  }

  Duration _calculateDuration(ValueChangingArgs args) {
    // Duration does not accept minutes as double
    return Duration(
      minutes: args.value.toInt(),
      seconds:
          ((double.parse("0." + args.value.toString().split('.').elementAt(1)) *
                  60)
              .round()),
    );
  }

  void onGaugeRangeChanged(ValueChangingArgs valueChangingArgs) {
    logger.d("argss " + valueChangingArgs.value.toString());
    timerDuration.value = _calculateDuration(valueChangingArgs);
    countdownDuration.value = parseDuration(timerDuration.value.toString());
    printInfo(info: timerDuration.value.toString());
  }

  /// used to pause sleep timer
  void pauseTimer() {
    printInfo(info: "PAUSING TIMER");
    sleepTimer.value.pause();
    stopwatch.value.stop();
    countdownTimer!.cancel();
    printInfo(info: countdownTimer?.isActive.toString() ?? "");
    update();
  }

  /// used to resume sleep timer
  void resumeTimer() {
    printInfo(info: "RESUMING TIMER");
    sleepTimer.value.start();
    stopwatch.value.start();
    startCountdownTimer();
    update();
  }

  void startCountdownTimer() {
    // To avoid milli and microseconds to avoid ruining animations
    // as this method does not convert milli and microseconds
    countdownDuration.value = parseDuration(timerDuration.value.toString());
    countdownTimer =
        Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (countdownDuration.value.inMilliseconds != 0) {
        countdownDuration.value = parseDuration(
            (countdownDuration.value - const Duration(seconds: 1)).toString());
        NotificationHandler.notifyTimerNotifications(
            timer, timerDuration.value);
      }
    });
  }

  void updateCountdownTimer() {}

  void cancelTimer() {
    sleepTimer.value.cancel();
    _onTimerCancel();
  }

  void _onTimerCancel() {
    Workmanager().cancelByUniqueName("start");
    // resetting [countdownTimer] and  [stopWatch]
    countdownTimer?.cancel();
    stopwatch.value.reset();

    // on cancelling Timer we will need to get the stored [end_value] stored in [GetStorage]
    _getGaugeEndValueFromLocalStorage();

    // enabling GaugeDragging again because the timer is free
    enableDragging.value = true;

    // resetting the [countdownDuration]
    countdownDuration.value = timerDuration.value;
    // durationInMilliseconds.value = duration.value;
    logger.d("cancelled");
    logger.d(timerDuration.value);

    // showing timer cancellation notifications
    NotificationHandler.cancelTimerNotifications(
        sleepTimer.value, timerDuration.value);
  }

  void _onTimerFinished(Duration duration) async {
    logger.d("Sleeping");
    // await session.setActive(false);

    // resetting [countdownTimer] and  [stopWatch]
    countdownTimer?.cancel();
    stopwatch.value.reset();

    // on cancelling Timer we will need to get the stored [end_value] stored in [GetStorage]
    _getGaugeEndValueFromLocalStorage();
    // timerDuration.value = parseDuration(appData.read('duration'));
    _goToHome();
    _setSilent();
    // interstitialAdEndTimer.show();
    _cancelTimerBackgroundTask('start');
    // enabling GaugeDragging again because the timer is free
    enableDragging.value = true;
    // resetting the [countdownDuration]
    countdownDuration.value = timerDuration.value;
    // durationInMilliseconds.value = duration.value;
    // showing timer finished notifications
    NotificationHandler.finishTimerNotifications(
        sleepTimer.value, timerDuration.value);
    update();
  }

  /// exit the app without closing and go to home
  void _goToHome() {
    if (goToHome.isTrue) {
      SystemShortcuts.home();
    }
  }

  /// sets the phone to silent mode if the user choosed that
  void _setSilent() {
    if (silentMode.value) {
      try {
        SoundMode.setSoundMode(RingerModeStatus.silent);
      } on PlatformException {
        logger.d('Please enable permissions required');
      }
    }
  }

  /// get the stored [end_value] stored in [GetStorage] to reset the [GaugeRange]
  /// returns 91 if null
  double _getGaugeEndValueFromLocalStorage() {
    gaugeEndValue.value = appData.read("end_value") ?? 91;
    return gaugeEndValue.value;
  }

  void setGaugeEndValue(Duration duration) {
    gaugeEndValue.value = duration.inSeconds.toDouble() / 60;
  }

  void storeEndValueInLocalStorage() {
    appData.write("end_value", gaugeEndValue.value);
  }

  Duration getCurrentCountdown() {
    // var dur = timerDuration.value - stopwatch.value.elapsed;
    return countdownDuration.value;
  }

  void extendTimer(Duration duration) {
    timerDuration.value = timerDuration.value + duration;
    // countdownDuration.value = countdownDuration.value + duration;
  }
}

startBackgroundTask() async {
  // await AudioService.connect();
  await AudioService.start(backgroundTaskEntrypoint: () {
    HomeController().startSleepTimer();
  });
}
