import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sleep_timer/src/home/home_controller.dart';

class TimerButton extends StatelessWidget {
  final Color color;
  final Duration duration;
  final TimerButtonAction buttonAction;
  TimerButton(
      {Key? key,
      required this.color,
      required this.duration,
      required this.buttonAction})
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
              (duration.inMinutes.isNegative ? "" : "+") +
                  duration.inMinutes.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () {
              logger.d(duration.inMinutes);
              // prevent shrinking timer if the amount of shrinking will cause the timer to be zero or less
              var dur = controller.countdownDuration.value.inMicroseconds -
                  duration.inMicroseconds;
              if (dur.isNegative &&
                  (buttonAction == TimerButtonAction.shrink)) {
                showSnackBar("TimerCannotBeSetted".tr);
              }
              // if ((controller.timerDuration.value.inSeconds <= 60) &&
              //     (buttonAction == TimerButtonAction.shrink) &&
              //     (duration == const Duration(minutes: -1))) {
              //   showSnackBar("TimerCannotBeSetted".tr);
              //   return;
              // } else if ((controller.timerDuration.value.inSeconds <= 300) &&
              //     (buttonAction == TimerButtonAction.shrink) &&
              //     (duration == const Duration(minutes: -5))) {
              //   showSnackBar("TimerCannotBeSetted".tr);
              //   return;
              // }
              else {
                if (controller.timerDuration.value.inMinutes >= (90) &&
                    buttonAction == TimerButtonAction.extend) {
                  // controller.gaugeEndValue.value =
                  //     controller.timerDuration.value.inSeconds + 60;
                  controller.setGaugeEndValue(
                      controller.countdownDuration.value + duration);
                  controller.storeEndValueInLocalStorage();
                } //else{}

                controller.extendTimer(duration);

                // controller.countdownDuration.value =
                //     controller.timerDuration.value + duration;
                // controller.timerDuration.value = controller.timerDuration.value;
                logger.d(controller.timerDuration.value);
              }
            }),
      ),
    );
  }
}

enum TimerButtonAction { extend, shrink }
