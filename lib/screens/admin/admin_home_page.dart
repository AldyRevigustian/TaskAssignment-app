import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_task_planner_app/helpers/get_helper.dart';
import 'package:flutter_task_planner_app/provider/identity.dart';
import 'package:flutter_task_planner_app/provider/user.dart';
import 'package:flutter_task_planner_app/screens/admin/admin_menu_bottom_bar.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:svg_icon/svg_icon.dart';
import 'package:intl/intl.dart';
import 'adminCardExpandActive.dart';
import 'adminCardExpandNon.dart';

class AdminMainPage extends StatefulWidget {
  final String id;
  final String token;
  AdminMainPage({
    Key key,
    @required this.id,
    @required this.token,
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
  UserInf getParentInfo;
  IdentityInf getIdentityInfo;
  String companyName;

  DateFormat formatHari;

  DateFormat formatTanggal;

  DateFormat formatTahun;

  DateTime now = DateTime.now();

  var dateTime = new DateTime.now();

  DateTime dets;
  DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
  DateFormat formatterHours = DateFormat('dd/MM/yyyy HH:mm');

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  String deviceTokenToSendPushNotification = "";
  void initState() {
    getSWData();
    initializeDateFormatting();
    formatHari = new DateFormat.EEEE('id');
    formatTanggal = DateFormat.MMMMd('id');
    formatTahun = DateFormat.y('id');

    listTask = GetHelper().getAllTask(widget.token);
    fetchandrefresh();
    super.initState();
  }

  showLoadingProgress(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Center(
                child: Container(
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
    listTask = GetHelper().getAllTask(widget.token);
    getSWData();
    setState(() {});
  }

  List data = List(); //edited line

  Future<String> getSWData() async {
    var res = await http.get(Uri.parse(URL + "api/worker"),
        headers: {'Authorization': 'Bearer' + " " + widget.token});
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
    print(parentAvatar);
    String formatted = formatter.format(now);

    TextEditingController title = new TextEditingController();
    TextEditingController desc = new TextEditingController();
    TextEditingController date = new TextEditingController();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    getParentInfo = Provider.of<User>(context).getUserInf();
    parentName = getParentInfo.name;
    parentAvatar = getParentInfo.avatar;
    parentId = getParentInfo.id.toString();
    getIdentityInfo = Provider.of<Identity>(context).getIdentityInf();
    companyName = getIdentityInfo.company_name;

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
                        insetPadding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        content: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                          return Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    width: width,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ))),
                                      onPressed: () async {
                                        DateTime dateTime =
                                            await showOmniDateTimePicker(
                                          context: context,
                                          type: OmniDateTimePickerType
                                              .dateAndTime,
                                          primaryColor: Colors.cyan,
                                          backgroundColor: Colors.white,
                                          calendarTextColor: Colors.black,
                                          tabTextColor: Colors.black,
                                          unselectedTabBackgroundColor:
                                              Colors.white,
                                          minutesInterval: 10,
                                          buttonTextColor: Colors.black,
                                          timeSpinnerTextStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                          timeSpinnerHighlightedTextStyle:
                                              const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24),
                                          is24HourMode: true,
                                          isShowSeconds: false,
                                          startInitialDate: DateTime.now(),
                                          borderRadius:
                                              const Radius.circular(5),
                                        );
                                        setState(() {
                                          dets = dateTime;
                                        });
                                        print("dateTime: $dateTime");
                                      },
                                      child: Text(formatterHours
                                          .format(dets ?? DateTime.now())),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: DropdownButtonFormField(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),

                                    iconEnabledColor:
                                        LightColors.lightBlack.withOpacity(0.5),
                                    validator: (value) => value == null
                                        ? 'Please fill this field'
                                        : null,
                                    isExpanded: true,
                                    style: TextStyle(
                                        color: LightColors.lightBlack,
                                        fontSize: 15,
                                        fontFamily: "Lato"),
                                    // label
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color:
                                            LightColors.mainBlue.withOpacity(1),
                                      )),
                                      label: Text("Assign To"),
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
                                      setState(() {
                                        _mySelection = newVal;
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
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color:
                                            LightColors.mainBlue.withOpacity(1),
                                      )),
                                      label: Text("Task Title"),
                                    ),
                                    enabled:
                                        (_mySelection == null) ? false : true,
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
                                        borderRadius: BorderRadius.circular(5)),
                                    child: RaisedButton(
                                      color: LightColors.oldBlue,
                                      child: Text(
                                        "Send Task",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          bool res = await GetHelper().postTask(
                                              widget.token,
                                              _mySelection.split(" ")[0].trim(),
                                              title.text,
                                              desc.text,
                                              DateFormat("yyyy-MM-dd HH:mm")
                                                  .format(dets ?? DateTime.now()));
                                          if (res) {
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
                                        }
                                      },
                                    ),
                                  ),
                                ),
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
                                                  "On Progress",
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
                                                              name: snapshot
                                                                  .data[index]
                                                                  .user,
                                                              date: snapshot
                                                                  .data[index]
                                                                  .date,
                                                              token:
                                                                  widget.token,
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
                                                              image: snapshot
                                                                  .data[index]
                                                                  .image,
                                                              name: snapshot
                                                                  .data[index]
                                                                  .user,
                                                              date: snapshot
                                                                  .data[index]
                                                                  .date,
                                                              token:
                                                                  widget.token,
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
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                    topRight: Radius.circular(0)),
                                color: LightColors.mainBlue,
                                image: DecorationImage(
                                    opacity: 0.5,
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
                                                URL + parentAvatar,
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
                                              width: width / 2.3,
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
                                          companyName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
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
                                      color: LightColors.oldBlue,
                                      fontWeight: FontWeight.w600,
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
