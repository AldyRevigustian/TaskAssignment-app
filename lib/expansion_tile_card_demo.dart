import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';

class CardExpand extends StatefulWidget {
  const CardExpand({
    Key key,
    @required this.card,
  }) : super(key: key);

  final GlobalKey<ExpansionTileCardState> card;

  @override
  State<CardExpand> createState() => _CardExpandState();
}

class _CardExpandState extends State<CardExpand> {
  formatSize(String formatSize) {
    if (formatSize.length > 15) {
      return 13.00;
    } else {
      return 15.00;
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = "Menyapu Lantai";
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
        key: widget.card,
        leading: Icon(
          FluentIcons.checkmark_circle_32_regular,
          color: LightColors.lightGreen,
          size: 40,
        ),
        title: Text(
          title,
          style: TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.bold,
              color: LightColors.lightBlack,
              fontSize: formatSize(title)),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Row(
            children: [
              Icon(
                FluentIcons.clock_16_regular,
                size: 20,
                color: LightColors.lightBlack,
              ),
              Text(
                "01/06/2022 - 09:30",
                style: TextStyle(
                    fontFamily: "Lato",
                    // fontWeight: FontWeight.bold,
                    color: LightColors.lightBlack,
                    fontSize: 13),
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

                    decoration: const InputDecoration(
                        hintText: "Sampai Bersih ya ;)",
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
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            buttonHeight: 20.0,
            buttonMinWidth: 50.0,
            children: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                onPressed: () {
                  widget.card.currentState?.expand();
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      FluentIcons.dismiss_circle_20_regular,
                      color: LightColors.lightBlack,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Text(
                      'Dissmiss',
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
                  widget.card.currentState?.collapse();
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      FluentIcons.camera_20_regular,
                      color: LightColors.lightBlack,
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
                onPressed: () {},
                child: Column(
                  children: <Widget>[
                    Icon(
                      FluentIcons.save_20_regular,
                      color: LightColors.lightBlack,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Text(
                      'Done',
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
}
