import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sleep_timer/src/globals.dart';

class AdsController extends GetxController with WidgetsBindingObserver {
  AdmobInterstitial? interstitialAdStartTimer;
  AdmobInterstitial? interstitialAdEndTimer;
  RxBool isInForeground = true.obs;
  RxBool isLoadingAd = false.obs;
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);

    interstitialAdStartTimer = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitIdStartTimer()!,
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        // if (event == AdmobAdEvent.closed) interstitialAdStartTimer?.load();
        handleEvent(event, args, 'Interstitial');
      },
    )..load();
    // interstitialAdEndTimer = AdmobInterstitial(
    //   adUnitId: getInterstitialAdUnitIdStartTimer()!,
    //   listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
    //     if (event == AdmobAdEvent.closed) interstitialAdEndTimer?.load();
    //     handleEvent(event, args, 'Interstitial');
    //   },
    // );
    // interstitialAdEndTimer?.load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      isInForeground.value = true;
    } else {
      isInForeground.value = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    interstitialAdStartTimer?.dispose();
    interstitialAdEndTimer?.dispose();
    super.dispose();
  }

  String? getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      // return 'ca-app-pub-3940256099942544/6300978111';
      return 'ca-app-pub-5426827911938239/6880935059';
    }
    return null;
  }

  String? getSettingsBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      // return 'ca-app-pub-3940256099942544/6300978111';
      return 'ca-app-pub-5426827911938239/4235984988';
    }
    return null;
  }

  String? getInterstitialAdUnitIdStartTimer() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      // return
      return 'ca-app-pub-5426827911938239/2659646682';
    }
    return null;
  }

  String? getInterstitialAdUnitIdEndTimer() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      // return
      return 'ca-app-pub-5426827911938239/5254020439';
    }
    return null;
  }

  String? getRewardBasedVideoAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    }
    return null;
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic>? args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Adwill be shown');
        logger.d('ssssssssss');
        isLoadingAd.value = true;
        Future.delayed(const Duration(seconds: 5)).then((value) {
          isLoadingAd.value = false;
          if (isInForeground.value && kReleaseMode) {
            interstitialAdStartTimer?.show();
          }
        });
        break;
      case AdmobAdEvent.opened:
        // showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        // showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        // showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args?['type']}'),
                    Text('Amount: ${args?['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                // scaffoldState.currentState.hideCurrentSnackBar();
                Get.back();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }
}
