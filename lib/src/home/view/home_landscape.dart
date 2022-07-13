import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sleep_timer/src/app/services/navigation/navigation.dart';
import 'package:sleep_timer/src/home/bloc/home_bloc.dart';
import 'package:sleep_timer/src/home/view/home.dart';
import 'package:sleep_timer/src/home/view/home_portrait.dart';
import 'package:sleep_timer/src/home/widgets/timer_button.dart';
import 'package:sleep_timer/src/home/widgets/timer_guage.dart';
import 'package:sleep_timer/src/settings/view/settings.dart';
import 'package:sleep_timer/src/timer/bloc/timer_bloc.dart';

class LandscapeHomeView extends StatefulWidget {
  const LandscapeHomeView({Key? key}) : super(key: key);

  @override
  State<LandscapeHomeView> createState() => _LandscapeHomeViewState();
}

class _LandscapeHomeViewState extends State<LandscapeHomeView> {
  @override
  Widget build(BuildContext context) {
    final timerBloc = context.read<TimerBloc>();
    final HomeBloc homeBloc = context.read<HomeBloc>();
    return Center(
      child: Stack(
        children: [
          ResponsiveRowColumn(
            columnMainAxisAlignment: MainAxisAlignment.center,
            rowMainAxisAlignment: MainAxisAlignment.center,
            layout: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                ? ResponsiveRowColumnType.ROW
                : ResponsiveRowColumnType.COLUMN,
            children: [
              ResponsiveRowColumnItem(
                  child: Column(
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
                ],
              )),
              ResponsiveRowColumnItem(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
              ResponsiveRowColumnItem(
                child: Transform.scale(scale: 0.7, child: const TimerGuage()),
              ),
              ResponsiveRowColumnItem(
                child: BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                  if (state.timerStatus == TimerStatus.running) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        pauseTimer(timerBloc),
                        const SizedBox(
                          width: 10,
                        ),
                        cancelTimer(timerBloc)
                      ],
                    );
                  } else if (state.timerStatus == TimerStatus.paused) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        resumeTimer(timerBloc),
                        const SizedBox(
                          width: 10,
                        ),
                        cancelTimer(timerBloc)
                      ],
                    );
                  } else if (state.timerStatus == TimerStatus.cancelled) {
                    return startTimer(timerBloc);
                  }
                  return startTimer(timerBloc);
                }),
              ),
            ],
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.1,
              child: const HomeBanner()),
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
                        NavigatorService.goNamed(SettingsPage.routeName);
                      }),
                ),
                TextButton(
                    child: const Icon(
                      Icons.apps,
                      size: 50,
                    ),
                    onPressed: () {
                      homeBloc.openMyAppsOnPlayStore();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
