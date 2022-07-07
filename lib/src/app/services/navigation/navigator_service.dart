import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/src/app/services/navigation/go_router.dart';
import 'package:sleep_timer/src/app/services/navigation/router_observer.dart';
import 'package:sleep_timer/src/settings/bloc/settings_bloc.dart';
import 'package:sleep_timer/src/timer/bloc/timer_bloc.dart';

/// this class act as global navigator throughout the app.
class NavigatorService {
  NavigatorService._constructor();
// Register the RouteObserver as a navigation observer.
  static final AppNavigatorObserver routeObserver = AppNavigatorObserver();
  // get router => routerDelegate.router;
  static final _router = MyRouter();

  static GoRouter get router => _router.router;

  static final routerDelegate = router.routerDelegate;
  static final routeInformationParser = router.routeInformationParser;
  static final NavigatorService _instance = NavigatorService._constructor();
  factory NavigatorService() {
    return _instance;
  }
  static GlobalKey<NavigatorState> navigatorKey = routerDelegate.navigatorKey;
  // static ModalRoute? currentRoute = ModalRoute.of(context);

  /// A getter for the current context.
  static BuildContext get context {
    return navigatorKey.currentContext!;
  }

  static void pushNamed(
    String location, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
  }) {
    router.pushNamed(location,
        params: params, queryParams: queryParams, extra: extra);
  }

  static void push(String location, {Object? extra}) {
    router.push(location, extra: extra);
  }

  static void go(String location, {Object? extra}) {
    router.go(location, extra: extra);
  }

  static void goNamed(
    String location, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
  }) {
    router.goNamed(location,
        params: params, queryParams: queryParams, extra: extra);
  }

  static void pop() {
    router.pop();
  }

  /// pushes a new route with the given configuration
  /// and then pops the current route
  static void pushReplacement(String location) {
    router.pop();
    router.goNamed(location);
  }
  // static void pushNamedAndRemoveUntil(String routeName) {
  //   // updating context before navigation
  //   Navigator.of(context, rootNavigator: true)
  //       .pushNamedAndRemoveUntil(routeName, (route) => false);
  // }

  // /// returns to previous route
  // static void back() {
  //   // updating context before navigation
  //   Navigator.of(context, rootNavigator: true).pop();
  // }

  static Future<void> backAfter(Duration duration) async {
    log('popped after $duration');
    return await Future.delayed(
      duration,
      () => // updating context before navigation
          router.pop(),
    );
  }

  static SettingsBloc get settingsBloc => context.read<SettingsBloc>();
  static TimerBloc get timerBloc => context.read<TimerBloc>();
}
