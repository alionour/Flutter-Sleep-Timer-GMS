import 'package:get/get.dart';
import 'package:volume_control/volume_control.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:audio_session/audio_session.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:system_shortcuts/system_shortcuts.dart';
import 'package:flutter_t/Globals.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_t/Notifications/NotificationHandler.dart';

class HomeController extends GetxController {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  ///////////////////////////////////////////
  /// Ads
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAdStartTimer;
  AdmobInterstitial interstitialAdEndTimer;
  var appData = GetStorage();
  AdmobReward rewardAd;

  //////////////////////////////////////////

  VolumeControl volumeController;
  double currentVolume;
  var duration = Duration(minutes: 1).obs;
  Timer timer;
  Timer countdownTimer;
  var millisec = 0.obs;
  var endValue = 91.0.obs;
  var timerButtonText = "Start Timer".obs;
  var enableDragging = true.obs;
  // var color  = Colors.greenAccent.
  Action action = Action.start;
  Future<void> startSleepTimer() async {
    await FlutterLocalNotificationsPlugin().cancelAll();
    appData.write("minutes", duration.value.inMinutes);
    print("clicked");
    if (action == Action.start) {
      interstitialAdStartTimer.show();
      timerButtonText.value = "Cancel Timer";
      enableDragging.value = false;
      update();
      action = Action.cancel;
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration.music());
      millisec.value = duration.value.inMilliseconds;
      print(millisec);
      int progress = 0;
      countdownTimer =
          Timer.periodic(Duration(milliseconds: 1000), (timer) async {
        progress += 1000;
        if (millisec.value != 0) {
          millisec.value -= 1000;
          NotificationHandler.notifyTimerNotifications(timer, duration);
        }
      });

      endValue.value = millisec.value / 1000 / 60;
      timer = Timer(duration.value, () async {
        if (await session.setActive(true,
            avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions(1),
            androidAudioFocusGainType: AndroidAudioFocusGainType.gain)) {
          print("end");

          await session.setActive(false);
          enableDragging.value = true;
          timerButtonText.value = "Start Timer";
          update();
          endValue.value = appData.read("end_value") ?? 91;
          countdownTimer.cancel();

          action = Action.start;
          duration.value = Duration(seconds: 59);
          NotificationHandler.finishTimerNotifications(timer, duration);
          goToHome
              ? await SystemShortcuts.home()
              : printInfo(info: "Not going to home");
          interstitialAdEndTimer.show();
        } else {}
      });
    } else if (action == Action.cancel) {
      timer.cancel();
      countdownTimer.cancel();
      endValue.value = appData.read("end_value") ?? 91;
      enableDragging.value = true;

      timerButtonText.value = "Start Timer";
      action = Action.start;
      // duration.value = Duration(seconds: 59);
      // millisec.value = duration.value.inMilliseconds;
      print("cancelled");
      print(duration.value);
      print(millisec.value);
      print(double.parse((millisec.value / 1000 / 60).toString()));
      NotificationHandler.cancelTimerNotifications(timer, duration);
      // await FlutterLocalNotificationsPlugin().cancelAll();
    }
  }

  @override
  void dispose() {
    interstitialAdStartTimer.dispose();
    interstitialAdEndTimer.dispose();
    // rewardAd.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    // You should execute `Admob.requestTrackingAuthorization()` here before showing any ad.

    // bannerSize = AdmobBannerSize.BANNER;
    duration.value = Duration(minutes: appData.read("minutes") ?? 1);
    millisec.value = duration.value.inMilliseconds;
    endValue.value = appData.read("end_value") ?? 91;
    interstitialAdStartTimer = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitIdStartTimer(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAdStartTimer.load();
        handleEvent(event, args, 'Interstitial');
      },
    );
    interstitialAdEndTimer = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitIdStartTimer(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAdEndTimer.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    // rewardAd = AdmobReward(
    //   adUnitId: getRewardBasedVideoAdUnitId(),
    //   listener: (AdmobAdEvent event, Map<String, dynamic> args) {
    //     if (event == AdmobAdEvent.closed) rewardAd.load();
    //     handleEvent(event, args, 'Reward');
    //   },
    // );

    interstitialAdStartTimer.load();
    interstitialAdEndTimer.load();
    // interstitialAd.show();
    // rewardAd.load();
    super.onInit();
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }
  /*
Test Id's from:
https://developers.google.com/admob/ios/banner
https://developers.google.com/admob/android/banner

App Id - See README where these Id's go
Android: ca-app-pub-3940256099942544~3347511713
iOS: ca-app-pub-3940256099942544~1458002511

Banner
Android: ca-app-pub-3940256099942544/6300978111
iOS: ca-app-pub-3940256099942544/2934735716

Interstitial
Android: ca-app-pub-3940256099942544/1033173712
iOS: ca-app-pub-3940256099942544/4411468910

Reward Video
Android: ca-app-pub-3940256099942544/5224354917
iOS: ca-app-pub-3940256099942544/1712485313
*/

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      // return 'ca-app-pub-3940256099942544/6300978111';
      return 'ca-app-pub-5426827911938239/6880935059';
    }
    return null;
  }

  String getInterstitialAdUnitIdStartTimer() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      // return
      return 'ca-app-pub-5426827911938239/2659646682';
    }
    return null;
  }

  String getInterstitialAdUnitIdEndTimer() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      // return
      return 'ca-app-pub-5426827911938239/5254020439';
    }
    return null;
  }
  // String getRewardBasedVideoAdUnitId() {
  //   if (Platform.isIOS) {
  //     return 'ca-app-pub-3940256099942544/1712485313';
  //   } else if (Platform.isAndroid) {
  //     return 'ca-app-pub-3940256099942544/5224354917';
  //   }
  //   return null;
  // }
}

enum Action { start, cancel }

startBackgroundTask() async {
  print("herwe1");
  await AudioService.connect();
  await AudioService.start(backgroundTaskEntrypoint: () {
    HomeController().startSleepTimer();
    print("herer  in");
  });
  print("calld");
  // AudioServiceBackground.setState(
  //     playing: true,
  //     processingState: AudioServiceBackground.state.processingState,
  //     controls: null);
}
