import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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

class CardExpandActive extends StatefulWidget {
  final String id;
  final String status;
  final String title;
  final String description;
  final String created_at;
  final String updated_at;
  GlobalKey<ExpansionTileCardState> idCard;

  CardExpandActive({
    Key key,
    @required this.id,
    @required this.status,
    @required this.title,
    @required this.description,
    @required this.created_at,
    @required this.updated_at,
  }) : super(key: key);

  @override
  State<CardExpandActive> createState() => _CardExpandActiveState();
}

class _CardExpandActiveState extends State<CardExpandActive> {
  File imageFile;
  String imageData;
  String imagePath;

  final _descController = TextEditingController();

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  pickImage() async {
    try {
      var image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 15);
      if (image == null) return;

      setState(() {
        imagePath = image.path;
        imageFile = File(image.path);
      });
      // print(imageData);
      print(imageFile);
      return imageFile;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
  // pickImage() async {
  //   try {
  //     var image = await ImagePicker()
  //         .pickImage(source: ImageSource.gallery, imageQuality: 15);
  //     if (image == null) return;

  //     setState(() {
  //       imagePath = image.path;
  //       imageFile = File(image.path);
  //       imageData = base64Encode(imageFile.readAsBytesSync());
  //     });
  //     // print(imageData);
  //     print(imagePath);
  //     return imageData;
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }

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

  // showImage(String image) {
  //   return Image.memory(
  //     base64Decode(image),
  //     width: 100,
  //     height: 100,
  //     fit: BoxFit.cover,
  //   );
  // }
  showImage(File image) {
    // return Image.memory(
    //   base64Decode(image),
    //   width: 100,
    //   height: 100,
    //   fit: BoxFit.cover,
    // );
    return Image.file(
      image,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }

  DateFormat formatTanggal;

  final picker = ImagePicker();

  void initState() {
    formatTanggal = DateFormat.MMMMEEEEd('id');
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
        title: Text(
          // "kkdopaskdopaskdsadasdasdasdasdasdasdasdasdasdasdokasopdkasodkaopskdpoakpokfopkerpofkeoprkfoperkfoperkfopkerofpkerpofkeorpkfeorpkfpoerkfporekfperk",
          capitalize(widget.title),
          style: TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.bold,
              color: LightColors.lightBlack,
              fontSize: formatSize(widget.title)),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  FluentIcons.clock_12_filled,
                  color: LightColors.lightBlack.withOpacity(0.6),
                  size: 15,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "  " +
                        formatTanggal.format(DateTime.parse(widget.created_at)),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Lato",
                        // fontWeight: FontWeight.bold,
                        color: LightColors.lightBlack.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                  Text(
                    DateFormat('   kk : mm')
                        .format(DateTime.parse(widget.created_at)),
                    style: TextStyle(
                        fontFamily: "Lato",
                        // fontWeight: FontWeight.bold,
                        color: LightColors.lightBlack.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
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
                  child: TextFormField(
                    controller: _descController,
                    // decoration: InputDecoration(border: Border),
                    maxLines: 5,
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        fontSize: 14,
                        fontFamily: "Lato"),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: (widget.description != null)
                            ? widget.description
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
          imageFile != null
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
                      // child: showImage(imageFile),
                      child: Image.file(
                        imageFile,
                        width: 100,
                        height: 100,
                      ),
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
                      FluentIcons.dismiss_circle_20_regular,
                      color: Color.fromRGBO(160, 160, 160, 0.7),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Text(
                      'Incomplete',
                      style: TextStyle(
                          fontFamily: "Lato",
                          color: Color.fromRGBO(160, 160, 160, 1),
                          fontSize: 10),
                    ),
                  ],
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                onPressed: () {
                  // getImage(ImageSource.camera);
                  pickImage();
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      FluentIcons.camera_20_regular,
                      color: Color.fromRGBO(160, 160, 160, 0.7),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(
                          fontFamily: "Lato",
                          color: Color.fromRGBO(160, 160, 160, 1),
                          fontSize: 10),
                    ),
                  ],
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                onPressed: () async {
                  // print(imageData);
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
                    bool res = await GetHelper().putTaskFinale(
                        widget.id, "Completed", imagePath.toString());

                    if (res == true) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return UserMenuBottomBarPage();
                          },
                        ),
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
                  // print(imagePath);
                  // bool res = await GetHelper().putDio(
                  //   widget.id,
                  //   "1",
                  //   _descController.text,
                  //   imageData,
                  // );
                  // bool res = await GetHelper().putTaskImage(
                  //     widget.id, "1", _descController.text, imageData);
                  // bool res = await GetHelper()
                  //     .putTask(widget.id, "1", _descController.text,);
                },
                // onPressed: () async {
                //   bool res = await GetHelper()
                //       .putTask(widget.id, "1", _descController.text);
                //   if (res) {
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //         builder: (BuildContext context) {
                //           return MenuBottomBarPage();
                //         },
                //       ),
                //     );
                //   } else {
                //     print("gagal");
                //   }
                // },
                child: Column(
                  children: <Widget>[
                    Icon(
                      FluentIcons.save_20_regular,
                      color: Color.fromRGBO(160, 160, 160, 0.7),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Text(
                      'Complete',
                      style: TextStyle(
                          fontFamily: "Lato",
                          color: Color.fromRGBO(160, 160, 160, 1),
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
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text(
            'Incomplete Task',
            style: TextStyle(fontFamily: "Lato"),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  "Are you sure you will report this task as incompleted?",
                  style: TextStyle(
                      fontFamily: "Lato", color: LightColors.lightBlack),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                if (imagePath == null) {
                  String imagePath = "";
                  bool res = await GetHelper().putTaskCancel(
                      widget.id, "Incompleted", imagePath.toString());
                } else {
                  bool res = await GetHelper().putTaskCancel(
                      widget.id, "Incompleted", imagePath.toString());
                  if (res) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return UserMenuBottomBarPage();
                        },
                      ),
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
            ),
          ],
        );
      },
    );
  }
}
