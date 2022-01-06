import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleep_timer/src/ads/ads_controller.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sleep_timer/src/settings/settings_controller.dart';
import 'package:admob_flutter/admob_flutter.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final SettingsController _settingsController = SettingsController();

  // final HomeController _homeController = Get.find();
  final AdsController _adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              _settingsController.scaffoldTitle.value.tr,
              style: TextStyle(
                color: isDarkTheme.value ? Colors.white : Colors.greenAccent,
              ),
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            leading: const SizedBox(),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
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
                          "GeneralSettings".tr,
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
                      ListTile(
                        leading: const Icon(
                          Icons.language_outlined,
                        ),
                        title: Text("ChangeLanguage".tr),
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
                                        leading: Icon(
                                          Icons.language_outlined,
                                          color: isDarkTheme.value
                                              ? Colors.pinkAccent
                                              : Colors.greenAccent,
                                        ),
                                        title: Text(_settingsController
                                            .languages
                                            .elementAt(index)
                                            .tr),
                                      ),
                                      onTap: () async {
                                        _settingsController
                                            .onLanguageChanged(index);
                                      },
                                    );
                                  },
                                );
                              });
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.lightbulb),
                        title: Text("DarkMode".tr),
                        trailing: Switch(
                            value: isDarkTheme.value,
                            activeColor: isDarkTheme.value
                                ? Colors.pinkAccent
                                : Colors.pinkAccent,
                            onChanged: _settingsController.onDarkModeChanged),
                      ),
                      ListTile(
                        leading: const Icon(Icons.lightbulb),
                        title: Text("Notifications".tr),
                        trailing: Switch(
                            value: notification.value,
                            activeColor: isDarkTheme.value
                                ? Colors.pinkAccent
                                : Colors.greenAccent,
                            onChanged:
                                _settingsController.onNotificationsChanged),
                      ),
                      ListTile(
                          leading: const Icon(
                              Icons.drive_file_rename_outline_rounded),
                          title: Text("ResetToDefault".tr),
                          onTap: _settingsController.onResetToDefault),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: Text(
                          "TimerSettings".tr,
                          style: const TextStyle(color: Colors.white),
                        ),
                        shape: const RoundedRectangleBorder(),
                        tileColor: Colors.blueGrey,
                      ),
                      ListTile(
                        leading: const Icon(Icons.home_filled),
                        title: Text("GoToHomeScreen".tr),
                        trailing: Switch(
                            value: goToHome.value,
                            activeColor: isDarkTheme.value
                                ? Colors.pinkAccent
                                : Colors.greenAccent,
                            onChanged:
                                _settingsController.onGoToHomeScreenChanged),
                      ),
                      ListTile(
                        leading: const Icon(Icons.home_filled),
                        title: Text("SilentMode".tr),
                        trailing: Switch(
                            value: silentMode.value,
                            activeColor: isDarkTheme.value
                                ? Colors.pinkAccent
                                : Colors.greenAccent,
                            onChanged: _settingsController.onSilentModeChanged),
                      ),
                    ],
                  )),
              Positioned(
                bottom: 0,
                child: AdmobBanner(
                  adSize: AdmobBannerSize.FULL_BANNER,
                  adUnitId: _adsController.getSettingsBannerAdUnitId()!,
                ),
              ),
            ],
          ),
        ));
  }
}
