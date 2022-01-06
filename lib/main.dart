import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sleep_timer/src/controllers/callback_dispatcher.dart';
import 'package:sleep_timer/src/custom_widgets/touch_indicator.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sleep_timer/src/home/home.dart';
import 'package:sleep_timer/src/themes/dark_theme.dart';
import 'package:sleep_timer/src/themes/light_theme.dart';
import 'package:sleep_timer/src/translations/translate.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_background/flutter_background.dart';

void main() async {
  // To keep app running and losing activity on android
  // FlutterBackground.initialize();
  // FlutterBackground.enableBackgroundExecution();

  /// App Data
  await GetStorage.init();
  // Notifications
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings("mipmap/launcher_icon");
  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  FlutterLocalNotificationsPlugin().initialize(initializationSettings,
      onSelectNotification: onSelectionNotification);
  Workmanager().initialize(
    callBackDispatcher,
  );

  runApp(const MyApp());
  if (await FlutterBackground.hasPermissions) {
  } else {
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
                """To run properly , Turn off Battery optimization""",
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
        FlutterBackground.enableBackgroundExecution();
        FlutterBackground.initialize(
                androidConfig: const FlutterBackgroundAndroidConfig(
                    notificationIcon: AndroidResource(
                        name: 'launcher_icon', defType: 'drawable'),
                    notificationTitle: "Timer Notification",
                    notificationText: "Timer has Finished",
                    notificationImportance: AndroidNotificationImportance.High))
            .then((value) async {});
      }
    });
  }

  //ads
  Admob.initialize();

  // Admob.initialize(testDeviceIds: ["0e69b376-e911-482b-a9c1-3cc0b6053428"]);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // SettingsController _ = SettingsController();
  final appData = GetStorage();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // appContext = context;
    appData.writeIfNull("darkmode", true);
    appData.writeIfNull("gotohome", true);
    appData.writeIfNull("notification", true);
    appData.writeIfNull('language', 'en');
    return SimpleBuilder(builder: (_) {
      isDarkTheme.value = appData.read("darkmode") ?? true;
      language.value = appData.read('language') ?? "en";
      return GetMaterialApp(
        title: 'Sleep Timer',
        // darkTheme: DarkTheme.darkTheme,
        theme: LightTheme.lightTheme,
        themeMode: isDarkTheme.value ? ThemeMode.dark : ThemeMode.light,
        darkTheme: MyDarkTheme.darkTheme,
        home: const MyHomePage(title: 'Sleep Timer'),
        builder: (context, child) {
          return SafeArea(child: TouchIndicator(child: child!));
        },
        translations: Translation(),
        locale: Locale(language.value ?? 'en'),
        fallbackLocale: const Locale('en'),
      );
    });
  }
}

Future onSelectionNotification(payload) async {
  Get.to(() => const MyApp());
}
