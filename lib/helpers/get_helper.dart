import 'dart:convert';

import 'package:flutter_task_planner_app/model/taskModel.dart';
import 'package:http/http.dart' as http;

class GetHelper {
  Future<List<Task>> fetchTask() async {
    final response = await http.get(Uri.parse(
        'https://624e8ad153326d0cfe5c1a33.mockapi.io/api/task/listTask'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Task.fromJson(job)).toList();

      // AdTemplate template = AdTemplate.fromJson(data[0]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Task');
    }
  }

  Future putTask(String id, String status, String description) async {
    final response = await http.put(
        Uri.parse(
            'https://624e8ad153326d0cfe5c1a33.mockapi.io/api/task/listTask/' +
                id),
        body: {
          'status': status,
          'description': description,
        });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
