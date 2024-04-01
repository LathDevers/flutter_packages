/// This is a wrapper for the Flutter package `awesome_notifications`
/// with initialization and preferred notication UI.
/// ----------------------
/// Lurvig @2022
library;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

const String _basicChannelKey = 'basic_channel';

/// This is a wrapper for the Flutter package `awesome_notifications`
/// with initialization and prefered notication UI.
class MyNotification {
  /// Initializes the plugin, creating icon and the initial channels.
  ///
  /// Run this in the `main()` function before `runApp`. Only needs to be called at main.dart once
  static void initialize() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: _basicChannelKey,
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Colors.red.shade300,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
    );
  }

  /// Checks if user enabled the app to send notifications. And if not, requests for permission.
  static void checkPermission() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) AwesomeNotifications().requestPermissionToSendNotifications();
    });
  }

  /// Sends a simple notification with [title] and [message] in it.
  static void simpleNotification({required String title, required String message}) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: _basicChannelKey,
        title: title,
        body: message,
      ),
    );
  }
}
