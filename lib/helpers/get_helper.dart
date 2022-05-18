import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_task_planner_app/model/taskModel.dart';
import 'package:http/http.dart' as http;

class GetHelper {
  // String link = "https://6268a04eaa65b5d23e77f552.mockapi.io/listTask/";
  String link = "http://10.0.2.2:8000/api/schedule";
  String linkImage = "http://10.0.2.2:8000/storage/bukti/";

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

  // Future putTaskFinale(
  //   String id,
  //   String status,
  //   String image,
  //   // String description,
  // ) async {
  //   // var request = http.MultipartRequest(
  //   // 'POST', Uri.parse('http://10.0.2.2:8000/api/update'));
  //   // request.fields.addAll({'id': id, 'status': status});
  //   // request.files.add(await http.MultipartFile.fromPath('upload_bukti', image));

  //   // http.StreamedResponse response = await request.send();

  //   final response =
  //       await http.put(Uri.parse("http://10.0.2.2:8000/api/update"), body: {
  //     'id': id,
  //     'status': status,
  //     // 'description': description,
  //     'image': "",
  //   });

  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  Future putTaskFinale(
    String id,
    String status,
    String image,
    // String description,
  ) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:8000/api/update'));
    request.fields.addAll({'id': id, 'status': status});
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
    String image,
    // String description,
  ) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:8000/api/update'));
    request.fields.addAll({'id': id, 'status': status});
    request.files.add(http.MultipartFile.fromBytes(
        'upload_bukti',
        (await rootBundle.load('assets/images/multiply.png'))
            .buffer
            .asUint8List(),
        filename: 'testimage.png'));

    http.StreamedResponse response = await request.send();

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
