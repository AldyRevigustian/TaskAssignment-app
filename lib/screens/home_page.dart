import 'dart:convert';
import 'dart:math';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/expansion_tile_card_demo.dart';
import 'package:flutter_task_planner_app/helpers/get_helper.dart';
import 'package:flutter_task_planner_app/provider/parent.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/loading_alert.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:svg_icon/svg_icon.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_task_planner_app/model/piketModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<List<Task>> fetchTask() async {
  final response = await http.get(Uri.parse(
      'https://624e8ad153326d0cfe5c1a33.mockapi.io/api/task/listTask'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // return Task.fromJson(json.decode(response.body));
    // final data = convert.jsonDecode(response.body);
    // Task template = Task.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    // return [
    //   for (final item in jsonDecode(response.body)) Task.fromJson(item),
    // ];
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((job) => new Task.fromJson(job)).toList();

    // AdTemplate template = AdTemplate.fromJson(data[0]);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Task');
  }
}

class Task {
  // final int userId;

  final String id;
  final String status;
  final String title;
  final String description;
  final String timestamp;

  const Task({
    @required this.id,
    @required this.status,
    @required this.title,
    @required this.timestamp,
    @required this.description,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      // userId: json['userId'],
      id: json['id'],
      status: json['status'],
      title: json['title'],
      description: json['description'],
      timestamp: json['timestamp'],
    );
  }
}

// List<Task> listOfDownloadedFile = List();
// listOfDownloadedFile.add(...);

// var

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future listTask;

  // final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  // final GlobalKey<ExpansionTileCardState> cardB = new GlobalKey();
  // final GlobalKey<ExpansionTileCardState> cardC = new GlobalKey();
  // final GlobalKey<ExpansionTileCardState> cardD = new GlobalKey();
  static const String routeName = "/homePage";
  String parentName;
  String parentAvatar;
  ParentInf getParentInfo;

  DateFormat formatHari;

  DateFormat formatTanggal;

  DateFormat formatTahun;

  DateTime now = DateTime.now();

  var dateTime = new DateTime.now();

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  // void initState() {
  //   listTask = GetHelper.getData();

  //   super.initState();
  // }
  void initState() {
    listTask = fetchTask();
    super.initState();
    initializeDateFormatting();
    initializeDateFormatting();
    formatHari = new DateFormat.EEEE('id');
    formatTanggal = DateFormat.MMMMd('id');
    formatTahun = DateFormat.y('id');
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
    listTask = fetchTask();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getParentInfo = Provider.of<Parent>(context).getParentInf();
    parentName = getParentInfo.name;
    parentAvatar = getParentInfo.image_profile;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Container(
              height: height,
              width: 1,
              color: LightColors.mainBlue,
            ),
          ),
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();

              return;
            },
            child: RefreshIndicator(
              onRefresh: () {
                // return setState(() {
                //   listTask = fetchTask();
                // });
                return _refreshProducts(context);

                // Future.
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
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
                                  // borderRadius: BorderRadius.only(
                                  //     bottomLeft: Radius.circular(20),
                                  //     bottomRight: Radius.circular(20)),
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
                                              Container(
                                                width: 150,
                                                child: Text(
                                                  capitalize(parentName),
                                                  // "sadkoaskdopaskdopkasopdkasopkdoaspkdoaskdopaskdopaskdpkasopdkaspodkasokdopaskdoasdoask",
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                    // ElevatedButton(
                    // onPressed: () {
                    //   listTask = fetchTask();
                    //   setState(() {});
                    // },
                    // child: Text("REFRESH")),
                    // FutureBuilder(
                    //   // future: ReadJsonData(),
                    //   future: listTask,
                    //   builder: (index, snapshot) {
                    //     // var items = snapshot.data as List<ModelCard>;
                    //     if (!snapshot.hasData || snapshot.data.length == 0) {
                    //       return ListView.builder(
                    //         shrinkWrap: true,
                    //         primary: false,
                    //         itemCount:
                    //             snapshot.data == null ? 0 : snapshot.data.length,
                    //         physics: const NeverScrollableScrollPhysics(),
                    //         itemBuilder: (context, index) {
                    //           return Padding(
                    //             padding:
                    //                 const EdgeInsets.symmetric(horizontal: 40),
                    //             child: Column(
                    //               children: [
                    //                 // SizedBox(
                    //                 //   height: 10,
                    //                 // ),
                    //                 // Padding(
                    //                 //   padding: const EdgeInsets.only(
                    //                 //       left: 30, top: 10),
                    //                 //   child: CardExpand(
                    //                 //       status: items[index].status,
                    //                 //       title: items[index].title,
                    //                 //       description: items[index].description),
                    //                 // )
                    //                 Text("No Task")
                    //               ],
                    //             ),
                    //           );
                    //         },
                    //       );
                    //     } else if (snapshot.hasData) {
                    //       return Column(
                    //         children: [
                    //           Padding(
                    //             padding: const EdgeInsets.only(left: 30, top: 20),
                    //             child: Row(
                    //               children: [
                    //                 Container(
                    //                   height: 20,
                    //                   width: 20,
                    //                   decoration: BoxDecoration(
                    //                       color: Colors.white,
                    //                       borderRadius: BorderRadius.circular(20),
                    //                       border: Border.all(
                    //                           color: LightColors.mainBlue,
                    //                           width: 5)),
                    //                 ),
                    //                 SizedBox(
                    //                   width: 20,
                    //                 ),
                    //                 Text(
                    //                   "Main Task",
                    //                   style: TextStyle(
                    //                       fontFamily: "Lato",
                    //                       fontWeight: FontWeight.w700,
                    //                       color: LightColors.oldBlue,
                    //                       fontSize: 20),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           ListView.builder(
                    //             shrinkWrap: true,
                    //             primary: false,
                    //             itemCount: snapshot.data == null
                    //                 ? 0
                    //                 : snapshot.data.length,
                    //             physics: const NeverScrollableScrollPhysics(),
                    //             itemBuilder: (context, index) {
                    //               return Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 40),
                    //                 child: Column(
                    //                   children: [
                    //                     // SizedBox(
                    //                     //   height: 10,
                    //                     // ),
                    //                     Padding(
                    //                       padding: const EdgeInsets.only(
                    //                           left: 30, top: 10, bottom: 5),
                    //                       child: CardExpand(
                    //                           status: snapshot.data[index].status,
                    //                           title: snapshot.data[index].title,
                    //                           description: snapshot
                    //                               .data[index].description),
                    //                     )
                    //                   ],
                    //                 ),
                    //               );
                    //             },
                    //           ),
                    //         ],
                    //       );
                    //     } else {
                    //       return CircularProgressIndicator();
                    //     }
                    //   },
                    // ),
                    FutureBuilder(
                      future: listTask,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot snapshot,
                      ) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return AlertDialog(
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
                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 30, top: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  padding: EdgeInsets.only(top: 10),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: snapshot.data == null
                                      ? 0
                                      : snapshot.data.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return (snapshot.data[index].status ==
                                            "progress")
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40),
                                            child: Column(
                                              children: [
                                                // SizedBox(
                                                //   height: 10,
                                                // ),
                                                // g bner nih
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30,
                                                          top: 5,
                                                          bottom: 5),
                                                  child: CardExpand(
                                                    status: snapshot
                                                        .data[index].status,
                                                    title: snapshot
                                                        .data[index].title,
                                                    description: snapshot
                                                        .data[index]
                                                        .description,
                                                    timestamp: snapshot
                                                        .data[index].timestamp,
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
                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 30, top: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  padding: EdgeInsets.only(top: 10),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: snapshot.data == null
                                      ? 0
                                      : snapshot.data.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return (snapshot.data[index].status !=
                                            "progress")
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40),
                                            child: Column(
                                              children: [
                                                // SizedBox(
                                                //   height: 10,
                                                // ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30,
                                                          top: 5,
                                                          bottom: 5),
                                                  child: CardExpand(
                                                    status: snapshot
                                                        .data[index].status,
                                                    title: snapshot
                                                        .data[index].title,
                                                    description: snapshot
                                                        .data[index]
                                                        .description,
                                                    timestamp: snapshot
                                                        .data[index].timestamp,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<List<ModelCard>> ReadJsonData() async {
  //   final jsondata =
  //       await rootBundle.rootBundle.loadString('assets/piket.json');
  //   final list = json.decode(jsondata) as List<dynamic>;

  //   return list.map((e) => ModelCard.fromJson(e)).toList();
  // }
}
