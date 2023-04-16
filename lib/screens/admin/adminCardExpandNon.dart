import 'dart:async';
import 'dart:math';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_task_planner_app/helpers/get_helper.dart';
import 'package:flutter_task_planner_app/screens/user/user_menu_bottom_bar.dart';

import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../widget/custAlert.dart';
import 'admin_menu_bottom_bar.dart';
import '../detail.dart';

class AdminCardExpandNon extends StatefulWidget {
  final String status;
  final String id;
  final String title;
  final String description;
  final String image;
  final String name;
  final String date;
  final String token;
  GlobalKey<ExpansionTileCardState> idCard;

  AdminCardExpandNon({
    Key key,
    @required this.status,
    @required this.id,
    @required this.name,
    @required this.title,
    @required this.description,
    @required this.image,
    @required this.date,
    @required this.token,
  }) : super(key: key);

  @override
  State<AdminCardExpandNon> createState() => _AdminCardExpandNonState();
}

class _AdminCardExpandNonState extends State<AdminCardExpandNon> {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  final _descController = TextEditingController();

  showImage(String path) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailScreen(
            pathImage: URL + path,
          );
        }));
      },
      child: Hero(
        tag: path + Random().toString(),
        child: Image.network(
          URL + path,
          width: MediaQuery.of(context).size.width,
          height: 100,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 100,
              height: 100,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  DateFormat formatTanggal;
  DateFormat formatJam;

  void initState() {
    formatTanggal = DateFormat.MMMMEEEEd('id');
    formatJam = DateFormat.jm('id');
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
    if (status == "Complete") {
      return FluentIcons.checkmark_circle_32_regular;
    } else if (status == "On Progress") {
      return FluentIcons.error_circle_24_regular;
    } else {
      return FluentIcons.dismiss_circle_24_regular;
    }
  }

  colorStatus(String colorStatus) {
    if (colorStatus == "Complete") {
      return LightColors.lightGreen;
    } else if (colorStatus == "On Progress") {
      return LightColors.lightYellow;
    } else {
      return LightColors.lightRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
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
                capitalize(widget.name),
                style: TextStyle(
                    fontFamily: "Lato",
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
                    controller: _descController,
                    readOnly: true,
                    style: TextStyle(
                        color: LightColors.lightBlack,
                        fontSize: 14,
                        fontFamily: "Lato"),
                    maxLines: 5,
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
          widget.image != "null"
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: showImage(widget.image),
                    ),
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
                      FluentIcons.delete_20_filled,
                      color: LightColors.lightRed,
                      // color: Color.fromRGBO(160, 160, 160, 0.7),
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
