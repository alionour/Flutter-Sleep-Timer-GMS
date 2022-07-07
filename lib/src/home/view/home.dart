import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sleep_timer/src/app/services/ads/ads_controller.dart';
import 'package:sleep_timer/src/app/services/ads/open_app_ad.dart';
import 'package:sleep_timer/src/app/services/navigation/navigation.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sleep_timer/src/home/bloc/home_bloc.dart';
import 'package:sleep_timer/src/home/widgets/timer_button.dart';
import 'package:sleep_timer/src/home/widgets/timer_guage.dart';
import 'package:sleep_timer/src/timer/bloc/timer_bloc.dart';

import '../../settings/view/settings.dart';

extension TimesRepeat on AnimationController {
  void repeatTimes(int times) async {
    int count = 0;
    addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        count++;
        if (count < times) {
          repeat();
        } else {
          stop();
        }
      }
      //else if (status == AnimationStatus.dismissed) {
      //   forward();
      // }
    });
  }
}

class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();

  @override
  void initState() {
    super.initState();
    appOpenAdManager.showAdIfAvailable();
  }

  late final AppLifecycleReactor _appLifecycleReactor =
      AppLifecycleReactor(appOpenAdManager: appOpenAdManager);

  final AdsController _adsController = Get.put(AdsController());
  final HomeBloc _homeBloc = HomeBloc();
  final TimerBloc _timerBloc = TimerBloc();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _homeBloc),
        BlocProvider(create: (context) => _timerBloc),
      ],
      child: Builder(builder: (context) {
        return WillPopScope(
          onWillPop: _homeBloc.moveToBackground,
          child: Scaffold(
            floatingActionButton: Visibility(
              visible: kDebugMode,
              child: FloatingActionButton(
                onPressed: () {
                  showSnackBar('content');
                },
                child: const Icon(Icons.settings),
              ),
            ),
            body: Center(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Flexible(
                        child: TimerGuage(),
                      ),
                      Flexible(
                        child: BlocBuilder<TimerBloc, TimerState>(
                            builder: (context, state) {
                          if (state.timerStatus == TimerStatus.running) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                pauseTimer(),
                                const SizedBox(
                                  width: 10,
                                ),
                                cancelTimer()
                              ],
                            );
                          } else if (state.timerStatus == TimerStatus.paused) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                resumeTimer(),
                                const SizedBox(
                                  width: 10,
                                ),
                                cancelTimer()
                              ],
                            );
                          } else if (state.timerStatus ==
                              TimerStatus.cancelled) {
                            return startTimer();
                          }
                          return startTimer();
                        }),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            TimerButton(
                              color: Colors.pinkAccent,
                              duration: Duration(minutes: 1),
                            ),
                            TimerButton(
                              color: Colors.pinkAccent,
                              duration: Duration(minutes: 5),
                            ),
                            TimerButton(
                              color: Colors.blueGrey,
                              duration: Duration(minutes: -1),
                            ),
                            TimerButton(
                              color: Colors.blueGrey,
                              duration: Duration(minutes: -5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: AdWidget(
                        ad: _adsController.homeBanner,
                      )),
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                              child: const Icon(
                                Icons.settings_rounded,
                                size: 35,
                              ),
                              onPressed: () {
                                NavigatorService.goNamed(
                                    SettingsPage.routeName);
                              }),
                        ),
                        TextButton(
                            child: const Icon(
                              Icons.apps,
                              size: 50,
                            ),
                            onPressed: () {
                              _homeBloc.openMyAppsOnPlayStore();
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget startTimer() => Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 20),
        child: GestureDetector(
            onTap: () => _timerBloc
                .add(StartTimer(duration: _timerBloc.state.countdownDuration)),
            child: const CircleAvatar(
              radius: 30,
              // backgroundColor: isDarkTheme.value
              //     ? Colors.teal
              //     : Colors.pinkAccent,
              child: Icon(
                Icons.play_arrow_rounded,
                size: 30,
                color: Colors.white,
              ),
            )),
      );

  Widget resumeTimer() => Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 20),
        child: GestureDetector(
          onTap: () => _timerBloc.add(ResumeTimer()),
          child: CircleAvatar(
            radius: 30,
            // backgroundColor: isDarkTheme.value
            // ? Colors.teal
            // : Colors.pinkAccent,
            child: Icon(
              _timerBloc.state.sleepTimer.isPaused
                  ? Icons.play_arrow_rounded
                  : Icons.pause_rounded,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      );

  Widget cancelTimer() => Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 20),
        child: GestureDetector(
          onTap: () => _timerBloc.add(CancelTimer()),
          child: const CircleAvatar(
            radius: 30,
            // backgroundColor: isDarkTheme.value
            //     ? Colors.teal
            //     : Colors.pinkAccent,
            child: Icon(
              Icons.stop_rounded,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      );

  Widget pauseTimer() => Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 20),
        child: GestureDetector(
          onTap: () => _timerBloc.add(PauseTimer()),
          child: const CircleAvatar(
            radius: 30,
            child: Icon(
              Icons.pause_rounded,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      );
}
