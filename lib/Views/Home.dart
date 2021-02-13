import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_t/Controllers/HomeController.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:admob_flutter/admob_flutter.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return Obx(() => Scaffold(
          backgroundColor: Color(0x1B1E45).withOpacity(1),
          body: Center(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SfRadialGauge(
                      axes: [
                        RadialAxis(
                            axisLabelStyle: GaugeTextStyle(color: Colors.white),
                            maximumLabels: 2,
                            maximum: controller.endValue.value,
                            ranges: [
                              GaugeRange(
                                  startValue: 0,
                                  endValue: controller.endValue.value,
                                  labelStyle:
                                      GaugeTextStyle(color: Colors.white),
                                  // color: Colors.green,
                                  gradient: SweepGradient(
                                      colors: [Colors.greenAccent]),
                                  startWidth: 20,
                                  endWidth: 20),
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                value: double.parse(
                                    (controller.millisec.value / 1000 / 60)
                                        .toString()),
                                needleColor: Colors.white,
                                enableDragging: controller.enableDragging.value,
                                tailStyle: TailStyle(color: Colors.red),
                                onValueChanging:
                                    (ValueChangingArgs valueChangingArgs) {
                                  controller.duration.value = Duration(
                                      minutes: valueChangingArgs.value.toInt());
                                  controller.millisec.value =
                                      controller.duration.value.inMilliseconds;
                                },
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Container(
                                      child: Text(
                                          "${(controller.millisec.value ~/ 1000 ~/ 60).toString()} Minutes",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))),
                                  angle: 90,
                                  positionFactor: 0.8)
                            ])
                      ],
                    ),
                    RaisedButton(
                        child: Text(controller.timerButtonText.value),
                        onPressed: controller.startSleepTimer)
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: AdmobBanner(
                    adSize: AdmobBannerSize.FULL_BANNER,
                    adUnitId: controller.getBannerAdUnitId(),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
