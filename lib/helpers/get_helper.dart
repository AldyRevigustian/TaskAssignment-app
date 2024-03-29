import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_task_planner_app/model/taskModel.dart';
import 'package:flutter_task_planner_app/screens/admin/history_schedule.dart';
import 'package:flutter_task_planner_app/widget/const.dart';
import 'package:http/http.dart' as http;

class GetHelper {
  String linkImage = URL + "storage/bukti/";

  Future<List<Task>> fetchTask(String id, String token) async {
    final response = await http.get(Uri.parse(URL + 'api/task/user/$id'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Task.fromJson(job)).toList();
    }
  }

  Future<List<Task>> getAllTask(String token) async {
    print(token);
    final response = await http.get(Uri.parse(URL + "api/task/"),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Task.fromJson(job)).toList();
    }
  }

  Future updateTask(
    String id,
    String status,
    String image,
    String description,
    String token,
  ) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(URL + 'api/task/update/'));
    request.headers.addAll({'Authorization': 'Bearer $token'});

    request.fields
        .addAll({'id': id, 'status': status, "task_description": description});

    if (image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('upload_bukti', image));
    }

    http.StreamedResponse response = await request.send();
    print(response);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future registid(String id, String regis) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(URL + 'api/registration'));
    request.fields.addAll({'id': id, 'registration': regis});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future postTask(String token, String id, String title, String description,
      String date) async {
    print(date);
    var request =
        http.MultipartRequest('POST', Uri.parse(URL + 'api/task/add'));
    request.headers.addAll({'Authorization': 'Bearer $token'});
    request.fields.addAll({
      'user_id': id,
      'task_title': title,
      'task_description': description,
      'assigned_date': date
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future deleteTask(String id, String token) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(URL + 'api/task/delete'));
    request.fields.addAll({'id': id});
    request.headers.addAll({'Authorization': 'Bearer $token'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Task>> history(String date, String token) async {
    final response = await http.post(Uri.parse(URL + "api/task/history"),
        body: {'assigned_date': date.toString()},
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Task.fromJson(job)).toList();
    } else {}
  }
}
