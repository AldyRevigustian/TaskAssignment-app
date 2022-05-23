/**the provider for parent */

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/widget/const.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//ParentClass
class ParentInf {
  final int id;
  final String email;
  final String name;
  final String created_at;
  final String registration;
  final String avatar;
  ParentInf({
    this.id,
    this.email,
    this.name,
    this.created_at,
    this.registration,
    this.avatar,
  });
}

class Parent with ChangeNotifier {
  ParentInf _inf;

  ParentInf getParentInf() {
    return _inf;
  }

  void setParentInf(ParentInf inf) {
    _inf = inf;
    print(_inf);
    notifyListeners();
  }

  Future loginParentAndGetInf(String user, String pass) async {
    var response;
    var datauser;
    var dataid;
    try {
      response = await http.post(Uri.parse(LINKAPI + "/api/login"), body: {
        "email": user.trim(),
        "password": pass.trim(),
      });
      if (response.statusCode == 200) {
        datauser = await json.decode(response.body);
        dataid = json.decode(response.body);
        // print(response.body);
        log(response.body);
        // log(dataid['data']['id'].toString());
        insertInf(datauser);
        if (datauser['data']['role'] == "user") {
          return "user";
        } else {
          return "admin";
        }
        // return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  // Future<bool> loginParentAndGetInf(String user, String pass) async {
  //   var dataUser;
  //   try {
  //     final response =
  //         await Dio().post("http://10.0.2.2:8000/api/login", data: {
  //       // "image": image,
  //       "email": user.trim(),
  //       "password": pass.trim(),
  //     });

  //     if (response.statusCode == 200) {
  //       dataUser = jsonDecode(response.data);
  //       print(dataUser);
  //       // log(response.data);
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   // open a bytestream
  //   return false;
  //   // get file lengthvar length = await imageFile.length();
  // }
  // Future<bool> loginParentAndGetInf(String user, String pass) async {
  //   var response;
  //   var datauser;
  //   try {
  //     response = await http
  //         .post(Uri.parse("https://la-att.intek.co.id/api/login"), body: {
  //       "email": user.trim(),
  //       "password": pass.trim(),
  //     });
  //     if (response.statusCode == 200) {
  //       datauser = await json.decode(response.body);
  //       print(response.body);
  //       insertInf(datauser);
  //       return true;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }

  //   return false;
  // }

  insertInf(dynamic datauser) {
    ParentInf parentInf = ParentInf(
      id: datauser['data']['id'],
      name: datauser['data']['name'],
      email: datauser['data']['email'],
      registration: (datauser['data']['registration'] == null)
          ? " "
          : datauser['data']['registration'],
      // created_at: datauser['data']['created_at'],
      avatar: (datauser['data']['registration'] == null)
          ? null
          : datauser['data']['poto'],
    );

    setParentInf(parentInf);
  }

  logOut() {
    _inf = new ParentInf();
    notifyListeners();
    print(_inf.id);
  }
}
