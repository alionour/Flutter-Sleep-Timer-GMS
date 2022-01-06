import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sleep_timer/src/hourglass/hourglass_timer_controller.dart';

class HourglassView extends StatefulWidget {
  const HourglassView({Key? key}) : super(key: key);

  @override
  _HourglassViewState createState() => _HourglassViewState();
}

class _HourglassViewState extends State<HourglassView> {
  late double bigContainerWidth = Get.width - 150;
  late double bigSquareArea = bigContainerWidth * 2;
  late double smallSquarewidth = bigContainerWidth / 8;

  late double smallSquareArea = smallSquarewidth * 2;
  late int squaresCount = (bigSquareArea ~/ smallSquareArea);
  int rowCount = 8;
  int top = 73;
  int firstTemp = 73;
  // final HourglassController _hourglassController = HourglassController();
  final HourglassController _hourglassController =
      Get.put(HourglassController());
  late List<int> firstItemCourse = List.generate(8, (index) {
    return firstTemp = firstTemp - 9;
  });

  @override
  Widget build(BuildContext context) {
    logger.d(firstItemCourse);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Transform.rotate(
            angle: 3.14,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Transform.rotate(
                    angle: 3.14 * .25,
                    child: Container(
                      width: bigContainerWidth,
                      height: bigContainerWidth,
                      decoration: BoxDecoration(
                        // color: Colors.amber,
                        // border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          itemCount: 64,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: rowCount,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2),
                          itemBuilder: (context, index) {
                            return Obx(() => Led(
                                  ledId: index + 1,
                                  isOn: _hourglassController
                                      .ledVerticalBaseCourse
                                      .firstWhere((element) =>
                                          element.value.ledId.value ==
                                          (index + 1))
                                      .value
                                      .isOn
                                      .value,
                                  height: smallSquarewidth,
                                  width: smallSquarewidth,
                                ));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Flexible(
                  child: Transform.rotate(
                    angle: 3.14 * 0.25,
                    child: Container(
                      width: bigContainerWidth,
                      height: bigContainerWidth,
                      decoration: BoxDecoration(
                          // color: Colors.amber,
                          // border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                            itemCount: 64,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 8,
                                    mainAxisSpacing: 2,
                                    crossAxisSpacing: 2),
                            itemBuilder: (context, index) {
                              return Obx(() => Led(
                                    ledId: index + 1,
                                    isOn: _hourglassController
                                        .ledVerticalTopCourse
                                        .firstWhere((element) =>
                                            element.value.ledId.value ==
                                            (index + 1))
                                        .value
                                        .isOn
                                        .value,
                                    height: smallSquarewidth,
                                    width: smallSquarewidth,
                                  ));
                            }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Led extends StatefulWidget {
  final int ledId;
  final bool isOn;
  final double width;
  final double height;
  const Led(
      {Key? key,
      required this.ledId,
      required this.isOn,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  _LedState createState() => _LedState();
}

class _LedState extends State<Led> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      child: Text(widget.ledId.toString()),
      decoration: BoxDecoration(
          color: widget.isOn ? Colors.pinkAccent : Colors.grey,
          borderRadius: BorderRadius.circular(5)),
    );
  }
}
