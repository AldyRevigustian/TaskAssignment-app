import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_task_planner_app/main.dart';
import 'package:flutter_task_planner_app/provider/identity.dart';
import 'package:flutter_task_planner_app/provider/user.dart';
import 'package:flutter_task_planner_app/screens/user/user_home_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/const.dart';
import 'package:flutter_task_planner_app/widget/loading_alert.dart';
import 'package:flutter_task_planner_app/screens/user/user_menu_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svg_icon/svg_icon.dart';

import '../widget/custAlert.dart';
import 'admin/admin_menu_bottom_bar.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  String appLogo;
  IdentityInf getIdentityInfo;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  String email = "";
  String password = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(
        AssetImage(
          "assets/images/background.png",
        ),
        context);
    precacheImage(
        AssetImage(
          "assets/images/admin.png",
        ),
        context);
    precacheImage(
        AssetImage(
          "assets/images/user.png",
        ),
        context);
    precacheImage(
        AssetImage(
          "assets/images/header.png",
        ),
        context);
    precacheImage(
        AssetImage(
          "assets/images/header_admin.png",
        ),
        context);
    super.didChangeDependencies();
  }

  showLoadingProgress(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => Center(
                child: Container(
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

  _login() async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState.validate()) {
      if (isLoading) {
        showLoadingProgress(context);
      }

      Provider.of<User>(context, listen: false)
          .loginUser(emailController.text, passwordController.text)
          .then((state) {
        if (state == "user") {
          setState(() {
            isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => UserMenuBottomBarPage()),
            ModalRoute.withName('/home'),
          );
        } else if (state == "admin") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => AdminMenuBottomBarPage()),
            ModalRoute.withName('/home'),
          );
        } else {
          setState(() {
            isLoading = false;
          });
          showCustAlert(
              height: 300,
              context: context,
              title: "Error",
              buttonString: "OK",
              onSubmit: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              detailContent:
                  "You Entered Wrong Email or password / Phone not connected to Internet",
              pathLottie: "error");
        }
      });
    }
  }

  Widget build(BuildContext context) {
    getIdentityInfo = Provider.of<Identity>(context).getIdentityInf();
    appLogo = getIdentityInfo.app_logo;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFF8fcdde),
        systemNavigationBarIconBrightness: Brightness.light));
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: height,
            width: width,
            child: Stack(
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        URL + appLogo,
                        width: 150,
                        height: 150,
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
                        height: 30,
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
                                        controller: emailController,
                                        style: TextStyle(
                                          color: LightColors.lightBlack,
                                        ),
                                        decoration: InputDecoration(
                                            hintText: "Email",
                                            hintStyle: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 15,
                                                color: LightColors.lightGrey),
                                            prefixIcon: Container(
                                              width: 0,
                                              alignment: Alignment(-0.10, 0.0),
                                              child: Icon(
                                                FluentIcons.mail_24_regular,
                                                size: 25,
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
                                    height: 30,
                                  ),
                                  Column(
                                    children: [
                                      TextFormField(
                                        style: TextStyle(
                                          color: LightColors.lightBlack,
                                          // fontFamily: "Montserrat",
                                        ),
                                        controller: passwordController,
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
                                                size: 25,
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
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _login();
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
                      // SizedBox(
                      //   height: 32,
                      // ),
                      Container(
                        height: 250,
                      )
                    ]),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/images/background.png",
                            ),
                            fit: BoxFit.cover)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
