import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleep_timer/src/globals.dart';

class HourglassController extends GetxController with WidgetsBindingObserver {
  startTimer() async {
    logger.d('Starting Hourglass Timer');
    if (orientation.value == Orientation.portrait) {
      // Future.delayed(const Duration(seconds: 1)).then((value) {
      for (var element in ledVerticalBaseCourse) {
        await _animateBaseContainer(element.value.ledId.value);
        // await _animateTopContainer(element.value.ledId.value);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  late Rx<Orientation> orientation = Get.mediaQuery.orientation.obs;
  @override
  void didChangeMetrics() {
    orientation.value = Get.mediaQuery.orientation;
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      orientation.value = Get.mediaQuery.orientation;
    });
  }

  Future<void> _animateBaseContainer(int ledId) async {
    for (var e in ledVerticalBaseCourse
        .firstWhere((element) => element.value.ledId.value == ledId)
        .value
        .course) {
      ledVerticalBaseCourse
          .firstWhere((element) => element.value.ledId.value == e)
          .value
          .isOn
          .value = true;
      if (e == ledId) {
      } else {
        await Future.delayed(
          const Duration(milliseconds: 300),
        ).then((value) {
          ledVerticalBaseCourse
              .firstWhere((element) => element.value.ledId.value == e)
              .value
              .isOn
              .value = false;
        });
      }
    }

    // });
  }

  RxList<Rx<LedItem>> ledVerticalBaseCourse = [
    Rx(LedItem(1.obs, false.obs, [64, 55, 46, 37, 28, 19, 10, 1])),
    Rx(
      LedItem(2.obs, false.obs, [64, 55, 46, 37, 28, 19, 10, 2]),
    ),
    Rx(
      LedItem(9.obs, false.obs, [64, 55, 46, 37, 28, 19, 10, 9]),
    ),
    Rx(
      LedItem(10.obs, false.obs, [64, 55, 46, 37, 28, 19, 10]),
    ),
    Rx(
      LedItem(3.obs, false.obs, [64, 55, 46, 37, 28, 19, 11, 3]),
    ),
    Rx(
      LedItem(11.obs, false.obs, [64, 55, 46, 37, 28, 19, 11]),
    ),
    Rx(
      LedItem(17.obs, false.obs, [64, 55, 46, 37, 28, 19, 18, 17]),
    ),
    Rx(
      LedItem(18.obs, false.obs, [64, 55, 46, 37, 28, 19, 18]),
    ),
    Rx(
      LedItem(19.obs, false.obs, [64, 55, 46, 37, 28, 19]),
    ),
    Rx(
      LedItem(4.obs, false.obs, [64, 55, 46, 37, 28, 20, 12, 4]),
    ),
    Rx(
      LedItem(12.obs, false.obs, [64, 55, 46, 37, 28, 20, 12]),
    ),
    Rx(
      LedItem(20.obs, false.obs, [64, 55, 46, 37, 28, 20]),
    ),
    Rx(
      LedItem(25.obs, false.obs, [64, 55, 46, 37, 28, 27, 26, 25]),
    ),
    Rx(
      LedItem(26.obs, false.obs, [64, 55, 46, 37, 28, 27, 26]),
    ),
    Rx(
      LedItem(27.obs, false.obs, [64, 55, 46, 37, 28, 27]),
    ),
    Rx(
      LedItem(28.obs, false.obs, [64, 55, 46, 37, 28]),
    ),
    Rx(
      LedItem(5.obs, false.obs, [64, 55, 46, 37, 29, 21, 13, 5]),
    ),
    Rx(
      LedItem(13.obs, false.obs, [64, 55, 46, 37, 29, 21, 13]),
    ),
    Rx(
      LedItem(21.obs, false.obs, [64, 55, 46, 37, 29, 21]),
    ),
    Rx(
      LedItem(29.obs, false.obs, [64, 55, 46, 37, 29]),
    ),
    Rx(
      LedItem(33.obs, false.obs, [64, 55, 46, 37, 36, 35, 34, 33]),
    ),
    Rx(
      LedItem(34.obs, false.obs, [64, 55, 46, 37, 36, 35, 34]),
    ),
    Rx(
      LedItem(35.obs, false.obs, [64, 55, 46, 37, 36, 35]),
    ),
    Rx(
      LedItem(36.obs, false.obs, [64, 55, 46, 37, 36]),
    ),
    Rx(
      LedItem(37.obs, false.obs, [64, 55, 46, 37]),
    ),
    Rx(
      LedItem(6.obs, false.obs, [64, 55, 46, 38, 30, 22, 14, 6]),
    ),
    Rx(
      LedItem(14.obs, false.obs, [64, 55, 46, 38, 30, 22, 14]),
    ),
    Rx(
      LedItem(22.obs, false.obs, [64, 55, 46, 38, 30, 22]),
    ),
    Rx(
      LedItem(30.obs, false.obs, [64, 55, 46, 38, 30]),
    ),
    Rx(
      LedItem(38.obs, false.obs, [64, 55, 46, 38]),
    ),
    Rx(
      LedItem(41.obs, false.obs, [64, 55, 46, 45, 44, 43, 42, 41]),
    ),
    Rx(
      LedItem(42.obs, false.obs, [64, 55, 46, 45, 44, 43, 42]),
    ),
    Rx(
      LedItem(43.obs, false.obs, [64, 55, 46, 45, 44, 43]),
    ),
    Rx(
      LedItem(44.obs, false.obs, [64, 55, 46, 45, 44]),
    ),
    Rx(
      LedItem(45.obs, false.obs, [64, 55, 46, 45]),
    ),
    Rx(
      LedItem(46.obs, false.obs, [64, 55, 46]),
    ),
    Rx(
      LedItem(7.obs, false.obs, [64, 55, 47, 39, 31, 23, 15, 7]),
    ),
    Rx(
      LedItem(15.obs, false.obs, [64, 55, 47, 39, 31, 23, 15]),
    ),
    Rx(
      LedItem(23.obs, false.obs, [64, 55, 47, 39, 31, 23]),
    ),
    Rx(
      LedItem(31.obs, false.obs, [64, 55, 47, 39, 31]),
    ),
    Rx(
      LedItem(39.obs, false.obs, [64, 55, 47, 39]),
    ),
    Rx(
      LedItem(47.obs, false.obs, [64, 55, 47]),
    ),
    Rx(
      LedItem(49.obs, false.obs, [64, 55, 54, 53, 52, 51, 50, 49]),
    ),
    Rx(
      LedItem(50.obs, false.obs, [64, 55, 54, 53, 52, 51, 50]),
    ),
    Rx(
      LedItem(51.obs, false.obs, [64, 55, 54, 53, 52, 51]),
    ),
    Rx(
      LedItem(52.obs, false.obs, [64, 55, 54, 53, 52]),
    ),
    Rx(
      LedItem(53.obs, false.obs, [64, 55, 54, 53]),
    ),
    Rx(
      LedItem(54.obs, false.obs, [64, 55, 54]),
    ),
    Rx(
      LedItem(55.obs, false.obs, [64, 55]),
    ),
    Rx(
      LedItem(8.obs, false.obs, [64, 56, 48, 40, 32, 24, 16, 8]),
    ),
    Rx(
      LedItem(16.obs, false.obs, [64, 56, 48, 40, 32, 24, 16]),
    ),
    Rx(
      LedItem(24.obs, false.obs, [64, 56, 48, 40, 32, 24]),
    ),
    Rx(
      LedItem(32.obs, false.obs, [64, 56, 48, 40, 32]),
    ),
    Rx(
      LedItem(40.obs, false.obs, [64, 56, 48, 40]),
    ),
    Rx(
      LedItem(48.obs, false.obs, [64, 56, 48]),
    ),
    Rx(
      LedItem(56.obs, false.obs, [64, 56]),
    ),
    Rx(
      LedItem(57.obs, false.obs, [64, 63, 62, 61, 60, 59, 58, 57]),
    ),
    Rx(
      LedItem(58.obs, false.obs, [64, 63, 62, 61, 60, 59, 58]),
    ),
    Rx(
      LedItem(59.obs, false.obs, [64, 63, 62, 61, 60, 59]),
    ),
    Rx(
      LedItem(60.obs, false.obs, [64, 63, 62, 61, 60]),
    ),
    Rx(
      LedItem(61.obs, false.obs, [64, 63, 62, 61]),
    ),
    Rx(
      LedItem(62.obs, false.obs, [64, 63, 62]),
    ),
    Rx(
      LedItem(63.obs, false.obs, [64, 63]),
    ),
    Rx(
      LedItem(64.obs, false.obs, [64]),
    ),
  ].obs;
  late RxList<Rx<LedItem>> ledVerticalTopCourse = [
    Rx(LedItem(1.obs, true.obs, [64, 55, 46, 37, 28, 19, 10, 1])),
    Rx(
      LedItem(2.obs, true.obs, [64, 55, 46, 37, 28, 19, 10, 2]),
    ),
    Rx(
      LedItem(9.obs, true.obs, [64, 55, 46, 37, 28, 19, 10, 9]),
    ),
    Rx(
      LedItem(10.obs, true.obs, [64, 55, 46, 37, 28, 19, 10]),
    ),
    Rx(
      LedItem(3.obs, true.obs, [64, 55, 46, 37, 28, 19, 11, 3]),
    ),
    Rx(
      LedItem(11.obs, true.obs, [64, 55, 46, 37, 28, 19, 11]),
    ),
    Rx(
      LedItem(17.obs, true.obs, [64, 55, 46, 37, 28, 19, 18, 17]),
    ),
    Rx(
      LedItem(18.obs, true.obs, [64, 55, 46, 37, 28, 19, 18]),
    ),
    Rx(
      LedItem(19.obs, true.obs, [64, 55, 46, 37, 28, 19]),
    ),
    Rx(
      LedItem(4.obs, true.obs, [64, 55, 46, 37, 28, 20, 12, 4]),
    ),
    Rx(
      LedItem(12.obs, true.obs, [64, 55, 46, 37, 28, 20, 12]),
    ),
    Rx(
      LedItem(20.obs, true.obs, [64, 55, 46, 37, 28, 20]),
    ),
    Rx(
      LedItem(25.obs, true.obs, [64, 55, 46, 37, 28, 27, 26, 25]),
    ),
    Rx(
      LedItem(26.obs, true.obs, [64, 55, 46, 37, 28, 27, 26]),
    ),
    Rx(
      LedItem(27.obs, true.obs, [64, 55, 46, 37, 28, 27]),
    ),
    Rx(
      LedItem(28.obs, true.obs, [64, 55, 46, 37, 28]),
    ),
    Rx(
      LedItem(5.obs, true.obs, [64, 55, 46, 37, 29, 21, 13, 5]),
    ),
    Rx(
      LedItem(13.obs, true.obs, [64, 55, 46, 37, 29, 21, 13]),
    ),
    Rx(
      LedItem(21.obs, true.obs, [64, 55, 46, 37, 29, 21]),
    ),
    Rx(
      LedItem(29.obs, true.obs, [64, 55, 46, 37, 29]),
    ),
    Rx(
      LedItem(33.obs, true.obs, [64, 55, 46, 37, 36, 35, 34, 33]),
    ),
    Rx(
      LedItem(34.obs, true.obs, [64, 55, 46, 37, 36, 35, 34]),
    ),
    Rx(
      LedItem(35.obs, true.obs, [64, 55, 46, 37, 36, 35]),
    ),
    Rx(
      LedItem(36.obs, true.obs, [64, 55, 46, 37, 36]),
    ),
    Rx(
      LedItem(37.obs, true.obs, [64, 55, 46, 37]),
    ),
    Rx(
      LedItem(6.obs, true.obs, [64, 55, 46, 38, 30, 22, 14, 6]),
    ),
    Rx(
      LedItem(14.obs, true.obs, [64, 55, 46, 38, 30, 22, 14]),
    ),
    Rx(
      LedItem(22.obs, true.obs, [64, 55, 46, 38, 30, 22]),
    ),
    Rx(
      LedItem(30.obs, true.obs, [64, 55, 46, 38, 30]),
    ),
    Rx(
      LedItem(38.obs, true.obs, [64, 55, 46, 38]),
    ),
    Rx(
      LedItem(41.obs, true.obs, [64, 55, 46, 45, 44, 43, 42, 41]),
    ),
    Rx(
      LedItem(42.obs, true.obs, [64, 55, 46, 45, 44, 43, 42]),
    ),
    Rx(
      LedItem(43.obs, true.obs, [64, 55, 46, 45, 44, 43]),
    ),
    Rx(
      LedItem(44.obs, true.obs, [64, 55, 46, 45, 44]),
    ),
    Rx(
      LedItem(45.obs, true.obs, [64, 55, 46, 45]),
    ),
    Rx(
      LedItem(46.obs, true.obs, [64, 55, 46]),
    ),
    Rx(
      LedItem(7.obs, true.obs, [64, 55, 47, 39, 31, 23, 15, 7]),
    ),
    Rx(
      LedItem(15.obs, true.obs, [64, 55, 47, 39, 31, 23, 15]),
    ),
    Rx(
      LedItem(23.obs, true.obs, [64, 55, 47, 39, 31, 23]),
    ),
    Rx(
      LedItem(31.obs, true.obs, [64, 55, 47, 39, 31]),
    ),
    Rx(
      LedItem(39.obs, true.obs, [64, 55, 47, 39]),
    ),
    Rx(
      LedItem(47.obs, true.obs, [64, 55, 47]),
    ),
    Rx(
      LedItem(49.obs, true.obs, [64, 55, 54, 53, 52, 51, 50, 49]),
    ),
    Rx(
      LedItem(50.obs, true.obs, [64, 55, 54, 53, 52, 51, 50]),
    ),
    Rx(
      LedItem(51.obs, true.obs, [64, 55, 54, 53, 52, 51]),
    ),
    Rx(
      LedItem(52.obs, true.obs, [64, 55, 54, 53, 52]),
    ),
    Rx(
      LedItem(53.obs, true.obs, [64, 55, 54, 53]),
    ),
    Rx(
      LedItem(54.obs, true.obs, [64, 55, 54]),
    ),
    Rx(
      LedItem(55.obs, true.obs, [64, 55]),
    ),
    Rx(
      LedItem(8.obs, true.obs, [64, 56, 48, 40, 32, 24, 16, 8]),
    ),
    Rx(
      LedItem(16.obs, true.obs, [64, 56, 48, 40, 32, 24, 16]),
    ),
    Rx(
      LedItem(24.obs, true.obs, [64, 56, 48, 40, 32, 24]),
    ),
    Rx(
      LedItem(32.obs, true.obs, [64, 56, 48, 40, 32]),
    ),
    Rx(
      LedItem(40.obs, true.obs, [64, 56, 48, 40]),
    ),
    Rx(
      LedItem(48.obs, true.obs, [64, 56, 48]),
    ),
    Rx(
      LedItem(56.obs, true.obs, [64, 56]),
    ),
    Rx(
      LedItem(57.obs, true.obs, [64, 63, 62, 61, 60, 59, 58, 57]),
    ),
    Rx(
      LedItem(58.obs, true.obs, [64, 63, 62, 61, 60, 59, 58]),
    ),
    Rx(
      LedItem(59.obs, true.obs, [64, 63, 62, 61, 60, 59]),
    ),
    Rx(
      LedItem(60.obs, true.obs, [64, 63, 62, 61, 60]),
    ),
    Rx(
      LedItem(61.obs, true.obs, [64, 63, 62, 61]),
    ),
    Rx(
      LedItem(62.obs, true.obs, [64, 63, 62]),
    ),
    Rx(
      LedItem(63.obs, true.obs, [64, 63]),
    ),
    Rx(
      LedItem(64.obs, true.obs, [64]),
    ),
  ].obs;
}

class LedItem {
  RxInt ledId;
  RxBool isOn;
  List<int> course = [];
  LedItem(
    this.ledId,
    this.isOn, [
    this.course = const [],
  ]);
}
