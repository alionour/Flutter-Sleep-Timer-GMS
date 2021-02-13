import 'package:flutter/material.dart';
import 'package:flutter_t/Views/Home.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main() {
  runApp(MyApp());
  Admob.initialize(testDeviceIds: ["0e69b376-e911-482b-a9c1-3cc0b6053428"]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sleep Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Sleep Timer'),
    );
  }
}
