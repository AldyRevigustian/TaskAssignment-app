import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_task_planner_app/helpers/get_helper.dart';
import 'package:flutter_task_planner_app/notificationservice/local_notification_service.dart';
import 'package:flutter_task_planner_app/provider/parent.dart';
import 'package:flutter_task_planner_app/screens/admin/admin_menu_bottom_bar.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/const.dart';
import 'package:flutter_task_planner_app/widget/loading_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svg_icon/svg_icon.dart';
import 'package:intl/intl.dart';
import 'adminCardExpandActive.dart';
import 'adminCardExpandNon.dart';

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
  String _mySelection;

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

  DateFormat formatter = DateFormat('yyyy-MM-dd');
  // void getId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   usrId = prefs.getString('id');
  // }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  String deviceTokenToSendPushNotification = "";
  void initState() {
    getSWData();
    initializeDateFormatting();
    formatHari = new DateFormat.EEEE('id');
    formatTanggal = DateFormat.MMMMd('id');
    formatTahun = DateFormat.y('id');
    listTask = GetHelper().getAllTask();
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
    listTask = GetHelper().getAllTask();
    getSWData();
    setState(() {});
  }

  List data = List(); //edited line

  Future<String> getSWData() async {
    var res = await http.get(Uri.parse(LINKAPI + "api/dataOb"),
        headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    String formatted = formatter.format(now);

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

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
          backgroundColor: LightColors.oldBlue,
          child: Icon(FluentIcons.add_20_filled),
          onPressed: () {
            getSWData();
            showDialog(
                barrierDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () {
                      // print("test");
                      // log("test");
                      Navigator.pop(context);
                      setState(() {
                        _mySelection = null;
                      });
                      title.clear();
                      desc.clear();
                      return;
                    },
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                      ),
                      child: AlertDialog(
                        title: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, bottom: 0, top: 10),
                            child: Text(
                              "Add Task",
                              style: TextStyle(
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.bold,
                                  color: LightColors.lightBlack),
                            ),
                          ),
                        ),
                        insetPadding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.only(left: 8, right: 8),
                                //   child: Text("Select Employee"),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 8, right: 8),
                                  child: DropdownButtonFormField(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),

                                    iconEnabledColor:
                                        LightColors.lightBlack.withOpacity(0.5),
                                    validator: (value) => value == null
                                        ? 'Please fill this field'
                                        : null,
                                    isExpanded: true,
                                    // label
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(20),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: LightColors.lightBlack
                                                  .withOpacity(0.5))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                            color: LightColors.mainBlue
                                                .withOpacity(1),
                                          )),
                                      label: Text(
                                        "Assign To",
                                      ),
                                      // hintText: "Assign To",
                                      // hint: Text(),
                                    ),
                                    items: data.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(item['name']),
                                        // value: "${item['id']}" "${item['registration']}",
                                        value: item["id"].toString() +
                                            " " +
                                            item["registration"].toString() +
                                            " " +
                                            item["name"],
                                        // value: item['registration'].toString(),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      log(newVal);
                                      // log(newVal.split(" ")[0]);
                                      // log(newVal.split(" ")[2]);
                                      setState(() {
                                        _mySelection = newVal;
                                        // _mySelection = newVal.split(" ")[0];
                                        // regis = newVal.split(" ")[1];
                                      });
                                    },
                                    value: _mySelection,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 3,

                                    // decoration:
                                    //     InputDecoration(label: Text("Title"), ),
                                    decoration: InputDecoration(
                                      // border: OutlineInputBorder(
                                      //     borderSide: BorderSide(
                                      //         color: LightColors.lightBlack
                                      //             .withOpacity(0.5))),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color:
                                            LightColors.mainBlue.withOpacity(1),
                                      )),
                                      // disabledBorder: UnderlineInputBorder(
                                      //     borderSide: BorderSide(width: 0.3)),
                                      label: Text("Task Title"),
                                      // hintText: "Assign To",
                                      // hint: Text(),
                                    ),
                                    enabled:
                                        (_mySelection == null) ? false : true,
                                    // (_mySelection)
                                    // enabled: ,

                                    controller: title,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the title';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          color: LightColors.mainBlue
                                              .withOpacity(1),
                                        )),
                                        label: Text("Description")),
                                    enabled:
                                        (_mySelection == null) ? false : true,
                                    controller: desc,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the description.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 50, 0, 8),
                                  child: ButtonTheme(
                                    minWidth: width,
                                    height: 50.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: RaisedButton(
                                      color: LightColors.oldBlue,
                                      child: Text(
                                        "Send Task",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          log(formatted);
                                          bool res = await GetHelper()
                                              .postSchedule(
                                                  _mySelection
                                                      .split(" ")[0]
                                                      .trim(),
                                                  title.text,
                                                  desc.text,
                                                  formatted);
                                          if (res) {
                                            GetHelper().notif(
                                                _mySelection
                                                    .split(" ")[1]
                                                    .trim(),
                                                "You have a new task, " +
                                                    _mySelection
                                                        .split(" ")[2]
                                                        .trim() +
                                                    " 📝",
                                                title.text);
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      AdminMenuBottomBarPage()),
                                              ModalRoute.withName('/home'),
                                            );
                                            Fluttertoast.showToast(
                                                msg: "Successfully add task ",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.black54,
                                                textColor: Colors.white,
                                                fontSize: 12.0);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Failed to add task ",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.black54,
                                                textColor: Colors.white,
                                                fontSize: 12.0);
                                          }

                                          // title.clear();
                                          // desc.clear();
                                          // Navigator.pop(context);
                                          // Navigator.pushAndRemoveUntil(context, newRoute, (route) => false)
                                          // _formKey.currentState.save();
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                          ;
                        }),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
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
                                    horizontal: 140, vertical: width / 2),
                                content: Center(
                                  child: SpinKitWave(
                                    color:
                                        LightColors.mainBlue.withOpacity(0.5),
                                    size: 25.0,
                                  ),
                                ),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Text('Error');
                              } else if (snapshot.hasData) {
                                return snapshot.data.isEmpty
                                    ? Container(
                                        height: height / 1.8,
                                        child: Column(
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/no_task2.png",
                                              width: 100,
                                              height: 100,
                                              opacity:
                                                  AlwaysStoppedAnimation(0.3),
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
                                            Text(
                                                'To Add A New Task Press  " + "',
                                                style: TextStyle(
                                                    fontFamily: "Lato",
                                                    fontWeight: FontWeight.w400,
                                                    color: LightColors
                                                        .lightBlack
                                                        .withOpacity(0.5),
                                                    fontSize: 11)),
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
                                                  "All Task",
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
                                                                AdminCardExpandActive(
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
                                                              name: snapshot
                                                                  .data[index]
                                                                  .user_id,
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
                                                  "Submitted Task",
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
                                                                AdminCardExpandNon(
                                                              status: snapshot
                                                                  .data[index]
                                                                  .status,
                                                              id: snapshot
                                                                  .data[index]
                                                                  .id,
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
                                                              name: snapshot
                                                                  .data[index]
                                                                  .user_id,
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
                                    image: AssetImage(
                                        'assets/images/header_admin.png'),
                                    fit: BoxFit.fitWidth)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 100,
                                      width: 100,
                                      child: ClipOval(
                                        child: parentAvatar == null
                                            ? Image.asset(
                                                "assets/images/admin.png")
                                            : Image.network(
                                                LINKAPI +
                                                    "storage/pp/" +
                                                    parentAvatar,
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              ),
                                      )),
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
