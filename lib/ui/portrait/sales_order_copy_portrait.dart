import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/sales_order.dart';
import 'package:dynamics_crm/models/sales_order_line.dart';
import 'package:dynamics_crm/providers/data_provider.dart';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../models/customer.dart';
import '../../models/debounce.dart';
import '../../models/remark.dart';
import '../../models/task_event.dart';
import '../../services/api_service.dart';
import 'item_edit_portrait.dart';

class SalesOrderCopyPortrait extends ConsumerStatefulWidget {
  const SalesOrderCopyPortrait({Key? key, required this.header, required this.detail}) : super(key: key);

  final SalesOrder header;
  final SalesOrderLine detail;

  @override
  _SalesOrderCopyPortraitState createState() => _SalesOrderCopyPortraitState();
}

class _SalesOrderCopyPortraitState extends ConsumerState<SalesOrderCopyPortrait> {
  @override
  Widget build(BuildContext context) {
    final SalesOrder myOrderHeader = ref.watch(salesOrderCopy);
    final List<SalesOrderLine> myOrderDetail = ref.watch(salesOrderLinesCopy);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                verticalDirection: VerticalDirection.up,
                children: const [
                  Text("Sales Order "),
                  Badge(
                      backgroundColor: PRIMARY_COLOR,
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                        child: Text("COPY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white),),
                      )
                  ),
                ]
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.9), BlendMode.lighten),
                image: AssetImage("assets/bg_nic.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 11),
                        padding: const EdgeInsets.all(10),
                        width: 350,
                        //color: Colors.indigo,
                        child: Text(
                          'หัวบิล การสั่งสินค้า',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(0)),
                          color: Theme.of(context).primaryColor,
                          // boxShadow: [
                          //   BoxShadow(color: Colors.green, spreadRadius: 3),
                          // ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                        child: TextFormField(
                          //initialValue: '00001',
                          readOnly: true,
                          controller: txtDocuNo,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "เลขที่ใบสั่งสินค้า",
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                        child: TextFormField(
                          controller: txtDocuDate,
                          // initialValue: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                          readOnly: true,
                          onTap: () async {
                            // _docuDate = await showDatePicker(
                            //   context: context,
                            //   initialDate: _docuDate != null
                            //       ? _docuDate
                            //       : DateTime.now(),
                            //   firstDate: DateTime.now().add(Duration(days: -90)),
                            //   lastDate: DateTime.now().add(Duration(days: 365)),
                            // );
                            //
                            // setState(() {
                            //   if (_docuDate == null) _docuDate = DateTime.now();
                            //   txtDocuDate.text = DateFormat('dd/MM/yyyy').format(_docuDate);
                            // });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "วันที่เอกสาร",
                          ),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 15),
                  Row(children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                        child: TextField(
                          readOnly: true,
                          controller: txtRefNo,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "เลขที่อ้างอิงระบบ",
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 5.0, right: 10.0),
                        child: TextFormField(
                          controller: txtShiptoDate,
                          readOnly: true,
                          onTap: () async {
                            DateTime tmpDate = _shiptoDate;
                            _shiptoDate = await showDatePicker(
                              context: context,
                              initialDate: _shiptoDate != null
                                  ? _shiptoDate
                                  : DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            ) ?? tmpDate;

                            setState(() {
                              if (_shiptoDate == null && tmpDate == null) {
                                _shiptoDate =
                                    DateTime.now().add(const Duration(hours: 24));
                              }
                              else if(_shiptoDate == null && tmpDate != null){
                                _shiptoDate = tmpDate;
                              }

                              txtShiptoDate.text =
                                  DATE_FORMAT.format(_shiptoDate);
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "วันที่ส่ง (ปกติ 1 วัน)",
                          ),
                        ),
                      ),
                    ),
                  ]),

                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                          child: TextField(
                            controller: txtCustPONo,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              labelText: 'เลขที่ใบสั่งซื้อของลูกค้า',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0, right: 10.0),
                          child: TextField(
                            controller: txtOrderDate,
                            readOnly: true,
                            onTap: () async {
                              _orderDate = (await showDatePicker(
                                context: context,
                                initialDate: _orderDate != null
                                    ? _orderDate
                                    : DateTime.now(),
                                firstDate: DateTime(1995),
                                lastDate: DateTime(2030),
                              )) ?? DateTime.now();

                              setState(() {
                                if (_orderDate == null) _orderDate = DateTime.now();
                                txtOrderDate.text = DATE_FORMAT.format(_orderDate);
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'วันที่สั่งซื้อของลูกค้า',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      readOnly: true,
                      initialValue: '${EMPLOYEE?.name} (${EMPLOYEE?.code})',
                      // controller: txtEmpCode,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "ชื่อพนักงาน",
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          readOnly: true,
                          maxLines: 2,
                          initialValue: '${widget.header?.sellToCustomerNo ?? ''} (${custCode ?? ''})',
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
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
                        width: 350,
                        child: Text(
                          'สถานที่จัดส่ง',
                          style: TextStyle(color: Colors.white, fontSize: 20),
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

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    child: TextFormField(
                      readOnly: true,
                      maxLines: 3,
                      //initialValue: globals.customer?.,
                      controller: txtShiptoAddress,
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
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: TextFormField(
                      readOnly: true,
                      controller: txtShiptoRemark,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "หมายเหตุ",
                      ),
                    ),
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 80),
                        Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 5.0),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  //_showShiptoDialog(context);
                                  // _showDialog(context);
                                },
                                icon: const Icon(Icons.local_shipping_outlined),
                                label: const Text('สถานที่ส่ง'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                ),
                              ),
                            )
                        ),
                        Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 5.0, right: 15.0),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    // globals.selectedShiptoCopy = globals.allShipto.firstWhere(
                                    //         (x) => x.custId == globals.customer.custId
                                    //         && x.isDefault == 'Y');
                                    //
                                    // setShipto();
                                  });

                                  // Fluttertoast.showToast(
                                  //     msg: "ใช้ค่าเริ่มต้นเรียบร้อย",
                                  //     toastLength: Toast.LENGTH_SHORT,
                                  //     gravity: ToastGravity.BOTTOM,
                                  //     timeInSecForIosWeb: 1,
                                  //     backgroundColor: Colors.black54,
                                  //     textColor: Colors.white,
                                  //     fontSize: 18.0);
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('ค่าเริ่มต้น'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blueGrey,
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                                  ),
                                ),
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
                        width: 350,
                        child: Text(
                          'รายการสินค้าขาย',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(0)),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(height: 10),

                            // Visibility(
                            //   visible: true,
                            //   child: Container(
                            //       margin: EdgeInsets.only(top: 13, left: 20),
                            //       child: RaisedButton.icon(
                            //         onPressed: () {
                            //           globals.editingProductCart = null;
                            //           Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                   builder: (context) =>
                            //                       OrderExpress(fromPage: 'COPY',))).then((value) => setState(() => calculateSummary()));
                            //         },
                            //         icon: Icon(Icons.local_fire_department,
                            //             color: Colors.white),
                            //         color: Colors.deepOrange[400],
                            //         padding: EdgeInsets.all(10),
                            //         label: Text(
                            //           'เพิ่มรายการด่วน',
                            //           style: TextStyle(
                            //               fontSize: 14, color: Colors.white),
                            //         ),
                            //       )),
                            // ),
                            // Visibility(
                            //   visible: true,
                            //   child: Container(
                            //       margin: EdgeInsets.only(top: 13, left: 20),
                            //       child: RaisedButton.icon(
                            //         onPressed: () {
                            //           globals.editingProductCart = null;
                            //           Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                   builder: (context) =>
                            //                       OrderPromo(fromPage: 'COPY',))).then((value) => setState(() => calculateSummary()));
                            //         },
                            //         icon: Icon(Icons.list, color: Colors.white),
                            //         color: Colors.blueAccent,
                            //         padding: EdgeInsets.all(10),
                            //         label: Text(
                            //           'เพิ่มรายการโปรโมชั่น',
                            //           style: TextStyle(
                            //               fontSize: 14, color: Colors.white),
                            //         ),
                            //       )),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  saleOrderDetail(myOrderDetail),

                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // globals.editingProductCart = null;
                          // await Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             ProductSelect(type: DocumentType.copy)));
                          //
                          // globals.editingProductCart = null;
                          // calculateSummary();
                        },
                        icon: Icon(Icons.add_circle_outline_outlined,
                            color: Colors.white),
                        label: Text(
                          'เพิ่มรายการสินค้า',
                          style: TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey,
                          padding: EdgeInsets.all(10),
                        ),
                      )
                  ),

                  Row(
                    children: [
                      SizedBox(height: 80),
                      Container(
                        margin: const EdgeInsets.only(top: 11),
                        padding: const EdgeInsets.all(10),
                        width: 350,
                        child: Text(
                          'ท้ายบิล การสั่งสินค้า',
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            List<Remark> allRemarks = await ApiService().getRemark();
                            Remark? result = await SharedWidgets.showRemark(context, allRemarks);

                            if(result != null) {
                              myOrderHeader.salecmttxt += result.remark!;
                              ref.read(salesOrderCopy.notifier).edit(myOrderHeader);
                              txtRemark.text = myOrderHeader.salecmttxt;
                            }
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

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: TextFormField(
                      controller: txtRemark,
                      maxLength: 80,
                      maxLines: 6,
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
                        // globals.selectedRemarkDraft.remark = value;
                      },
                    ),
                  ),

                  Row(
                    children: [
                      const Expanded(
                        child: Text('รวมส่วนลด',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                      ),
                      Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              readOnly: true,
                              textAlign: TextAlign.right,
                              controller: txtDiscountTotal,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                floatingLabelBehavior:
                                FloatingLabelBehavior.never,
                                //border: OutlineInputBorder()
                              ),
                            ),
                          )
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Text('รวมเงิน',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: txtPriceTotal,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              floatingLabelBehavior:
                              FloatingLabelBehavior.never,
                              //border: OutlineInputBorder()
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text('ส่วนลดท้ายบิล',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      // showDiscountTypeDialog();
                                      //focusDiscount.requestFocus();

                                      setState(() {
                                        myOrderHeader.discountType = changeDiscountType(myOrderHeader.discountType ?? 'PER');
                                        ref.read(salesOrderCopy.notifier).edit(myOrderHeader);
                                      });
                                    },
                                    child: SharedWidgets.discountType(myOrderHeader.discountType ?? 'PER')
                                ),
                              ),
                            ],
                          )
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
                                    extentOffset: txtDiscountBill
                                        .value.text.length);
                              },
                              onEditingComplete: () {
                                setState(() {
                                  if (myOrderHeader.discountType ==
                                      'PER' &&
                                      double.tryParse(txtDiscountBill.text
                                          .replaceAll(',', ''))! >
                                          100) {
                                    // showDialog(
                                    //     context: context,
                                    //   builder: (BuildContext context){
                                    //       return AlertDialog(
                                    //         title: Text('แจ้งเตือน'),
                                    //         content: Text('ใส่ค่าไม่เกิน 100')
                                    //       );
                                    //   },
                                    // );

                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.warning,
                                      title: 'กรอกตัวเลขได้ไม่เกิน 100',
                                      text: 'ส่วนลดเปอร์เซ็นกรอกได้ไม่เกินหนึ่งร้อย',
                                    );

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
                                  } else if (myOrderHeader.discountType == 'PER') {
                                    myOrderHeader.invdiscountpct = double.tryParse(txtDiscountBill.text.replaceAll(',', ''));
                                    // calculateSummary();
                                  } else if (myOrderHeader.discountType == 'THB') {

                                    double disc = double.tryParse(txtDiscountBill.text.replaceAll(',', '')) ?? 0;

                                    // globals.discountBillCopy.number = disc;
                                    myOrderHeader.invdiscountamt = disc;

                                  }

                                  FocusScope.of(context).unfocus();
                                  // calculateSummary();
                                });
                              },
                              onChanged: (text) {
                                debounce.call(() {
                                  if(text.isEmpty) {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.warning,
                                      title: 'แจ้งเตือน',
                                      text: 'กรุณากรอกส่วนลด !!',
                                    );
                                    // return globals.showAlertDialog('แจ้งเตือน', 'กรุณากรอกส่วนลด', context);
                                  }
                                  else{
                                    if(double.tryParse(text) == null){
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.warning,
                                        title: 'แจ้งเตือน',
                                        text: 'กรอกเฉพาะตัวเลข !!',
                                      );
                                      // return globals.showAlertDialog('แจ้งเตือน', 'กรอกเฉพาะตัวเลข !!', context);
                                    }
                                  }

                                  if (myOrderHeader.discountType == 'PER' &&
                                      double.tryParse(txtDiscountBill.text.replaceAll(',', ''))! > 100) {
                                    // showDialog(
                                    //     context: context,
                                    //   builder: (BuildContext context){
                                    //       return AlertDialog(
                                    //         title: Text('แจ้งเตือน'),
                                    //         content: Text('ใส่ค่าไม่เกิน 100')
                                    //       );
                                    //   },
                                    // );

                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.warning,
                                      title: 'กรอกตัวเลขได้ไม่เกิน 100',
                                      text: 'ส่วนลดเปอร์เซ็นกรอกได้ไม่เกินหนึ่งร้อย',
                                    );

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
                                  } else if (myOrderHeader.discountType == 'PER') {
                                    myOrderHeader.invdiscountpct = double.tryParse(txtDiscountBill.text.replaceAll(',', ''));
                                    FocusScope.of(context).unfocus();
                                    // calculateSummary();
                                  } else if (myOrderHeader.discountType == 'THB') {
                                    double disc = double.tryParse(txtDiscountBill.text.replaceAll(',', '')) ?? 0;

                                    myOrderHeader.invdiscountamt = disc;
                                    // globals.discountBillCopy.amount = disc;
                                    FocusScope.of(context).unfocus();
                                    // calculateSummary();
                                  }
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                floatingLabelBehavior:
                                FloatingLabelBehavior.never,
                                //border: OutlineInputBorder()
                              ),
                            ),
                          ))
                    ],
                  ),

                  Row(
                    children: [
                      const Expanded(
                        child: Text('ยอดก่อนรวมภาษี',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                textAlign: TextAlign.right,
                                controller: txtPriceAfterDiscount,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 0),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  //border: OutlineInputBorder()
                                ),
                              )))
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('ภาษี 7%',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                textAlign: TextAlign.right,
                                controller: txtVatTotal,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 0),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  //border: OutlineInputBorder()
                                ),
                              )))
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('รวมสุทธิ',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              readOnly: true,
                              textAlign: TextAlign.right,
                              controller: txtNetTotal,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                floatingLabelBehavior:
                                FloatingLabelBehavior.never,
                                //border: OutlineInputBorder()
                              ),
                            )),
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
                              padding: const EdgeInsets.only(top: 25, bottom: 25, left: 15.0, right: 5.0),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.attach_file),
                                label: const Text('แนบเอกสาร', style: TextStyle(fontSize: 16),),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.orange[600],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(30.0))
                                  ),
                                ),
                                onPressed: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             FileAttachManager(globals.attachCopyOrder, "COPY")
                                  //     )
                                  // );
                                },
                              ),
                            )
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.only(top: 25, bottom: 25, left: 5.0, right: 15.0),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              // var isConfirm = await orderValidation();
                              //
                              // if(isConfirm) {
                              //   AwesomeDialog(
                              //     context: context,
                              //     dialogType: DialogType.INFO,
                              //     animType: AnimType.BOTTOMSLIDE,
                              //     width: 400,
                              //     title: 'Draft Order',
                              //     desc: 'Do you want to save draft order ?',
                              //     btnCancelOnPress: () {},
                              //     btnOkOnPress: () async {
                              //       // setState(() {});
                              //       globals.showLoaderDialog(context, false);
                              //       // await postOrder('D');
                              //
                              //       if(widget.header.fromFlag == 'Q') {
                              //         QuotationHeader quotHeader = await _apiService.getQuotationHeader(widget.header.refSoid);
                              //         quotHeader.isTransfer = 'S';
                              //         await _apiService.updateQuotationHeader(widget.header.refSoid, quotHeader);
                              //       }
                              //
                              //       TaskEvent event = await _apiService
                              //           .postSaleOrder(
                              //           'COPY',
                              //           'D',
                              //           widget.header.refSoid,
                              //           _docuDate,
                              //           _shiptoDate,
                              //           _orderDate,
                              //           txtCustPONo.text,
                              //           txtRemark.text,
                              //           priceTotal,
                              //           priceAfterDiscount,
                              //           vatTotal,
                              //           netTotal);
                              //
                              //       if (event.isComplete) {
                              //         txtRemark.text = '';
                              //         Navigator.pop(context);
                              //         Navigator.pop(context);
                              //
                              //         return showDialog<void>(
                              //             context: context,
                              //             builder: (BuildContext context) {
                              //               return RichAlertDialog(
                              //                 //uses the custom alert dialog
                              //                 alertTitle: richTitle(
                              //                     event.title),
                              //                 alertSubtitle: richSubtitle(
                              //                     event.message),
                              //                 alertType: event.eventCode,
                              //               );
                              //             });
                              //       }
                              //       else {
                              //         Navigator.pop(context);
                              //         return showDialog<void>(
                              //             context: context,
                              //             builder: (BuildContext context) {
                              //               return RichAlertDialog(
                              //                 //uses the custom alert dialog
                              //                 alertTitle: richTitle(
                              //                     event.title),
                              //                 alertSubtitle: richSubtitle(
                              //                     event.message),
                              //                 alertType: event.eventCode,
                              //               );
                              //             });
                              //       }
                              //       Navigator.pop(context);
                              //       Navigator.pop(context);
                              //     },
                              //   )..show();
                              // }
                            },
                            icon: const Icon(Icons.save_alt, size: 22,),
                            label: const Text('บันทึกฉบับร่าง', style: TextStyle(fontSize: 16),),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30.0))
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 20,)
                  Container(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // var isConfirm = await orderValidation();

                        // if(isConfirm) {
                        //   AwesomeDialog(
                        //     context: context,
                        //     dialogType: DialogType.INFO,
                        //     animType: AnimType.BOTTOMSLIDE,
                        //     width: 400,
                        //     title: 'Create Order',
                        //     desc: 'Do you want to create sales order ?',
                        //     btnCancelOnPress: () {},
                        //     btnOkOnPress: () async {
                        //       // setState(() {});
                        //       // await postOrder('N');
                        //
                        //       if(widget.header.fromFlag == 'Q') {
                        //         QuotationHeader quotHeader = await _apiService.getQuotationHeader(widget.header.refSoid);
                        //         quotHeader.isTransfer = 'S';
                        //         await _apiService.updateQuotationHeader(widget.header.refSoid, quotHeader);
                        //       }
                        //
                        //       TaskEvent event = await _apiService
                        //           .postSaleOrder(
                        //           'COPY',
                        //           'N',
                        //           widget.header.refSoid,
                        //           _docuDate,
                        //           _shiptoDate,
                        //           _orderDate,
                        //           txtCustPONo.text,
                        //           txtRemark.text,
                        //           priceTotal,
                        //           priceAfterDiscount,
                        //           vatTotal,
                        //           netTotal);
                        //
                        //       if (event.isComplete) {
                        //         txtRemark.text = '';
                        //         Navigator.pop(context);
                        //         return showDialog<void>(
                        //             context: context,
                        //             builder: (BuildContext context) {
                        //               return RichAlertDialog(
                        //                 //uses the custom alert dialog
                        //                 alertTitle: richTitle(
                        //                     event.title),
                        //                 alertSubtitle: richSubtitle(
                        //                     event.message),
                        //                 alertType: event.eventCode,
                        //               );
                        //             });
                        //       }
                        //       else {
                        //         Navigator.pop(context);
                        //         return showDialog<void>(
                        //             context: context,
                        //             builder: (BuildContext context) {
                        //               return RichAlertDialog(
                        //                 //uses the custom alert dialog
                        //                 alertTitle: richTitle(
                        //                     event.title),
                        //                 alertSubtitle: richSubtitle(
                        //                     event.message),
                        //                 alertType: event.eventCode,
                        //               );
                        //             });
                        //       }
                        //       Navigator.pop(context);
                        //       Navigator.pop(context);
                        //     },
                        //   )
                        //     ..show();
                        // }
                      },
                      icon: const Icon(Icons.done, size: 35,),
                      label: const Text(
                        'ยืนยันคำสั่งขาย',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20.0)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Customer customer = Customer();
  String runningNo = '';
  String docuNo = '';
  String refNo = '';
  String custPONo = '';
  String creditState = '';
  double vat = 0.07;
  double priceTotal = 0;
  double discountTotal = 0;
  double discountBill = 0;
  double priceAfterDiscount = 0;
  double vatTotal = 0.0;
  double netTotal = 0.0;
  String custCode = '';
  DateTime _docuDate = DateTime.now();
  DateTime _shiptoDate = DateTime.now().add(const Duration(hours: 24));
  DateTime _orderDate = DateTime.now();

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

  TextEditingController txtDocuDate = TextEditingController(text: DATE_FORMAT.format(DateTime.now()));
  TextEditingController txtShiptoDate = TextEditingController(text: DATE_FORMAT.format(DateTime.now().add(const Duration(hours: 24))));
  TextEditingController txtOrderDate = TextEditingController(text: DATE_FORMAT.format(DateTime.now()));

  final debounce = Debouncer(delay: const Duration(milliseconds: 1000));

  Future<bool> _onWillPop() async {
    final popValue = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('บันทึกฉบับร่าง ?'),
        content: const Text('ต้องการบันทึกฉบับร่างหรือไม่ ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Navigator.of(context).pop(true);
              // globals.productCartCopy = <ProductCart>[];
              Navigator.of(context).pop(true); // Go to OrderView
              Navigator.of(context).pop(true); //Go to Status document
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Launcher(pageIndex: 0,)));
            },
            child: const Text('ไม่ต้องการ'),
          ),
          TextButton(
            onPressed: () async {
              // await postOrder('D');

              // if(widget.header.status == 'Quote') {
              //   QuotationHeader quotHeader = await _apiService.getQuotationHeader(widget.header.refSoid);
              //   quotHeader.isTransfer = 'S';
              //   await _apiService.updateQuotationHeader(widget.header.refSoid, quotHeader);
              // }
              //
              // TaskEvent event = await _apiService.postSaleOrder('COPY', 'D', widget.header.refSoid, _docuDate, _shiptoDate, _orderDate, txtCustPONo.text, txtRemark.text, priceTotal, priceAfterDiscount, vatTotal, netTotal);

              TaskEvent event = TaskEvent(isComplete: true, eventCode: 0, title: 'Success', message: '');

              if(event.isComplete) {
                // txtRemark.text = '';

                Navigator.pop(context);
                Navigator.pop(context);

                // return showDialog<void>(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return RichAlertDialog(
                //         //uses the custom alert dialog
                //         alertTitle: richTitle(event.title),
                //         alertSubtitle: richSubtitle(event.message),
                //         alertType: event.eventCode,
                //       );
                //     });
              }
              else{
                Navigator.pop(context);
                // return showDialog<void>(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return RichAlertDialog(
                //         //uses the custom alert dialog
                //         alertTitle: richTitle(event.title),
                //         alertSubtitle: richSubtitle(event.message),
                //         alertType: event.eventCode,
                //       );
                //     });
              }

              Navigator.of(context).pop(true);
              Navigator.of(context).pop(true);
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Launcher(pageIndex: 0,)));
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    ) ?? false;

    return popValue;
  }

  saleOrderDetail(List<SalesOrderLine> orders) {
    return ListView(
      primary: false,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),

      children: orders.map((e) {
        String goodsCode = ITEMS.firstWhere((goods) => goods.id == e.itemId).code ?? '';
        String goodsName = ITEMS.firstWhere((goods) => goods.id == e.itemId).displayName ?? '';
        String unitName = UNITS.firstWhere((unit) => unit.id == e.unitOfMeasureId).code ?? '';

        Color flagFreeColor = e.unitPrice == 0 ? Colors.lightGreen : Colors.orangeAccent;

        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${e.sequence}. ($goodsCode) $goodsName', style: const TextStyle(fontSize: 14.0),),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                    child: Badge(
                      // toAnimate: false,
                      // shape: BadgeShape.square,
                      // badgeColor: flagFreeColor,
                      // borderRadius: BorderRadius.circular(15.0),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      backgroundColor: flagFreeColor,
                        textStyle: GoogleFonts.kanit(fontSize: 10),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(e.unitPrice == 0 ? 'แถมฟรี' : 'เพื่อขาย', style: const TextStyle(color: Colors.white, fontSize: 12.0)),
                        ),
                      // child: Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      //   child: Text(e.unitPrice == 0 ? 'แถมฟรี' : 'เพื่อขาย', style: const TextStyle(color: Colors.white, fontSize: 12.0)),
                      // ),
                    ),
                  ),

                  Text(' ${CURRENCY.format(e.quantity)} x $unitName', style: const TextStyle(fontSize: 14.0), overflow: TextOverflow.ellipsis, maxLines: 2,),
                ],
              )
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('ส่วนลด ${e.discountType == 'PER' ? '${CURRENCY.format(e.discountAmount)}%' : CURRENCY.format(e.discountAmount)}', style: const TextStyle(fontSize: 14.0),)
              ),
              Row(
                children: [
                  Container(
                    child: TextButton(
                      child: const Text('แก้ไข'),
                      onPressed: () async {
                        var res = await Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => ItemEditPortrait(editItem: e)
                            )
                        );

                        if(res != null) {
                          // if(res == 'Remove') {
                          //   globals.productCartCopy.removeWhere((x) => x.rowIndex == e.rowIndex);
                          //
                          //   /// Re-Index
                          //   int row = 1;
                          //   globals.productCartCopy.forEach((x) => x.rowIndex = row++);
                          // }
                          // else{
                          //   globals.productCartCopy[globals.productCartCopy.indexWhere((x) => x.rowIndex == e.rowIndex)] = res;
                          // }
                        }

                        // setState(() {
                        //   calculateSummary();
                        // });
                      },
                    ),
                  ),

                  TextButton(
                      onPressed: (){
                        // int index = 1;
                        // globals.productCartCopy.removeWhere(
                        //         (element) => element.rowIndex == e.rowIndex);
                        // globals.productCartCopy.forEach((element) {
                        //   element.rowIndex = index++;
                        // });
                        // globals.editingProductCart = null;
                        // print(globals.productCartCopy?.length.toString());
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
              Text(CURRENCY.format(e.unitPrice)),
              Text(CURRENCY.format(e.netAmount), style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),),
            ],
          ),
        );
      })?.toList() ?? [],
    );
  }
}
