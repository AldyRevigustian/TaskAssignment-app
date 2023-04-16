import 'package:flutter/material.dart';

class Task {
  final String user_id;
  final String id;
  final String status;
  final String title;
  final String description;
  final String date;
  final String image;

  const Task({
    @required this.user_id,
    @required this.id,
    @required this.status,
    @required this.title,
    @required this.description,
    @required this.date,
    @required this.image,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      user_id: json['user_id'].toString(),
      id: json['id'].toString(),
      status: json['status'],
      title: json['task_title'],
      description: json['task_description'],
      date: json['assigned_date'],
      image: (json["upload_bukti"] == null) ? "null" : json["upload_bukti"],
    );
  }
}
