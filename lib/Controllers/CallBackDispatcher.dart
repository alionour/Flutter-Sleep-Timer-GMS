import 'package:audio_session/audio_session.dart';
import 'dart:async';
import 'package:system_shortcuts/system_shortcuts.dart';
import 'package:flutter_t/Globals.dart';
import 'package:workmanager/workmanager.dart';

void callBackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case "request_audio_focus":
        final session = await AudioSession.instance;
        await session.configure(AudioSessionConfiguration.music());
        Timer(Duration(seconds: inputData["seconds"]), () async {
          if (await session.setActive(true,
              avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions(1),
              androidAudioFocusGainType: AndroidAudioFocusGainType.gain)) {
            await session.setActive(false);
            goToHome
                ? await SystemShortcuts.home()
                : print("Not going to home");
            // interstitialAdEndTimer.show();
          }
        });
        break;
      default:
    }
    return Future.value(true);
  });
}
