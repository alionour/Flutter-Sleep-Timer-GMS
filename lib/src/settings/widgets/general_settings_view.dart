import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleep_timer/src/settings/bloc/settings_bloc.dart';
import 'package:sleep_timer/src/settings/widgets/widgets.dart';

class GeneralSettingsView extends StatelessWidget {
  const GeneralSettingsView({Key? key}) : super(key: key);

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
          const Divider(height: 1),
          ListTile(
            leading: const Icon(
              Icons.language_outlined,
            ),
            title: Text('ChangeLanguage'.tr),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ListView.separated(
                      itemCount: 3,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: ListTile(
                            leading: const Icon(
                              Icons.language_outlined,
                            ),
                            title: Text(
                                settingBloc.languages.elementAt(index).tr),
                          ),
                          onTap: () async {
                            settingBloc.add(ChangeLanguage(
                                settingBloc.languages.elementAt(index)));
                          },
                        );
                      },
                    );
                  });
            },
          ),
          const ThemeListTile(),
          ListTile(
            leading: const Icon(Icons.notification_important_rounded),
            title: Text('Notifications'.tr),
            trailing: Switch(
              value: settingBloc.state.notification,
              onChanged: (value) => settingBloc.add(
                ChangeNotificationsOn(value),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.rounded_corner_rounded),
            title: Text('RunInBackground'.tr),
            trailing: Switch(
              value: settingBloc.state.runInBackground,
              onChanged: (value) =>
                  settingBloc.add(ChangeRunInBackground(value)),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.drive_file_rename_outline_rounded),
              title: Text('ResetToDefault'.tr),
              onTap: () => settingBloc.add(ResetToDefault())),
        ],
      ),
    );
  }
}
