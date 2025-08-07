import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sleep_timer/src/app/services/ads/ads_controller.dart';
import 'package:sleep_timer/src/settings/bloc/settings_bloc.dart';
import 'package:sleep_timer/src/settings/widgets/general_settings_view.dart';
import 'package:sleep_timer/src/settings/widgets/timer_settings_view.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const routeName = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Stack(
              children: [
                ListView(
                  children: const [
                    GeneralSettingsView(),
                    TimerSettingsView(),
                  ],
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: AdWidget(
                      ad: _adsController.settingsBanner,
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}
