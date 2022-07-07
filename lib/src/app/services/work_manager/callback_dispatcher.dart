import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:sleep_timer/src/app/services/navigation/navigation.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sleep_timer/src/timer/bloc/timer_bloc.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:system_shortcuts/system_shortcuts.dart';
import 'package:workmanager/workmanager.dart';

void callBackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case 'request_audio_focus':
        final session = await AudioSession.instance;
        await session.configure(const AudioSessionConfiguration.music());
        Timer(Duration(seconds: inputData?['seconds']), () async {
          if (await session.setActive(true,
              avAudioSessionSetActiveOptions:
                  const AVAudioSessionSetActiveOptions(1),
              androidAudioFocusGainType: AndroidAudioFocusGainType.gain)) {
            await session.setActive(false);
            NavigatorService.settingsBloc.state.goToHome
                ? await SystemShortcuts.home()
                : logger.d('Not going to home');
            NavigatorService.settingsBloc.state.notification
                ? TurnScreenOff()
                : logger.d('Failed to turn screen off');
            // interstitialAdEndTimer.show();
            if (NavigatorService.settingsBloc.state.silentMode) {
              try {
                await SoundMode.setSoundMode(RingerModeStatus.silent);
              } on PlatformException {
                logger.d('Please enable permissions required');
              }
            }
          }
        });
        break;
      default:
    }
    return Future.value(true);
  });
}
