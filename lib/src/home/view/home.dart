import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lecle_system_shortcuts/lecle_system_shortcuts.dart';
import 'package:sleep_timer/src/app/services/ads/ads_controller.dart';
import 'package:sleep_timer/src/app/services/ads/open_app_ad.dart';
import 'package:sleep_timer/src/app/services/rate_app/rate_app.dart';
import 'package:sleep_timer/src/home/bloc/home_bloc.dart';
import 'package:sleep_timer/src/home/view/home_landscape.dart';
import 'package:sleep_timer/src/home/view/home_portrait.dart';
import 'package:sleep_timer/src/timer/bloc/timer_bloc.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeRateMyApp();
      if (mounted) {
        showRateDialog(context);
      }
      appOpenAdManager.showAdIfAvailable();
    });
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
                  Future.delayed(const Duration(milliseconds: 5000), () {
                    SystemShortcuts.home();
                  });
                },
                child: const Icon(Icons.settings),
              ),
            ),
            body: OrientationBuilder(builder: (context, orientation) {
              if (orientation == Orientation.landscape) {
                return const LandscapeHomeView();
              }
              return const PortraitHomeView();
            }),
          ),
        );
      }),
    );
  }
}

Widget startTimer(TimerBloc timerBloc) => Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: GestureDetector(
          onTap: () => timerBloc
              .add(StartTimer(duration: timerBloc.state.countdownDuration)),
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

Widget resumeTimer(TimerBloc timerBloc) => Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: GestureDetector(
        onTap: () => timerBloc.add(ResumeTimer()),
        child: CircleAvatar(
          radius: 30,
          // backgroundColor: isDarkTheme.value
          // ? Colors.teal
          // : Colors.pinkAccent,
          child: Icon(
            timerBloc.state.sleepTimer.isPaused
                ? Icons.play_arrow_rounded
                : Icons.pause_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );

Widget cancelTimer(TimerBloc timerBloc) => Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: GestureDetector(
        onTap: () => timerBloc.add(CancelTimer()),
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

Widget pauseTimer(TimerBloc timerBloc) => Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: GestureDetector(
        onTap: () => timerBloc.add(PauseTimer()),
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
