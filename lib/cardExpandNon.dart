import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/services.dart';

import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class CardExpandNon extends StatefulWidget {
  final String status;
  final String title;
  final String description;
  final String created_at;
  final String updated_at;
  final String image;
  GlobalKey<ExpansionTileCardState> idCard;

  CardExpandNon({
    Key key,
    @required this.status,
    @required this.title,
    @required this.description,
    @required this.created_at,
    @required this.updated_at,
    @required this.image,
  }) : super(key: key);

  @override
  State<CardExpandNon> createState() => _CardExpandNonState();
}

class _CardExpandNonState extends State<CardExpandNon> {
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
    return Image.network(
      "http://10.0.2.2:8000/storage/bukti/" + path,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }

  DateFormat formatTanggal;

  void initState() {
    formatTanggal = DateFormat.MMMMEEEEd('id');
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
    log(widget.image);
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
                  color: (widget.status == "Completed")
                      ? LightColors.lightGreen.withOpacity(0.7)
                      : LightColors.lightRed.withOpacity(0.7),
                  size: 15,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "  " +
                        formatTanggal.format(DateTime.parse(widget.updated_at)),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Lato",
                        // fontWeight: FontWeight.bold,
                        color: (widget.status == "Completed")
                            ? LightColors.lightGreen.withOpacity(0.7)
                            : LightColors.lightRed.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                  Text(
                    DateFormat('   kk : mm')
                        .format(DateTime.parse(widget.updated_at)),
                    style: TextStyle(
                        fontFamily: "Lato",
                        // fontWeight: FontWeight.bold,
                        color: (widget.status == "Completed")
                            ? LightColors.lightGreen.withOpacity(0.7)
                            : LightColors.lightRed.withOpacity(0.7),
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

          widget.image != null
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

          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
