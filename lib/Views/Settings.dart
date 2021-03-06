import 'package:flutter/material.dart';
import 'package:flutter_t/Controllers/SettingsController.dart';
import 'package:get/get.dart';
import 'package:flutter_t/Globals.dart';
import 'package:get_storage/get_storage.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SettingsController _ = SettingsController();
  final appData = GetStorage();
  @override
  Widget build(BuildContext context) {
    context.theme;

    goToHome = appData.read("go_to_home");
    notification = appData.read("notification");
    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              _.scaffoldTitle.value,
              style: TextStyle(
                color: isDarkTheme ? Colors.white : Colors.greenAccent,
              ),
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
          ),
          body: Card(
              elevation: 10,
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.lightbulb),
                    title: Text("DarkMode"),
                    trailing: Switch(
                      value: isDarkTheme,
                      activeColor:
                          isDarkTheme ? Colors.pinkAccent : Colors.greenAccent,
                      onChanged: (bool value) {
                        appData.write("darkmode", value);
                        setState(() {
                          isDarkTheme = value;
                        });
                        // Get.isDarkMode
                        //     ? Get.changeTheme(MyDarkTheme.darkTheme)
                        //     : Get.changeTheme(LightTheme.lightTheme);

                        print("changed0");
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home_filled),
                    title: Text("Go To Home Screen"),
                    trailing: Switch(
                      value: goToHome,
                      activeColor:
                          goToHome ? Colors.pinkAccent : Colors.greenAccent,
                      onChanged: (bool value) {
                        appData.write("go_to_home", value);
                        setState(() {
                          goToHome = !goToHome;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.lightbulb),
                    title: Text("Notifications"),
                    trailing: Switch(
                      value: notification,
                      activeColor:
                          notification ? Colors.pinkAccent : Colors.greenAccent,
                      onChanged: (bool value) {
                        appData.write("notification", value);
                        setState(() {
                          notification = value;
                        });
                        // Get.isDarkMode
                        //     ? Get.changeTheme(MyDarkTheme.darkTheme)
                        //     : Get.changeTheme(LightTheme.lightTheme);

                        print("changed0");
                      },
                    ),
                  ),
                ],
              )),
        ));
  }
}
