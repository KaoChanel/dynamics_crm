import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class CustomerDetail extends StatefulWidget {
  final Customer customer;
  const CustomerDetail({super.key, required this.customer});

  @override
  _CustomerDetailState createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียด'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customerInfo('รหัสลูกค้า', widget.customer?.code ?? '', TextAlign.left),
                              customerInfo('เลขที่ผู้เสียภาษี', widget.customer?.taxRegistrationNumber ?? '', TextAlign.left)
                            ],
                          ),
                          customerInfo('ชื่อลูกค้า', widget.customer?.displayName ?? '', TextAlign.left),
                          // Text('${widget.customer?.custName ?? ''} (${widget.customer?.custCode ?? ''})', style: TextStyle(fontWeight: FontWeight.bold),),
                          // Text(widget.customer?.custStatus ?? ''),
                          // Text('เลขภาษี ${widget.customer?.taxId ?? ''}'),
                          // Text('โทร ${widget.customer?.contTel ?? ''}'),
                          customerInfo('ที่อยู่', '${widget.customer?.addressLine1} ${widget.customer?.addressLine2 ?? ''} ${''} ${widget.customer?.city ?? ''} ${widget.customer?.state ?? ''} ${widget.customer?.postalCode ?? ''}', TextAlign.left),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customerInfo('เบอร์ติดต่อ', widget.customer?.phoneNumber ?? '-', TextAlign.left),
                              customerInfo('E-Mail', widget.customer?.email ?? '-', TextAlign.left)
                            ],
                          ),
                        ],
                      ),
                    ),
                    customerMenu(),
                  ],
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    customerInfo('สถานะ', widget.customer?.blocked ?? '-', TextAlign.left),
                                    // customerInfo('เครดิตวัน', NumberFormat('#,###.##').format(widget.customer?.creditDays ?? 0), TextAlign.right),
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     customerInfo('วงเงินทั้งหมด', CURRENCY.format(widget.customer?.creditAmnt ?? 0 + widget.customer?.creditTempIncrease ?? 0), TextAlign.left),
                                //     customerInfo('วงเงินใช้ไป', CURRENCY.format(widget.customer?.reNetBrchAmnt ?? 0 + widget.customer?.cheqReturnedAmnt ?? 0 + widget.customer?.waitCheqAmnt ?? 0), TextAlign.right),
                                //   ],
                                // ),

                                // customerInfo('วงเงินคงเหลือ', CURRENCY.format(widget.customer?.creditBalance ?? 0), TextAlign.left),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton.icon(
        icon: const Icon(Icons.today_outlined, size: 30.0,),
        label: const Text('นัดหมายลูกค้า', style: TextStyle(fontSize: 22.0),),
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20.0)
        ),
        onPressed: () async {
          if(CUSTOMER?.id != null || widget.customer != null) {
            await showAppointment(this.context);
          }
        },
      ),
    );
  }

  customerInfo(String title, String text, TextAlign align) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey, fontSize: 12.0)),
          Text(text, textAlign: align,)
        ],
      ),
    );
  }

  customerMenu() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: [
          Expanded(
              child: TextButton(
                child: Column(
                  children: [
                    Icon(Icons.map_outlined, size: 30.0,),
                    Text('แผนที่'),
                  ],
                ),
                onPressed: widget.customer.latitude == null || widget.customer.latitude == '' ? null : () async {
                  if(widget.customer.latitude!.isNotEmpty && widget.customer.longitude!.isNotEmpty) {
                    String url = 'https://www.google.com/maps/search/?api=1&query=${widget.customer.latitude},${widget.customer.longitude}';
                    await _launchInBrowser(url);
                  }
                },
              )
          ),
          Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    right: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                child: TextButton(
                  child: Column(
                    children: [
                      Icon(Icons.location_on_outlined, size: 30.0,),
                      Text('เก็บพิกัด'),
                    ],
                  ),
                  onPressed: () async {
                    // if(globals.newcustomer_newcustid != '0'){
                    //   globals.newcustomer_newcustid = widget.customer?.id;
                    //
                    //   if(widget.customer.latitude.isEmpty && widget.customer.longitude.isEmpty){
                    //     globals.customerLocationPage = 'create_customer';
                    //   }else{
                    //     globals.customerLocationPage = 'edit_customer';
                    //   }
                    //
                    //   await Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => CustomerLocationPortrait(customer: widget.customer,)
                    //       )
                    //   );
                    // }
                  },
                ),
              )
          ),
          Expanded(
              child: TextButton(
                child: Column(
                  children: [
                    Icon(Icons.image_outlined, size: 30.0,),
                    Text('รูปภาพ'),
                  ],
                ),
                onPressed: () {
                  // if(globals.newcustomer_newcustid != '0'){
                  //   FocusScope.of(context).unfocus();
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => CustomerGallery(customerId: widget.customer?.custId,)
                  //       )
                  //   );
                  // }
                },
              )
          )
        ],
      ),
    );
  }

  showAppointment(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.85,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.70,
                child: AppointmentCreate(customer: widget.customer),
              );
            },
          ),
        );
      },
    );
  }

  getLocation() async {
    LocationData locationData;
    LocationData currentLocation;

    final LocationData data = await Location().getLocation();
    setState(() {
      locationData = data;
    });

    print("Get Location: $data");
  }

  Future<PermissionStatus> checkPermission() async {
    return await Location().hasPermission();
  }

  Future<PermissionStatus> requestPermission() async {
    return await Location().requestPermission();
  }

  checkLocation() async {
    PermissionStatus permissionGranted = await checkPermission();
    if (kIsWeb) {
      if (permissionGranted != PermissionStatus.granted) {
        requestPermission();
      }

      getLocation();
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