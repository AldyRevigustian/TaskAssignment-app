import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_task_planner_app/cardExpandActive.dart';
import 'package:flutter_task_planner_app/cardExpandNon.dart';
import 'package:flutter_task_planner_app/helpers/get_helper.dart';
import 'package:flutter_task_planner_app/notificationservice/local_notification_service.dart';
import 'package:flutter_task_planner_app/provider/parent.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/const.dart';
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

class AdminMainPage extends StatefulWidget {
  final String id;
  AdminMainPage({
    Key key,
    @required this.id,
  }) : super(key: key);
  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  Future listTask;
  static const String routeName = "/homePage";
  String parentName;
  String parentAvatar;
  String parentId;
  String usrId;
  String tokens = "";
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
  String deviceTokenToSendPushNotification = "";
  void initState() {
    initializeDateFormatting();
    formatHari = new DateFormat.EEEE('id');
    formatTanggal = DateFormat.MMMMd('id');
    formatTahun = DateFormat.y('id');
    // listTask = GetHelper().fetchTask(widget.id);
    fetchandrefresh();
    // listTask = GetHelper().fetchTask
    // _refreshProducts(context);
    super.initState();
  }

  showLoadingProgress(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Center(
                // Aligns the container to center
                child: Container(
              // A simplified version of dialog.
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

  Future<void> _refreshProducts(BuildContext context) async {
    return fetchandrefresh();
  }

  void fetchandrefresh() {
    listTask = GetHelper().fetchTask(widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController title = new TextEditingController();
    TextEditingController desc = new TextEditingController();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    getParentInfo = Provider.of<Parent>(context).getParentInf();
    parentName = getParentInfo.name;
    parentAvatar = getParentInfo.avatar;
    parentId = getParentInfo.id.toString();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // print(dateTime);
    // log(parentName);
    // log(parentId);

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
                    child: Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: Column(children: [
                        Container(
                          height: height / 2,
                        ),
                        TextFormField(
                          controller: title,
                        ),
                        TextFormField(
                          controller: desc,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              GetHelper().postSchedule(
                                  "3", title.text, desc.text, "2022-05-23");
                              GetHelper().notif(
                                  "eM4amWXEQuiZDdZXESPu98:APA91bFhep19JnjDn4FnL_OOx9JgH_h4VeOgw1oC6bm0qqW8sOM7fPh5bD_n0twO5b0ikiP7nAZJ9GwhcKS_3oZNZ-TMzi2PVl4OQmPG2t3jXmzTTNCWd-R_LI3TUyQQRfpxVESkPeNL",
                                  title.text,
                                  desc.text);
                              title.clear();
                              desc.clear();
                            },
                            child: Text('send')),
                      ]),
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
                                            : new NetworkImage(LINKAPI +
                                                "storage/pp/" +
                                                parentAvatar))
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
                                        ),
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
