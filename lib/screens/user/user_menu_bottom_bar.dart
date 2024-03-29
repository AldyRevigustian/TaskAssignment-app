import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_task_planner_app/provider/user.dart';
import 'package:flutter_task_planner_app/screens/user/user_home_page.dart';
import 'package:flutter_task_planner_app/screens/login_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/bottom_nav.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String userId;
  String token;
  UserInf getUserInfo;
  String tokens = "";
  String deviceTokenToSendPushNotification = "";

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    getDeviceTokenToSendNotification();

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        log("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => UserMenuBottomBarPage()),
            ModalRoute.withName('/home'),
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
          LocalNotificationService.createanddisplaynotification(message);
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
    await GetHelper().registid(userId, deviceTokenToSendPushNotification);
    return deviceTokenToSendPushNotification;
  }

  changePage(String pageName) {
    setState(() {
      currentPage = pageName;
    });
  }

  removeValuesSharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    prefs.remove("password");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));

    getUserInfo = Provider.of<User>(context).getUserInf();
    userId = getUserInfo.id.toString();
    token = getUserInfo.token.toString();

    Map<String, Widget> pageView = <String, Widget>{
      "main": UserMainPage(id: userId, token: token,),
      "logOut": LoginPage(),
    };

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
                    GetHelper().registid(userId, "logout");

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
                    // Navigator.pop(context);
                    // changePage('main');
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
              child: Container(
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
