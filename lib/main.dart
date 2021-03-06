import 'package:flutter/material.dart';
import 'package:flutter_t/Controllers/SettingsController.dart';
import 'package:flutter_t/Themes/DarkTheme.dart';
import 'package:flutter_t/Themes/LightTheme.dart';
import 'package:flutter_t/Views/Home.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_t/Globals.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background/flutter_background.dart';

BuildContext appContext;

void main() async {
  // To keep app running and losing activity on android
  FlutterBackground.initialize();
  FlutterBackground.enableBackgroundExecution();
  // App Data
  await GetStorage.init();
  // Notifications
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings("mipmap/launcher_icon");
  final InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );

  FlutterLocalNotificationsPlugin().initialize(initializationSettings,
      onSelectNotification: onSelectionNotification);
  runApp(MyApp());
  //ads
  Admob.initialize(testDeviceIds: ["0e69b376-e911-482b-a9c1-3cc0b6053428"]);
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SettingsController _ = SettingsController();
  final appData = GetStorage();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    appContext = context;
    appData.writeIfNull("darkmode", true);
    appData.writeIfNull("go_to_home", true);
    appData.writeIfNull("notification", true);
    return SimpleBuilder(builder: (_) {
      isDarkTheme = appData.read("darkmode");
      return GetMaterialApp(
        title: 'Flutter Sleep Timer',
        // darkTheme: DarkTheme.darkTheme,
        theme: LightTheme.lightTheme,
        themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        darkTheme: MyDarkTheme.darkTheme,
        home: MyHomePage(title: 'Flutter Sleep Timer'),
      );
    });
  }
}

Future onSelectionNotification(payload) async {
  await Navigator.push(
      appContext, MaterialPageRoute(builder: (context) => MyApp()));
}
