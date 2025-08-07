import 'package:flutter/material.dart';
import 'package:sleep_timer/src/timer/bloc/timer_bloc.dart';

Widget resumeTimer(TimerBloc timerBloc) => Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: GestureDetector(
        onTap: () => timerBloc.add(const ResumeTimer()),
        child: CircleAvatar(
          radius: 30,
          child: Icon(
            timerBloc.state.sleepTimer.isPaused
                ? Icons.play_arrow_rounded
                : Icons.pause_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
