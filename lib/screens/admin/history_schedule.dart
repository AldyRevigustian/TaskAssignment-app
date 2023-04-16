import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_task_planner_app/helpers/get_helper.dart';
import 'package:flutter_task_planner_app/screens/admin/adminCardExpandNon.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:svg_icon/svg_icon.dart';
import 'package:intl/intl.dart';

import '../user/userCardExpandNon.dart';

class HistorySchedule extends StatefulWidget {
  final String tanggal;
  final String token;
  HistorySchedule({
    Key key,
    @required this.tanggal,
    @required this.token,
  }) : super(key: key);
  @override
  State<HistorySchedule> createState() => _HistoryScheduleState();
}

class _HistoryScheduleState extends State<HistorySchedule> {
  DateTime _dateTime;
  Future listTask;
  static const String routeName = "/homePage";

  DateFormat formatHari;
  DateFormat formatTanggal;
  DateFormat formatTahun;

  DateTime now = DateTime.now();

  var dateTime = new DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  void initState() {
    initializeDateFormatting();
    formatHari = new DateFormat.EEEE('id');
    formatTanggal = DateFormat.MMMMd('id');
    formatTahun = DateFormat.y('id');
    listTask = GetHelper().history(
        _dateTime == null ? widget.tanggal : formatter.format(_dateTime),
        widget.token);
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
    listTask = GetHelper().history(
        _dateTime == null ? widget.tanggal : formatter.format(_dateTime),
        widget.token);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    log(widget.tanggal + "skrg");
    String formatted = formatter.format(now);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                  color: LightColors.oldBlue.withOpacity(0.5),
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
                          height: height / 5.5,
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
                                    horizontal: 140, vertical: width / 1.5),
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
                                        height: height / 1.5,
                                        child: Column(
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
                                            Text("No History Available",
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
                                                  "History",
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
                                                              image: snapshot
                                                                  .data[index]
                                                                  .image,
                                                              date: snapshot
                                                                  .data[index]
                                                                  .date,
                                                              name: snapshot
                                                                  .data[index]
                                                                  .user,
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
                      ],
                    ),
                  ),
                  Container(
                    height: height / 5,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: height / 6,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                    topRight: Radius.circular(0)),
                                color: LightColors.mainBlue,
                                image: DecorationImage(
                                    opacity: 0.3,
                                    image:
                                        AssetImage('assets/images/cloud.png'),
                                    fit: BoxFit.fitWidth)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: _dateTime == null
                                    ? DateTime.now()
                                    : _dateTime,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2200),
                              ).then((date) {
                                setState(() {
                                  _dateTime = date;
                                });

                                log(_dateTime.toString() + "Rubah");
                                fetchandrefresh();
                              });
                            },
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
                                    formatHari.format(_dateTime == null
                                            ? DateTime.parse(widget.tanggal)
                                            : _dateTime) +
                                        ", ",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: LightColors.oldBlue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  ),
                                  Text(
                                    formatTanggal.format(_dateTime == null
                                            ? DateTime.parse(widget.tanggal)
                                            : _dateTime) +
                                        " " +
                                        formatTahun.format(_dateTime == null
                                            ? DateTime.parse(widget.tanggal)
                                            : _dateTime),
                                    style: TextStyle(
                                        fontFamily: "Montserrat", fontSize: 13),
                                  )
                                ],
                              ),
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
