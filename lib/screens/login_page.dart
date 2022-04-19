import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_task_planner_app/main.dart';
import 'package:flutter_task_planner_app/provider/parent.dart';
import 'package:flutter_task_planner_app/screens/home_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widget/loading_alert.dart';
import 'package:flutter_task_planner_app/widget/menu_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svg_icon/svg_icon.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

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

  String usern = "";
  String passwd = "";
  bool sharedpref = false;
  bool state = false;

  @override
  void initState() {
    checkSFstring();
    if (sharedpref == true) {
      Provider.of<Parent>(context, listen: false)
          .loginParentAndGetInf(usern, passwd)
          .then((state) {
        // pass username and password that user entered

        if (state) {
          setState(() {
            state = true;
          });
          // if the function returned true
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            ModalRoute.withName('/login'),
          );

          // Navigator.of(context).pushNamed(
          //     MainParentPage.routeName); // go to the Main page for parent
        } else {
          setState(() {
            state = false;
          });
          // showAlert('Error',
          //     'You Entered Wrong Email or password/ Phone not connected Internet'); // otherwise show an Alert
        }
      });
    }
    //call alert

    // alertinfo(context);
    super.initState();
  }

  // login function
  saveSFstring(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);

    print(
        "Data email dan password sudah di simpan yaitu => ${prefs.getString('email')}");
  }

  checkSFstring() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool email = prefs.containsKey('email');
    bool password = prefs.containsKey('password');

    if (email == true && password == true) {
      setState(() {
        usern = prefs.getString('email');
        passwd = prefs.getString('password');
        sharedpref = true;
      });
      if (state == false) {
        showLoadingProgress();
      }
      Provider.of<Parent>(context, listen: false)
          .loginParentAndGetInf(usern.toString(), passwd.toString())
          .then((state) {
        // pass username and password that user entered

        if (state) {
          // if the function returned true
          //Navigator.of(context).pushNamed(DashboardMenu.routeName);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MenuBottomBarPage()),
            ModalRoute.withName('/home'),
          );
          //Navigator.of(context).pushNamed(BottomNavScreen.routeName); // go to the Main page for parent
        } else {
          setState(() {
            sharedpref = false;
          });
          // otherwise show an Alert
        }
      });
      print(
          "Data email dan password sudah ada di sharedpreference yaitu => ${usern.toString()}");
    } else {
      print("No Data sharedpreference bro");
    }
  }

  showLoadingProgress() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoadingAlert();
        });
  }

  showAlert(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) => LoginPage()));
                  // Navigator.popUntil(
                  //   context,
                  //   ModalRoute.withName('/login'),
                  // );
                },
              )
            ],
          );
        });
  }

  _login() async {
    saveSFstring(user.text, pass.text);
    setState(() {
      state = true;
    });
    if (_formKey.currentState.validate()) {
      // check if all the conditionsthe we put on validators are right
      if (state) {
        showLoadingProgress(); // show CircularProgressIndicator
      }
      // if the radio button on parent then login using parent provider

      if (sharedpref == false) {
        Provider.of<Parent>(context, listen: false)
            .loginParentAndGetInf(user.text, pass.text)
            .then((state) {
          // pass username and password that user entered

          if (state) {
            setState(() {
              state = false;
            });
            // if the function returned true
            // Navigator.of(context)
            //     .pushReplacementNamed(DashboardMenu.routeName);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MenuBottomBarPage()),
              ModalRoute.withName('/home'),
            );
            //Navigator.of(context).pushNamed(BottomNavScreen.routeName); // go to the Main page for parent
          } else {
            setState(() {
              state = false;
            });
            showAlert('Error',
                'You Entered Wrong Email or password'); // otherwise show an Alert
          }
        });
      }
    }
  }

  Widget build(BuildContext context) {
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
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Image.asset(
                          "assets/images/SII.png",
                          width: 180,
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
                                        controller: user,
                                        style: TextStyle(
                                          color: LightColors.lightBlack,
                                        ),
                                        decoration: InputDecoration(
                                            // contentPadding:
                                            //     EdgeInsets.only(top: 0),
                                            // floatingLabelBehavior:
                                            //     FloatingLabelBehavior.auto,
                                            hintText: "Email",
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
                                  decoration: BoxDecoration(
                                      color: LightColors.mainBlue,
                                      borderRadius: BorderRadius.circular(8)),
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
