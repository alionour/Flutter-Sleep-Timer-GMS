import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleep_timer/src/app/services/navigation/navigator_service.dart';
import 'package:sleep_timer/src/custom_widgets/touch_indicator.dart';
import 'package:sleep_timer/src/globals.dart';
import 'package:sleep_timer/src/settings/bloc/settings_bloc.dart';
import 'package:sleep_timer/src/translations/translate.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _settingsBloc = SettingsBloc();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // appContext = context;

    return BlocProvider<SettingsBloc>(
      create: (_) => _settingsBloc,
      child: Builder(
        builder: (context) {
          return BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return GetMaterialApp.router(
                scaffoldMessengerKey: scaffoldMessengerKey,
                routerDelegate: NavigatorService.routerDelegate,
                routeInformationParser: NavigatorService.routeInformationParser,
                routeInformationProvider:
                    NavigatorService.router.routeInformationProvider,
                title: 'SleepTimer'.tr,
                theme: state.appTheme.theme,
                builder: (context, child) {
                  return SafeArea(child: TouchIndicator(child: child!));
                },
                translations: Translation(),
                locale: Locale(state.languageCode),
              );
            },
          );
        },
      ),
    );
  }
}
