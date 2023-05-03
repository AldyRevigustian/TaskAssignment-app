import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_task_planner_app/helpers/get_helper.dart';
import 'package:flutter_task_planner_app/provider/identity.dart';
import 'package:flutter_task_planner_app/provider/user.dart';
import 'package:flutter_task_planner_app/screens/admin/admin_menu_bottom_bar.dart';
import 'package:flutter_task_planner_app/screens/login_page.dart';
import 'package:flutter_task_planner_app/screens/user/user_menu_bottom_bar.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void _loadFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Provider.of<Identity>(context, listen: false).getIdentity();

    bool isSaved = prefs.containsKey('email');
    if (!isSaved) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    } else {
      String email = prefs.getString('email');
      String password = prefs.getString('password');

      Provider.of<User>(context, listen: false)
          .loginUser(email.toString(), password.toString())
          .then((state) {
        if (state == "user") {
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
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false);
        }
      });
    }
  }

  @override
  void initState() {
    _loadFirst();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitWave(
            color: LightColors.mainBlue.withOpacity(0.5),
            size: 25.0,
          ),
        ],
      ),
    );
  }
}
