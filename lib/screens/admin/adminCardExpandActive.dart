import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_planner_app/helpers/get_helper.dart';
import 'package:flutter_task_planner_app/screens/user/user_home_page.dart';

import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/screens/user/user_menu_bottom_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import '../../widget/custAlert.dart';
import 'admin_menu_bottom_bar.dart';

class AdminCardExpandActive extends StatefulWidget {
  final String id;
  final String status;
  final String title;
  final String description;
  final String name;
  final String date;
  final String token;
  GlobalKey<ExpansionTileCardState> idCard;

  AdminCardExpandActive({
    Key key,
    @required this.id,
    @required this.status,
    @required this.title,
    @required this.description,
    @required this.name,
    @required this.date,
    @required this.token,
  }) : super(key: key);

  @override
  State<AdminCardExpandActive> createState() => _AdminCardExpandActiveState();
}

class _AdminCardExpandActiveState extends State<AdminCardExpandActive> {
  File imageFile;
  String imageData;
  String imagePath;

  final _descController = TextEditingController();

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  DateFormat formatTanggal;
  DateFormat formatJam;

  final picker = ImagePicker();

  void initState() {
    formatTanggal = DateFormat.MMMMEEEEd('id');
    formatJam = DateFormat.Hm('id');

    _descController.text = widget.description;

    super.initState();
  }

  formatSize(String formatSize) {
    if (formatSize.length > 15) {
      return 14.00;
    } else {
      return 14.00;
    }
  }

  iconStatus(String status) {
    return FluentIcons.error_circle_24_regular;
  }

  colorStatus(String colorStatus) {
    return LightColors.lightYellow;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.name);
    // String title = "Menyapu Lantai";
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      // height: 80,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 5)
      ], borderRadius: BorderRadius.circular(10)),
      child: ExpansionTileCard(
        elevation: 0,
        baseColor: Colors.white,
        expandedColor: Colors.white,
        key: widget.idCard,
        leading: Icon(
          iconStatus(widget.status),
          color: colorStatus(widget.status),
          size: 40,
        ),
        // animateTrailing: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            capitalize(widget.title),
            style: TextStyle(
                fontFamily: "Lato",
                fontWeight: FontWeight.bold,
                color: LightColors.lightBlack,
                fontSize: formatSize(widget.title)),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // 'sasasdasd',
                capitalize(widget.name),
                style: TextStyle(
                    fontFamily: "Lato",
                    // fontWeight: FontWeight.bold,
                    color: LightColors.lightBlack.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                    fontSize: 11),
              ),
              Row(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        formatTanggal.format(DateTime.parse(widget.date)),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Lato",
                            color: LightColors.lightBlack.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                            fontSize: 11),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Icon(
                          FluentIcons.clock_12_filled,
                          size: 12,
                          color: LightColors.lightBlack.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        formatJam.format(DateTime.parse(widget.date)),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Lato",
                            color: LightColors.lightBlack.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                            fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 3.0,
                ),
                child: Container(
                  child: TextFormField(
                    readOnly: true,
                    controller: _descController,
                    maxLines: 5,
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        fontSize: 14,
                        fontFamily: "Lato"),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: (widget.description != null)
                            ? capitalize(widget.description)
                            : "",
                        hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: "Lato"),
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.3),
                                width: 0.8)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.3),
                                width: 0.8)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.3),
                                width: 0.8)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.3),
                                width: 0.8))),
                  ),
                )),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            buttonHeight: 20.0,
            buttonMinWidth: 50.0,
            children: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                onPressed: () {
                  _showAlertDialog();
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      FluentIcons.delete_20_filled,
                      color: LightColors.lightRed,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Text(
                      'Delete',
                      style: TextStyle(
                          fontFamily: "Lato",
                          color: LightColors.lightRed,
                          fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showAlertDialog() {
    return showCustAlertDouble(
        height: 280,
        context: context,
        title: "Delete Task",
        // buttonString: "OK",
        onSubmitOk: () async {
          showLoadingProgress(context);
          bool res = await GetHelper().deleteTask(widget.id, widget.token);
          if (res) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AdminMenuBottomBarPage()),
              ModalRoute.withName('/home'),
            );
            Fluttertoast.showToast(
                msg: "Successfully delete task ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            Fluttertoast.showToast(
                msg: "Failed delete task ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 12.0);
            print("gagal");
          }
        },
        onSubmitCancel: () {
          Navigator.of(context).pop();
        },
        detailContent: "Are you sure you want delete this task ?",
        pathLottie: "warning");
  }
}
