import 'dart:developer';
import 'dart:io' show Platform;

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {
  String adUnitId = Platform.isAndroid
      ? 'ca-app-pub-5426827911938239/5364613295'
      : 'ca-app-pub-3940256099942544/5662855259';

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  /// Load an AppOpenAd.
  Future<void> loadAd() async {
    try {
      await AppOpenAd.load(
        adUnitId: adUnitId,
        orientation: AppOpenAd.orientationPortrait,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            print('$ad loaded open app');
            _appOpenLoadTime = DateTime.now();
            _appOpenAd = ad;
          },
          onAdFailedToLoad: (error) {
            print('AppOpenAd failed to load: $error');
            // Handle the error.
          },
        ),
      );
    } catch (e) {
      log('Error loading AppOpenAd: $e');
    }
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() async {
    try {
      if (!isAdAvailable) {
        print('Tried to show ad before available.');
        await loadAd();
        return;
      }
      if (_isShowingAd) {
        print('Tried to show ad while already showing an ad.');
        return;
      }
      if (DateTime.now()
          .subtract(maxCacheDuration)
          .isAfter(_appOpenLoadTime!)) {
        print('Maximum cache duration exceeded. Loading another ad.');
        _appOpenAd!.dispose();
        _appOpenAd = null;
        await loadAd();
        return;
      }

      // Set the fullScreenContentCallback and show the ad.
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          _isShowingAd = true;
          print('$ad onAdShowedFullScreenContent');
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
          _isShowingAd = false;
          ad.dispose();
          _appOpenAd = null;
        },
        onAdDismissedFullScreenContent: (ad) async {
          print('$ad onAdDismissedFullScreenContent');
          _isShowingAd = false;
          ad.dispose();
          _appOpenAd = null;
          await loadAd();
        },
      );
      _appOpenAd!.show();
    } catch (e) {
      log('Error showing ad: $e');
      rethrow;
    }
  }

  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;
}

/// Listens for app foreground events and shows app open ads.
class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    // Try to show an app open ad if the app is being resumed and
    // we're not already showing an app open ad.
    if (appState == AppState.foreground) {
      appOpenAdManager.showAdIfAvailable();
    }
  }
}
