import 'package:flutter/material.dart';

class Task {
  // final int userId;

  final String id;
  final String status;
  final String title;
  final String description;
  final String created_at;
  final String end_time;
  final String image;

  const Task({
    @required this.id,
    @required this.status,
    @required this.title,
    @required this.created_at,
    @required this.description,
    @required this.end_time,
    @required this.image,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      // userId: json['userId'],
      id: json['id'].toString(),
      status: json['status'],
      title: json['task_title'],
      description: json['task_description'],
      // created_at: json['created_at'],
      created_at: json["created_at"],
      end_time: json["tanggal"],
      image: json["upload_bukti"],
    );
    // return Task(
    //   // userId: json['userId'],
    //   id: json['id'],
    //   status: json['status'],
    //   title: json['title'],
    //   description: json['description'],
    //   // created_at: json['created_at'],
    //   created_at: json["created_at"],
    //   end_time: json["end_time"],
    //   image: json["image"],
    // );
  }
}
