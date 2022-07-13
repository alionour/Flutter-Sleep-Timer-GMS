import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/src/timer/bloc/timer_bloc.dart';

class TimerButton extends StatelessWidget {
  final Color? color;
  final Duration duration;
  const TimerButton({
    Key? key,
    required this.color,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timerBloc = context.read<TimerBloc>();
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
              (duration.inMinutes.isNegative ? '' : '+') +
                  duration.inMinutes.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () {
              timerBloc.add(ExtendTimer(duration));
            }),
      ),
    );
  }
}
