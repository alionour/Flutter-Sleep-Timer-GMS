import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_t/Controllers/HomeController.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'Settings.dart';
import 'package:flutter_t/Globals.dart';
import 'package:move_to_background/move_to_background.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                                    value: double.parse(
                                        (controller.millisec.value / 1000 / 60)
                                            .toString()),
                                    needleColor: isDarkTheme
                                        ? Colors.greenAccent
                                        : Colors.pinkAccent,
                                    enableDragging:
                                        controller.enableDragging.value,
                                    tailStyle: TailStyle(color: Colors.red),
                                    onValueChanging:
                                        (ValueChangingArgs valueChangingArgs) {
                                      controller.duration.value = Duration(
                                          minutes:
                                              valueChangingArgs.value.toInt(),
                                          seconds: int.parse(valueChangingArgs
                                              .value
                                              .toString()
                                              .split(".")[1][1]));
                                      controller.millisec.value = controller
                                          .duration.value.inMilliseconds;
                                    },
                                  ),
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: Container(
                                          child: Text(
                                              "${(controller.millisec.value ~/ 1000 ~/ 60).toStringAsFixed(2)}",
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
                        child: RaisedButton(
                            child: Text(
                              controller.timerButtonText.value,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: isDarkTheme
                                ? Colors.greenAccent
                                : Colors.pinkAccent,
                            onPressed: () {
                              print("clicked");

                              // startBackgroundTask();
                              print("finished");
                              controller.startSleepTimer();
                            }),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            var label;
                            Color color;
                            int minutes;
                            switch (index) {
                              case 0:
                                label = "+1";
                                color = isDarkTheme
                                    ? Colors.greenAccent
                                    : Colors.pinkAccent;
                                minutes = 1;
                                break;
                              case 1:
                                label = "+5";
                                color = isDarkTheme
                                    ? Colors.greenAccent
                                    : Colors.pinkAccent;
                                minutes = 5;

                                break;
                              case 2:
                                label = "-1";
                                color = Colors.pink[400];
                                minutes = -1;

                                break;
                              case 3:
                                label = "-5";
                                color = Colors.pink[400];
                                minutes = -5;

                                break;

                              default:
                                label = "";
                            }
                            return Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: RaisedButton(
                                    color: color,
                                    child: Text(
                                      label ?? "",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      print(controller.duration.value);
                                      if (controller.duration.value.inMinutes <=
                                          1) {
                                      } else {
                                        if (controller
                                                .duration.value.inMinutes >=
                                            90) {
                                          controller.endValue.value = controller
                                                  .duration.value.inMinutes +
                                              1.0;
                                          controller.appData.write("end_value",
                                              controller.endValue.value);
                                        } else {}
                                        controller.duration.value = Duration(
                                            minutes: controller
                                                    .duration.value.inMinutes +
                                                minutes);
                                        controller.millisec.value = controller
                                            .duration.value.inMilliseconds;

                                        print(controller.duration.value);
                                      }
                                    }),
                              ),
                            );
                          }),
                        ),
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
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
