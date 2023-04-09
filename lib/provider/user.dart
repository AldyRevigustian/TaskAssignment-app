import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/widget/const.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserInf {
  final int id;
  final String email;
  final String name;
  final String created_at;
  final String registration;
  final String avatar;
  UserInf({
    this.id,
    this.email,
    this.name,
    this.created_at,
    this.registration,
    this.avatar,
  });
}

class User with ChangeNotifier {
  UserInf _inf;

  UserInf getUserInf() {
    return _inf;
  }

  saveSFstring(String email, String password, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
    prefs.setString('token', token);

    print("Data user sudah di simpan email : ${prefs.getString('email')}");
  }

  void setUserInf(UserInf inf) {
    _inf = inf;
    print(_inf);
    notifyListeners();
  }

  Future loginUser(String user, String pass) async {
    var response;
    var datauser;
    var data;
    try {
      response = await http.post(Uri.parse(LINKAPI + "api/login"), body: {
        "email": user.trim(),
        "password": pass.trim(),
      });
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        datauser = data['user'];
        insertInf(datauser);
        saveSFstring(user.trim(), pass.trim(), data['token']);

        if (datauser['role'] == "user") {
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
      avatar: (datauser['photo'] == null) ? null : datauser['poto'],
    );

    setUserInf(parentInf);
  }

  logOut() {
    _inf = new UserInf();
    notifyListeners();
    print(_inf.id);
  }
}
