import 'dart:io';

import 'package:flutter/material.dart';

class UserDetailScreen extends StatefulWidget {
  final File pathImage;
  UserDetailScreen({Key key, @required this.pathImage});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.file(
              widget.pathImage,
            ),
          ),
        ),
      ),
    );
  }
}
