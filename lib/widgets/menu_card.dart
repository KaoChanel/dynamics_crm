import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({super.key, required this.title, required this.path});

  final String title;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        margin: const EdgeInsets.all(8.0),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          // decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Container(
              height: 135,
              width: 200,
              // decoration: BoxDecoration(color: Colors.blueAccent),
              child: Image(
                image: AssetImage(path),
                fit: BoxFit.cover,
              ),
              // Center(
              //     child: Icon(
              //       icon,
              //       size: 40.0,
              //       color: Colors.black,
              //     )),
            ),
            //SizedBox(height: 5.0),
            Container(
                color: Colors.lightGreen,
                padding: const EdgeInsets.only(bottom: 6, top: 3),
                child: Center(
                  child: Text(
                      title,
                      style: const TextStyle(
                          height: 1.5,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)
                  ),
                ))
          ],
        ));
  }
}
