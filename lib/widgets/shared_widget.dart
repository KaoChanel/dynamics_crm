import 'package:flutter/material.dart';

class SharedWidgets {
  // static Widget buildAppBar({String? title}) {
  //   return AppBar(
  //     title: Text(title),
  //   );
  // }
  //
  // static Widget buildButton({
  //   @required String label,
  //   @required VoidCallback onPressed,
  // }) {
  //   return RaisedButton(
  //     child: Text(label),
  //     onPressed: onPressed,
  //   );
  // }

  static showAlert(BuildContext context, String title, String content) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close")
                )
              ]
          );
        }
    );
  }

  static showLoader(BuildContext context, bool dismiss) async {
    // var alert = Consumer<MessageDialog>(
    //   builder: (context, dialog, child) =>
    //       AlertDialog(
    //         content: Container(
    //           height: 120,
    //           child: Column(
    //             children: [
    //               const SizedBox(
    //                   width: 60,
    //                   height: 60,
    //                   child: CircularProgressIndicator(
    //                     strokeWidth: 7.0,
    //                   )
    //               ),
    //               Container(
    //                 // margin: EdgeInsets.only(left: 7),
    //                   padding: EdgeInsets.only(top: 25.0),
    //                   child:Text(dialog.message, style: TextStyle(fontSize: 18.0),)
    //               ),
    //             ],),
    //         ),
    //       ),
    // );

    AlertDialog alert = AlertDialog(
      content: Container(
        height: 120,
        child: Column(
          children: [
            SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 7.0,
                )
            ),
            Container(
              // margin: EdgeInsets.only(left: 7),
                padding: const EdgeInsets.only(top: 25.0),
                child: Text('กำลังโหลด', style: TextStyle(fontSize: 18.0))
            ),
          ],),
      ),
    );

    await showDialog(
      barrierDismissible: dismiss,
      context: context,
      builder: (BuildContext context) {
        if(dismiss == false){
          return WillPopScope(
              child: alert,
              onWillPop: () async => false);
        }
        else {
          return alert;
        }
      },
    );
  }
}

