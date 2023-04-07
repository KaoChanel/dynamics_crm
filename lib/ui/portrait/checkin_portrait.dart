import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dynamics_crm/models/activity.dart';
import 'package:dynamics_crm/ui/location_maps.dart';
import 'package:dynamics_crm/ui/portrait/customer_select.dart';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:ismart_crm/portrait_layouts/customer_location_portrait.dart';
// import 'package:ismart_crm/src/customer_appointment.dart';
// import 'package:ismart_crm/src/customer_gallery.dart';
// import 'package:ismart_crm/src/customer_location.dart';
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/customer.dart';
import '../appoinment_create.dart';
import 'customer_location_portrait.dart';

class CheckInPortrait extends StatefulWidget {

  const CheckInPortrait({super.key, required this.customer});

  final Customer customer;

  @override
  _CheckInPortraitState createState() => _CheckInPortraitState();
}

class _CheckInPortraitState extends State<CheckInPortrait> {

  LatLng currentLocation = DEFAULT_LOCATION;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เข้าเยี่ยม'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerSelect()));
              },
              icon: const Icon(Icons.manage_accounts, size: 30.0,))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: ListView(
                    primary: false,
                    shrinkWrap: true,
                    children: [],
                  ),
                )
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton.icon(
        icon: const Icon(Icons.location_on_outlined, size: 25.0,),
        label: const Text('Check In', style: TextStyle(fontSize: 18.0),),
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15.0)
        ),
        onPressed: () async {
          if(CUSTOMER.latitude == null || CUSTOMER.longitude == null){
            SharedWidgets.showAwesomeSnackBar(context, ContentType.warning, 'ยังไม่มีพิกัดลูกค้า', 'ต้องเก็บพิกัดลูกค้าก่อนทำการ Check In');
          }
          else{
            await checkLocation();
            if(currentLocation != null){
              await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      LocationMaps(activity: Activity.checkIn, location: currentLocation)
                  )
              );
            }
          }
        },
      ),
    );
  }

  Future<PermissionStatus> checkPermission() async {
    return await Location().hasPermission();
  }

  Future<PermissionStatus> requestPermission() async {
    return await Location().requestPermission();
  }

  getLocation() async {
    LocationData data = await Location().getLocation();
    currentLocation = LatLng(data.latitude ?? 13, data.longitude ?? 100);
  }

  checkLocation() async {
    PermissionStatus permissionGranted = await checkPermission();
    if (kIsWeb) {
      if (permissionGranted != PermissionStatus.granted) {
        requestPermission();
      }

      await getLocation();
    }
  }

  _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}