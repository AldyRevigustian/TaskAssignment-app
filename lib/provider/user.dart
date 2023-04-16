import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/widget/const.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserInf {
  final int id;
  final String name;
  final String email;
  final String registration;
  final String avatar;
  final String token;
  UserInf({
    this.id,
    this.email,
    this.name,
    this.registration,
    this.avatar,
    this.token,
  });
}

class User with ChangeNotifier {
  UserInf _inf;

  UserInf getUserInf() {
    return _inf;
  }

  saveSFstring(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);

    print("Data user sudah di simpan email : ${prefs.getString('email')}");
  }

  void setUserInf(UserInf inf) {
    _inf = inf;
    print(_inf);
    notifyListeners();
  }

  Future loginUser(String user, String pass) async {
    var response;
    var data;
    try {
      response = await http.post(Uri.parse(URL + "api/login"), body: {
        "email": user.trim(),
        "password": pass.trim(),
      });
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        insertInf(data);
        saveSFstring(user.trim(), pass.trim());

        if (data['role'] == "user") {
          return "user";
        } else {
          return "admin";
        }
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  insertInf(dynamic datauser) {
    UserInf parentInf = UserInf(
      id: datauser['id'],
      name: datauser['name'],
      email: datauser['email'],
      registration:
          (datauser['registration'] == null) ? " " : datauser['registration'],
      avatar: (datauser['photo'] == null) ? null : datauser['photo'],
      token: datauser['token'],
    );

    setUserInf(parentInf);
  }

  logOut() {
    _inf = new UserInf();
    notifyListeners();
    print(_inf.id);
  }
}
