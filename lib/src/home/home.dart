import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleep_timer/src/ads/ads_controller.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sleep_timer/src/home/animated_timer.dart';
import 'package:sleep_timer/src/home/home_controller.dart';
import 'package:sleep_timer/src/home/timer_button.dart';
import 'package:sleep_timer/src/hourglass/hourglass.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:admob_flutter/admob_flutter.dart';
import '../settings/settings.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  final double gaugeWidth = 20.0;
  final AdsController _adsController = Get.put(AdsController());
  final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: _homeController.moveTaskToBackground,
          child: Scaffold(
            body: Center(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: SfRadialGauge(
                          axes: [
                            RadialAxis(
                                // Used to make corners rounded
                                axisLineStyle: AxisLineStyle(
                                  cornerStyle: CornerStyle.bothCurve,
                                  thickness: gaugeWidth,
                                ),
                                axisLabelStyle: GaugeTextStyle(
                                  color: isDarkTheme.value
                                      ? Colors.teal
                                      : Colors.red,
                                ),
                                maximumLabels: 4,
                                maximum: _homeController.gaugeEndValue.value,
                                ranges: const [
                                  // GaugeRange(
                                  //   startValue: 0,
                                  //   endValue: _homeController.endValue.value,
                                  //   labelStyle: GaugeTextStyle(
                                  //     color: isDarkTheme.value
                                  //         ? Colors.teal
                                  //         : Colors.pinkAccent,
                                  //   ),
                                  //   // color: Colors.green,
                                  //   gradient: SweepGradient(colors: [
                                  //     isDarkTheme.value
                                  //         ? Colors.teal
                                  //         : Colors.pinkAccent,
                                  //   ]),
                                  //   startWidth: gaugeWidth,
                                  //   endWidth: gaugeWidth,
                                  // ),
                                ],
                                pointers: <GaugePointer>[
                                  // Used to make corners rounded
                                  RangePointer(
                                    value: _homeController.gaugeEndValue.value,
                                    enableDragging:
                                        _homeController.enableDragging.value,
                                    width: gaugeWidth,
                                    gradient: SweepGradient(colors: [
                                      isDarkTheme.value
                                          ? Colors.teal
                                          : Colors.pinkAccent,
                                    ]),
                                    cornerStyle: CornerStyle.bothCurve,
                                    onValueChanging:
                                        _homeController.onGaugeRangeChanged,
                                  ),
                                  NeedlePointer(
                                      value: double.parse((_homeController
                                                  .timerDuration
                                                  .value
                                                  .inMilliseconds /
                                              1000 /
                                              60)
                                          .toString()),
                                      needleColor: isDarkTheme.value
                                          ? Colors.teal
                                          : Colors.pinkAccent,
                                      enableDragging:
                                          _homeController.enableDragging.value,
                                      tailStyle:
                                          const TailStyle(color: Colors.red),
                                      onValueChanging:
                                          _homeController.onGaugeRangeChanged),
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      verticalAlignment: GaugeAlignment.near,
                                      widget: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          GetBuilder(
                                              init: _homeController,
                                              builder: (context) {
                                                var hours = _homeController
                                                    .getCurrentCountdown()
                                                    .toString()
                                                    .split('.')[0]
                                                    .split(':')[0];
                                                var paddingLeft =
                                                    (int.parse(hours) >= 10)
                                                        ? ""
                                                        : "0";
                                                return AnimatedTimer(
                                                  isAnimationActive: false,
                                                  text: "$paddingLeft$hours",
                                                );
                                              }),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          GetBuilder<HomeController>(
                                            init: _homeController,
                                            initState: (_) {},
                                            builder: (_) {
                                              logger.d('minute up');
                                              return AnimatedTimer(
                                                isAnimationActive: false,
                                                text: _homeController
                                                    .getCurrentCountdown()
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
                                          GetBuilder<HomeController>(
                                            init: _homeController,
                                            initState: (_) {},
                                            builder: (_) {
                                              return AnimatedTimer(
                                                  isAnimationActive:
                                                      _homeController
                                                              .countdownTimer
                                                              ?.isActive ??
                                                          false,
                                                  text: _homeController
                                                      .getCurrentCountdown()
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
                        ),
                      ),
                      Flexible(
                        child: GetBuilder(
                            init: _homeController,
                            builder: (context) {
                              if (_homeController.sleepTimer.value.isActive) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 60.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: isDarkTheme.value
                                              ? Colors.teal
                                              : Colors.pinkAccent,
                                          child: const Icon(
                                            Icons.pause_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: _homeController.pauseTimer,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: isDarkTheme.value
                                              ? Colors.teal
                                              : Colors.pinkAccent,
                                          child: const Icon(
                                            Icons.stop_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: _homeController.cancelTimer,
                                      )
                                    ],
                                  ),
                                );
                              } else if (_homeController
                                  .sleepTimer.value.isPaused) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 60.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: isDarkTheme.value
                                              ? Colors.teal
                                              : Colors.pinkAccent,
                                          child: Icon(
                                            _homeController
                                                    .sleepTimer.value.isPaused
                                                ? Icons.play_arrow_rounded
                                                : Icons.pause_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: _homeController.resumeTimer,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: isDarkTheme.value
                                              ? Colors.teal
                                              : Colors.pinkAccent,
                                          child: const Icon(
                                            Icons.stop_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: _homeController.cancelTimer,
                                      )
                                    ],
                                  ),
                                );
                              } else if (_homeController
                                  .sleepTimer.value.isCancelled) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 60.0),
                                  child: GestureDetector(
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: isDarkTheme.value
                                            ? Colors.teal
                                            : Colors.pinkAccent,
                                        child: const Icon(
                                          Icons.play_arrow_rounded,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: _homeController.startSleepTimer),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 60.0),
                                child: GestureDetector(
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: isDarkTheme.value
                                          ? Colors.teal
                                          : Colors.pinkAccent,
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: _homeController.startSleepTimer),
                              );
                            }),
                      ),
                      Flexible(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TimerButton(
                                  color: isDarkTheme.value
                                      ? Colors.teal
                                      : Colors.pinkAccent,
                                  duration: const Duration(minutes: 1),
                                  buttonAction: TimerButtonAction.extend),
                              TimerButton(
                                  color: isDarkTheme.value
                                      ? Colors.teal
                                      : Colors.pinkAccent,
                                  duration: const Duration(minutes: 5),
                                  buttonAction: TimerButtonAction.extend),
                              TimerButton(
                                  color: isDarkTheme.value
                                      ? Colors.pink
                                      : Colors.blueGrey,
                                  duration: const Duration(minutes: -1),
                                  buttonAction: TimerButtonAction.shrink),
                              TimerButton(
                                  color: isDarkTheme.value
                                      ? Colors.pink
                                      : Colors.blueGrey,
                                  duration: const Duration(minutes: -5),
                                  buttonAction: TimerButtonAction.shrink),
                            ]),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: Column(
                      children: [
                        Obx(() => Visibility(
                            visible: _adsController.isLoadingAd.value,
                            child: const Center(
                                child: CircularProgressIndicator()))),
                        const SizedBox(
                          height: 5,
                        ),
                        AdmobBanner(
                          adSize: AdmobBannerSize.FULL_BANNER,
                          adUnitId: _adsController.getBannerAdUnitId()!,
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            child: const Icon(
                              Icons.settings_applications,
                              size: 50,
                            ),
                            onPressed: () {
                              Get.to(const Settings());
                            }),
                        kReleaseMode
                            ? const SizedBox()
                            : TextButton(
                                child: const Icon(
                                  Icons.hourglass_bottom_rounded,
                                  size: 50,
                                ),
                                onPressed: () {
                                  Get.to(const HourglassView());
                                }),
                        TextButton(
                            child: const Icon(
                              Icons.apps,
                              size: 50,
                            ),
                            onPressed: () {
                              _homeController.openMyAppsOnPlayStore();
                            }),
                      ],
                    ),
                  ),

                  // if (controller.isBannerAdLoaded.value)
                  //   Positioned(
                  //     bottom: 0,
                  //     height:
                  //         controller.homeBanner.value.size.height.toDouble(),
                  //     width: controller.homeBanner.value.size.width.toDouble(),
                  //     child: AdWidget(ad: controller.homeBanner.value),
                  //   ),
                ],
              ),
              // child: (controller.isBannerAdLoaded.value)
              //     ? Positioned(
              //         bottom: 0,
              //         height:
              //             controller.homeBanner.value.size.height.toDouble(),
              //         width: controller.homeBanner.value.size.width.toDouble(),
              //         child: AdWidget(ad: controller.homeBanner.value),
              //       )
              //     : Container(),
            ),
          ),
        ));
  }
}
