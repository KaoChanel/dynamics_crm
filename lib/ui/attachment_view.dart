import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_filex/open_filex.dart';

class AttachView extends StatefulWidget {
  const AttachView({required this.path, required this.fromPage});
  final String path;
  final String fromPage;

  @override
  _AttachViewState createState() => _AttachViewState();
}

_launchURL(String path) async {
  var url = path;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchFile(String path) async {
  var url = 'file://' + path;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

getThumbnail(String path) {
  if(path.contains('http')){
    if(path.contains('.pdf') || path.contains('.doc') || path.contains('.docx') || path.contains('.xls') || path.contains('.xlsx')){
      // return SfPdfViewer.network(path);
      _launchURL(path);
    }

    return Hero(
        tag: path,
        child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 2,
            panEnabled: false, // Set it to false
            boundaryMargin: EdgeInsets.all(100),
            child: Center(
              child: Image.network(path, fit: BoxFit.cover,),
            )
        )
    );
    // return Image.network(path, fit: BoxFit.cover,);
  }
  else if(path.contains('.jpg') || path.contains('.jpeg') || path.contains('.png')){
    return Hero(
        tag: path,
        child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 2,
            panEnabled: false, // Set it to false
            boundaryMargin: EdgeInsets.all(100),
            child: Center(
              child: Image.file(File(path), fit: BoxFit.cover,),
            )
        )
    );
    // return Image.file(File(path), fit: BoxFit.cover,);
  }
  else{
    OpenFilex.open(path);
  }
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
      body: getThumbnail(widget.path),
    );
  }
}
