import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/provider/parent.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:svg_icon/svg_icon.dart';

import '../expansion_tile_card_demo.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  // final GlobalKey<ExpansionTileCardState> cardB = new GlobalKey();
  // final GlobalKey<ExpansionTileCardState> cardC = new GlobalKey();
  // final GlobalKey<ExpansionTileCardState> cardD = new GlobalKey();
  static const String routeName = "/homePage";
  String parentName;
  String parentAvatar;
  ParentInf getParentInfo;

  @override
  Widget build(BuildContext context) {
    getParentInfo = Provider.of<Parent>(context).getParentInf();
    parentName = getParentInfo.name;
    parentAvatar = getParentInfo.image_profile;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();

            return;
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Container(
                  height: height,
                  width: 1,
                  color: LightColors.mainBlue,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: height / 3.3,
                      child: Stack(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                          //   child: Container(
                          //     height: height / 3.51,
                          //     decoration: BoxDecoration(
                          //       color: Color(0xFFD9F2F9),
                          //       borderRadius: BorderRadius.circular(5),
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          //   child: Container(
                          //     height: height / 3.61,
                          //     decoration: BoxDecoration(
                          //       color: Color(0xFFAEE5F4),
                          //       borderRadius: BorderRadius.circular(5),
                          //     ),
                          //   ),
                          // ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: height / 3.7,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.2),
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  color: LightColors.mainBlue,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/header.png'),
                                      fit: BoxFit.fitWidth)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      child: CircleAvatar(
                                        foregroundImage:
                                            // (parentAvatar == null
                                            //     ? new AssetImage(
                                            //         "assets/images/user.png")
                                            //     : new NetworkImage(parentAvatar))
                                            AssetImage(
                                                "assets/images/user.png"),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                capitalize(parentName),
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "PT. SOLUSI INTEK INDONESIA",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                    )
                                  ],
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
                                    style: TextStyle(
                                        fontFamily: "Lato", fontSize: 13),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 20),
                      child: Column(
                        children: [
                          Container(
                            // height: height,
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: LightColors.mainBlue,
                                          width: 5)),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Main Task",
                                  style: TextStyle(
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.w700,
                                      color: LightColors.oldBlue,
                                      fontSize: 20),
                                )
                              ],
                            ),
                            // color: Colors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                CardExpand(
                                    status: "progress",
                                    title: "Mengisi Galon Lantai 3",
                                    description: ""),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                CardExpand(
                                    status: "progress",
                                    title: "Membeli Gorengan",
                                    description: ""),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                CardExpand(
                                    status: "progress",
                                    title: "Membeli Kopi",
                                    description: ""),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            // height: height,
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: LightColors.mainBlue,
                                          width: 5)),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Completed Task",
                                  style: TextStyle(
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.w700,
                                      color: LightColors.oldBlue,
                                      fontSize: 20),
                                )
                              ],
                            ),

                            // color: Colors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                CardExpand(
                                    status: "error",
                                    title: "Membersihkan Kaca",
                                    description: ""),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                CardExpand(
                                    status: "done",
                                    title: "Menyapu Lantai 3",
                                    description: ""),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
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
