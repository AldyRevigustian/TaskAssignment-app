import 'dart:developer';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_planner_app/provider/user.dart';
import 'package:flutter_task_planner_app/screens/admin/history_schedule.dart';
import 'package:flutter_task_planner_app/screens/user/user_home_page.dart';
import 'package:flutter_task_planner_app/screens/login_page.dart';
import 'package:flutter_task_planner_app/screens/user/user_menu_bottom_bar.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/bottom_nav.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../helpers/get_helper.dart';
import '../../widget/custAlert.dart';
import 'admin_home_page.dart';

class AdminMenuBottomBarPage extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<StatefulWidget> createState() => MenuBottomBarState();
}

class MenuBottomBarState extends State<AdminMenuBottomBarPage> {
  String currentPage = 'main';
  String userId;
  String userToken;
  UserInf getUserInfo;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    super.initState();
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
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    String formatted = formatter.format(DateTime.now());

    getUserInfo = Provider.of<User>(context).getUserInf();
    userId = getUserInfo.id.toString();
    userToken = getUserInfo.id.toString();

    Map<String, Widget> pageView = <String, Widget>{
      "main": AdminMainPage(
        id: userId,
        token: userToken,
      ),
      "history": HistorySchedule(
        tanggal: formatted,
      ),
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
              activeIcon: FluentIcons.history_24_filled,
              icon: FluentIcons.history_24_regular,
              onTap: () {
                changePage("history");
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
                    showLoadingProgress(context);
                    removeValuesSharedpref();
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
                            builder: (context) => AdminMenuBottomBarPage()),
                        (Route<dynamic> route) => false);
                  },
                  detailContent: "Are you sure you want to log out ?",
                  pathLottie: "warning");
            },
          ),
        ],
        milliseconds: 200,
      ),
    );
  }
}
