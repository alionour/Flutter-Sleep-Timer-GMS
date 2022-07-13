import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  Future<bool> moveToBackground() async {
    await MoveToBackground.moveTaskToBack();
    return true;
  }

  void openMyAppsOnPlayStore() async {
    const market = 'https://play.google.com/store/apps/developer?id=Ali Nour';
    const tunable = 'market://details?id=com.ali.nourmed.tunable';
    const url = 'https://play.google.com/store/apps/developer?id=Ali+Nour';
    try {
      if (await canLaunchUrlString(market)) {
        launchUrlString(market, mode: LaunchMode.externalApplication);
        log('launched market');
      } else if (await canLaunchUrlString(tunable)) {
        launchUrlString(tunable, mode: LaunchMode.externalApplication);
        log('launched market');
      } else if (await canLaunchUrlString(url)) {
        launchUrlString(url);
        log('launched url');
      } else {
        showSnackBar('Could not open playstore');
      }
    } catch (e) {
      log('error launching playstore $e');
      showSnackBar('Could not open playstore');
    }
  }
}
