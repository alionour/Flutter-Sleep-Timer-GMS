import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sleep_timer/src/app/services/ads/ads_controller.dart';
import 'package:sleep_timer/src/settings/bloc/settings_bloc.dart';
import 'package:sleep_timer/src/settings/widgets/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const routeName = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // final HomeController _homeController = Get.find();
  final AdsController _adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    final settingBloc = context.read<SettingsBloc>();
    return BlocProvider.value(
      value: settingBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Settings'.tr,
            style:
                TextStyle(color: Theme.of(context).appBarTheme.backgroundColor),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: const SizedBox(),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.arrow_back_ios_new_rounded))
          ],
        ),
        body: Stack(
          children: [
            Card(
                elevation: 10,
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(
                        'GeneralSettings'.tr,
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
                    BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, state) {
                        return ListTile(
                          leading: const Icon(
                            Icons.language_outlined,
                          ),
                          title: Text('ChangeLanguage'.tr),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            //open change language

                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ListView.separated(
                                    itemCount: 3,
                                    separatorBuilder: (context, index) =>
                                        const Divider(),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        child: ListTile(
                                          leading: const Icon(
                                            Icons.language_outlined,
                                            // color:
                                            //     settingBloc.state.appTheme.value
                                            //         ? Colors.pinkAccent
                                            //         : Colors.greenAccent,
                                          ),
                                          title: Text(settingBloc.languages
                                              .elementAt(index)
                                              .tr),
                                        ),
                                        onTap: () async {
                                          settingBloc.add(ChangeLanguage(
                                              settingBloc.languages
                                                  .elementAt(index)));
                                        },
                                      );
                                    },
                                  );
                                });
                          },
                        );
                      },
                    ),
                    // BlocBuilder<SettingsBloc, SettingsState>(
                    //   builder: (context, state) {
                    //     return ListTile(
                    //       leading: const Icon(Icons.lightbulb),
                    //       title: Text('DarkMode'.tr),
                    //       trailing: Switch(
                    //           value: isDarkTheme.value,
                    //           activeColor: isDarkTheme.value
                    //               ? Colors.pinkAccent
                    //               : Colors.pinkAccent,
                    //           onChanged: settingBloc.add(event)),
                    //     );
                    //   }
                    // ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const ThemeListTile()),
                    BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, state) {
                        return ListTile(
                          leading:
                              const Icon(Icons.notification_important_rounded),
                          title: Text('Notifications'.tr),
                          trailing: Switch(
                            value: state.notification,
                            onChanged: (value) => settingBloc.add(
                              ChangeNotificationsOn(value),
                            ),
                          ),
                        );
                      },
                    ),
                    BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, state) {
                        return ListTile(
                          leading: const Icon(Icons.rounded_corner_rounded),
                          title: Text('RunInBackground'.tr),
                          trailing: Switch(
                            value: state.runInBackground,
                            onChanged: (value) =>
                                settingBloc.add(ChangeRunInBackground(value)),
                          ),
                        );
                      },
                    ),
                    BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, state) {
                        return ListTile(
                            leading: const Icon(
                                Icons.drive_file_rename_outline_rounded),
                            title: Text('ResetToDefault'.tr),
                            onTap: () => settingBloc.add(ResetToDefault()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(
                        'TimerSettings'.tr,
                        style: const TextStyle(color: Colors.white),
                      ),
                      shape: const RoundedRectangleBorder(),
                      tileColor: Colors.blueGrey,
                    ),
                    BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, state) {
                        return Tooltip(
                          message: 'go to home screen after finishing timer.',
                          triggerMode: TooltipTriggerMode.tap,
                          child: ListTile(
                            leading: const Icon(Icons.home_filled),
                            title: Text('GoToHomeScreen'.tr),
                            trailing: Switch(
                                value: state.goToHome,
                                onChanged: (value) => settingBloc
                                    .add(ChangeGoToHomeScreen(value))),
                          ),
                        );
                      },
                    ),
                    BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                      return Tooltip(
                        message: 'turns screen off after finishing timer.',
                        triggerMode: TooltipTriggerMode.tap,
                        child: ListTile(
                          leading:
                              const Icon(Icons.screen_lock_portrait_rounded),
                          title: Text('TurnOffScreen'.tr),
                          trailing: Switch(
                              value: state.turnOffScreen,
                              onChanged: (value) =>
                                  settingBloc.add(ChangeTurnOffScreen(value))),
                        ),
                      );
                    }),
                    BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                      return Tooltip(
                        message:
                            'sets phone to silent mode after finishing timer.',
                        triggerMode: TooltipTriggerMode.tap,
                        child: ListTile(
                          leading: const Icon(Icons.do_not_disturb_alt_rounded),
                          title: Text('SilentMode'.tr),
                          trailing: Switch(
                              value: state.silentMode,
                              onChanged: (value) =>
                                  settingBloc.add(ChangeSilentMode(value))),
                        ),
                      );
                    }),
                    BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                      return Tooltip(
                        message: 'turn off wifi after finishing timer.',
                        triggerMode: TooltipTriggerMode.tap,
                        child: ListTile(
                          leading: const Icon(Icons.signal_wifi_off_rounded),
                          title: Text('TurnOffWifi'.tr),
                          trailing: Switch(
                              value: state.turnOffWifi,
                              onChanged: (value) =>
                                  settingBloc.add(ChangeWifi(value))),
                        ),
                      );
                    }),
                    BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                      return Tooltip(
                        message: 'turn off Bluetooth after finishing timer.',
                        triggerMode: TooltipTriggerMode.tap,
                        child: ListTile(
                          leading: const Icon(Icons.do_not_disturb_alt_rounded),
                          title: Text('TurnOffBluetooth'.tr),
                          trailing: Switch(
                              value: state.turnOffBluetooth,
                              onChanged: (value) =>
                                  settingBloc.add(ChangeBluetooth(value))),
                        ),
                      );
                    }),
                  ],
                )),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.1,
                child: AdWidget(
                  ad: _adsController.settingsBanner,
                )),
          ],
        ),
      ),
    );
  }
}
