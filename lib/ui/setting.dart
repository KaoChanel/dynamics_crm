import 'dart:async';

import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/task_event.dart';
import 'package:dynamics_crm/services/api_service.dart';
import 'package:dynamics_crm/widgets/shared_widget.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/customer.dart';
import '../services/api_service.dart';
import 'login.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SharedWidgets.showLoader(context, false);

      await ApiService().getEmployeeOption();
      setState(() {
        _selectAppointment = (EMPLOYEE_OPTION?.emailAlertAppointment == "Y" || EMPLOYEE_OPTION?.emailAlertAppointment == null) ? true : false;
      });

      Navigator.pop(context);
    });
  }

  bool _selectAppointment = true;

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('password', '');
    prefs.setString('company', '');
    prefs.setString('customer', '');
    prefs.setString('lockPrice', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text('การตั้งค่า'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.bottomSlide,
                width: 450,
                title: 'บันทึกการตั้งค่า',
                desc: 'ต้องการบันทึกการตั้งค่าหรือไม่ ?', // \n\n${txtNewCustCode.text}\n',
                btnCancelOnPress: () {
                  Navigator.of(context).pop();
                },
                btnOkOnPress: () async {
                  if(EMPLOYEE_OPTION == null){ // ถ้ายังไม่เคยบันทึก การตั้งค่า
                    post();
                  }else{
                    put();
                  }
                  // Navigator.of(context).pop();
                }
            ).show();
          },
        ),
      ),
      body:
      // Row(
      //   children: [
      //     Expanded(
      //       flex: 2,
      //         child: SingleChildScrollView(
      //           child: ListTileTheme(
      //             selectedTileColor: Colors.grey.shade200,
      //             selectedColor: Theme.of(context).primaryColor,
      //             child: ListTile(
      //               leading: Icon(Icons.widgets),
      //               title: Text('การใช้งาน'),
      //               selected: true,
      //         ),
      //       ),
      //     )),
      //     Expanded(
      //       flex: 4,
      //         child: SingleChildScrollView(
      //           child: ListTileTheme(
      //             child: ListTile(
      //               title: Text('แก้ไขราคาสินค้า'),
      //               trailing: Switch(
      //                 value: globals.employee.isLockPrice == 'Y' ? true : false,
      //                 onChanged: (value) {
      //                   setState(() async {
      //                     Employee emp = globals.employee;
      //                     emp.isLockPrice == 'Y' ? 'N' : 'Y';
      //                     _apiService.updateEmployee(emp);
      //                   });
      //                 },
      //               ),
      //             ),
      //           ),
      //         )),
      //   ],
      // ),

      Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  color: Theme.of(context).primaryColor,
                  child: ListTile(
                    onTap: () {
                      // open edit profile
                    },
                    title: Text(EMPLOYEE?.name ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage("assets/avatar_01.png"),
                    ),
                    trailing: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
                // const SizedBox(height: 10.0),
                // Card(
                //   elevation: 4.0,
                //   margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10.0)),
                //   child: Column(
                //     children: <Widget>[
                //       ListTile(
                //         leading: Icon(
                //           Icons.lock_outline,
                //           color: Theme.of(context).primaryColor,
                //         ),
                //         title: Text("Change Password"),
                //         trailing: Icon(Icons.keyboard_arrow_right),
                //         onTap: () {
                //           //open change password
                //         },
                //       ),
                //       _buildDivider(),
                //       // ListTile(
                //       //   leading: Icon(
                //       //     FontAwesomeIcons.language,
                //       //     color: Theme.of(context).primaryColor,
                //       //   ),
                //       //   title: Text("Change Language"),
                //       //   trailing: Icon(Icons.keyboard_arrow_right),
                //       //   onTap: () {
                //       //     //open change language
                //       //   },
                //       // ),
                //       // _buildDivider(),
                //       ListTile(
                //         leading: Icon(
                //           Icons.location_on,
                //           color: Theme.of(context).primaryColor,
                //         ),
                //         title: Text("Change Location"),
                //         trailing: Icon(Icons.keyboard_arrow_right),
                //         onTap: () {
                //           //open change location
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 20.0),
                const Text(
                  "การแจ้งเตือน Email",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).primaryColor,
                  contentPadding: const EdgeInsets.all(0),
                  value: _selectAppointment,
                  title: const Text("การนัดหมายลูกค้า" , style: TextStyle(fontWeight: FontWeight.bold),),
                  onChanged: (val) {
                    setState(() {
                      _selectAppointment = val;
                    });
                  },
                ), // Switch Work Schedule

                // CheckboxListTile(
                //   activeColor: Theme.of(context).primaryColor,
                //   contentPadding: const EdgeInsets.fromLTRB(13,0,13,0),
                //   value: false,
                //   title: Text("Received newsletter"),
                //   onChanged: null,
                // ),
                // CheckboxListTile(
                //   activeColor: Theme.of(context).primaryColor,
                //   contentPadding: const EdgeInsets.fromLTRB(13,0,13,0),
                //   value: false,
                //   title: Text("Received newsletter"),
                //   onChanged: null,
                // ),
                // CheckboxListTile(
                //   activeColor: Theme.of(context).primaryColor,
                //   contentPadding: const EdgeInsets.fromLTRB(13,0,13,0),
                //   value: false,
                //   title: Text("Received newsletter"),
                //   onChanged: null,
                // ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(8.0,8.0,8.0,8.0),
                  child: Divider(
                    height: 10,
                    thickness: 3, //ความหนา
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                // Text(
                //   "Other Settings",
                //   style: TextStyle(
                //     fontSize: 20.0,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.indigo,
                //   ),
                // ),
                // SwitchListTile(
                //   activeColor: Theme.of(context).primaryColor,
                //   contentPadding: const EdgeInsets.all(0),
                //   value: true,
                //   title: Text("Other 1"),
                //   onChanged: (val) {},
                // ),
                // SwitchListTile(
                //   activeColor: Theme.of(context).primaryColor,
                //   contentPadding: const EdgeInsets.all(0),
                //   value: false,
                //   title: Text("Other 2"),
                //   onChanged: null,
                // ),
                // SwitchListTile(
                //   activeColor: Theme.of(context).primaryColor,
                //   contentPadding: const EdgeInsets.all(0),
                //   value: true,
                //   title: Text("Other 3"),
                //   onChanged: (val) {},
                // ),
                // SwitchListTile(
                //   activeColor: Theme.of(context).primaryColor,
                //   contentPadding: const EdgeInsets.all(0),
                //   value: true,
                //   title: Text("Other 4"),
                //   onChanged: null,
                // ),
                const SizedBox(height: 60.0),
                Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.white,
                  child: ListTile(
                    onTap: () async {
                      CUSTOMER = Customer();
                      // globals.allCustomerByEmp = null;
                      // globals.allShipto = null;
                      // globals.allProduct = null;
                      // globals.editingProductCart = null;
                      //
                      // globals.selectedShipto = null;
                      // globals.selectedShiptoCopy = null;
                      // globals.selectedShiptoDraft = null;
                      //
                      // globals.clearOrder();
                      // globals.clearCopyOrder();
                      // globals.clearDraftOrder();

                      logout();

                      await Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const Login()));
                    },
                    title: Center(
                      child: Text( "Logout",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    trailing: Icon(
                      Icons.logout,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   bottom: -20,
          //   left: -20,
          //   child: Container(
          //     width: 80,
          //     height: 80,
          //     alignment: Alignment.center,
          //     decoration: BoxDecoration(
          //       color: Theme.of(context).primaryColor,
          //       shape: BoxShape.circle,
          //     ),
          //   ),
          // ),
          // Positioned(
          //   bottom: 00,
          //   left: 00,
          //   child: IconButton(
          //     icon: Icon(
          //       FontAwesomeIcons.powerOff,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       //log out
          //     },
          //   ),
          // )
        ],
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }

  /// START SAVE
  post() async {
    String emailAlertAppointment  = _selectAppointment == true ? "Y" : "N";

    // AwesomeDialog(
    //   context: context,
    //   dialogType: DialogType.INFO,
    //   animType: AnimType.BOTTOMSLIDE,
    //   width: 450,
    //   title: 'Confirmation',
    //   desc: 'Are you sure to Save Customers ?',
    //   btnCancelOnPress: () {},
    //   btnOkOnPress: () async {

    TaskEvent event = await ApiService().createEmployeeOption(emailAlertAppointment);

    if (event.isComplete) {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          width: 450,
          title: 'SUCCESS',
          desc: '\nSave Complete\n',
          //btnCancelOnPress: () {},
          btnOkOnPress: () async {
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => super.widget));
            Navigator.of(context).pop();
          }
      ).show();
      //       // Navigator.pop(context);
      //       // showDialog<void>(
      //       //     context: context,
      //       //     builder: (BuildContext context) {
      //       //       return RichAlertDialog(
      //       //         alertTitle: richTitle('SUCCESS'),
      //       //         alertSubtitle:
      //       //         richSubtitle('Save Customers Complete.'),
      //       //         alertType: RichAlertType.SUCCESS ,
      //       //         actions: <Widget>[
      //       //           FlatButton(
      //       //             color: Colors.green,
      //       //             child: Text("OK"),
      //       //             onPressed: (){
      //       //               Navigator.push(
      //       //                   context,
      //       //                   MaterialPageRoute(
      //       //                       builder: (context) => NewCustomer()));
      //       //             },
      //       //           ),
      //       //         ],
      //       //       );
      //       //     });
    } else { //print('error');
      Navigator.pop(context);
      return QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: event.title,
        text: event.message,
      );
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

    // postSaleOrder().then((value) => setState((){}));
    // },
    // )..show();
  }
  put() async { //print('put');
    String emailAlertAppointment  = _selectAppointment == true ? "Y" : "N";
    // AwesomeDialog(
    //   context: context,
    //   dialogType: DialogType.WARNING,
    //   animType: AnimType.BOTTOMSLIDE,
    //   width: 450,
    //   title: 'Confirmation',
    //   desc: 'Are you sure to Update Customers ?\n\n${txtNewCustCode.text}\n',
    //   btnCancelOnPress: () {},
    //   btnOkOnPress: () async {

    TaskEvent event = await ApiService().putEmployeeOption(emailAlertAppointment);

    if (event.isComplete) {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          width: 450,
          title: 'SUCCESS',
          desc: '\nSave Complete\n',
          //btnCancelOnPress: () {},
          btnOkOnPress: () async {
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => super.widget));
            Navigator.of(context).pop();
          }
      ).show();
    } else { //print('error');
      Navigator.pop(context);
      return QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Transaction Completed Successfully!',
      );
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

    //   },
    // )..show();
  }
// delete(){
//   AwesomeDialog(
//     context: context,
//     dialogType: DialogType.WARNING,
//     animType: AnimType.BOTTOMSLIDE,
//     width: 450,
//     title: 'Confirmation',
//     desc: 'Are you sure to Delete Customers ?\n\n${txtNewCustCode.text}\n',
//     btnCancelOnPress: () {},
//     btnOkOnPress: () async {
//       //print(globals.newcustomer_update.rowId);
//       //print(globals.newcustomer_update.newCustId);
//       bool event = await _apiService.deleteNewCustomers(globals.newcustomer_update.rowId, globals.newcustomer_update.newCustId);
//       if (event == true) {
//         AwesomeDialog(
//             context: context,
//             dialogType: DialogType.SUCCES,
//             animType: AnimType.BOTTOMSLIDE,
//             width: 450,
//             title: 'SUCCESS',
//             desc: 'Data Delete is complete \n\n${txtNewCustCode.text}\n',
//             //btnCancelOnPress: () {},
//             btnOkOnPress: () async {
//               Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                       builder: (BuildContext context) => super.widget));
//             }
//         )..show();
//         // Navigator.pop(context);
//         // showDialog<void>(
//         //     context: context,
//         //     builder: (BuildContext context) {
//         //       return RichAlertDialog(
//         //         alertTitle: richTitle('SUCCESS'),
//         //         alertSubtitle:
//         //         richSubtitle('Delete Customers Complete.'),
//         //         alertType: RichAlertType.SUCCESS ,
//         //         actions: <Widget>[
//         //           FlatButton(
//         //             color: Colors.green,
//         //             child: Text("OK"),
//         //             onPressed: (){
//         //               Navigator.push(
//         //                   context,
//         //                   MaterialPageRoute(
//         //                       builder: (context) => NewCustomer()));
//         //             },
//         //           ),
//         //         ],
//         //       );
//         //     });
//       } else { //print('error');
//         Navigator.pop(context);
//         return showDialog<void>(
//             context: context,
//             builder: (BuildContext context) {
//               return RichAlertDialog(
//                 alertTitle: richTitle('ERROR'),
//                 alertSubtitle:
//                 richSubtitle("Can't Delete Customer Data !\n\n${globals.newcustomer_update.newCustCode}\n${globals.newcustomer_update.newCustName}\n"),
//                 alertType: RichAlertType.ERROR,
//               );
//             });
//       }
//     },
//   )..show();
// }
/// END SAVE
}
