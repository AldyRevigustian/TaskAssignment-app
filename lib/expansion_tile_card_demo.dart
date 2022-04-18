import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/services.dart';

import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:intl/intl.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class CardExpand extends StatefulWidget {
  final int status;
  final String title;
  final String description;
  final String created_at;
  final String end_time;
  GlobalKey<ExpansionTileCardState> idCard;

  CardExpand({
    Key key,
    @required this.status,
    @required this.title,
    @required this.description,
    @required this.created_at,
    @required this.end_time,
  }) : super(key: key);

  @override
  State<CardExpand> createState() => _CardExpandState();
}

class _CardExpandState extends State<CardExpand> {
  File image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  DateFormat formatTanggal;

  File _image;
  final picker = ImagePicker();

  void initState() {
    formatTanggal = DateFormat.MMMMd('id');
    super.initState();
  }

  formatSize(String formatSize) {
    if (formatSize.length > 15) {
      return 13.00;
    } else {
      return 13.00;
    }
  }

  iconStatus(int status) {
    if (status == 1) {
      return FluentIcons.checkmark_circle_32_regular;
    } else if (status == 0) {
      return FluentIcons.error_circle_24_regular;
    } else {
      return FluentIcons.dismiss_circle_24_regular;
    }
  }

  colorStatus(int colorStatus) {
    if (colorStatus == 1) {
      return LightColors.lightGreen;
    } else if (colorStatus == 0) {
      return LightColors.lightYellow;
    } else {
      return LightColors.lightRed;
    }
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
          widget.title,
          style: TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.bold,
              color: LightColors.lightBlack,
              fontSize: formatSize(widget.title)),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    DateFormat('dd/MM ')
                        .format(DateTime.parse(widget.created_at)),
                    style: TextStyle(
                        fontFamily: "Lato",
                        // fontWeight: FontWeight.bold,
                        color: LightColors.lightBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 11),
                  ),
                  Text(
                    DateFormat(' kk : mm')
                        .format(DateTime.parse(widget.created_at)),
                    style: TextStyle(
                        fontFamily: "Lato",
                        // fontWeight: FontWeight.bold,
                        color: LightColors.lightBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 11),
                  ),
                  Text(
                    " - ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: LightColors.lightBlack,
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM ')
                        .format(DateTime.parse(widget.end_time)),
                    style: TextStyle(
                        fontFamily: "Lato",
                        // fontWeight: FontWeight.bold,
                        color: LightColors.lightRed,
                        fontWeight: FontWeight.w600,
                        fontSize: 11),
                  ),
                  Text(
                    DateFormat(' kk : mm')
                        .format(DateTime.parse(widget.end_time)),
                    style: TextStyle(
                        fontFamily: "Lato",
                        // fontWeight: FontWeight.bold,
                        color: LightColors.lightRed,
                        fontWeight: FontWeight.w600,
                        fontSize: 11),
                  ),
                ],
              )
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
                    // decoration: InputDecoration(border: Border),
                    maxLines: 5,
                    style: TextStyle(
                        fontFamily: "Lato",
                        fontSize: 15,
                        color: LightColors.lightBlack),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: (widget.description != null)
                            ? widget.description
                            : "",
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.3), fontSize: 15),
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
          image != null
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.file(
                        image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
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
                  widget.idCard.currentState?.expand();
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
                      'Dissmiss',
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
                  pickImageC();
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
                onPressed: () {},
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
                      'Done',
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
}
