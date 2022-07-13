import 'package:home_widget/home_widget.dart';
import 'package:sleep_timer/src/app/services/background_tasks/background_tasks.dart';
import 'package:sleep_timer/src/app/services/work_manager/callback_dispatcher.dart';
import 'package:workmanager/workmanager.dart';

Future<void> initializeWorkManager() async {
  await Workmanager().initialize(
    callBackDispatcher,
  );
  await initializeHomeWidget();
}

Future<void> initializeHomeWidget() async {
  await HomeWidget.setAppGroupId('home_timer');
  await HomeWidget.registerBackgroundCallback(homeWidgetBackgroundCallback)
      .then((value) {
    print('Background Callback isRegistered $value');
  });
}
