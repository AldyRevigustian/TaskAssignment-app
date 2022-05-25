import 'package:flutter/material.dart';

class AllTask {
  // final int userId;

  final String id;
  final String status;
  final String title;
  final String description;
  final String created_at;
  final String updated_at;
  final String image;

  const AllTask({
    @required this.id,
    @required this.status,
    @required this.title,
    @required this.created_at,
    @required this.description,
    @required this.updated_at,
    @required this.image,
  });

  factory AllTask.fromJson(Map<String, dynamic> json) {
    return AllTask(
      // userId: json['userId'],
      id: json['id'].toString(),
      status: json['status'],
      title: json['AllTask_title'],
      description: json['AllTask_description'],
      // created_at: json['created_at'],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      image: (json["upload_bukti"] == null) ? "null" : json["upload_bukti"],
    );
    // return AllTask(
    //   // userId: json['userId'],
    //   id: json['id'],
    //   status: json['status'],
    //   title: json['title'],
    //   description: json['description'],
    //   // created_at: json['created_at'],
    //   created_at: json["created_at"],
    //   update_at: json["update_at"],
    //   image: json["image"],
    // );
  }
}
