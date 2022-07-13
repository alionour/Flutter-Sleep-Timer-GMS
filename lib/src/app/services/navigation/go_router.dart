import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sleep_timer/src/app/services/navigation/navigator_service.dart';
import 'package:sleep_timer/src/home/view/home.dart';
import 'package:sleep_timer/src/settings/view/settings.dart';

class MyRouter {
  MyRouter();
  late final router = GoRouter(
      debugLogDiagnostics: true,
      urlPathStrategy: UrlPathStrategy.path,
      initialLocation: HomePage.routeName,
      observers: [NavigatorService.routeObserver],
      routes: [
        GoRoute(
            name: HomePage.routeName,
            path: HomePage.routeName,
            builder: (context, state) => const HomePage(),
            routes: [
              GoRoute(
                name: SettingsPage.routeName,
                path: SettingsPage.routeName.replaceAll('/', ''),
                builder: (context, state) => const SettingsPage(),
              ),
            ]),
      ],
      errorBuilder: (context, state) => ErrorHandlerView(error: state.error));
}

class ErrorHandlerView extends StatelessWidget {
  const ErrorHandlerView({
    Key? key,
    @required this.error,
  }) : super(key: key);

  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Text(
          'An error occurred: $error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
