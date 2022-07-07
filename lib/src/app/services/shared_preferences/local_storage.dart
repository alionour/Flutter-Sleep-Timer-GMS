import 'package:hive_flutter/hive_flutter.dart';

extension WriteIfNull<E> on Box<E> {
  Future<void> writeIfNull(String key, dynamic value) async {
    final bool isEmpty = get(key) == null;
    if (isEmpty) {
      put(key, value);
    }
  }

  E? read(String key) {
    return get(key);
  }
}

/// initialize GetStorage package
Future<void> initializeLocalStorage() async {
  await Hive.initFlutter();
  await Hive.openBox('timer');
  final settingsBox = await Hive.openBox('settings');
  await settingsBox.writeIfNull('darkmode', true);
  await settingsBox.writeIfNull('gotohome', true);
  await settingsBox.writeIfNull('turnscreenoff', false);
  await settingsBox.writeIfNull('notification', true);
  await settingsBox.writeIfNull('language', 'en');
  await settingsBox.writeIfNull('silentmode', false);
}
