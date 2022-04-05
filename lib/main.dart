import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/provider/parent.dart';
import 'package:flutter_task_planner_app/screens/home_page.dart';
import 'package:flutter_task_planner_app/screens/login_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_planner_app/widget/menu_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'widget/bottom_nav.dart';

void main() {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.transparent, // navigation bar color
  //   // systemNavigationBarColor: Color(0xFFE5E5E5), // navigation bar color
  //   statusBarColor: Colors.transparent, // status bar color
  //   // statusBarColor: LightColors.mainBlue, // status bar color
  //   // statusBarColor: Colors.red, // status bar color
  // ));

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFF2FA0BF, color);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Parent(), // parentProvier
        ),
      ],
      child: MaterialApp(
        title: 'Task Assignment',
        // initialRoute: '/',
        // routes: {
        //   '/': (context) => ,
        // },
        theme: ThemeData(
          primarySwatch: colorCustom,
          textTheme: Theme.of(context).textTheme.apply(
              // bodyColor: LightColors.kDarkBlue,
              // displayColor: LightColors.kDarkBlue,
              fontFamily: 'Montserrat'),
        ),
        // home: HomePage(),
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
        routes: {
          // route names to mainParentPage and mainTeacherPage
          MenuBottomBarPage.routeName: (ctx) => MenuBottomBarPage(),
          LoginPage.routeName: (ctx) => LoginPage(),
          // MainParentPage.routeName: (ctx) => MainParentPage(),
          // MainTeacherPage.routeName: (ctx) => MainTeacherPage(),
          // InicialPage.routeName: (ctx) => InicialPage(),
          // DashboardMenu.routeName: (ctx) => DashboardMenu(),
          // // LeavePage.routeName: (ctx) => LeavePage(),
          // InicialLeavePage.routeName: (ctx) => InicialLeavePage(),
          // ReportPage.routeName: (ctx) => ReportPage()
        },
      ),
    );
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(47, 160, 191, .1),
  100: Color.fromRGBO(47, 160, 191, .2),
  200: Color.fromRGBO(47, 160, 191, .3),
  300: Color.fromRGBO(47, 160, 191, .4),
  400: Color.fromRGBO(47, 160, 191, .5),
  500: Color.fromRGBO(47, 160, 191, .6),
  600: Color.fromRGBO(47, 160, 191, .7),
  700: Color.fromRGBO(47, 160, 191, .8),
  800: Color.fromRGBO(47, 160, 191, .9),
  900: Color.fromRGBO(47, 160, 191, 1),
};
