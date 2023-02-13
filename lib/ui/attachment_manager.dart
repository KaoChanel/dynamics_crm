// ignore: avoid_web_libraries_in_flutter
import 'dart:io';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:file/local.dart';
import 'package:file/memory.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'attachment_view.dart';

class AttachmentManager extends StatefulWidget {
  const AttachmentManager(this.allFiles, this.fromPage);

  final List<File> allFiles;
  final fromPage;

  @override
  _AttachmentManagerState createState() => _AttachmentManagerState();
}

class _AttachmentManagerState extends State<AttachmentManager> {
  // File _image;
  late File _image;
  int currentIndex = 0;
  final picker = ImagePicker();
  final BoxDecoration backgroundDecoration = const BoxDecoration(color: Colors.black);
  final PageController pageController = PageController();

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แนบไฟล์เอกสาร'),
        centerTitle: true,
      ),
      body: ListView(
        children:
        widget.allFiles.map((e) => Container(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              leading: Hero(
                  tag: e.path,
                  child: getThumbnail(e.path),
              ),
              title: Text(basename(e.path)),
              trailing: Visibility(
                visible: widget.fromPage == 'VIEW' ? false : true,
                child: ElevatedButton(
                  child: const Icon(Icons.delete_forever),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                  ),
                  onPressed: (){
                    setState(() {
                      widget.allFiles.remove(e);
                      // globals.recycleBin.add(e);
                    });
                  },
                ),
              ),
              onTap: () async {
                viewDocument(e.path);
                // await Navigator.push(context, MaterialPageRoute(builder: (context) => AttachView(path: e.path, fromPage: widget.fromPage,)));
              },
            ),
          )
          ).toList(),
      ),
      bottomNavigationBar: Visibility(
        visible: widget.fromPage == 'VIEW' ? false : true,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 100,
                padding: const EdgeInsets.only(top: 30.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showImagePicker(context);
                  },
                  icon: Icon(Icons.drive_folder_upload, size: 35,),
                  label: Text('เลือกไฟล์แนบ', style: TextStyle(fontSize: 20)),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green)
                  ),
                ),
              ),
            ),
            // Expanded(
            //   flex: 3,
            //   child: Container(
            //       height: 100,
            //       padding: const EdgeInsets.only(top: 30.0),
            //       child: ElevatedButton(
            //           onPressed: () {
            //             switch(widget.fromPage){
            //               case "ORDER" :
            //                 globals.attachOrder = widget.allFiles;
            //                 break;
            //               case "COPY" :
            //                 globals.attachCopyOrder = widget.allFiles;
            //                 break;
            //               case "DRAFT" :
            //                 globals.attachDraftOrder = widget.allFiles;
            //                 break;
            //               // case "QUOTATION" :
            //               //   globals.attachQuot = widget.allFiles;
            //             }
            //
            //             Navigator.pop(context, widget.allFiles);
            //             // _apiService.uploadMultipleFile(globals.attachOrder, globals.company, 900000000);
            //           },
            //           child: Text('ยืนยันการแนบไฟล์', style: TextStyle(fontSize: 20))
            //       )
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  _showImagePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.insert_drive_file_outlined),
                    title: const Text('Document'),
                    onTap: () async {
                      // _pickFile();
                      await _pickDocument();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        _pickImagesFromGallery();
                        Navigator.of(context).pop();
                      }),
                  // ListTile(
                  //   leading: Icon(Icons.photo_camera),
                  //   title: Text('Camera'),
                  //   onTap: () {
                  //     _imgFromCamera(context);
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                ],
              ),
            ),
          );
        }
    );
  }

  _launchURL(String path, bool inBrowser) async {
    var url = path;
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: inBrowser);
    } else {
      throw 'Could not launch $url';
    }
  }

  _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: true,           /// Flutter Web set => true for bytes data
        withReadStream: false,    /// Flutter Web set => false
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
      );

      if(result != null) {
        result.files.forEach((element) {
          PlatformFile platformFile = element;
          if(kIsWeb) {
            // File file = File.fromRawPath(result.files.single.bytes);

            File file = MemoryFileSystem().file(platformFile.name);
            // file.writeAsBytesSync(platformFile.bytes!.toList());

            var res = file.absolute;

            print('Memory FileSystem !!');
            print('Absolute is: ${file.isAbsolute}');
            print('Path: ' + res.path);

            widget.allFiles.add(file);
            print('widget.allFiles: ${widget.allFiles.length}');
          }
          else {
            print('Local FileSystem !!');
            File res = const LocalFileSystem().file(platformFile.path);
            // res.writeAsBytesSync(platformFile.bytes!.toList());

            print('Absolute is: ${res.isAbsolute}');

            widget.allFiles.add(res);
            print('widget.allFiles: ${widget.allFiles.length}');
          }
        });
      }

      setState(() {

      });
    } catch (err) {
      print(err);
    }
  }

  _pickImagesFromGallery() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: true,           /// Flutter Web set => true for bytes data
        withReadStream: false,    /// Flutter Web set => false
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if(result != null) {
        result.files.forEach((element) {
          PlatformFile platformFile = element;
          if(kIsWeb) {
            // File file = File.fromRawPath(result.files.single.bytes);

            File file = MemoryFileSystem().file(platformFile.name);
            // file.writeAsBytesSync(platformFile.bytes!.toList());

            var res = file.absolute;

            print('Memory FileSystem !!');
            print('Absolute is: ${file.isAbsolute}');
            print('Path: ' + res.path);

            widget.allFiles.add(file);
            print('widget.allFiles: ${widget.allFiles.length}');
          }
          else {
            print('Local FileSystem !!');
            File res = const LocalFileSystem().file(platformFile.path);
            // res.writeAsBytesSync(platformFile.bytes!.toList());

            print('Absolute is: ${res.isAbsolute}');

            widget.allFiles.add(res);
            print('widget.allFiles: ${widget.allFiles.length}');
          }
        });
      }

      setState(() {

      });
    } catch (err) {
      print(err);
    }
  }

  getThumbnail(String path) {
    if(path.contains('http')) {
      if(path.contains('.pdf') || path.contains('.doc') || path.contains('.docx') || path.contains('.xls') || path.contains('.xlsx')){
        return const Icon(Icons.insert_drive_file, size: 20.0,);
      }
      return Image.network(path);
    }
    else if(path.contains('.jpg') || path.contains('.jpeg') || path.contains('.png')) {
      return Image.file(File(path));
    }
    else{
      return Icon(Icons.insert_drive_file, size: 20.0,);
    }
  }

  viewDocument(String path) async {
    if(path.contains('http')) {
      if(path.contains('.pdf') || path.contains('.doc') || path.contains('.docx') || path.contains('.xls') || path.contains('.xlsx')){
        return await _launchURL(path, false);
      }
      return await _launchURL(path, true);
      // return await OpenFile.open(path);
    }
    else if(path.contains('.jpg') || path.contains('.jpeg') || path.contains('.png')) {
      return await OpenFilex.open(path);
    }
    else{
      // var res = await OpenFile.open(path);
      var res = SfPdfViewer.file(File(path));
      return res;
    }
  }
}

