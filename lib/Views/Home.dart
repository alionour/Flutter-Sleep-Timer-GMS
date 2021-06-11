import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_t/Controllers/HomeController.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:admob_flutter/admob_flutter.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'Settings.dart';
import 'package:flutter_t/Globals.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:flutter_background/flutter_background.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.theme;
    HomeController controller = Get.put(HomeController());
    return Obx(() => WillPopScope(
          onWillPop: () async {
            MoveToBackground.moveTaskToBack();
            return false;
          },
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
                                axisLabelStyle: GaugeTextStyle(
                                    color: isDarkTheme
                                        ? Colors.greenAccent
                                        : Colors.red),
                                maximumLabels: 2,
                                maximum: controller.endValue.value,
                                ranges: [
                                  GaugeRange(
                                      startValue: 0,
                                      endValue: controller.endValue.value,
                                      labelStyle: GaugeTextStyle(
                                        color: isDarkTheme
                                            ? Colors.greenAccent
                                            : Colors.pinkAccent,
                                      ),
                                      // color: Colors.green,
                                      gradient: SweepGradient(colors: [
                                        isDarkTheme
                                            ? Colors.greenAccent
                                            : Colors.pinkAccent,
                                      ]),
                                      startWidth: 20,
                                      endWidth: 20),
                                ],
                                pointers: <GaugePointer>[
                                  NeedlePointer(
                                      value: double.parse((controller
                                                  .durationInMilliseconds
                                                  .value
                                                  .inMilliseconds /
                                              1000 /
                                              60)
                                          .toString()),
                                      needleColor: isDarkTheme
                                          ? Colors.greenAccent
                                          : Colors.pinkAccent,
                                      enableDragging:
                                          controller.enableDragging.value,
                                      tailStyle: TailStyle(color: Colors.red),
                                      onValueChanging: (ValueChangingArgs
                                          valueChangingArgs) {
                                        // if (valueChangingArgs.value <= 1) {
                                        //   controller.duration.value =
                                        //       Duration(minutes: 1);
                                        //   controller
                                        //           .durationInMilliseconds.value =
                                        //       Duration(milliseconds: 1000);
                                        //   print(controller.duration.value);
                                        // } else {
                                        controller.duration.value = Duration(
                                            minutes:
                                                valueChangingArgs.value.toInt(),
                                            // seconds: int.tryParse(valueChangingArgs
                                            //     .value
                                            //     .toString()
                                            //     .split(".").elementAt(1)[1]),
                                            seconds: ((double.tryParse("0." +
                                                        (valueChangingArgs
                                                                    .value /
                                                                60)
                                                            .toString()
                                                            .split('.')
                                                            ?.elementAt(1)) *
                                                    60)
                                                .round()));
                                        controller.durationInMilliseconds
                                            .value = controller.duration.value;
                                      }
                                      // },
                                      ),
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: Container(
                                          child: Text(
                                              // "${(controller.durationInMilliseconds.value.inMilliseconds ~/ 1000 ~/ 60).toStringAsFixed(2)}",
                                              "${controller.durationInMilliseconds.value.inMinutes}.${((double.tryParse("0." + (controller.durationInMilliseconds.value.inSeconds / 60).toString().split('.')?.elementAt(1)) * 60).round())}",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: isDarkTheme
                                                      ? Colors.greenAccent
                                                      : Colors.pinkAccent,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      angle: 90,
                                      positionFactor: 0.8)
                                ])
                          ],
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton(
                            child: Text(
                              controller.timerButtonText.value,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ButtonStyle(
                              backgroundColor: isDarkTheme
                                  ? MaterialStateProperty.all(
                                      Colors.greenAccent)
                                  : MaterialStateProperty.all(
                                      Colors.pinkAccent),
                            ),
                            onPressed: () {
                              if (controller.duration.value.inSeconds < 1) {
                                Get.snackbar(
                                    "Note", "Timer Can not be started");
                              } else {
                                controller.startSleepTimer();
                              }
                            }),
                      ),
                      Flexible(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TimerButton(
                                  color: isDarkTheme
                                      ? Colors.greenAccent
                                      : Colors.pinkAccent,
                                  text: "+1",
                                  duration: Duration(minutes: 1),
                                  action: "increment"),
                              TimerButton(
                                  color: isDarkTheme
                                      ? Colors.greenAccent
                                      : Colors.pinkAccent,
                                  text: "+5",
                                  duration: Duration(minutes: 5),
                                  action: "increment"),
                              TimerButton(
                                  color: Colors.pink,
                                  text: "-1",
                                  duration: Duration(minutes: -1),
                                  action: "decrement"),
                              TimerButton(
                                  color: Colors.pink,
                                  text: "-5",
                                  duration: Duration(minutes: -5),
                                  action: "decrement"),
                            ]),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: AdmobBanner(
                      adSize: AdmobBannerSize.FULL_BANNER,
                      adUnitId: controller.getBannerAdUnitId(),
                    ),
                  ),

                  Positioned(
                    top: 25,
                    left: 10,
                    child: TextButton(
                        child: Icon(
                          Icons.settings_applications,
                          size: 50,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () {
                          Get.to(Settings());
                        }),
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

class TimerButton extends StatelessWidget {
  final Color color;
  final String text;
  final Duration duration;
  final String action;
  TimerButton({Key key, this.color, this.text, this.duration, this.action})
      : super(key: key);

  final HomeController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color),
              // shape:MaterialStateProperty.all(CircleBorder())
            ),
            child: Text(
              text ?? "",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              print(controller.duration.value);
              if (controller.duration.value.inSeconds <= 60 &&
                  action == "decrement" &&
                  duration.inSeconds == -60) {
                Get.snackbar("Note", "Timer Can be setted");
                return;
              } else if (controller.duration.value.inSeconds <= 300 &&
                  action == "decrement" &&
                  duration.inSeconds == -300) {
                Get.snackbar("Note", "Timer Can be setted");
                return;
              } else {
                if (controller.duration.value.inSeconds >= (5400)) {
                  controller.endValue.value =
                      controller.duration.value.inSeconds + 60.0;
                  controller.appData
                      .write("end_value", controller.endValue.value);
                } //else{}
                controller.duration.value = Duration(
                    seconds: controller.durationInMilliseconds.value.inSeconds +
                        duration.inSeconds);
                controller.durationInMilliseconds.value =
                    controller.duration.value;
                print(controller.duration.value);
              }
            }),
      ),
    );
  }
}
