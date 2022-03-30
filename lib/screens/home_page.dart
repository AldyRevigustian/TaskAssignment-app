import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/calendar_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:svg_icon/svg_icon.dart';

import '../widget/bottom_navbar.dart';
import '../main.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height / 3.3,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: height / 3.7,
                        decoration: BoxDecoration(
                            color: LightColors.mainBlue,
                            image: DecorationImage(
                                image: AssetImage('assets/images/header.png'),
                                fit: BoxFit.fill)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                child: CircleAvatar(
                                  foregroundImage:
                                      AssetImage('assets/images/user.png'),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Hi, ",
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "Paryono",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "PT. SOLUSI INTEK INDONESIA",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: width / 1.8,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgIcon(
                              'assets/images/calendar_filled.svg',
                              width: 32,
                              height: 32,
                              color: LightColors.oldBlue,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Senin, ",
                              style: TextStyle(
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13),
                            ),
                            Text(
                              "25 Maret 2022",
                              style:
                                  TextStyle(fontFamily: "Lato", fontSize: 13),
                            )
                          ],
                        ),
                        // child: Text(
                        //   "Hello",
                        //   style: TextStyle(color: Colors.black),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
