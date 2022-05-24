import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_task_planner_app/model/taskModel.dart';
import 'package:flutter_task_planner_app/widget/const.dart';
import 'package:http/http.dart' as http;

class GetHelper {
  String link = LINKAPI + "/api/schedule";
  String linkImage = LINKAPI + "/storage/bukti/";

  // Future<List<Task>> fetchTask() async {
  //   final response = await http.get(Uri.parse(link));

  //   if (response.statusCode == 200) {
  //     List jsonResponse = json.decode(response.body);
  //     return jsonResponse.map((job) => new Task.fromJson(job)).toList();

  //     // AdTemplate template = AdTemplate.fromJson(data[0]);
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load Task');
  //   }
  // }

  Future<List<Task>> fetchTask(String id) async {
    // var data = {
    //   'user_id': "2",
    // };

    final response =
        await http.post(Uri.parse(link), body: {"user_id": id.toString()});
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      // print(jsonResponse.map((job) => new Task.fromJson(job)).toList());
      return jsonResponse.map((job) => new Task.fromJson(job)).toList();
      // AdTemplate template = AdTemplate.fromJson(data[0]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // throw Exception('Failed to load Task');
    }
  }

  Future putTaskFinale(
    String id,
    String status,
    String image,
    String description,
  ) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(LINKAPI + '/api/update'));
    request.fields
        .addAll({'id': id, 'status': status, "task_description": description});
    request.files.add(await http.MultipartFile.fromPath('upload_bukti', image));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future putTaskCancel(
    String id,
    String status,
  ) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(LINKAPI + '/api/update'));
    request.fields.addAll({'id': id, 'status': status});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future notif(String regis, String title, String body) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAX4bqqMs:APA91bGm76Hqu8z_YZfeEtuS7KenY99AG69HKOJwFD6lUDVjPlC6OM8JiSy2BT0DXv8IZFqL6XjfhYiWrr1PY3SUIIg9qhnwcRBzTdJc1b2rafIh_ps2-_RpWeUwOnn7JUWdm-fFfmpE'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "registration_ids": [regis],
      "notification": {
        "body": body,
        "title": title,
        "android_channel_id": "pushnotificationapp",
        "sound": true
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future registid(String id, String regis) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(LINKAPI + '/api/registration'));
    request.fields.addAll({'id': id, 'registration': regis});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future postSchedule(
      String id, String title, String description, String date) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(LINKAPI + 'api/addSchedule'));
    request.fields.addAll({
      'user_id': "3",
      'task_title': title,
      'task_description': description,
      'tanggal': '2022-05-23'
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
