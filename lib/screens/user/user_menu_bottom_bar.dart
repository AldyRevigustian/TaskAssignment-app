import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_task_planner_app/provider/parent.dart';
import 'package:flutter_task_planner_app/screens/user/user_home_page.dart';
import 'package:flutter_task_planner_app/screens/login_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/bottom_nav.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../helpers/get_helper.dart';
import '../../notificationservice/local_notification_service.dart';
import '../../widget/custAlert.dart';

class UserMenuBottomBarPage extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<StatefulWidget> createState() => MenuBottomBarState();
}

class MenuBottomBarState extends State<UserMenuBottomBarPage> {
  String currentPage = 'main';
  String parentId;
  ParentInf getParentInfo;
  String tokens = "";
  String deviceTokenToSendPushNotification = "";

  @override
  void initState() {
    getDeviceTokenToSendNotification();

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        log("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          log("New OII");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserMenuBottomBarPage(),
            ),
          );
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (message) {
        log("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          log(message.notification.title);
          log(message.notification.body);
          log("message.data11 ${message.data}");
          log("hoho");
          LocalNotificationService.createanddisplaynotification(message);
          // setState(() {});
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (BuildContext context) {
          //       return UserMenuBottomBarPage();
          //     },
          //   ),
          // );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => UserMenuBottomBarPage()),
            ModalRoute.withName('/home'),
          );
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        log("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          log(message.notification.title);
          log(message.notification.body);
          log("message.data22 ${message.data['_id']}");
        }
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (BuildContext context) {
        //       return UserMenuBottomBarPage();
        //     },
        //   ),
        // );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => UserMenuBottomBarPage()),
          ModalRoute.withName('/home'),
        );
      },
    );

    super.initState();
  }

  Future getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    setState(() {
      tokens = deviceTokenToSendPushNotification;
    });
    log("Token Value $deviceTokenToSendPushNotification");
    await GetHelper().registid(parentId, deviceTokenToSendPushNotification);
    return deviceTokenToSendPushNotification;
  }

  changePage(String pageName) {
    setState(() {
      currentPage = pageName;
    });
  }

  removeValuesSharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove String
    prefs.remove("username");
    //Remove bool
    prefs.remove("password");
  }

  @override
  Widget build(BuildContext context) {
    getParentInfo = Provider.of<Parent>(context).getParentInf();
    parentId = getParentInfo.id.toString();

    Map<String, Widget> pageView = <String, Widget>{
      "main": UserMainPage(id: parentId),
      "logOut": LoginPage(),
    };
    // log(parentId + "kntl");
    return Scaffold(
      body: pageView[currentPage],
      bottomNavigationBar: new BottomNavigationDot(
        paddingBottomCircle: 10,
        color: LightColors.oldBlue,
        backgroundColor: Colors.white,
        activeColor: LightColors.oldBlue,
        items: [
          new BottomNavigationDotItem(
              activeIcon: FluentIcons.home_16_filled,
              icon: FluentIcons.home_16_regular,
              onTap: () {
                changePage("main");
              }),
          // new BottomNavigationDotItem(
          //     activeIcon: FluentIcons.history_16_filled,
          //     icon: FluentIcons.history_16_regular,
          //     onTap: () {
          //       changePage("java");
          //     }),
          new BottomNavigationDotItem(
            activeIcon: FluentIcons.sign_out_24_filled,
            icon: FluentIcons.sign_out_24_regular,
            onTap: () {
              return showCustAlertDouble(
                  height: 280,
                  context: context,
                  title: "Log Out",
                  // buttonString: "OK",
                  onSubmitOk: () async {
                    removeValuesSharedpref();
                    GetHelper().registid(parentId, "logout");

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false);
                    Fluttertoast.showToast(
                        msg: "Successfully log out ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                        fontSize: 12.0);
                  },
                  onSubmitCancel: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => UserMenuBottomBarPage()),
                        (Route<dynamic> route) => false);
                  },
                  detailContent: "Are you sure you want to log out ?",
                  pathLottie: "warning");
            },
          )
        ],
        milliseconds: 200,
      ),
    );
  }
}

showLoadingProgress(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => Center(
              // Aligns the container to center
              child: Container(
            // A simplified version of dialog.
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            width: 100.0,
            height: 70.0,
            child: SpinKitWave(
              color: LightColors.mainBlue.withOpacity(0.5),
              size: 25.0,
            ),
          )));
}
