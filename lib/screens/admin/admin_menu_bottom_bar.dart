import 'dart:developer';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/provider/parent.dart';
import 'package:flutter_task_planner_app/screens/admin/history_schedule.dart';
import 'package:flutter_task_planner_app/screens/user/user_home_page.dart';
import 'package:flutter_task_planner_app/screens/login_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/bottom_nav.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'admin_home_page.dart';

class AdminMenuBottomBarPage extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<StatefulWidget> createState() => MenuBottomBarState();
}

class MenuBottomBarState extends State<AdminMenuBottomBarPage> {
  String currentPage = 'main';
  String parentId;
  ParentInf getParentInfo;

  @override
  void initState() {
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
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    String formatted = formatter.format(DateTime.now());

    getParentInfo = Provider.of<Parent>(context).getParentInf();
    parentId = getParentInfo.id.toString();

    Map<String, Widget> pageView = <String, Widget>{
      "main": AdminMainPage(
        id: parentId,
      ),
      "history": HistorySchedule(
        tanggal: formatted,
      ),
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
              removeValuesSharedpref();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
        milliseconds: 200,
      ),
    );
  }
}
