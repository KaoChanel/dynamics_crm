import 'dart:async';
import 'dart:io';

import 'package:dynamics_crm/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/sales_order_line.dart';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamics_crm/providers/data_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../models/activity.dart';
import '../../models/item.dart';
import '../../models/sales_order.dart';
import '../../models/task_event.dart';
import '../../services/api_service.dart';
import '../attachment_manager.dart';
import 'item_edit_portrait.dart';
import 'item_select.dart';

class SalesOrderCreatePortrait extends ConsumerStatefulWidget {
  const SalesOrderCreatePortrait({Key? key}) : super(key: key);

  @override
  ConsumerState<SalesOrderCreatePortrait> createState() => _SalesOrderCreatePortraitState();
}

class _SalesOrderCreatePortraitState extends ConsumerState<SalesOrderCreatePortrait> {
  late Timer timer;
  late String runningNo;
  late String docuNo;
  late String refNo;
  late String custPONo;
  late String creditState;
  late int promoHeaderId;
  double vatRate = 0.07;
  final DateTime documentDate = DateTime.now();
  DateTime shipmentDate = DateTime.now().add(const Duration(hours: 24));
  DateTime orderDate = DateTime.now();
  double priceTotal = 0;
  double discountTotal = 0;
  double discountBill = 0;
  double priceAfterDiscount = 0;
  double vatTotal = 0.0;
  double netTotal = 0.0;
  late SalesOrder myOrderHeader = ref.watch(salesOrder);
  late List<SalesOrderLine> myOrders = ref.watch(salesOrderLines);

  FocusNode focusDiscount = FocusNode();
  TextEditingController txtRunningNo = TextEditingController();
  TextEditingController txtDocuNo = TextEditingController();
  TextEditingController txtRefNo = TextEditingController();
  TextEditingController txtCustPONo = TextEditingController();
  TextEditingController txtSONo = TextEditingController();
  TextEditingController txtDeptCode = TextEditingController();
  TextEditingController txtCopyDocuNo = TextEditingController();
  TextEditingController txtEmpCode = TextEditingController();
  TextEditingController txtEmpName = TextEditingController();
  TextEditingController txtCustCode = TextEditingController();
  TextEditingController txtCustName = TextEditingController();
  TextEditingController txtCreditType = TextEditingController();
  TextEditingController txtCredit = TextEditingController();
  TextEditingController txtStatus = TextEditingController();
  TextEditingController txtRemark = TextEditingController();

  TextEditingController txtShiptoName = TextEditingController();
  TextEditingController txtShiptoCode = TextEditingController();
  TextEditingController txtShiptoProvince = TextEditingController();
  TextEditingController txtShiptoAddress = TextEditingController();
  TextEditingController txtShiptoRemark = TextEditingController();
  TextEditingController txtPriceTotal = TextEditingController();
  TextEditingController txtDiscountTotal = TextEditingController();
  TextEditingController txtDiscountBill = TextEditingController();
  TextEditingController txtPriceAfterDiscount = TextEditingController();
  TextEditingController txtVatTotal = TextEditingController();
  TextEditingController txtNetTotal = TextEditingController();

  TextEditingController txtDocuDate = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  TextEditingController txtShiptoDate = TextEditingController(
      text: DateFormat('dd/MM/yyyy')
          .format(DateTime.now().add(const Duration(hours: 24))));
  TextEditingController txtOrderDate = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var orders = ref.watch(salesOrderLines);
    myOrders = ref.watch(salesOrderLines);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Sales Order"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.9), BlendMode.lighten),
              image: const AssetImage("assets/bg_nic.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                // Row(
                //   children: [
                //     Container(
                //       margin: const EdgeInsets.only(top: 11),
                //       padding: const EdgeInsets.all(10),
                //       width: MediaQuery.of(context).size.width - 20,
                //       decoration: BoxDecoration(
                //         borderRadius: const BorderRadius.only(
                //             topRight: Radius.circular(20),
                //             bottomRight: Radius.circular(0)
                //         ),
                //         color: Theme.of(context).primaryColor,
                //         // boxShadow: [
                //         //   BoxShadow(color: Colors.green, spreadRadius: 3),
                //         // ],
                //       ),
                //       //color: Colors.indigo,
                //       child: const Text(
                //         'ใบสั่งขาย',
                //         style: TextStyle(color: Colors.white, fontSize: 20),
                //       ),
                //     ),
                //   ],
                // ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(DateFormat('EEEE, d MMMM yyyy', 'th').formatInBuddhistCalendarThai(DateTime.now()), style: const TextStyle(color: Colors.black54)),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                        readOnly: true,
                        controller: txtDocuNo,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "ใบสั่งขาย",
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Container(
                  //     padding: EdgeInsets.only(left: 5.0, right: 15.0),
                  //     child: TextFormField(
                  //       readOnly: true,
                  //       controller: txtDocuDate,
                  //       decoration: InputDecoration(
                  //         border: OutlineInputBorder(),
                  //         contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  //         floatingLabelBehavior: FloatingLabelBehavior.always,
                  //         labelText: "วันที่เอกสาร",
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ]),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                        child: TextField(
                          readOnly: true,
                          controller: txtRefNo,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "ใบเสนอราคา",
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                        child: TextFormField(
                          controller: txtShiptoDate,
                          readOnly: true,
                          onTap: () async {
                            DateTime tmpDate = shipmentDate;
                            shipmentDate = (await showDatePicker(
                              context: context,
                              initialDate: shipmentDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 180)),
                            )) ?? DateTime.now();

                            setState(() {
                              if (shipmentDate == null && tmpDate == null) {
                                shipmentDate = DateTime.now().add(const Duration(hours: 24));
                              }
                              else if(shipmentDate == null && tmpDate != null) {
                                shipmentDate = tmpDate;
                              }

                              txtShiptoDate.text =
                                  DateFormat('dd/MM/yyyy').format(shipmentDate);
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "วันที่ส่ง (ปกติ 1 วัน)",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                      child: TextField(
                        controller: txtCustPONo,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          labelText: 'ใบสั่งซื้อ (PO)',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                      child: TextField(
                        controller: txtOrderDate,
                        readOnly: true,
                        onTap: () async {
                          orderDate = (await showDatePicker(
                            context: context,
                            initialDate: orderDate,
                            firstDate: DateTime(1995),
                            lastDate: DateTime(2030))
                          ) ?? DateTime.now();

                          setState(() {
                            if (orderDate == null) orderDate = DateTime.now();
                            txtOrderDate.text = DateFormat('dd/MM/yyyy').format(orderDate);
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'วันที่ลูกค้าสั่งซื้อ',
                        ),
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 15),
                Row(children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                        readOnly: true,
                        initialValue: '${EMPLOYEE?.displayName ?? ''} (${EMPLOYEE?.code ?? ''})',
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'ชื่อพนักงาน',
                        ),
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 15),
                Row(children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                        readOnly: true,
                        maxLines: 2,
                        initialValue: '${CUSTOMER?.displayName ?? ''} (${CUSTOMER?.code ?? ''})',
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'ชื่อลูกค้า',
                        ),
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 15),
                Row(
                  children: [
                    SizedBox(height: 80),
                    Container(
                      margin: const EdgeInsets.only(top: 11),
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width - 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(0)),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        'สถานที่จัดส่ง',
                        style: TextStyle(
                            color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: txtShiptoAddress,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15.0),
                      floatingLabelBehavior:
                      FloatingLabelBehavior.always,
                      labelText: "สถานที่ส่งจริง",
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: txtShiptoProvince,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      labelText: 'ส่งจังหวัด',
                      floatingLabelBehavior:
                      FloatingLabelBehavior.always,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: txtShiptoRemark,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "หมายเหตุ",
                    ),
                  ),
                ),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 80),
                      Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 5.0),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.local_shipping_outlined),
                              label: const Text('สถานที่ส่ง'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                                ),
                              ),
                              onPressed: () {
                                // _showDialog(context);
                              },
                            ),
                          )
                      ),
                      Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 5.0, right: 15.0),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.refresh),
                              label: const Text('ค่าเริ่มต้น'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey,
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              ),
                              onPressed: () {
                                setState(() {
                                  // globals.selectedShipto = globals.allShipto.firstWhere((e) => e.custId == CUSTOMER!.id && e.isDefault == 'Y');
                                  // setSelectedShipto();

                                  Fluttertoast.showToast(
                                      msg: "ใช้ค่าเริ่มต้นเรียบร้อย",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black54,
                                      textColor: Colors.white,
                                      fontSize: 18.0);
                                });
                              },
                            ),
                          )
                      ),
                    ]),

                Row(
                  children: [
                    SizedBox(height: 80),
                    Container(
                      margin: EdgeInsets.only(top: 11),
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width - 20,
                      child: Text(
                        'รายการสินค้าขาย',
                        style: TextStyle(
                            color: Colors.white, fontSize: 20),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(0)),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                salesOrderDetail(),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10, left: 18, right: 5.0),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent,
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                                )
                            ),
                            onPressed: () async {
                              // globals.editingProductCart = null;
                              // var res = await Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             OrderPromo(fromPage: 'ORDER',)));
                              //
                              // if(res != null) {
                              //   // calculateSummary();
                              // }
                            },
                            icon: Icon(Icons.list, color: Colors.white),
                            label: const Text(
                              'รายการโปรโมชั่น',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                          )
                      ),
                    ),

                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10, left: 5.0, right: 18.0),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepOrange[400],
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                                )
                            ),
                            onPressed: () async {
                              // globals.editingProductCart = null;
                              //
                              // await Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             OrderExpressPortrait(type: DocumentType.order,))
                              // );

                              // calculateSummary();
                            },
                            icon: Icon(Icons.local_fire_department,
                                color: Colors.white),
                            label: const Text(
                              'รายการด่วน',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                          )
                      ),
                    )
                  ],
                ),

                Container(
                    margin: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add_circle_outline_outlined,
                          color: Colors.white),
                      label: const Text(
                        'เพิ่มรายการสินค้า',
                        style: TextStyle(
                            fontSize: 14, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal,
                        // splashColor: Colors.green,
                        padding: const EdgeInsets.all(10),
                      ),

                      onPressed: () async {
                        // globals.editingProductCart = null;
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ItemSelect(type: Activity.order)
                            )
                        );

                        // globals.editingProductCart = null;
                        // calculateSummary();
                      },
                    )
                ),

                Row(
                  children: [
                    SizedBox(height: 80),
                    Container(
                      margin: const EdgeInsets.only(top: 11),
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width - 20,
                      child: const Text(
                        'ส่วนท้ายรายการ',
                        style: TextStyle(
                            color: Colors.white, fontSize: 20),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(0)),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // _showRemarkDialog(context);
                        },
                        icon: const Icon(Icons.add_comment),
                        label: const Text(
                          'ข้อความหมายเหตุ',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: txtRemark,
                    maxLength: 80,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      floatingLabelBehavior:
                      FloatingLabelBehavior.always,
                      labelText: "หมายเหตุท้ายบิล",
                      //border: OutlineInputBorder()
                    ),
                    onChanged: (value) {
                      // globals.selectedRemark.remark = value;
                    },
                  ),
                ),

                SizedBox(
                  height: 10.0,
                ),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: txtDiscountTotal,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            labelText: 'รวมส่วนลด',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            // floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: txtPriceTotal,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            // floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText: 'รวมเงิน',
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            // showDiscountTypeDialog();
                            //focusDiscount.requestFocus();
                          },
                        child: Container(),
                          // child: setDiscountType()
                      ),
                    ),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: txtDiscountBill,
                            focusNode: focusDiscount,
                            textAlign: TextAlign.right,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onTap: () {
                              txtDiscountBill.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                  txtDiscountBill.value.text.length);
                            },
                            onEditingComplete: () {
                              if(txtDiscountBill.text.isEmpty) return SharedWidgets.showAlert(context, 'แจ้งเตือน', 'กรุณากรอกตัวเลข');

                              setState(() {
                                if (myOrderHeader.discountType == 'PER' &&
                                    double.tryParse(txtDiscountBill.text
                                        .replaceAll(',', ''))! > 100) {
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return RichAlertDialog(
                                  //         //uses the custom alert dialog
                                  //         alertTitle: richTitle(
                                  //             "กรอกตัวเลขได้ไม่เกิน 100"),
                                  //         alertSubtitle: richSubtitle(
                                  //             "ส่วนลดเปอร์เซ็นกรอกได้ไม่เกินหนึ่งร้อย"),
                                  //         alertType:
                                  //         RichAlertType.WARNING,
                                  //       );
                                  //     });

                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                  );

                                } else if (myOrderHeader.discountType ==
                                    'PER') {
                                  myOrderHeader.discountAmount =
                                      double.tryParse(txtDiscountBill.text
                                          .replaceAll(',', ''));
                                  FocusScope.of(context).unfocus();
                                } else {

                                  double? disc = double.tryParse(txtDiscountBill.text.replaceAll(',', ''));

                                  // globals.discountBill.number = disc;
                                  myOrderHeader.discountAmount = disc;

                                  FocusScope.of(context).unfocus();
                                }

                                // calculateSummary();
                              });
                            },
                            onChanged: (text) {
                              const duration = Duration(milliseconds: 1000); // set the duration that you want call search() after that.
                              if (timer != null) {
                                setState(() => timer.cancel()); // clear timer
                              }

                              timer = Timer(duration, () =>
                                  setState(() {
                                    if(text.isEmpty) {
                                      return SharedWidgets.showAlert(context, 'แจ้งเตือน', 'กรุณากรอกส่วนลด');
                                    }
                                    else{
                                      if(double.tryParse(text) == null){
                                        return SharedWidgets.showAlert(context, 'แจ้งเตือน', 'กรุณากรอกเฉพาะตัวเลข');
                                      }
                                    }

                                    // if (globals.discountBill.type == 'PER' &&
                                    //     double.tryParse(txtDiscountBill.text
                                    //         .replaceAll(',', ''))
                                    //         100) {
                                    //   showDialog(
                                    //       context: context,
                                    //       builder: (BuildContext context) {
                                    //         return RichAlertDialog(
                                    //           // Uses the custom alert dialog
                                    //           alertTitle: richTitle(
                                    //               "กรอกตัวเลขได้ไม่เกิน 100"),
                                    //           alertSubtitle: richSubtitle(
                                    //               "ส่วนลดเปอร์เซ็นกรอกได้ไม่เกินหนึ่งร้อย"),
                                    //           alertType:
                                    //           RichAlertType.WARNING,
                                    //         );
                                    //       });
                                    // } else if (globals.discountBill.type ==
                                    //     'PER') {
                                    //   globals.discountBill.number =
                                    //       double.tryParse(txtDiscountBill.text
                                    //           .replaceAll(',', ''));
                                    //   FocusScope.of(context).unfocus();
                                    // } else {
                                    //   double disc = double.tryParse(
                                    //       txtDiscountBill.text
                                    //           .replaceAll(',', ''));
                                    //
                                    //   globals.discountBill.number = disc;
                                    //   globals.discountBill.amount = disc;
                                    //
                                    //   FocusScope.of(context).unfocus();
                                    // }
                                    //
                                    // calculateSummary();
                                  })
                              );
                            },
                            decoration: const InputDecoration(
                              labelText: 'ส่วนลดท้ายบิล',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              // floatingLabelBehavior: FloatingLabelBehavior.never,
                            ),
                          ),
                        ))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: txtPriceAfterDiscount,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              labelText: 'ยอดก่อนรวมภาษี',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              // floatingLabelBehavior: FloatingLabelBehavior.never,
                              //border: OutlineInputBorder()
                            ),
                          ),
                        ))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: txtVatTotal,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              labelText: 'ภาษี 7%',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              // floatingLabelBehavior: FloatingLabelBehavior.never,
                              //border: OutlineInputBorder()
                            ),
                          ),
                        ))
                  ],
                ),
                Row(
                  children: [
                    // SizedBox(
                    //   width: 195,
                    //   child: Text('ยอดสุทธิ',
                    //       textAlign: TextAlign.right,
                    //       style: TextStyle(
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.bold)),
                    // ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: txtNetTotal,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            labelText: 'ยอดสุทธิ',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            // floatingLabelBehavior: FloatingLabelBehavior.never,
                            //border: OutlineInputBorder()
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                Row(
                  children: [
                    Visibility(
                      visible: kIsWeb == false ? true : true,
                      child: Expanded(
                          child: Container(
                            height: 100,
                            padding: const EdgeInsets.only(top: 25, bottom: 25, left: 8.0, right: 5.0),
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.attach_file, size: 22,),
                              label: Text('แนบเอกสาร', style: TextStyle(fontSize: 14),),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orange[600],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30.0))
                                ),
                              ),
                              onPressed: (){
                                List<File> orderAttach = ref.read(salesOrderAttach);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AttachmentManager(orderAttach, "ORDER")
                                    )
                                );
                              },
                            ),
                          )
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.only(top: 25, bottom: 25, left: 5.0, right: 8.0),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.save_alt, size: 22,),
                          label: const Text(
                            'บันทึกฉบับร่าง',
                            style: TextStyle(fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0))
                            ),
                          ),
                          onPressed: () async {
                            var isConfirm = await orderValidation();

                            if(isConfirm == true) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.INFO,
                                animType: AnimType.BOTTOMSLIDE,
                                width: 450,
                                title: 'Save Draft',
                                desc: 'Do you want to save draft ?',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () async {

                                  SharedWidgets.showLoader(context, false);

                                  SalesOrder header = SalesOrder()
                                  ..orderDate = orderDate;

                                  var result =
                                  await ApiService().createSalesOrder(header);

                                  // 'ORDER',
                                  // 'D',
                                  // null,
                                  // documentDate,
                                  // shipmentDate,
                                  // orderDate,
                                  // txtCustPONo.text,
                                  // txtRemark.text,
                                  // priceTotal,
                                  // priceAfterDiscount,
                                  // vatTotal,
                                  // netTotal

                                  Navigator.pop(context);

                                  if (result != null) {
                                    txtRemark.text = '';
                                    Navigator.pop(context);

                                    // await Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             StatusTransferDoc())
                                    // );

                                    // showDialog<void>(
                                    //     context: context,
                                    //     builder: (BuildContext context) {
                                    //       return RichAlertDialog(
                                    //         //uses the custom alert dialog
                                    //         alertTitle: richTitle(
                                    //             event.title),
                                    //         alertSubtitle:
                                    //         richSubtitle(event.message),
                                    //         alertType: event.eventCode,
                                    //       );
                                    //     });
                                  } else {
                                    // Navigator.pop(context);

                                    // return showDialog<void>(
                                    //     context: context,
                                    //     builder: (BuildContext context) {
                                    //       return RichAlertDialog(
                                    //         //uses the custom alert dialog
                                    //         alertTitle: richTitle(
                                    //             event.title),
                                    //         alertSubtitle:
                                    //         richSubtitle(event.message),
                                    //         alertType: event.eventCode,
                                    //       );
                                    //     });
                                  }

                                },
                              ).show();
                            }
                            //print(jsonEncode(globals.productCart));
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.done, size: 30),
                    label: const Text(
                      'ยืนยันการสั่งขาย',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18.0)
                    ),
                    onPressed: () async {
                      var isConfirm = await orderValidation();

                      if(isConfirm == true) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.INFO,
                          animType: AnimType.BOTTOMSLIDE,
                          width: 450,
                          title: 'Create Order',
                          desc: 'Do you want to create sales order ?',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () async {
                            if (this.txtDocuNo.text == '') {

                            }

                            SharedWidgets.showLoader(context, false);
                            SalesOrder header = SalesOrder()
                              ..orderDate = orderDate;
                            var result = await ApiService().createSalesOrder(header);
                            // TaskEvent event =
                            // await _apiService.postSaleOrder(
                            //     'ORDER',
                            //     'N',
                            //     null,
                            //     _docuDate,
                            //     _shiptoDate,
                            //     _orderDate,
                            //     txtCustPONo.text,
                            //     txtRemark.text,
                            //     priceTotal,
                            //     priceAfterDiscount,
                            //     vatTotal,
                            //     netTotal);

                            Navigator.pop(context);

                            if (result != null) {
                              txtRemark.text = '';
                              Navigator.pop(context);

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             StatusTransferDoc()));

                              // showDialog<void>(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return RichAlertDialog(
                              //         //uses the custom alert dialog
                              //         alertTitle: richTitle(event.title),
                              //         alertSubtitle:
                              //         richSubtitle(event.message),
                              //         alertType: event.eventCode,
                              //       );
                              //     });
                            } else {
                              // Navigator.pop(context);

                              // return showDialog<void>(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return RichAlertDialog(
                              //         //uses the custom alert dialog
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
                    },
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  salesOrderDetail() {
    return ListView(
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      children: myOrders.mapIndexed((index, e) {
        String goodsCode = ITEMS.firstWhere((product) => product.id == e.itemId, orElse: () => Item()).code ?? '';
        String goodsName = ITEMS.firstWhere((product) => product.id == e.itemId, orElse: () => Item()).displayName ?? '';
        String unitName = UNITS.firstWhere((unit) => unit.id == e.unitOfMeasureId, orElse: () => Unit()).displayName ?? '';

        Color flagFreeColor = e.unitPrice == 0 ? Colors.lightGreen : Colors.orangeAccent;

        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${e.sequence ?? 1}. ($goodsCode) $goodsName', style: const TextStyle(fontSize: 14.0),),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                    child: Badge(
                      toAnimate: false,
                      shape: BadgeShape.square,
                      badgeColor: flagFreeColor,
                      borderRadius: BorderRadius.circular(15.0),
                      badgeContent: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text('สินค้า${e.unitPrice == 0 ? 'แถมฟรี' : 'เพื่อขาย'}', style: TextStyle(color: Colors.white, fontSize: 12.0)),
                      ),
                    ),
                  ),

                  Text(' ${CURRENCY.format(e.quantity)} x $unitName', style: TextStyle(fontSize: 14.0),),
                ],
              )
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('ส่วนลด ${e.discountType == 'PER' ? '${CURRENCY.format(e.discountPercent ?? 0)}%' : CURRENCY.format(e.discountAmount ?? 0)}', style: TextStyle(fontSize: 14.0),)
              ),
              Row(
                children: [
                  Container(
                    child: TextButton(
                      child: const Text('แก้ไข'),
                      onPressed: () async {

                        var result = await Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => ItemEditPortrait(editItem: e)
                            )
                        );

                        if(result != null) {
                          if(result == 'Remove') {
                            // myOrders.removeWhere((x) => x.id == e.id);
                            ref.read(salesOrderLines.notifier).remove(myOrders.firstWhere((x) => x.id == e.id));
                          }
                          else{
                            // myOrders[myOrders.indexWhere((x) => x.id == e.id)] = res;
                            ref.read(salesOrderLines.notifier).edit(result);
                          }
                        }

                        setState(() {

                        });
                      },
                    ),
                  ),

                  TextButton(
                      onPressed: (){
                        int index = 1;
                        SalesOrderLine item = myOrders.firstWhere((x) => x.id == e.id);

                        ref.read(salesOrderLines.notifier).remove(item);

                        // myItems.forEach((element) {
                        //   element.rowIndex = index++;
                        // });

                        // globals.editingProductCart = null;
                        // print(globals.productCart?.length.toString());
                        // setState(() {calculateSummary();});
                      },
                      child: const Text('ลบรายการ')
                  )
                ],
              )
              // Expanded(
              //     child: Text('฿ ${currency.format(e.goodAmnt)}', textAlign: TextAlign.right,)
              // )
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CURRENCY.format(e.unitPrice ?? 0)),
              Text(
                  CURRENCY.format(e.netAmount ?? 0),
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal)
              ),
            ],
          ),
        );
      }).toList() ?? [],
    );
  }

  orderValidation() async {
    if (txtDocuNo.text == '') {
      return SharedWidgets.showAlert(
          context,
          'ยังไม่มีเลขที่เอกสาร',
          'กรุณาลองเข้าหน้าทำรายการอีกครั้ง');
    }

    if (myOrders.isEmpty) {
      return SharedWidgets.showAlert(context, 'โปรดเพิ่มรายการสินค้า', 'คุณยังไม่มีรายการสินค้า');
    }

    if(!checkCredit(netTotal)) {
      // double limitAmount = CUSTOMER_FINANCIAL.balance + CUSTOMER_FINANCIAL.creditTempIncrease;
      double limitAmount = CUSTOMER_FINANCIAL?.balance ?? 0;
      return SharedWidgets.showAlert(context, 'ยอดสั่งเกินวงเงินของลูกค้า', 'วงเงินของลูกค้าไม่เพียงพอในการสั่ง \n คงเหลือ = ${CURRENCY.format(limitAmount)}');
    }

    if(!checkMixedVat(myOrders)) {
      return await SharedWidgets.showConfirm(context, 'มีสินค้าคิด VAT & Non-VAT รวมกัน', 'คุณต้องการทำการสั่งขายอยู่หรือไม่ ?', 'ใช่, สร้างใบสั่งขาย', 'ยกเลิก') ?? false;
    }
    else{
      return true;
    }
  }
}
