import 'dart:io';
import 'package:flutter/material.dart';

class AttachView extends StatefulWidget {
  const AttachView({super.key, required this.path});
  final String path;

  @override
  _AttachViewState createState() => _AttachViewState();
}

class _AttachViewState extends State<AttachView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0x44000000),
        elevation: 0,
      ),
      body: Hero(
        tag: widget.path,
        child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 2,
            panEnabled: false, // Set it to false
            boundaryMargin: EdgeInsets.all(100),
            child: Image(
              image: FileImage(File(widget.path)),
              fit: BoxFit.cover,
            )
        )
      ),
    );
  }
}
