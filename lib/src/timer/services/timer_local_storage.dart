import 'package:hive_flutter/hive_flutter.dart';
import 'package:sleep_timer/src/globals.dart';

class TimerService {
  final _timerBox = Hive.box('timer');
  final Duration _initialDuration = const Duration(minutes: 3);

  /// updates duration in local storage
  Future<void> updateDuration(Duration duration) async {
    await _timerBox.put('duration', duration.toString());
  }

  /// gets duration from local storage
  Future<Duration> get duration async {
    final duration = await _timerBox.get('duration') as String?;
    return parseDuration(
      duration ?? _initialDuration.toString(),
    );
  }
}
