import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'dart:async';
import 'package:system_shortcuts/system_shortcuts.dart';
import 'package:workmanager/workmanager.dart';

void callBackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case "request_audio_focus":
        final session = await AudioSession.instance;
        await session.configure(const AudioSessionConfiguration.music());
        Timer(Duration(seconds: inputData?["seconds"]), () async {
          if (await session.setActive(true,
              avAudioSessionSetActiveOptions:
                  const AVAudioSessionSetActiveOptions(1),
              androidAudioFocusGainType: AndroidAudioFocusGainType.gain)) {
            await session.setActive(false);
            goToHome.value
                ? await SystemShortcuts.home()
                : logger.d("Not going to home");
            // interstitialAdEndTimer.show();
            if (silentMode.value) {
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
