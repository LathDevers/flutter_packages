/// This is a wrapper for the Flutter package `fluttertoast` with customizations.
/// ----------------------
/// Lurvig @2022
library;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyToast extends Fluttertoast {
  /// Summons the platform's showToast which will display the message.
  /// This is a wrapper for the package `fluttertoast` with customizations.
  /// Please only change the UI parameters individually only if justified.
  ///
  /// Parameter [message] is required and all remaining are optional
  ///
  /// Usage: `MyToast.showToast(message: 'message')`
  static Future<bool?> showToast({
    required String message,

    /// The duration for which the toast should be displayed on Android.
    ///
    /// Defaults to 1 sec if message is short and 5 sec if message is long.
    Toast? toastLength,

    /// The time in seconds the toast should be displayed on iOS and the web.
    ///
    /// Defaults to 0.3 sec times the length of the message.
    int? timeInSecForIosWeb,
    double fontSize = 16.0,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = const Color(0xFF1F1F1F),
    Color textColor = Colors.white,
    bool webShowClose = false,
    String webBgColor = '#696969',
    dynamic webPosition = 'right',
  }) async {
    final double seconds = RegExp(r'(\w+)').allMatches(message).length * .3;
    Toast lengthSec = Toast.LENGTH_SHORT;
    if (seconds > 2.5) lengthSec = Toast.LENGTH_LONG;
    await Fluttertoast.cancel();
    return Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength ?? lengthSec,
      timeInSecForIosWeb: timeInSecForIosWeb ?? seconds.round(),
      fontSize: fontSize,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      webShowClose: webShowClose,
      webBgColor: webBgColor,
      webPosition: webPosition,
    );
  }
}
