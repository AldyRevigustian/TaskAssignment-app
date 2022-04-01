import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/home_page.dart';
import 'package:flutter_task_planner_app/screens/login_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter/services.dart';
import 'widget/bottom_nav.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFFE5E5E5), // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
    // statusBarColor: LightColors.mainBlue, // status bar color
    // statusBarColor: Colors.red, // status bar color
  ));

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFF2FA0BF, color);

    return MaterialApp(
      title: 'Flutter Demo',
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

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomePage> {
  String currentPage = 'main';
  final Map<String, Widget> pageView = <String, Widget>{
    "main": MainPage(),
    // "main": MainPage(),
    "java": Scaffold(
        appBar: AppBar(title: Text('Java')),
        body: Center(child: Text('Java Tutorial'))),
    "php": Scaffold(
        appBar: AppBar(title: Text('PHP')),
        body: Center(child: Text('PHP Tutorial'))),
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
                changePage("php");
              }),
        ],
        milliseconds: 200,
      ),
    );
  }
}
