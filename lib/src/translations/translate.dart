import 'package:get/get.dart';
import 'package:sleep_timer/src/translations/ar.dart';
import 'package:sleep_timer/src/translations/ch.dart';
import 'package:sleep_timer/src/translations/en.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en': en, 'ar': ar, 'ch': ch};
}
