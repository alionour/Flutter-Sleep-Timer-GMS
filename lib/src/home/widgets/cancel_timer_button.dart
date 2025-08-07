import 'package:flutter/material.dart';
import 'package:sleep_timer/src/timer/bloc/timer_bloc.dart';

Widget cancelTimer(TimerBloc timerBloc) => Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: GestureDetector(
        onTap: () => timerBloc.add(const CancelTimer()),
        child: const CircleAvatar(
          radius: 30,
          child: Icon(
            Icons.stop_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
