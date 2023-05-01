import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/widget/const.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IdentityInf {
  final String app_name;
  final String app_logo;
  final String company_name;

  IdentityInf({
    this.app_name,
    this.app_logo,
    this.company_name,
  });
}

class Identity with ChangeNotifier {
  IdentityInf _inf;

  IdentityInf getIdentityInf() {
    return _inf;
  }

  saveSFstring(String app_name, String app_logo, String company_name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('app_name', app_name);
    prefs.setString('app_logo', app_logo);
    prefs.setString('company_name', company_name);

    print("Data Identity sudah di simpan");
  }

  void setIdentityInf(IdentityInf inf) {
    _inf = inf;
    print(_inf);
    notifyListeners();
  }

  Future getIdentity() async {
    var response;
    var data;
    try {
      response = await http.get(Uri.parse(URL + "api/identity"));
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        insertInf(data);
        saveSFstring(data['app_name'], data['app_logo'], data['company_name']);

        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  insertInf(dynamic datauser) {
    IdentityInf identityInf = IdentityInf(
      app_name: datauser['app_name'],
      app_logo: datauser['app_logo'],
      company_name: datauser['company_name'],
    );

    setIdentityInf(identityInf);
  }
}
