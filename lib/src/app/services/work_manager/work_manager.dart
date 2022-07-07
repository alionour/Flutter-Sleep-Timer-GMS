import 'package:sleep_timer/src/app/services/work_manager/callback_dispatcher.dart';
import 'package:workmanager/workmanager.dart';

Future<void> initializeWorkManager() async {
  await Workmanager().initialize(
    callBackDispatcher,
  );
}
