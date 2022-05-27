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
      android: AndroidInitializationSettings("@drawable/ic_stat_group_68"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: (String id) async {
      //   log("onSelectNotification");

      //   // Navigator.of(context).push(
      //   //   MaterialPageRoute(
      //   //     builder: (context) => DemoScreen(
      //   //       id: id,
      //   //     ),
      //   //   ),
      //   // );

      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (BuildContext context) {
      //         return LoginPage();
      //       },
      //     ),
      //   );
      //   if (id.isNotEmpty) {
      //     print("Router Value1234 $id");

      //     // Navigator.of(context).push(
      //     //   MaterialPageRoute(
      //     //     builder: (context) => DemoScreen(
      //     //       id: id,
      //     //     ),
      //     //   ),
      //     // );

      //   }
      // },
      onSelectNotification: (String payload) async {
        log("pencet");
        // Get.to(UserMenuBottomBarPage());

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => UserMenuBottomBarPage(),
        //   ),
        // );

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => UserMenuBottomBarPage(),
        //   ),
        // );
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
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_trans'),
        ),
      );

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
