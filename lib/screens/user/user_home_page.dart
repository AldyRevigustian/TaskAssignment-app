import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_planner_app/cardExpandActive.dart';
import 'package:flutter_task_planner_app/cardExpandNon.dart';
import 'package:flutter_task_planner_app/helpers/get_helper.dart';
import 'package:flutter_task_planner_app/notificationservice/local_notification_service.dart';
import 'package:flutter_task_planner_app/provider/parent.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/loading_alert.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svg_icon/svg_icon.dart';
import 'package:intl/intl.dart';

// List<Task> listOfDownloadedFile = List();
// listOfDownloadedFile.add(...);

// var

class UserMainPage extends StatefulWidget {
  final String id;
  UserMainPage({
    Key key,
    @required this.id,
  }) : super(key: key);
  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  Future listTask;
  static const String routeName = "/homePage";
  String parentName;
  String parentAvatar;
  String parentId;
  String usrId;
  ParentInf getParentInfo;

  DateFormat formatHari;

  DateFormat formatTanggal;

  DateFormat formatTahun;

  DateTime now = DateTime.now();

  var dateTime = new DateTime.now();

  // void getId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   usrId = prefs.getString('id');
  // }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  void initState() {
    // getId();
    initializeDateFormatting();
    formatHari = new DateFormat.EEEE('id');
    formatTanggal = DateFormat.MMMMd('id');
    formatTahun = DateFormat.y('id');
    // listTask = GetHelper().fetchTask(widget.id);
    fetchandrefresh();
    // listTask = GetHelper().fetchTask
    // _refreshProducts(context);

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification.title);
          print(message.notification.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification.title);
          print(message.notification.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
    super.initState();
  }

  showLoadingProgress() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoadingAlert();
        });
  }

  Future<void> _refreshProducts(BuildContext context) async {
    return fetchandrefresh();
  }

  void fetchandrefresh() {
    listTask = GetHelper().fetchTask(widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    getParentInfo = Provider.of<Parent>(context).getParentInf();
    parentName = getParentInfo.name;
    parentAvatar = getParentInfo.image_profile;
    parentId = getParentInfo.id.toString();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(dateTime);
    log(parentName);
    log(parentId);

    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  height: height,
                  width: 1.8,
                  color: LightColors.mainBlue.withOpacity(0.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  height: height,
                  width: 1.8,
                  color: LightColors.mainBlue.withOpacity(0.5),
                ),
              ),
              // SizedBox(
              //   width: 2,
              // ),
              // Container(
              //   height: height,
              //   width: 1,
              //   color: LightColors.mainBlue,
              // ),
              // SizedBox(
              //   width: 2,
              // ),
              // Container(
              //   height: height,
              //   width: 1,
              //   color: LightColors.mainBlue,
              // ),
            ],
          ),
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();

              return;
            },
            child: RefreshIndicator(
              onRefresh: () {
                return _refreshProducts(context);
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          height: height / 3.1,
                        ),
                        FutureBuilder(
                          future: listTask,
                          builder: (
                            BuildContext context,
                            AsyncSnapshot snapshot,
                          ) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return AlertDialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                insetPadding: EdgeInsets.symmetric(
                                    horizontal: 150, vertical: 150),
                                content: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 100,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                LightColors.mainBlue),
                                      ),
                                    )),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Text('Error');
                              } else if (snapshot.hasData) {
                                return snapshot.data.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, top: 30),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  height: 30,
                                                  width: 50,
                                                  // child: Container(
                                                  //   width: 1,
                                                  //   height: 1,
                                                  //   decoration: BoxDecoration(
                                                  //       color: Colors.white,
                                                  //       borderRadius:
                                                  //           BorderRadius
                                                  //               .circular(50)),
                                                  // ),
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          LightColors.mainBlue,
                                                      borderRadius: BorderRadius
                                                          .horizontal(
                                                              right: Radius
                                                                  .circular(
                                                                      50))),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Main Task",
                                                  style: TextStyle(
                                                      fontFamily: "Lato",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          LightColors.oldBlue,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 40,
                                                ),
                                                Text("No Task Available",
                                                    style: TextStyle(
                                                        fontFamily: "Lato",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: LightColors
                                                            .lightBlack
                                                            .withOpacity(0.3),
                                                        fontSize: 15)),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0, top: 30),
                                            child: Row(
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  height: 40,
                                                  width: 50,
                                                  // child: Container(
                                                  //   width: 1,
                                                  //   height: 1,
                                                  //   decoration: BoxDecoration(
                                                  //       color: Colors.white,
                                                  //       borderRadius:
                                                  //           BorderRadius
                                                  //               .circular(50)),
                                                  // ),
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          LightColors.mainBlue,
                                                      borderRadius: BorderRadius
                                                          .horizontal(
                                                              right: Radius
                                                                  .circular(
                                                                      50))),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  "Main Task",
                                                  style: TextStyle(
                                                      fontFamily: "Lato",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          LightColors.oldBlue,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListView.builder(
                                            padding: EdgeInsets.only(
                                              top: 5,
                                            ),
                                            shrinkWrap: true,
                                            primary: false,
                                            itemCount: snapshot.data == null
                                                ? 0
                                                : snapshot.data.length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return (snapshot
                                                          .data[index].status ==
                                                      "On Progress")
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 40),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 25,
                                                                    top: 5,
                                                                    bottom: 5),
                                                            child:
                                                                CardExpandActive(
                                                              id: snapshot
                                                                  .data[index]
                                                                  .id,
                                                              status: snapshot
                                                                  .data[index]
                                                                  .status,
                                                              title: snapshot
                                                                  .data[index]
                                                                  .title,
                                                              description: snapshot
                                                                  .data[index]
                                                                  .description,
                                                              created_at: snapshot
                                                                  .data[index]
                                                                  .created_at,
                                                              updated_at: snapshot
                                                                  .data[index]
                                                                  .updated_at,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 0,
                                                    );
                                            },
                                          ),
                                        ],
                                      );
                              } else {
                                return Text('Empty data');
                              }
                            } else {
                              return Text('State: ${snapshot.connectionState}');
                            }
                          },
                        ),
                        FutureBuilder(
                          future: listTask,
                          builder: (
                            BuildContext context,
                            AsyncSnapshot snapshot,
                          ) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Text('Error');
                              } else if (snapshot.hasData) {
                                return snapshot.data.isEmpty
                                    ? Center()
                                    : Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 0,
                                              top: 20,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  height: 40,
                                                  width: 50,
                                                  // child: Container(
                                                  //   width: 1,
                                                  //   height: 1,
                                                  //   decoration: BoxDecoration(
                                                  //       color: Colors.white,
                                                  //       borderRadius:
                                                  //           BorderRadius
                                                  //               .circular(50)),
                                                  // ),
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          LightColors.mainBlue,
                                                      borderRadius: BorderRadius
                                                          .horizontal(
                                                              right: Radius
                                                                  .circular(
                                                                      50))),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  "Completed Task",
                                                  style: TextStyle(
                                                      fontFamily: "Lato",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          LightColors.oldBlue,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListView.builder(
                                            padding: EdgeInsets.only(
                                              top: 5,
                                            ),
                                            shrinkWrap: true,
                                            primary: false,
                                            itemCount: snapshot.data == null
                                                ? 0
                                                : snapshot.data.length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return (snapshot
                                                          .data[index].status !=
                                                      "On Progress")
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 40),
                                                      child: Column(
                                                        children: [
                                                          // SizedBox(
                                                          //   height: 10,
                                                          // ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 25,
                                                                    top: 5,
                                                                    bottom: 5),
                                                            child:
                                                                CardExpandNon(
                                                              status: snapshot
                                                                  .data[index]
                                                                  .status,
                                                              title: snapshot
                                                                  .data[index]
                                                                  .title,
                                                              description: snapshot
                                                                  .data[index]
                                                                  .description,
                                                              created_at: snapshot
                                                                  .data[index]
                                                                  .created_at,
                                                              updated_at: snapshot
                                                                  .data[index]
                                                                  .updated_at,
                                                              image: snapshot
                                                                  .data[index]
                                                                  .image,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 0,
                                                    );
                                            },
                                          ),
                                        ],
                                      );
                              } else {
                                return Container(
                                  height: height / 2,
                                  child: Column(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/no_task2.png",
                                        width: 100,
                                        height: 100,
                                        opacity: AlwaysStoppedAnimation(0.3),
                                      ),

                                      // Container(
                                      //   height: 100,
                                      //   width: 100,
                                      //   decoration: BoxDecoration(
                                      //       image: DecorationImage(
                                      //           image: AssetImage(
                                      //               "assets/images/no_task.png"),
                                      //           opacity: 0.3,
                                      //           colorFilter: ColorFilter.mode(
                                      //               Colors.grey,
                                      //               BlendMode.color))),
                                      // ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text("No Task Available",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              fontWeight: FontWeight.w400,
                                              color: LightColors.lightBlack
                                                  .withOpacity(0.5),
                                              fontSize: 11)),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              return Text('State: ${snapshot.connectionState}');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: height / 2.9,
                    child: Stack(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        //   child: Container(
                        //     height: height / 3.51,
                        //     decoration: BoxDecoration(
                        //       color: Color(0xFFD9F2F9),
                        //       borderRadius: BorderRadius.only(
                        //           bottomLeft: Radius.circular(50)),
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        //   child: Container(
                        //     height: height / 3.61,
                        //     decoration: BoxDecoration(
                        //       color: Color(0xFFAEE5F4),
                        //       borderRadius: BorderRadius.only(
                        //           bottomLeft: Radius.circular(50)),
                        //     ),
                        //   ),
                        // ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: height / 3.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25),
                                    topRight: Radius.circular(0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.2),
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                                // borderRadius: BorderRadius.only(
                                //     bottomLeft: Radius.circular(20),
                                //     bottomRight: Radius.circular(20)),
                                color: LightColors.mainBlue,
                                image: DecorationImage(
                                    opacity: 0.8,
                                    image:
                                        AssetImage('assets/images/header.png'),
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
                                        foregroundImage: (parentAvatar == null
                                            ? new AssetImage(
                                                "assets/images/user.png")
                                            : new NetworkImage(parentAvatar))
                                        // AssetImage(
                                        //     "assets/images/user.png"),
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
                                            Container(
                                              width: width / 2.5,
                                              child: Text(
                                                capitalize(parentName),
                                                // "sadkoaskdopaskdopkasopdkasopkdoaspkdoaskdopaskdopaskdpkasopdkaspodkasokdopaskdoasdoask",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
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
                                  formatHari.format(dateTime) + ", ",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                ),
                                Text(
                                  formatTanggal.format(dateTime) +
                                      " " +
                                      formatTahun.format(dateTime),
                                  style: TextStyle(
                                      fontFamily: "Montserrat", fontSize: 13),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}