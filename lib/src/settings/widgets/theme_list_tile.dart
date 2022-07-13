import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/src/settings/bloc/settings_bloc.dart';

class ThemeListTile extends StatefulWidget {
  const ThemeListTile({Key? key}) : super(key: key);

  @override
  State<ThemeListTile> createState() => _ThemeListTileState();
}

class _ThemeListTileState extends State<ThemeListTile> {
  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();
    return ExpansionTile(
        leading: Icon(
          Icons.color_lens,
          color: Theme.of(context).iconTheme.color,
        ),
        title: Text('Theme'.tr),
        children: [
          SizedBox(
            width: settingsBloc.themes.length * 80,
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: settingsBloc.themes.length,
              itemBuilder: (ctx, index) => Tooltip(
                message: settingsBloc.themes[index].key,
                child: TextButton(
                  onPressed: () {
                    settingsBloc.add(
                      ChangeThemeData(
                        settingsBloc.themes.elementAt(
                          index,
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.color_lens,
                    color: settingsBloc.themes
                        .elementAt(index)
                        .palette
                        .appBarColor,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
        ]);
  }
}
