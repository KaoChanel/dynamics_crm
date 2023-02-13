import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:ismart_crm/models/tbmNewCustType.dart';
// import 'package:ismart_crm/src/customer_gallery.dart';
// import 'package:ismart_crm/src/customer_location.dart';
import 'package:location/location.dart';
// import 'package:rich_alert/rich_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/district.dart';
import '../../models/customer.dart';
import '../../models/province.dart';
import '../../models/task_event.dart';
import 'customer_location_portrait.dart';

class CustomerEditPortrait extends StatefulWidget {
  const CustomerEditPortrait({super.key, required this.customer});

  final Customer customer;

  @override
  _CustomerEditPortraitState createState() => _CustomerEditPortraitState();
}

class _CustomerEditPortraitState extends State<CustomerEditPortrait> {

  late Customer myCustomer;
  TextEditingController txtRowID = TextEditingController(); // Primary Key
  TextEditingController txtNewCustomerCode = TextEditingController(); //รหัสลูกค้า
  TextEditingController txtNewCustomerName = TextEditingController(); //ชื่อลูกค้า
  TextEditingController txtAddress1 = TextEditingController(); //ที่อยู่
  TextEditingController txtSubDistrict = TextEditingController(); //ตำบล
  TextEditingController txtPostCode = TextEditingController(); //รหัษไปรษณี
  TextEditingController txtContactTel = TextEditingController(); //เบอร์โทรผู้ติดต่อ
  TextEditingController txtTaxID = TextEditingController(); //เลขที่ประจำตัวผู้เสียภาษี
  TextEditingController txtRemark = TextEditingController(); //หมายเหตุ
  TextEditingController txtLatLng = TextEditingController(); //ตำแหน่งพิกัด

  List<Province> allProvince = <Province>[];
  List<District> allDistrict = <District>[];

  Province selectedProvince = Province(name: '');
  District selectedDistrict = District(name: '');
  late int selectedNewTypeID;

  final _formKey = GlobalKey<FormState>();

  late GoogleMapController mapController;
  // Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Set<Marker> marker = {};
  LatLng position = const LatLng(13.00, 100.00);

  final Location location = Location();
  late LocationData? _locationData;
  late PermissionStatus _permissionGranted;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedWidgets.showLoader(context, false);

      await checkLocation();
      // await _apiService.getCustomerLocation('Y',widget.customer.custId.toString()); // ดึง พิกัด
      //await getCustomerImages(widget.customer.custId); //ดึงข้อมูลรูปภาพ
      Navigator.pop(context);

      setState(() {
        allProvince = PROVINCES;
        allDistrict = DISTRICTS;

        myCustomer = widget.customer;
        setController(myCustomer);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    txtRowID.dispose();
    txtNewCustomerCode.dispose();
    txtNewCustomerName.dispose();
    txtAddress1.dispose();
    txtSubDistrict.dispose();
    txtPostCode.dispose();
    txtContactTel.dispose();
    txtTaxID.dispose();
    txtRemark.dispose();
    txtLatLng.dispose();
  }

  setCustomer() {
    myCustomer.displayName = txtNewCustomerName.text;
    // myCustomer.custTypeId = selectedNewTypeID;
    myCustomer.addressLine1 = txtAddress1.text;
    myCustomer.city = txtSubDistrict.text;
    myCustomer.postalCode = txtPostCode.text;
    myCustomer.phoneNumber = txtContactTel.text;
  }

  setController(Customer customer) {
    txtNewCustomerCode.text = customer.code ?? '';
    txtNewCustomerName.text = customer.displayName ?? '';
    // selectedNewTypeID = customer.custTypeId ?? '';
    txtAddress1.text = customer.addressLine1 ?? '';
    txtSubDistrict.text = customer.city ?? '';
    txtPostCode.text = customer.postalCode ?? '';
    txtContactTel.text = customer.phoneNumber ?? '';

    selectedDistrict = allDistrict.firstWhere((e) => e.name == customer.city, orElse: () => District(name: ''));
    selectedProvince = allProvince.firstWhere((e) => e.name == customer.state, orElse: () => Province(name: ''));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onTapMap() async {
    // globals.customerLocationPage = 'create_customer';

    LatLng res = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomerLocationPortrait(customer: Customer())
        )
    );

    if(res != null) {
      position = res;
    }

    setState(() {
      marker.clear();
      marker.add(
          Marker(
              position: position,
              markerId: MarkerId(position.toString())
          )
      );
    });
  }

  void onTapGoogleMap(LatLng location) async {
    // globals.customerLocationPage = 'create_customer';

    LatLng res = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const CustomerLocationPortrait(customer: null)
        )
    );

    if(res != null) {
      position = res;
    }

    setState(() {
      mapController.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(
                target: position,
                zoom: 18.0,
              )
          )
      );

      marker.clear();
      marker.add(
          Marker(
              position: position,
              markerId: MarkerId(position.toString())
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ลูกค้าใหม่'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: TextFormField(
                    // readOnly: true,
                    enabled: false,
                    controller: txtNewCustomerCode,
                    decoration: const InputDecoration(
                      labelText: 'รหัสลูกค้า',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      //labelText: "รหัสลูกค้า",
                    ),
                  ),
                ),

                typeList(),

                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: txtNewCustomerName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*ระบุชื่อลูกค้าใหม่ของคุณ';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      // floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "ชื่อลูกค้า",
                      // errorText: _validate_txtNewCustName == true ? 'โปรดระบุชื่อลูกค้า' : null,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: TextFormField(
                    readOnly: false,
                    controller: txtTaxID,
                    keyboardType: TextInputType.number, //เฉพาะตัวเลข
                    maxLength: 13, //จำกัดการกรอก 13 หลัก
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], //เฉพาะตัวเลข
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      labelText: "เลขประจำตัวผู้เสียภาษี",
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: txtAddress1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
                      //floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "ที่อยู่",
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    readOnly: false,
                    controller: txtPostCode,
                    maxLength: 5, //จำกัดการกรอก 5 หลัก
                    keyboardType: TextInputType.number, //เฉพาะตัวเลข
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], //เฉพาะตัวเลข
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      labelText: "รหัสไปรษณีย์",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*ระบุรหัสไปรษณีย์.';
                      }
                      return null;
                    },
                  ),
                ),

                provinceList(),

                districtList(),

                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    readOnly: false,
                    controller: txtSubDistrict,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*ระบุแขวง / ตำบล';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      labelText: "แขวง / ตำบล",
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    readOnly: false,
                    controller: txtContactTel,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      labelText: "เบอร์โทร",
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: TextFormField(
                    readOnly: false,
                    maxLines: 2,
                    controller: txtRemark,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
                      labelText: "หมายเหตุ",
                    ),
                  ),
                ),

                customerMenu(),

                // Container(
                //     height: 200,
                //     padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                //     child: Row(
                //       children: [
                //         Expanded(
                //           child: position.longitude != 100.00 ? GoogleMap(
                //             markers: marker,
                //             onMapCreated: _onMapCreated,
                //             // onMapCreated: (GoogleMapController controller) {
                //             //   _controller.complete(controller);
                //             // },
                //             initialCameraPosition: CameraPosition(
                //               target: position,
                //               zoom: 18.0,
                //             ),
                //             onTap: onTapGoogleMap,
                //           ) : InkWell(
                //             child: Container(
                //               color: Colors.grey.shade200,
                //               child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Icon(Icons.add_location_alt_outlined, size: 80.0, color: Colors.grey.shade400,),
                //                   Container(
                //                       padding: EdgeInsets.symmetric(vertical: 5.0),
                //                       child: Text('เก็บพิกัด', style: TextStyle(fontSize: 26, color: Colors.grey.shade500),)
                //                   )
                //                 ],
                //               ),
                //             ),
                //             onTap: onTapMap,
                //           ),
                //         ),
                //       ],
                //     )
                // ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(9.0),
        color: Colors.transparent,
        child:
        Row(
          children: [
            // Expanded(
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 5.0),
            //     child: ElevatedButton(
            //         onPressed: () async {
            //
            //         },
            //         child: Icon(Icons.delete_forever, size: 24,),
            //         style: ElevatedButton.styleFrom( padding: EdgeInsets.all(13),
            //             primary: Colors.red)
            //     ),
            //   ),
            // ),
            Expanded(
              //flex: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: ElevatedButton.icon(
                  // onPressed: globals.objCustomersLocation == null || globals.objCustomersLocation == '' ? null : () async {
                  //   await checkIn();
                  // },
                    onPressed: () async {
                      // globals.newcustomer_newcustid = myCustomer.id;
                      await checkIn();
                    },
                    // onPressed: () async {
                    //   FocusScope.of(context).unfocus();
                    // },
                    icon: Icon(Icons.location_on),
                    label: Text('เช็คอิน', style: TextStyle(fontSize: 18),),
                    style: ElevatedButton.styleFrom( padding: EdgeInsets.all(13),
                        primary: CUSTOMER_LOCATION == null ? Colors.grey : Colors.blueAccent)
                ),
              ),
            ),
            Expanded(
              //flex: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: ElevatedButton.icon(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        await put();
                      }
                    },
                    icon: Icon(Icons.done_all),
                    label: Text('บันทึกข้อมูล', style: TextStyle(fontSize: 18),),
                    style: ElevatedButton.styleFrom( padding: EdgeInsets.all(13),
                        primary: Colors.green)
                ),
              ),
            ),
          ],
        ),
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
                // onPressed: myCustomer.latitude == null || myCustomer.latitude == '' ? null : () async {
                //   if(myCustomer.latitude.isNotEmpty && myCustomer.longitude.isNotEmpty) {
                //     String url = 'https://www.google.com/maps/search/?api=1&query=${myCustomer.latitude},${myCustomer.longitude}';
                //     await _launchInBrowser(url);
                //   }
                // },
                onPressed: CUSTOMER_LOCATION == null ? null : () async {
                  String url = 'https://www.google.com/maps/search/?api=1&query=${CUSTOMER_LOCATION!.latitude},${CUSTOMER_LOCATION!.longitude}';
                  await _launchInBrowser(url);
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
                    // globals.newcustomer_newcustid = myCustomer.id;
                    // if(globals.objCustomersLocation == null){
                    //   globals.customerLocationPage = 'create_newcustomer';
                    // }else{
                    //   globals.customerLocationPage = 'edit_newcustomer';
                    // }
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerLocationPortrait(customer: myCustomer)));
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
                onPressed: null,
                // onPressed: () {
                //   if(globals.newcustomer_newcustid != '0'){
                //     FocusScope.of(context).unfocus();
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => CustomerGallery(customerId: myCustomer?.custId,)
                //         )
                //     );
                //   }
                // },
              )
          )
        ],
      ),
    );
  }

  _launchInBrowser(String url) async {
    if(await canLaunch(url)) {
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

  Widget typeList() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownButtonFormField(
        // isExpanded: true,
        // isDense: true,
        hint: const Text('เลือกประเภทลูกค้า'),
        icon: const Icon(Icons.keyboard_arrow_down),
        decoration: const InputDecoration(
            labelText: 'ประเภทลูกค้า',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0)
        ),
        items: CUSTOMER_TYPE.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item.title),
          );
        }).toList() ?? [],
        validator: (value) {
          if(value == null){
            return '*เลือกประเภทลูกค้า';
          }
          return null;
        },
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        onChanged: (value) {
          selectedNewTypeID = value as int;
        },
        value: selectedNewTypeID,
      ),
    );
  }

  Widget provinceList() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownButtonFormField(
        isExpanded: false,
        isDense: true,
        hint: const Text('เลือกจังหวัด'),
        icon: const Icon(Icons.keyboard_arrow_down),
        decoration: const InputDecoration(
            labelText: 'จังหวัด',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0)
        ),
        value: selectedProvince,
        items: allProvince.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item.name),
          );
        }).toList() ?? [],
        validator: (value) {
          if(value == null) {
            return '*เลือกจังหวัด';
          }
          return null;
        },
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        onChanged: (value) {
          setState(() {
            selectedProvince = value as Province;
            selectedDistrict = District(name: '');
            allDistrict = DISTRICTS.where((e) => e.provinceName == selectedProvince.name).toList();
          });
        },
      ),
    );
  }

  Widget districtList() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownButtonFormField(
        isExpanded: true,
        isDense: true,
        hint: const Text('เลือกเขต / อำเภอ'),
        icon: const Icon(Icons.keyboard_arrow_down),
        decoration: const InputDecoration(
            labelText: 'เขต / อำเภอ',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0)
        ),
        items: allDistrict.where((e) => e.provinceName == selectedProvince.name).map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item.name ?? ''),
          );
        }).toList() ?? [],
        validator: (value) {
          if(value == null) {
            return '*เลือกเขต / อำเภอ';
          }
          return null;
        },
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        onChanged: (value) {
          setState(() {
            selectedDistrict = value as District;
          });
        },
        value: selectedDistrict,
      ),
    );
  }

  put(){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      width: 450,
      title: 'Save Changes ?',
      desc: 'Are you sure to edit customer information ?\n',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {

        setCustomer();

        TaskEvent event = TaskEvent(isComplete: true, eventCode: 1, title: '', message: '');

        // TaskEvent event =
        // await ApiService().saveNewCustomer(
        //     myCustomer,
        //     selectedDistrict.idamphur,
        //     selectedProvince.idprovince,
        //     txtRemark.text);

        if (event.isComplete) {
          AwesomeDialog(
              context: context,
              dialogType: DialogType.SUCCES,
              animType: AnimType.BOTTOMSLIDE,
              width: 450,
              title: 'Successful',
              desc: 'Customer information has updated. \n',
              //btnCancelOnPress: () {},
              btnOkOnPress: () {
                Navigator.pop(context, true);
              }
          ).show();

        } else { //print('error');
          Navigator.pop(context);
          // return showDialog<void>(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return RichAlertDialog(
          //         alertTitle: richTitle(event.title),
          //         alertSubtitle:
          //         richSubtitle(event.message),
          //         alertType: event.eventCode,
          //       );
          //     });
        }
      },
    ).show();
  }

  checkIn() async {
    if(CUSTOMER_LOCATION == null){
      AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.BOTTOMSLIDE,
          width: 450,
          title: 'ไม่สามารถ Check In ได้',
          desc: 'กรุณาเก็บพิกัดลูกค้า\nคุณต้องการเก็บพิกัดลูกค้าหรือไม่ ?',
          btnCancelOnPress: () {},
          btnOkOnPress: () async {
            // globals.customerLocationPage = 'create_newcustomer';

            Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerLocationPortrait(customer: Customer())));
          }
      ).show();
    }
    else{
      // Check Location & Service
      SharedWidgets.showLoader(context, false);

      try {
        checkLocation();

        /// คำนวนระยะห่าง 5 กิโลเมตร
        double distance = distanceCalculate(CUSTOMER_LOCATION!, _locationData!, 'K');

        print("Radius รัศมี ที่กำหนด : ${SYSTEM_OPTION.limitRadius} \n Distance ระยะห่าง : $distance กิโลเมตร");
        Navigator.pop(context);

        if(distance > SYSTEM_OPTION.limitRadius) { // มากกว่า 5.000 เมตร หรือ 5 กิโลเมตร
          return SharedWidgets.showAlert(context, 'Distance Exceeded', 'ตำแหน่งของท่านอยู่ห่างจากรัศมีเกิน ${SYSTEM_OPTION.limitRadius} กิโลเมตร');
        }else{
          post();
        }
      } catch (e) {
        Navigator.pop(context); // ปิด dialog
        _locationData = null;
        print('Check In Exception \n' + e.toString());
        return SharedWidgets.showAlert(context, 'GPS Service', 'โปรดตรวจสอบระบบ GPS\nสิทธิ์การเข้าถึงและอื่นๆ ที่เกี่ยวข้อง');
      }
    }
  }

  /// บันทึก เช็คอิน
  post() async {
    // TaskEvent event = await ApiService().postCheckIn(
    //     'Y',
    //     int.parse(globals.newcustomer_newcustid),
    //     globals.objCustomersLocation.latitude.toString(),
    //     globals.objCustomersLocation.longitude.toString(),
    //     _location.latitude.toString(),
    //     _location.longitude.toString()
    // );

    TaskEvent event = TaskEvent(isComplete: true, eventCode: 1, title: '', message: '');

    if (event.isComplete) {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          width: 450,
          title: 'SUCCESS',
          desc: 'Check In Complete',
          //btnCancelOnPress: () {},
          btnOkOnPress: () async {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (BuildContext context) => super.widget));
          }
      ).show();
    } else {
      Navigator.pop(context);
      // return showDialog<void>(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return RichAlertDialog(
      //         alertTitle: richTitle(event.title),
      //         alertSubtitle:
      //         richSubtitle(event.message),
      //         alertType: event.eventCode,
      //       );
      //     });
    }
  }

  /// เช็ค พิกัด
  checkLocation() async {
    _checkPermissions(); // เช็ค สิทธ์
    if (!kIsWeb){ //ถ้าไม่ใช่เว็บไซต์
      if(_permissionGranted == PermissionStatus.denied || _permissionGranted == PermissionStatus.deniedForever || _permissionGranted == null) {
        showAlertRequestPermissionLocation(context);
      }
      if(_permissionGranted != PermissionStatus.denied || _permissionGranted != PermissionStatus.deniedForever) {
        _getLocation();
      }
    }else{ // ถ้า เป็นเว็บไซต์
      if(_permissionGranted != PermissionStatus.granted && _permissionGranted == null) {
        _requestPermission();
      }
      _getLocation();
    }
  }

  /// เช็ค สิทธ์
  Future<void> _checkPermissions() async {
    final PermissionStatus permissionGrantedResult = await location.hasPermission();
    _permissionGranted = permissionGrantedResult;
  }

  /// ร้องขอ สิทธ์
  Future<void> _requestPermission() async {
    final PermissionStatus permissionRequestedResult = await location.requestPermission();
    _permissionGranted = permissionRequestedResult;
  }

  /// ตรวจจับ Location ครั้งเดียว ตามการเรียก
  Future<void> _getLocation() async {
    final LocationData _locationResult = await location.getLocation();
    _locationData = _locationResult;
  }

  /// showDialog Location
  void showAlertRequestPermissionLocation(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
              children:[
                Flexible(flex: 1,child: Image.asset('assets/new-bisgroup-logo.png',width: 100, height: 80, fit: BoxFit.contain,)),
                // Image.network('https://flutter-examples.com/wp-content/uploads/2019/12/android_icon.png',
                //   width: 50, height: 50, fit: BoxFit.contain,),
                Flexible(flex: 3,child: Padding(
                  padding: const EdgeInsets.only(left: 10,top: 0,right: 0,bottom: 0),
                  child: Text('Allow "SmartSales BIS" to access your location even when you are not using the App?'),
                ))
              ]
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Text('     SmartSales BIS needs access to your location. For use in recording visits, Check In and Google Map.\n'
                  '     Please "Allow" access to your location. For your benefit of making SmartSales BIS work perfectly.\n'
                  '     If you don\'t want to share a map of your location. Your can choose Don\'t Allow.'),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Don\'t Allow" , style: TextStyle(fontWeight: FontWeight.normal,fontStyle: FontStyle.italic ,color: Colors.grey) ),
              onPressed: () {
                //Put your code here which you want to execute on Yes button click.
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Allow" , style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.blueAccent) ),
              onPressed: () async {
                await _requestPermission();
                if(_permissionGranted == PermissionStatus.denied || _permissionGranted == PermissionStatus.deniedForever) {
                  //
                  if(_permissionGranted == PermissionStatus.deniedForever){ //ถ้าเปิดสิทธิ์ ถาวร ให้มีกล่องแจ้งเตือนอีกแบบ เปิดไปที่หน้า setting
                    Navigator.of(context).pop();
                    //showAlertRequestPermissionLocationIFdeniedForever(context);
                  }
                } else{
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        )
    );
  }

/// Start Customer View Image
/// End Customer View Image
}
