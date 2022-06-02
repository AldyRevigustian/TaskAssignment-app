import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_task_planner_app/helpers/get_helper.dart';
import 'package:flutter_task_planner_app/screens/user/user_menu_bottom_bar.dart';

import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../../widget/custAlert.dart';
import 'admin_menu_bottom_bar.dart';
import '../detail.dart';

class AdminCardExpandNon extends StatefulWidget {
  final String status;
  final String id;
  final String title;
  final String description;
  final String created_at;
  final String updated_at;
  final String image;
  final String name;
  GlobalKey<ExpansionTileCardState> idCard;

  AdminCardExpandNon({
    Key key,
    @required this.status,
    @required this.id,
    @required this.name,
    @required this.title,
    @required this.description,
    @required this.created_at,
    @required this.updated_at,
    @required this.image,
  }) : super(key: key);

  @override
  State<AdminCardExpandNon> createState() => _AdminCardExpandNonState();
}

class _AdminCardExpandNonState extends State<AdminCardExpandNon> {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  // showImage(String image) {
  //   return Image.memory(
  //     base64Decode(image),
  //     width: 100,
  //     height: 100,
  //     fit: BoxFit.cover,
  //   );
  // }

  showImage(String path) {
    return GestureDetector(
      onTap: () {
        // log("pencet ni gan");
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailScreen(
            pathImage: LINKAPI + "storage/bukti/" + path,
          );
        }));
      },
      child: Hero(
        tag: path + Random().toString(),
        child:
            // Image.network(LINKAPI + "storage/bukti/" + path,
            //     width: 100,
            //     height: 100,
            //     alignment: Alignment.center,
            //     fit: BoxFit.cover, loadingBuilder: (BuildContext context,
            //         Widget child, ImageChunkEvent loadingProgress) {
            //   if (loadingProgress == null) return child;
            //   return Container(
            //     width: 100,
            //     height: 100,
            //     child: SpinKitWave(
            //       color: LightColors.mainBlue.withOpacity(0.5),
            //       size: 25.0,
            //     ),

            //   );
            // }),
            Image.network(
          LINKAPI + "storage/bukti/" + path,
          width: 100,
          height: 100,
          alignment: Alignment.center,
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
    if (status == "Completed") {
      return FluentIcons.checkmark_circle_32_regular;
    } else if (status == "On Progress") {
      return FluentIcons.error_circle_24_regular;
    } else {
      return FluentIcons.dismiss_circle_24_regular;
    }
  }

  colorStatus(String colorStatus) {
    if (colorStatus == "Completed") {
      return LightColors.lightGreen;
    } else if (colorStatus == "On Progress") {
      return LightColors.lightYellow;
    } else {
      return LightColors.lightRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.image);
    // log(widget.image);
    // String title = "Menyapu Lantai";
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 5)
      ], borderRadius: BorderRadius.circular(10)),
      child: ExpansionTileCard(
        elevation: 0,
        // shadowColor: Color.fromRGBO(0, 0, 0, ),
        baseColor: Colors.white,
        expandedColor: Colors.white,
        key: widget.idCard,
        leading: Icon(
          // FluentIcons.checkmark_circle_32_regular,
          iconStatus(widget.status),
          color: colorStatus(widget.status),
          size: 40,
        ),
        // animateTrailing: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            // "kkdopaskdopaskdsadasdasdasdasdasdasdasdasdasdasdokasopdkasodkaopskdpoakpokfopkerpofkeoprkfoperkfoperkfopkerofpkerpofkeorpkfeorpkfpoerkfporekfperk",
            capitalize(widget.title),
            style: TextStyle(
                fontFamily: "Lato",
                fontWeight: FontWeight.bold,
                color: LightColors.lightBlack,
                fontSize: formatSize(widget.title)),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                capitalize(widget.name),
                style: TextStyle(
                    fontFamily: "Lato",
                    // fontWeight: FontWeight.bold,
                    color: LightColors.lightBlack.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                    fontSize: 11),
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        formatTanggal.format(DateTime.parse(widget.updated_at)),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Lato",
                            // fontWeight: FontWeight.bold,
                            color: (widget.status == "Completed")
                                ? LightColors.lightGreen.withOpacity(0.7)
                                : LightColors.lightRed.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                            fontSize: 11),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Icon(
                          FluentIcons.clock_12_filled,
                          size: 12,
                          color: (widget.status == "Completed")
                              ? LightColors.lightGreen.withOpacity(0.7)
                              : LightColors.lightRed.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        DateFormat('kk : mm')
                            .format(DateTime.parse(widget.updated_at)),
                        style: TextStyle(
                            fontFamily: "Lato",
                            // fontWeight: FontWeight.bold,
                            color: (widget.status == "Completed")
                                ? LightColors.lightGreen.withOpacity(0.7)
                                : LightColors.lightRed.withOpacity(0.7),
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
          // Divider(
          //   thickness: 1.0,
          //   height: 1.0,
          // ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 3.0,
                ),
                child:
                    // Container(
                    //   width: width,
                    //   height: 100,
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //         color: Colors.black,
                    //       ),
                    //       borderRadius: BorderRadius.circular(7)),
                    // ),
                    Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0, 0),
                            blurRadius: 4)
                      ],
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    enabled: false,
                    // decoration: InputDecoration(border: Border),
                    maxLines: 5,
                    style: TextStyle(
                        fontFamily: "Lato",
                        fontSize: 15,
                        color: LightColors.lightBlack),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: (widget.description != null)
                            ? capitalize(widget.description)
                            : "",
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                            fontSize: 15,
                            fontFamily: "Lato"),
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1))),
                  ),
                )),
          ),

          widget.image != "null"
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      // child: Image.file(
                      //   image,
                      //   width: 100,
                      //   height: 100,
                      //   fit: BoxFit.cover,
                      // ),
                      child: showImage(widget.image),
                    ),
                  ),
                )
              : Center(),

          // SizedBox(
          //   height: 15,
          // ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            buttonHeight: 20.0,
            buttonMinWidth: 50.0,
            children: <Widget>[
              FlatButton(
                onPressed: null,
                child: Column(
                  children: <Widget>[],
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                onPressed: () {
                  _showAlertDialog();
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      FluentIcons.delete_20_regular,
                      color: LightColors.lightRed.withOpacity(0.7),
                      // color: Color.fromRGBO(160, 160, 160, 0.7),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Text(
                      'Delete Task',
                      style: TextStyle(
                          fontFamily: "Lato",
                          color: LightColors.lightRed.withOpacity(1),
                          fontSize: 10),
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: null,
                child: Column(
                  children: <Widget>[],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showAlertDialog() {
    // return showDialog<void>(
    //   context: context,
    //   barrierDismissible: false, // user must tap button!
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       // <-- SEE HERE
    //       title: const Text(
    //         'Delete Task',
    //         style: TextStyle(fontFamily: "Lato"),
    //       ),
    //       content: SingleChildScrollView(
    //         child: ListBody(
    //           children: const <Widget>[
    //             Text(
    //               "Are you sure you want delete this task ?",
    //               style: TextStyle(
    //                   fontFamily: "Lato", color: LightColors.lightBlack),
    //             ),
    //           ],
    //         ),
    //       ),
    //       actions: <Widget>[
    //         TextButton(
    //           child: const Text('No'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //         TextButton(
    //           child: const Text('Yes'),
    //           onPressed: () async {
    //             bool res = await GetHelper().deleteTask(widget.id);
    //             if (res) {
    //               Navigator.pushAndRemoveUntil(
    //                 context,
    //                 MaterialPageRoute(
    //                     builder: (BuildContext context) =>
    //                         AdminMenuBottomBarPage()),
    //                 ModalRoute.withName('/home'),
    //               );
    //               Fluttertoast.showToast(
    //                   msg: "Successfully delete task ",
    //                   toastLength: Toast.LENGTH_SHORT,
    //                   gravity: ToastGravity.BOTTOM,
    //                   timeInSecForIosWeb: 1,
    //                   backgroundColor: Colors.black54,
    //                   textColor: Colors.white,
    //                   fontSize: 12.0);
    //             } else {
    //               Fluttertoast.showToast(
    //                   msg: "Failed delete task ",
    //                   toastLength: Toast.LENGTH_SHORT,
    //                   gravity: ToastGravity.BOTTOM,
    //                   timeInSecForIosWeb: 1,
    //                   backgroundColor: Colors.black54,
    //                   textColor: Colors.white,
    //                   fontSize: 12.0);
    //               print("gagal");
    //             }
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
    return showCustAlertDouble(
        height: 280,
        context: context,
        title: "Delete Task",
        // buttonString: "OK",
        onSubmitOk: () async {
          showLoadingProgress(context);
          bool res = await GetHelper().deleteTask(widget.id);
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
