import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/home_page.dart';
import 'package:flutter_task_planner_app/screens/login_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/bottom_nav.dart';

class MenuBottomBarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MenuBottomBarState();
}

class MenuBottomBarState extends State<MenuBottomBarPage> {
  String currentPage = 'main';
  final Map<String, Widget> pageView = <String, Widget>{
    "main": MainPage(),
    // "main": MainPage(),
    "java": Scaffold(
        appBar: AppBar(title: Text('Java')),
        body: Center(child: Text('Java Tutorial'))),
    "logOut": LoginPage(),
  };
  changePage(String pageName) {
    setState(() {
      currentPage = pageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this.pageView[currentPage],
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
              activeIcon: FluentIcons.history_16_filled,
              icon: FluentIcons.history_16_regular,
              onTap: () {
                changePage("java");
              }),
          new BottomNavigationDotItem(
              activeIcon: FluentIcons.sign_out_20_filled,
              icon: FluentIcons.sign_out_20_regular,
              onTap: () {
                // changePage("logOut");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => LoginPage(),
                  ),
                );
              }),
        ],
        milliseconds: 200,
      ),
    );
  }
}
