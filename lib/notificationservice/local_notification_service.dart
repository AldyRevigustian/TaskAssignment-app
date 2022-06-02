import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_task_planner_app/screens/login_page.dart';
import 'package:flutter_task_planner_app/screens/user/user_menu_bottom_bar.dart';
import 'package:path/path.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android:
                AndroidInitializationSettings("@drawable/ic_stat_group_68"),
            iOS: IOSInitializationSettings(
              requestSoundPermission: false,
              requestBadgePermission: false,
              requestAlertPermission: false,
              // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
            ));

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String payload) async {
        log("pencet");
      },
    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "pushnotificationapp",
            "pushnotificationappchannel",
            importance: Importance.max,
            priority: Priority.high,
            // icon: '@mipmap/ic_launcher',
            // largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_trans'),
          ),
          iOS: IOSNotificationDetails(
            presentAlert:
                true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
            presentBadge:
                true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
            presentSound:
                true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
          ));

      await _notificationsPlugin.show(
        id,
        message.notification.title,
        message.notification.body,
        notificationDetails,
        payload: message.data['_id'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
