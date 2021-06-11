import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  var scaffoldTitle = "Settings".obs;
  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }
}
