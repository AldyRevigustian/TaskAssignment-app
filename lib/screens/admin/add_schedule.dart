import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_task_planner_app/helpers/get_helper.dart';
import 'package:flutter_task_planner_app/provider/parent.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/const.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HistorySchedule extends StatefulWidget {
  @override
  State<HistorySchedule> createState() => _HistoryScheduleState();
}

class _HistoryScheduleState extends State<HistorySchedule> {
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

  void initState() {
    super.initState();
    this.getSWData();
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
    // print(dateTime);
    // log(parentName);
    // log(parentId);

    return Scaffold(
        body: SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(children: [
          TextFormField(
            controller: title,
          ),
          TextFormField(
            controller: desc,
          ),
          Column(
            children: [
              new DropdownButton(
                items: data.map((item) {
                  return new DropdownMenuItem(
                    child: new Text(item['name']),
                    // value: "${item['id']}" "${item['registration']}",
                    value: item["id"].toString() +
                        " " +
                        item["registration"].toString(),
                    // value: item['registration'].toString(),
                  );
                }).toList(),
                onChanged: (newVal) {
                  log(newVal);
                  // log(newVal.split(" ")[0]);
                  // log(newVal.split(" ")[1]);
                  setState(() {
                    _mySelection = newVal;
                    // _mySelection = newVal.split(" ")[0];
                    // regis = newVal.split(" ")[1];
                  });
                },
                value: _mySelection,
              ),
              // _mySelection == null
              //     ? Center()
              //     : Column(
              //         children: [
              //           Text(_mySelection.split(" ")[0]),
              //           Text(_mySelection.split(" ")[1]),
              //         ],
              //       )
            ],
          ),
          // Dropd
          ElevatedButton(
              onPressed: () {
                log(formatted);
                GetHelper().postSchedule(_mySelection.split(" ")[0].trim(),
                    title.text, desc.text, formatted);
                GetHelper().notif(
                    _mySelection.split(" ")[1].trim(), title.text, desc.text);
                // title.clear();
                // desc.clear();
              },
              child: Text('send')),
        ]),
      ),
    ));
  }
}
