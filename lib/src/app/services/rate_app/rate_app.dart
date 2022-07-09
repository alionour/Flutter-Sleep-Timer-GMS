// In this snippet, I'm giving a value to all parameters.
// Please note that not all are required (those that are required are marked with the @required annotation).

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:sleep_timer/src/globals.dart';

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: 'rateMyApp_',
  minDays: 3,
  minLaunches: 5,
  remindDays: 10,
  remindLaunches: 10,
  googlePlayIdentifier: 'com.ali.nourmed.sleep_timer',
  // appStoreIdentifier:
);
Future<void> initializeRateMyApp() async {
  await rateMyApp.init();
}

void showRateDialog(BuildContext context) {
  if (kDebugMode || rateMyApp.shouldOpenDialog) {
    rateMyApp.showRateDialog(
      context,
      title: 'Enjoying Sleep Timer', // The dialog title.
      message:
          'please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
      rateButton: 'RATE NOW', // The dialog "rate" button text.
      noButton: 'NO THANKS', // The dialog "no" button text.
      laterButton: 'MAYBE LATER', // The dialog "later" button text.
      barrierDismissible: true,
      listener: (button) {
        // The button click listener (useful if you want to cancel the click event).
        switch (button) {
          case RateMyAppDialogButton.rate:
            print('Clicked on "Rate".');
            launchInAppReview();
            break;
          case RateMyAppDialogButton.later:
            print('Clicked on "Later".');
            break;
          case RateMyAppDialogButton.no:
            print('Clicked on "No".');
            break;
        }

        return true; // Return false if you want to cancel the click event.
      },
      ignoreNativeDialog: Platform
          .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
      dialogStyle: const DialogStyle(), // Custom dialog styles.
      onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
          .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
      // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
      // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
    );
  }
}

void launchInAppReview() async {
  try {
    if (await InAppReview.instance.isAvailable()) {
      InAppReview.instance.requestReview();
    }
  } catch (e) {
    showSnackBar('Failed to open Store Review');
    log('error launching in app review $e');
  }
}
