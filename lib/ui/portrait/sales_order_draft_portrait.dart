import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/item.dart';
import 'package:dynamics_crm/models/sales_quote.dart';
import 'package:dynamics_crm/models/sales_shipment.dart';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../models/customer.dart';
import '../../models/activity.dart';
import '../../models/order.dart';
import '../../models/sales_order.dart';
import '../../models/sales_order_line.dart';
import 'item_edit_portrait.dart';
import 'item_select.dart';

class SalesOrderDraftPortrait extends ConsumerStatefulWidget {

  final SalesOrder header;

  const SalesOrderDraftPortrait({Key? key, required this.header}) : super(key: key);

  @override
  ConsumerState<SalesOrderDraftPortrait> createState() => _SalesOrderDraftPortraitState();
}

class _SalesOrderDraftPortraitState extends ConsumerState<SalesOrderDraftPortrait> {
  Timer? timer;
  String runningNo = '';
  String docuNo = '';
  String refNo = '';
  String custPONo = '';
  String creditState = '';
  double vat = 0.07;
  // double priceTotal = 0;
  // double discountTotal = 0;
  // double discountBill = 0;
  // double priceAfterDiscount = 0;
  // double vatTotal = 0.0;
  // double netTotal = 0.0;
  // ApiService _apiService = new ApiService();
  DateTime _docuDate = DateTime.now();
  DateTime _shiptoDate = DateTime.now().add(const Duration(hours: 24));
  DateTime _orderDate = DateTime.now();

  List<Item> orderItems = <Item>[];
  SalesQuote quotation = SalesQuote();
  SalesOrder salesOrder = SalesOrder();
  SalesShipment shipToAddress = SalesShipment();
  List<SalesOrderLine> salesOrderLines = <SalesOrderLine>[];
  List<SalesOrderLine> myOrders = [];
  // SoHeaderRemark headerRemark = SoHeaderRemark();
  // List<SoDetailRemark> detailRemark = <SoDetailRemark>[];

  FocusNode focusDiscount = FocusNode();
  TextEditingController txtRunningNo = TextEditingController();
  TextEditingController txtDocuNo = TextEditingController();
  TextEditingController txtRefNo = TextEditingController();
  TextEditingController txtCustPONo = TextEditingController();
  TextEditingController txtSONo = TextEditingController();
  TextEditingController txtQuotationNo = TextEditingController();
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
      text: DATE_FORMAT.format(DateTime.now()));
  TextEditingController txtShiptoDate = TextEditingController(
      text: DATE_FORMAT.format(DateTime.now().add(const Duration(hours: 24))));
  TextEditingController txtOrderDate = TextEditingController(
      text: DATE_FORMAT.format(DateTime.now()));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    salesOrder = widget.header;
    myOrders = SALES_ORDER_LINES.where((e) => e.documentId == salesOrder.id).toList();
    totalSummary(salesOrder, myOrders);
    bindingController();
  }

  @override
  Widget build(BuildContext context) {
    double headerWidth = MediaQuery.of(context).size.width * 0.98;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              verticalDirection: VerticalDirection.up,
              children: [
                const Text("Sales Order "),
                Badge(
                  elevation: 1.5,
                  shape: BadgeShape.square,
                  badgeColor: PRIMARY_COLOR,
                  animationType: BadgeAnimationType.scale,
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide.lerp(
                      const BorderSide(color: PRIMARY_COLOR, width: 1),
                      const BorderSide(color: PRIMARY_COLOR, width: 1),
                      0.5
                  ),
                  badgeContent: const Text("DRAFT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white),),
                ),
              ],
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
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 11),
                        padding: const EdgeInsets.all(10),
                        width: headerWidth,
                        //color: Colors.indigo,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${salesOrder.number}',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text('${DATE_FORMAT_TH.formatInBuddhistCalendarThai(_docuDate)}', style: TextStyle(color: Colors.white)),
                            )
                          ],
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
                  // SizedBox(height: 20),
                  // Row(children: [
                  //   Expanded(
                  //     child: Container(
                  //       padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  //       child: TextFormField(
                  //         readOnly: true,
                  //         controller: txtDocuNo,
                  //         decoration: const InputDecoration(
                  //           border: OutlineInputBorder(),
                  //           contentPadding: EdgeInsets.symmetric(
                  //               horizontal: 10, vertical: 0),
                  //           floatingLabelBehavior: FloatingLabelBehavior.always,
                  //           labelText: "???????????????????????????",
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ]),
                  SizedBox(height: 15),
                  Row(children: [
                    Visibility(
                      visible: widget.header != null ? true : false,
                      child: Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                          child: TextFormField(
                            controller: txtQuotationNo,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: "??????????????????????????????",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 5.0, right: 8.0),
                        child: TextFormField(
                          controller: txtShiptoDate,
                          readOnly: true,
                          onTap: () async {
                            DateTime tmpDate = _shiptoDate;
                            _shiptoDate = (await showDatePicker(
                              context: context,
                              initialDate: _shiptoDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                            )) ?? _shiptoDate;

                            setState(() {
                              if (_shiptoDate == null && tmpDate == null) {
                                _shiptoDate =
                                    DateTime.now().add(const Duration(hours: 24));
                              }
                              else if(_shiptoDate == null && tmpDate != null){
                                _shiptoDate = tmpDate;
                              }

                              txtShiptoDate.text = DATE_FORMAT.format(_shiptoDate);
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "??????????????????????????? (???????????? 1 ?????????)",
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
                          padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                          child: TextField(
                            controller: txtCustPONo,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              labelText: '?????????????????????????????? (PO)',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 5.0, right: 8.0),
                          child: TextField(
                            controller: txtOrderDate,
                            readOnly: true,
                            onTap: () async {
                              _orderDate = (await showDatePicker(
                                context: context,
                                initialDate: _orderDate ?? DateTime.now(),
                                firstDate: DateTime(1995),
                                lastDate: DateTime(2030),
                              )) ?? _orderDate;

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
                              labelText: '????????????????????????????????????????????????????????????',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: '${EMPLOYEE?.displayName ?? ''} (${EMPLOYEE?.code ?? ''})',
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: '?????????????????????????????????',
                          ),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 15),
                  Row(children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: txtCustName,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: '??????????????????????????????',
                          ),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.edit_outlined),
                      label: Text('???????????????????????????????????????', style: TextStyle(fontSize: 14.0),),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      ),
                      onPressed: () async {
                        // Customer res = await Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerSelect()));
                        // if(res != null){
                        //   print('res: [${res.id}] ${res.displayName}');
                        //   changeCustomer(res);
                        // }
                      },
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(height: 80),
                      Container(
                        margin: const EdgeInsets.only(top: 11),
                        padding: const EdgeInsets.all(10),
                        width: headerWidth,
                        child: Text(
                          '???????????????????????????????????????',
                          style: TextStyle(color: Colors.white, fontSize: 18),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: TextFormField(
                      readOnly: true,
                      maxLines: 3,
                      controller: txtShiptoAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15.0),
                        floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                        labelText: "??????????????????????????????????????????",
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: TextFormField(
                      readOnly: true,
                      controller: txtShiptoProvince,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        labelText: '??????????????????????????????',
                        floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: TextFormField(
                      readOnly: true,
                      controller: txtShiptoRemark,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "????????????????????????",
                      ),
                    ),
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 80),
                        Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 5.0),
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                                    )
                                  ),
                                  onPressed: () {
                                    // _showDialog(context);
                                    },
                                  icon: Icon(Icons.local_shipping_outlined),
                                  label: Text('??????????????????????????????')
                              ),
                            )
                        ),
                        Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 5.0, right: 8.0),
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blueGrey,
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)
                                        )
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      // globals.selectedShiptoDraft = globals.allShipto
                                      //     .firstWhere((element) => element.custId == globals.customer.custId
                                      //     && element.isDefault == 'Y');
                                      //
                                      // setShipto();
                                    });

                                    Fluttertoast.showToast(
                                        msg: "?????????????????????????????????????????????????????????????????????",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black54,
                                        textColor: Colors.white,
                                        fontSize: 18.0);
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('?????????????????????????????????')
                              ),
                            )
                        ),
                      ]),

                  Row(
                    children: [
                      SizedBox(height: 60),
                      Container(
                        margin: const EdgeInsets.only(top: 11),
                        padding: const EdgeInsets.all(10),
                        width: headerWidth,
                        child: Text(
                          '????????????????????????????????????',
                          style: TextStyle(color: Colors.white, fontSize: 18),
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

                  saleOrderDetail(),

                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey,
                          // splashColor: Colors.green,
                          padding: const EdgeInsets.all(10),
                        ),
                        onPressed: () async {
                          // globals.editingProductCart = null;
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ItemSelect(type: Activity.draft)));

                          // globals.editingProductCart = null;
                          Order sum = totalSummary(salesOrder, myOrders);
                          bindingController();
                        },
                        icon: const Icon(Icons.add_circle_outline_outlined,
                            color: Colors.white),
                        label: const Text(
                          '???????????????????????????????????????????????????',
                          style: TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                      )
                  ),

                  Row(
                    children: [
                      SizedBox(height: 80),
                      Container(
                        margin: const EdgeInsets.only(top: 11),
                        padding: const EdgeInsets.all(10),
                        width: headerWidth,
                        child: Text(
                          '????????????????????? ???????????????????????????',
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
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // _showRemarkDialog(context);
                          },
                          icon: const Icon(Icons.add_comment),
                          label: const Text(
                            '?????????????????????????????????????????????',
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
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                        labelText: "?????????????????????????????????????????????",
                        //border: OutlineInputBorder()
                      ),
                      onChanged: (value) {
                        // globals.selectedRemarkDraft.remark = value;
                      },
                    ),
                  ),

                  SizedBox(
                    height: 10.0,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text('???????????????????????????',
                      //       textAlign: TextAlign.right,
                      //       style: TextStyle(
                      //           fontSize: 18, fontWeight: FontWeight.bold)),
                      // ),
                      Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              readOnly: true,
                              textAlign: TextAlign.right,
                              controller: txtDiscountTotal,
                              decoration: const InputDecoration(
                                labelText: '???????????????????????????',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                              ),
                            ),
                          )),
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
                              labelText: '?????????????????????',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              SharedWidgets.showDiscountType(context, salesOrder);
                              //focusDiscount.requestFocus();
                            },
                            child: SharedWidgets.discountType(salesOrder.discountType ?? 'PER')),
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
                              onEditingComplete: () async {
                                if (salesOrder.discountType ==
                                    'PER' &&
                                    double.parse(txtDiscountBill.text
                                        .replaceAll(',', '')) >
                                        100) {

                                  await QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    title: '???????????????????????????????????????????????????????????? 100',
                                    text: '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????',
                                  );
                                } else if (salesOrder.discountType == 'PER') {

                                  // globals.discountBillDraft.number = double.tryParse(txtDiscountBill.text.replaceAll(',', ''));
                                  FocusScope.of(context).unfocus();
                                } else if (salesOrder.discountType == 'THB') {
                                  double disc = double.parse(txtDiscountBill.text.replaceAll(',', ''));
                                  //globals.discountBillDraft.discountNumber = globals.discountBillDraft.discountAmount;
                                  // globals.discountBillDraft.number = disc;
                                  salesOrder.discountAmount = disc;
                                  FocusScope.of(context).unfocus();
                                }

                                totalSummary(salesOrder, myOrders);
                                bindingController();
                              },
                              onChanged: (text) {
                                const duration = Duration(milliseconds: 1000); // set the duration that you want call search() after that.
                                if (timer != null) {
                                  setState(() => timer!.cancel()); // clear timer
                                }

                                timer = Timer(duration, () => setState(() {
                                  if(text.isEmpty) {
                                    SharedWidgets.showAlert(context, '???????????????????????????', '?????????????????????????????????????????????');
                                  }
                                  else{
                                    if(double.tryParse(text) == null){
                                      SharedWidgets.showAlert(context, '???????????????????????????', '????????????????????????????????????????????????????????????');
                                    }
                                  }

                                  if (salesOrder.discountType == 'PER'
                                      && double.parse(txtDiscountBill.text.replaceAll(',', '')) > 100) {

                                    // showDialog(
                                    //     context: context,
                                    //     builder: (BuildContext context) {
                                    //       return RichAlertDialog(
                                    //         //uses the custom alert dialog
                                    //         alertTitle: richTitle(
                                    //             "???????????????????????????????????????????????????????????? 100"),
                                    //         alertSubtitle: richSubtitle(
                                    //             "??????????????????????????????????????????????????????????????????????????????????????????????????????????????????"),
                                    //         alertType:
                                    //         RichAlertType.WARNING,
                                    //       );
                                    //     });

                                    QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.warning,
                                        title: '???????????????????????????????????????????????????????????? 100',
                                        text: '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????'
                                    );

                                  } else if (salesOrder.discountType == 'PER') {
                                    // globals.discountBillDraft.number = double.tryParse(txtDiscountBill.text.replaceAll(',', ''));
                                    salesOrder.discountAmount = double.tryParse(txtDiscountBill.text.replaceAll(',', ''));
                                    FocusScope.of(context).unfocus();
                                  } else if (salesOrder.discountType == 'THB') {
                                    double disc = double.parse(txtDiscountBill.text.replaceAll(',', ''));
                                    //globals.discountBillDraft.discountNumber = globals.discountBillDraft.discountAmount;
                                    // globals.discountBillDraft.number = disc;
                                    salesOrder.discountAmount = disc;
                                    FocusScope.of(context).unfocus();
                                  }

                                  totalSummary(salesOrder, myOrders);
                                  bindingController();
                                }));
                              },
                              decoration: const InputDecoration(
                                labelText: '???????????????????????????????????????',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
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
                                textAlign: TextAlign.right,
                                controller: txtPriceAfterDiscount,
                                decoration: const InputDecoration(
                                  labelText: '??????????????????????????????????????????',
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 0),
                                ),
                              )
                          )
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                textAlign: TextAlign.right,
                                controller: txtVatTotal,
                                decoration: const InputDecoration(
                                  labelText: '???????????? 7%',
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 0),
                                ),
                              )
                          )
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              readOnly: true,
                              textAlign: TextAlign.right,
                              controller: txtNetTotal,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                labelText: '????????????????????????',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                              ),
                            )
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
                                icon: Icon(Icons.attach_file, size: 22),
                                label: Text('???????????????????????????', style: TextStyle(fontSize: 14),),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.orange[600],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(30.0))
                                  ),
                                ),
                                onPressed: () async {
                                  // List<File> res = await Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             FileAttachManager(globals.attachDraftOrder, "DRAFT")));
                                  //
                                  // if(res != null){
                                  //   globals.recycleBin.forEach((e) {
                                  //     if(fileAttach.any((x) => e.path.contains(x.url))){
                                  //       var obj = fileAttach.firstWhere((x) => e.path.contains(x.url));
                                  //       globals.fileAttachTrash.add(obj);
                                  //       fileAttach.remove(obj);
                                  //     }
                                  //   });
                                  // }
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
                            label: Text(
                              '??????????????????????????????????????????',
                              style: TextStyle(fontSize: 14),
                            ),
                            icon: Icon(Icons.save_alt, size: 22),
                            onPressed: () async {
                              var isConfirm = await orderValidation();

                              if(isConfirm) {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.INFO,
                                  animType: AnimType.BOTTOMSLIDE,
                                  width: 400,
                                  title: 'Save Draft',
                                  desc: 'Do you want to save draft ?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    // await saveOrder('D');
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ).show();
                              }
                            },
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

                  Visibility(
                    visible: true,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 35.0, right: 10.0, left: 10.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete_forever, size: 28),
                        label: const Text('??????????????????????????????', style: TextStyle(fontSize: 18),),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0)
                        ),
                        onPressed: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.INFO,
                            animType: AnimType.BOTTOMSLIDE,
                            width: 400,
                            title: 'Remove Draft',
                            desc: 'Do you want to remove draft order ?',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () async {
                              // setState(() {});
                              SharedWidgets.showLoader(context, false);
                              // await _apiService.deleteSaleOrder(widget.header.id);

                              if(quotation.id != null){
                                quotation.status = 'Q';
                                // await _apiService.updateQuotationHeader(quotation.id, quotation);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                              else{
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            },
                          ).show();
                        },
                      ),
                    ),
                  ),

                  Container(
                    child: ElevatedButton.icon(
                      label: const Text('?????????????????????????????????????????????', style: TextStyle(fontSize: 20),),
                      icon: const Icon(Icons.done, size: 34),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20.0)
                      ),
                      onPressed: () async {
                        var isConfirm = await orderValidation();

                        if(isConfirm == true) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.INFO,
                            animType: AnimType.BOTTOMSLIDE,
                            width: 400,
                            title: 'Create Order',
                            desc: 'Do you want to create sales order ?',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () async {
                              // await saveOrder('N');
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
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
      ),
    );
  }

  bindingController() {
    setState(() {
      double totalPrice = myOrders.fold(0, (previousValue, element) => previousValue.toDouble() + element.netAmount);
      txtPriceTotal.text = CURRENCY.format(totalPrice);
      // txtDiscountTotal.text = CURRENCY.format(discountTotal);

      txtDiscountBill.text = CURRENCY.format(salesOrder.discountAmount);
      // txtPriceAfterDiscount.text = CURRENCY.format(salesOrder.discountAppliedBeforeTax);
      txtVatTotal.text = CURRENCY.format(salesOrder.totalTaxAmount);
      txtNetTotal.text = CURRENCY.format(salesOrder.netAmount);
    });
  }

  orderValidation() async {

    if (txtDocuNo.text == '') {
      return SharedWidgets.showAlert(context,
          '????????????????????????????????????????????????????????????',
          '????????????????????????????????????????????????????????????????????????????????????????????????');
    }

    if (myOrders.isEmpty) {
      return SharedWidgets.showAlert(context, '???????????????????????????????????????????????????????????????', '?????????????????????????????????????????????????????????????????????');
    }

    if(!checkCredit(salesOrder.netAmount)) {
      double limitAmount = CUSTOMER_FINANCIAL?.balance ?? 0;
      return SharedWidgets.showAlert(context, '??????????????????????????????????????????????????????????????????????????????', '?????????????????????????????????????????????????????????????????????????????????????????????????????? \n ????????????????????? = ${CURRENCY.format(limitAmount)}');
    }

    // if(!globals.checkMixedVat(globals.productCartDraft)) {
    //   return await SharedWidgets.showConfirm(context, '????????????????????????????????? VAT & Non-VAT ??????????????????', '??????????????????????????????????????????????????????????????????????????????????????????????????? ?', '?????????, ??????????????????????????????????????????', '??????????????????') ?? false;
    // }
    else {
      return true;
    }
  }

  saleOrderDetail() {
    return ListView(
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      children: myOrders.map((e) {
        Item item = ITEMS.firstWhere((x) => x.id == e.itemId);
        String goodsCode = item.code ?? '';
        String goodsName = item.displayName ?? '';
        String unitName = UNITS.firstWhere((unit) => unit.id == e.unitOfMeasureId).displayName ?? '';

        Color flagFreeColor = e.unitPrice == 0 ? Colors.lightGreen : Colors.orangeAccent;

        return ListTile(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${e.sequence}. ($goodsCode) $goodsName', style: const TextStyle(fontSize: 14.0),),
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
                          child: Text('??????????????????${e.unitPrice == 0 ? '??????????????????' : '????????????????????????'}', style: const TextStyle(color: Colors.white, fontSize: 12.0)),
                        ),
                      ),
                    ),

                    Text(' ${CURRENCY.format(e.quantity)} x $unitName', style: const TextStyle(fontSize: 14.0),),
                  ],
                )
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('?????????????????? ${e.discountType == 'PER' ? '${CURRENCY.format(e.discountPercent)}%' : CURRENCY.format(e.discountAmount)}', style: TextStyle(fontSize: 14.0),)
              ),
              Row(
                children: [
                  Container(
                    child: TextButton(
                      child: const Text('???????????????'),
                      onPressed: () async {

                        var res = await Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => ItemEditPortrait(editItem: e))
                        );

                        if(res != null) {
                          // if(res == 'Remove') {
                          //   globals.productCartDraft.removeWhere((x) => x.rowIndex == e.rowIndex);
                          //
                          //   /// Re-Index
                          //   int row = 1;
                          //   globals.productCartDraft.forEach((x) => x.rowIndex = row++);
                          // }
                          // else{
                          //   globals.productCartDraft[globals.productCartDraft.indexWhere((x) => x.rowIndex == e.rowIndex)] = res;
                          // }
                        }

                        totalSummary(salesOrder, myOrders);
                        bindingController();
                      },
                    ),
                  ),

                  TextButton(
                      onPressed: (){
                        myOrders.removeWhere((x) => x.sequence == e.sequence);

                        /// Re-Index
                        int index = 1;
                        for (var x in myOrders) {
                          x.sequence = index++;
                        }

                        totalSummary(salesOrder, myOrders);
                        bindingController();
                      },
                      child: const Text('????????????????????????')
                  )
                ],
              )
              // Expanded(
              //     child: Text('??? ${currency.format(e.goodAmnt)}', textAlign: TextAlign.right,)
              // )
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CURRENCY.format(e.unitPrice)),
              Text(CURRENCY.format(e.netAmount), style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),),
            ],
          ),
        );
      })?.toList() ?? [],
    );
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('?????????????????????????????????????????? ?'),
        content: const Text('?????????????????????????????????????????????????????????????????????????????????????????????????????? ?'),
        actions: <Widget>[
          TextButton(
            child: const Text('??????????????????????????????'),
            onPressed: () {
              Navigator.of(context).pop(true);
              Navigator.of(context).pop(true);
              Navigator.of(context).pop(true);
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Launcher(pageIndex: 0,)));
            },
          ),
          TextButton(
            child: const Text('??????????????????'),
            onPressed: () async {
              // await saveOrder('D');
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ) ?? false;
  }
}
