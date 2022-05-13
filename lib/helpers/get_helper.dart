import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_task_planner_app/model/taskModel.dart';
import 'package:http/http.dart' as http;

class GetHelper {
  // String link = "https://6268a04eaa65b5d23e77f552.mockapi.io/listTask/";
  String link = "http://10.0.2.2:8000/api/schedule";

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

    final response = await http.post(Uri.parse(link), body: {"user_id": "2"});

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(jsonResponse.map((job) => new Task.fromJson(job)).toList());
      return jsonResponse.map((job) => new Task.fromJson(job)).toList();

      // AdTemplate template = AdTemplate.fromJson(data[0]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Task');
    }
  }

  Future putTask(
    String id,
    String status,
    String description,
  ) async {
    final response = await http.put(Uri.parse(link + id), body: {
      'status': status,
      'description': description,
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future putTaskImage(
    String id,
    String status,
    String description,
    String image,
  ) async {
    try {
      final response = await http.put(Uri.parse(link + id), body: {
        // 'id': id,
        'status': status,
        'description': description,
        'image': image.toString(),
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
    // open a bytestream

    // get file lengthvar length = await imageFile.length();
  }

  Future putDio(
    String id,
    String status,
    String description,
    String image,
  ) async {
    try {
      final response = await Dio().put(link + id, data: {
        "image": image,
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
    // open a bytestream

    // get file lengthvar length = await imageFile.length();
  }
}
