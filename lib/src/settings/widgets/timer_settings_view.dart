import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleep_timer/src/app/services/background_tasks/services/timer_service.dart';
import 'package:sleep_timer/src/settings/bloc/settings_bloc.dart';
import 'package:sleep_timer/src/settings/widgets/duration_picker.dart';

class TimerSettingsView extends StatelessWidget {
  const TimerSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingBloc = context.read<SettingsBloc>();

    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              'TimerSettings'.tr,
              style: const TextStyle(color: Colors.white),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
            tileColor: Colors.blueGrey,
          ),
          const Divider(height: 1),
          Tooltip(
            message: 'go to home screen after finishing timer.',
            triggerMode: TooltipTriggerMode.tap,
            child: ListTile(
              leading: const Icon(Icons.home_filled),
              title: Text('GoToHomeScreen'.tr),
              trailing: Switch(
                  value: settingBloc.state.goToHome,
                  onChanged: (value) =>
                      settingBloc.add(ChangeGoToHomeScreen(value))),
            ),
          ),
          Tooltip(
            message: 'turns screen off after finishing timer.',
            triggerMode: TooltipTriggerMode.tap,
            child: ListTile(
              leading: const Icon(Icons.screen_lock_portrait_rounded),
              title: Text('TurnOffScreen'.tr),
              trailing: Switch(
                  value: settingBloc.state.turnOffScreen,
                  onChanged: (value) =>
                      settingBloc.add(ChangeTurnOffScreen(value))),
            ),
          ),
          Tooltip(
            message: 'sets phone to silent mode after finishing timer.',
            triggerMode: TooltipTriggerMode.tap,
            child: ListTile(
              leading: const Icon(Icons.do_not_disturb_alt_rounded),
              title: Text('SilentMode'.tr),
              trailing: Switch(
                  value: settingBloc.state.silentMode,
                  onChanged: (value) =>
                      settingBloc.add(ChangeSilentMode(value))),
            ),
          ),
          Tooltip(
            message: 'turn off wifi after finishing timer.',
            triggerMode: TooltipTriggerMode.tap,
            child: ListTile(
              leading: const Icon(Icons.signal_wifi_off_rounded),
              title: Text('TurnOffWifi'.tr),
              trailing: Switch(
                  value: settingBloc.state.turnOffWifi,
                  onChanged: (value) => settingBloc.add(ChangeWifi(value))),
            ),
          ),
          Tooltip(
            message: 'turn off Bluetooth after finishing timer.',
            triggerMode: TooltipTriggerMode.tap,
            child: ListTile(
              leading: const Icon(Icons.do_not_disturb_alt_rounded),
              title: Text('TurnOffBluetooth'.tr),
              trailing: Switch(
                  value: settingBloc.state.turnOffBluetooth,
                  onChanged: (value) =>
                      settingBloc.add(ChangeBluetooth(value))),
            ),
          ),
          Tooltip(
            message: "sets home widget timer's duration .",
            triggerMode: TooltipTriggerMode.tap,
            child: ListTile(
              onTap: () {
                showHomeWidgetDurationPicker(context);
              },
              leading: const Icon(Icons.widgets_rounded),
              title: Text('HomeWidgetTimerDuration'.tr),
            ),
          ),
        ],
      ),
    );
  }

  void showHomeWidgetDurationPicker(BuildContext context) async {
    showDurationPicker(
            context: context, initialTime: const Duration(minutes: 1))
        .then((value) async {
      final service = HomeWidgetTimerService();
      await service.updateDuration(value!);
    });
  }
}
