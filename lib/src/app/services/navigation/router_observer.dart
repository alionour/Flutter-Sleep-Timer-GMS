// import 'package:flutter/material.dart';

// // Register the RouteObserver as a navigation observer.
// final RouteObserver<ModalRoute<void>> routeObserver =
//     RouteObserver<ModalRoute<void>>();

import 'package:flutter/material.dart';

extension CurrentRoute on NavigatorState {
  Route? get currentRoute {
    Route? result;
// workaround (never pops as predictate always return true)
    popUntil((route) {
      result = route;
      return true;
    });
    return result;
  }
}

class AppNavigatorObserver extends RouteObserver<ModalRoute<Object?>>
    with WidgetsBindingObserver
    implements NavigatorObserver {
  AppNavigatorObserver() {
    WidgetsBinding.instance.addObserver(this);
  }
//   @override
//   void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
// 7    if (newRoute == null || newRoute == oldRoute) {
//       return;
//     }
//     super.didPush(newRoute, oldRoute);
//   }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
  }

  // /// plays floating oompa sound if current route is home
  // static void playFloatingOompaSound() {
  //   log('current location ${NavigatorService.router.location}');
  //   if (NavigatorService.router.location == HomeView.routeName) {
  //     AudioHelper.playFloatingOompaSound(10);
  //   } else {
  //     AudioHelper.pauseFloatingOompaSound();
  //   }
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   log(state.toString());
  //   if (state == AppLifecycleState.inactive ||
  //       state == AppLifecycleState.paused ||
  //       state == AppLifecycleState.detached) {
  //     AudioHelper.pauseFloatingOompaSound();
  //   } else if (state == AppLifecycleState.resumed) {
  //     AudioHelper.playFloatingOompaSound(10);
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addObserver(this);
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

}
