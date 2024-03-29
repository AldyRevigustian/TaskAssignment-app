import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_task_planner_app/helpers/get_helper.dart';
import 'package:flutter_task_planner_app/screens/user/userDetailScreen.dart';
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

class UserCardExpandActive extends StatefulWidget {
  final String id;
  final String status;
  final String title;
  final String description;
  final String date;
  final String token;
  GlobalKey<ExpansionTileCardState> idCard;

  UserCardExpandActive({
    Key key,
    @required this.id,
    @required this.status,
    @required this.title,
    @required this.description,
    @required this.date,
    @required this.token,
  }) : super(key: key);

  @override
  State<UserCardExpandActive> createState() => _UserCardExpandActiveState();
}

class _UserCardExpandActiveState extends State<UserCardExpandActive> {
  File imageFile;
  String imageData;
  String imagePath;

  final _descController = TextEditingController();

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  pickImage() async {
    try {
      var image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 15);
      if (image == null) return;

      setState(() {
        imagePath = image.path;
        imageFile = File(image.path);
      });
      print(imageFile);
      return imageFile;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      setState(() {
        imageFile = File(image.path);
      });
      imageData = base64Encode(imageFile.readAsBytesSync());
      return imageData;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  DateFormat formatTanggal;
  DateFormat formatJam;

  final picker = ImagePicker();

  void initState() {
    formatTanggal = DateFormat.MMMMEEEEd('id');
    formatJam = DateFormat.Hm('id');

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.1),
          blurRadius: 5,
        )
      ], borderRadius: BorderRadius.circular(8)),
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
        title: Text(
          capitalize(widget.title),
          style: TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.bold,
              color: LightColors.lightBlack,
              fontSize: formatSize(widget.title)),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Row(
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
                    // autofocus: true,
                    controller: _descController,
                    maxLines: 5,
                    style: TextStyle(
                        color: LightColors.lightBlack,
                        fontSize: 14,
                        fontFamily: "Lato"),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: (widget.description != null)
                            ? capitalize(widget.description)
                            : "",
                        hintStyle: TextStyle(
                            color: LightColors.lightBlack,
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
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.3),
                                width: 0.8))),
                  ),
                )),
          ),
          imageFile != null
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return UserDetailScreen(
                                pathImage: imageFile,
                              );
                            }));
                          },
                          child: Hero(
                            tag: imageFile.toString() + Random().toString(),
                            child: Image.file(
                              imageFile,
                              width: width,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                  ),
                )
              : Center(),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
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
                      FluentIcons.dismiss_circle_20_filled,
                      color: Color.fromRGBO(160, 160, 160, 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Text(
                      'Incomplete',
                      style: TextStyle(
                          fontFamily: "Lato",
                          color: LightColors.lightBlack,
                          fontSize: 10),
                    ),
                  ],
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                onPressed: () {
                  pickImage();
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      FluentIcons.camera_20_filled,
                      color: Color.fromRGBO(160, 160, 160, 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(
                          fontFamily: "Lato",
                          color: LightColors.lightBlack,
                          fontSize: 10),
                    ),
                  ],
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                onPressed: () async {
                  if (imagePath == null) {
                    Fluttertoast.showToast(
                        msg: "Please add Image",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                        fontSize: 12.0);
                  } else {
                    _showAlertCompleteDialog();
                  }
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      FluentIcons.save_20_filled,
                      color: Color.fromRGBO(160, 160, 160, 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Text(
                      'Complete',
                      style: TextStyle(
                          fontFamily: "Lato",
                          color: LightColors.lightBlack,
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
        height: 290,
        context: context,
        title: "Incomplete Task",
        onSubmitOk: () async {
          showLoadingProgress(context);
          if (imagePath == null) {
            bool res = await GetHelper().updateTask(
                widget.id,
                "Incomplete",
                null,
                _descController.text == ""
                    ? widget.description
                    : _descController.text,
                widget.token);
            if (res) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => UserMenuBottomBarPage()),
                ModalRoute.withName('/home'),
              );
              Fluttertoast.showToast(
                  msg: "Successfully set task as incompleted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 12.0);
            } else {
              Fluttertoast.showToast(
                  msg: "Failed set task as incompleted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 12.0);
              print("gagal");
            }
          } else {
            bool res = await GetHelper().updateTask(
                widget.id,
                "Incomplete",
                imagePath.toString(),
                _descController.text == ""
                    ? widget.description
                    : _descController.text,
                widget.token);
            if (res) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => UserMenuBottomBarPage()),
                ModalRoute.withName('/home'),
              );
              Fluttertoast.showToast(
                  msg: "Successfully set task as incompleted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 12.0);
            } else {
              Fluttertoast.showToast(
                  msg: "Failed set task as incompleted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 12.0);
              print("gagal");
            }
          }
        },
        onSubmitCancel: () {
          Navigator.of(context).pop();
        },
        detailContent: "Are you sure you will report this task as incompleted?",
        pathLottie: "warning");
  }

  Future<void> _showAlertCompleteDialog() {
    return showCustAlertDouble(
        height: 290,
        context: context,
        title: "Complete Task",
        onSubmitOk: () async {
          if (imagePath == null) {
            Fluttertoast.showToast(
                msg: "Please add Image",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            showLoadingProgress(context);
            bool res = await GetHelper().updateTask(
                widget.id,
                "Complete",
                imagePath.toString(),
                _descController.text == ""
                    ? widget.description
                    : _descController.text,
                widget.token);

            if (res == true) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => UserMenuBottomBarPage()),
                ModalRoute.withName('/home'),
              );
              Fluttertoast.showToast(
                  msg: "Success set task as completed",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 12.0);
            } else {
              Fluttertoast.showToast(
                  msg: "Failed set task as completed",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 12.0);
              print("gagal");
            }
          }
        },
        onSubmitCancel: () {
          Navigator.of(context).pop();
        },
        detailContent: "Are you sure you will report this task as Completed?",
        pathLottie: "warning");
  }
}

showLoadingProgress(BuildContext context) {
  showDialog(
      barrierDismissible: false,
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
