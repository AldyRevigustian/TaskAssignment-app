import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';

class ModelCard {
  String status;
  String title;
  String description;

  ModelCard({this.status, this.title, this.description});

  // String idCard;
  // var id = int.parse(idCard);

  ModelCard.fromJson(Map<String, dynamic> json) {
    // idCard = json['id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
  }
}
