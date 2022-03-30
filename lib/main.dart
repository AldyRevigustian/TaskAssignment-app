import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/home_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFFE5E5E5), // navigation bar color
    // statusBarColor: LightColors.mainBlue, // status bar color
    statusBarColor: Colors.red, // status bar color
  ));

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
            // bodyColor: LightColors.kDarkBlue,
            // displayColor: LightColors.kDarkBlue,
            fontFamily: 'Montserrat'),
      ),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
