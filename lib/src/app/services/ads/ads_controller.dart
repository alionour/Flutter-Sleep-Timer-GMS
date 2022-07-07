import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sleep_timer/src/globals.dart';

class AdsController extends GetxController with WidgetsBindingObserver {
  InterstitialAd? interstitialAdStartTimer;
  RxBool isInForeground = true.obs;
  RxBool isLoadingAd = false.obs;
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    InterstitialAd.load(
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          interstitialAdStartTimer = ad;
          showSnackBar('New Ad will be shown');
          isLoadingAd.value = true;
          Future.delayed(const Duration(seconds: 5)).then((value) {
            isLoadingAd.value = false;
            if (isInForeground.value && kReleaseMode) {
              interstitialAdStartTimer?.show();
            }
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
      adUnitId: getInterstitialAdUnitIdStartTimer()!,
    );
  }

  final BannerAd homeBanner = BannerAd(
    adUnitId: getBannerAdUnitId(),
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('Banner Ad loaded.');
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    ),
  )..load();
  final BannerAd settingsBanner = BannerAd(
    adUnitId: getSettingsBannerAdUnitId(),
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    ),
  )..load();
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
    WidgetsBinding.instance.removeObserver(this);
    interstitialAdStartTimer?.dispose();
    super.dispose();
  }
}

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    // return 'ca-app-pub-3940256099942544/6300978111';
    return 'ca-app-pub-5426827911938239/6880935059';
  }
  return '';
}

String getSettingsBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    // return 'ca-app-pub-3940256099942544/6300978111';
    return 'ca-app-pub-5426827911938239/4235984988';
  }
  return '';
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
