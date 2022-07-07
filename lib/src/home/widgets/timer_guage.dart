import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep_timer/src/home/widgets/animated_timer.dart';
import 'package:sleep_timer/src/timer/bloc/timer_bloc.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TimerGuage extends StatefulWidget {
  const TimerGuage({Key? key}) : super(key: key);

  @override
  State<TimerGuage> createState() => _TimerGuageState();
}

class _TimerGuageState extends State<TimerGuage> {
  final double gaugeWidth = 20.0;
  @override
  Widget build(BuildContext context) {
    final timerBloc = context.read<TimerBloc>();
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        log('chaned');
        return SfRadialGauge(
          axes: [
            RadialAxis(
                // Used to make corners rounded
                axisLineStyle: AxisLineStyle(
                  cornerStyle: CornerStyle.bothCurve,
                  thickness: gaugeWidth,
                ),
                axisLabelStyle: const GaugeTextStyle(
                    // color: isDarkTheme.value
                    //     ? const Color.fromARGB(255, 132, 35, 177)
                    //     : Colors.red,
                    ),
                maximumLabels: 4,
                minimum: 0,
                showFirstLabel: true,
                // showLastLabel: true,
                canRotateLabels: true,
                // interval: timerBloc.getInterval(),
                maximum: state.gaugeEndValue,
                // maximum: _homeController.gaugeEndValue.value,
                ranges: const [],
                pointers: <GaugePointer>[
                  // Used to make corners rounded
                  RangePointer(
                    value: state.gaugeEndValue,
                    enableDragging: state.dragEnabled,
                    width: gaugeWidth,
                    // gradient: SweepGradient(colors: [
                    //   isDarkTheme.value
                    //       ? const Color.fromARGB(255, 132, 35, 177)
                    //       : Colors.pinkAccent,
                    // ]),
                    cornerStyle: CornerStyle.bothCurve,
                    onValueChanging: (value) =>
                        timerBloc.add(ChangeGaugeRange(value)),
                  ),
                  NeedlePointer(
                    value: double.parse(
                        (state.countdownDuration.inMilliseconds / 1000 / 60)
                            .toString()),
                    // needleColor: isDarkTheme.value
                    //     ? const Color.fromARGB(255, 132, 35, 177)
                    //     : Colors.pinkAccent,
                    enableDragging: state.dragEnabled,
                    tailStyle: const TailStyle(color: Colors.red),
                    onValueChanging: (value) => timerBloc.add(
                      ChangeGaugeRange(value),
                    ),
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      verticalAlignment: GaugeAlignment.near,
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          BlocBuilder<TimerBloc, TimerState>(
                              builder: (context, state) {
                            var hours = state.countdownDuration
                                .toString()
                                .split('.')[0]
                                .split(':')[0];
                            var paddingLeft =
                                (int.parse(hours) >= 10) ? '' : '0';
                            return AnimatedTimer(
                              isAnimationActive: false,
                              text: paddingLeft + hours,
                            );
                          }),
                          const SizedBox(
                            width: 3,
                          ),
                          BlocBuilder<TimerBloc, TimerState>(
                            builder: (context, state) {
                              return AnimatedTimer(
                                isAnimationActive: false,
                                text: state.countdownDuration
                                    .toString()
                                    .split('.')[0]
                                    .split(':')[1]
                                    .split(':')[0],
                              );
                            },
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          BlocBuilder<TimerBloc, TimerState>(
                            builder: (context, state) {
                              return AnimatedTimer(
                                  isAnimationActive:
                                      state.timerStatus == TimerStatus.running,
                                  text: state.countdownDuration
                                      .toString()
                                      .split(':')[2]
                                      .split('.')[0]);
                            },
                          )
                        ],
                      ),
                      angle: 90,
                      positionFactor: 0.8)
                ])
          ],
        );
      },
    );
  }
}
