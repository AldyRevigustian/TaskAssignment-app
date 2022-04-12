/**the provider for parent */

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//ParentClass
class ParentInf {
  final int id;
  final String email;
  final String name;
  final String created_at;
  final String image_profile;
  final int team_id;
  ParentInf(
      {this.id,
      this.email,
      this.name,
      this.created_at,
      this.image_profile,
      this.team_id});
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

  Future<bool> loginParentAndGetInf(String user, String pass) async {
    var response;
    var datauser;
    try {
      response = await http
          .post(Uri.parse("https://la-att.intek.co.id/api/login"), body: {
        "email": user.trim(),
        "password": pass.trim(),
      });
      if (response.statusCode == 200) {
        datauser = await json.decode(response.body);
        print(response.body);
        insertInf(datauser);
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  insertInf(dynamic datauser) {
    ParentInf parentInf = ParentInf(
      id: datauser['data']['id'],
      name: datauser['data']['name'],
      email: datauser['data']['email'],
      created_at: datauser['data']['created_at'],
      image_profile: datauser['image_profile'],
    );

    setParentInf(parentInf);
  }

  logOut() {
    _inf = new ParentInf();
    notifyListeners();
    print(_inf.id);
  }
}
