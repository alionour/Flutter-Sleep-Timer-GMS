import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sound_mode/permission_handler.dart';

class SettingsController extends GetxController {
  var scaffoldTitle = "Settings".obs;
  List<String> languages = ["en", "ar", "ch"];
  final appData = GetStorage();
  // RxBool goToHomeBool = true.obs;
  // RxBool notificationsOn = true.obs;
  // RxBool SilentMode = true.obs;
  // RxBool goToHomeBool = true.obs;
  @override
  void onInit() {
    language.value = appData.read('language') ?? "en";
    goToHome.value = appData.read("gotohome") ?? true;
    notification.value = appData.read("notification") ?? true;
    silentMode.value = appData.read("silentmode") ?? false;
    super.onInit();
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  Future<void> onSilentModeChanged(bool value) async {
// checks if permissions is granted!!
    bool isGranted = await PermissionHandler.permissionsGranted ?? false;
    if (!isGranted) {
      // dialog for user to give required permissions
      await Get.dialog<bool>(
        AlertDialog(
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () {
                Get.back(result: true);
              },
              child: const Text("allow"),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: const Text("close"),
            ),
          ],
          title: const ListTile(
            leading: Icon(Icons.notification_important),
            title: Text("Permissions Required"),
          ),
          content: const FittedBox(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  """To activate this choice , "Do not disturb permission" is required""",
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ),
        ),
      ).then((allowed) async {
        if (allowed ?? false) {
          // Opens the Do Not Disturb Access settings to grant the access
          await PermissionHandler.openDoNotDisturbSetting();
        }
      });
    }
    if (isGranted) {
      appData.write("silentmode", value);
      silentMode.toggle();
      update();
    }
  }

  void onGoToHomeScreenChanged(bool value) {
    appData.write("gotohome", value);
    goToHome.toggle();
    update();
  }

  Future<void> onResetToDefault() async {
    await appData.erase();
    showSnackBar("Resetted to default , please restart your app");
  }

  void onNotificationsChanged(bool value) {
    appData.write("notification", value);
    notification.value = value;
    update();
    // Get.isDarkMode
    //     ? Get.changeTheme(MyDarkTheme.darkTheme)
    //     : Get.changeTheme(LightTheme.lightTheme);
  }

  void onDarkModeChanged(bool value) {
    appData.write("darkmode", value);
    isDarkTheme.value = value;
    update();
    // Get.isDarkMode
    //     ? Get.changeTheme(MyDarkTheme.darkTheme)
    //     : Get.changeTheme(LightTheme.lightTheme);
  }

  Future<void> onLanguageChanged(int index) async {
    language.value = languages.elementAt(index);
    Get.updateLocale(Locale(languages.elementAt(index)));
    await appData.write("language", language.value);
  }
}
