import 'package:flutter/material.dart';

class Task {
  final String user;
  final String id;
  final String status;
  final String title;
  final String description;
  final String date;
  final String image;

  const Task({
    @required this.user,
    @required this.id,
    @required this.status,
    @required this.title,
    @required this.description,
    @required this.date,
    @required this.image,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      user: json['user'].toString(),
      id: json['id'].toString(),
      status: json['status'],
      title: json['task_title'],
      description: json['task_description'],
      date: json['assigned_date'],
      image: (json["upload_bukti"] == null) ? "null" : json["upload_bukti"],
    );
  }
}
