import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_task_planner_app/main.dart';
import 'package:flutter_task_planner_app/screens/home_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/menu_bottom_bar.dart';
import 'package:svg_icon/svg_icon.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // the key for the form
  TextEditingController user =
      new TextEditingController(); // the controller for the usename that user will put in the text field
  TextEditingController pass =
      new TextEditingController(); // the controller for the password that user will put in the text field

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              height: height,
              width: width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Image.asset(
                        "assets/images/SII.png",
                        width: 200,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Welcome,",
                      style: TextStyle(
                          color: Color(0xFF0E4554),
                          fontFamily: "Lato",
                          fontSize: 30,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Login To Continue",
                      style: TextStyle(
                        color: Color(0xFF0E4554),
                        fontFamily: "Montserrat",
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: [
                                    TextFormField(
                                      style: TextStyle(
                                        color: LightColors.lightBlack,
                                      ),
                                      decoration: InputDecoration(
                                          // contentPadding:
                                          //     EdgeInsets.only(top: 0),
                                          // floatingLabelBehavior:
                                          //     FloatingLabelBehavior.auto,
                                          hintText: "Username",
                                          hintStyle: TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 15,
                                              color: LightColors.lightGrey),
                                          // label: Text(
                                          //   "Email",
                                          //   style: TextStyle(
                                          //     color:
                                          //         Color.fromRGBO(14, 69, 84, 1),
                                          //     fontFamily: "Montserrat",
                                          //   ),
                                          // ),
                                          prefixIcon: Container(
                                            width: 0,
                                            alignment: Alignment(-0.10, 0.0),
                                            child: Icon(
                                              FluentIcons.person_24_regular,
                                              size: 30,
                                              color: LightColors.lightGrey,
                                            ),
                                          ),
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: LightColors.lightGrey,
                                            width: 1,
                                          )),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: LightColors.lightGrey,
                                            width: 1,
                                          )),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: LightColors.lightGrey,
                                            width: 1,
                                          ))),
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value.length < 10) {
                                          return 'Please enter a valid email address.';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      style: TextStyle(
                                        color: LightColors.lightBlack,
                                        // fontFamily: "Montserrat",
                                      ),
                                      controller: pass,
                                      obscureText: _isObscure,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: _isObscure
                                                ? SvgIcon(
                                                    "assets/icon/regular_show.svg",
                                                    color:
                                                        LightColors.lightGrey,
                                                  )
                                                : SvgIcon(
                                                    "assets/icon/regular_hidden.svg",
                                                    color:
                                                        LightColors.lightGrey,
                                                  ),
                                            onPressed: () {
                                              setState(() {
                                                _isObscure = !_isObscure;
                                              });
                                            },
                                          ),
                                          // suffixIcon: IconButton(
                                          //   icon: Icon(
                                          //     _isObscure
                                          //         ? SvgIcon('assets/images/icon/regular_show.svg')
                                          //         : Icons.visibility_off,
                                          //     color: LightColors.lightGrey,
                                          //   ),
                                          //   onPressed: () {
                                          //     setState(() {
                                          //       _isObscure = !_isObscure;
                                          //     });
                                          //   },
                                          // )
                                          // // label: Text(
                                          //   "Password",
                                          //   style: TextStyle(
                                          //       color: Color.fromRGBO(
                                          //           14, 69, 84, 1),
                                          //       fontFamily: "Montserrat"),
                                          // ),
                                          // alignLabelWithHint: true,
                                          // floatingLabelBehavior:
                                          //     FloatingLabelBehavior.auto,
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 15,
                                              color: LightColors.lightGrey),
                                          prefixIcon: Container(
                                            width: 0,
                                            alignment: Alignment(-0.10, 0.0),
                                            child: Icon(
                                              FluentIcons
                                                  .lock_closed_24_regular,
                                              size: 30,
                                              color: LightColors.lightGrey,
                                            ),
                                          ),
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: LightColors.lightGrey,
                                            width: 1,
                                          )),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: LightColors.lightGrey,
                                            width: 1,
                                          )),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: LightColors.lightGrey,
                                            width: 1,
                                          ))),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      validator: (value) {
                                        if (value.length < 1) {
                                          return 'Please enter a password.';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: Container(
                                height: 45.0,
                                width: width,
                                decoration: BoxDecoration(
                                    color: LightColors.mainBlue,
                                    borderRadius: BorderRadius.circular(8)),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            MenuBottomBarPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // <-- Radius
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/images/background.png",
                              ),
                              fit: BoxFit.cover)),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
