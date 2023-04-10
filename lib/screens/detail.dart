import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String pathImage;
  DetailScreen({Key key, @required this.pathImage});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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
            child: Image.network(
              widget.pathImage,
            ),
          ),
        ),
      ),
    );
  }
}
