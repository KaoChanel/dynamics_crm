import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/sales_quote.dart';
import 'package:dynamics_crm/models/sales_shipment.dart';
import 'package:dynamics_crm/services/api_service.dart';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/order.dart';
import '../../models/sales_order.dart';
import '../../models/sales_order_line.dart';

class SalesOrderViewPortrait extends StatefulWidget {
  final SalesOrder header;

  const SalesOrderViewPortrait({Key? key, required this.header}) : super(key: key);

  @override
  State<SalesOrderViewPortrait> createState() => _SalesOrderViewPortraitState();
}

class _SalesOrderViewPortraitState extends State<SalesOrderViewPortrait> {
  SalesQuote quotation = SalesQuote();
  SalesOrder header = SalesOrder();
  List<SalesOrderLine> details = <SalesOrderLine>[];
  SalesShipment salesShipment = SalesShipment();

  // List<File> attachFile = <File>[];
  String runningNo = '';
  String docuNo = '';
  String refNo = '';
  String custPoNo = '';
  double vat = 0.7;
  double priceTotal = 0;
  double discountTotal = 0;
  double discountBill = 0;
  double priceAfterDiscount = 0;
  double vatTotal = 0.0;
  double netTotal = 0.0;
  late DateTime _docuDate;
  late DateTime _shiptoDate;
  late DateTime _orderDate;
  bool isInitial = false;
  bool editedDocuDate = false;
  bool editedShipDate = false;

  FocusNode focusDiscount = FocusNode();
  TextEditingController txtRunningNo = TextEditingController();
  TextEditingController txtDocuNo = TextEditingController();
  TextEditingController txtRefNo = TextEditingController();
  TextEditingController txtCustPoNo = TextEditingController();
  TextEditingController txtEmpCode = TextEditingController();
  TextEditingController txtEmpName = TextEditingController();
  TextEditingController txtCustCode = TextEditingController();
  TextEditingController txtCustName = TextEditingController();
  TextEditingController txtCustRemark = TextEditingController();
  TextEditingController txtCreditType = TextEditingController();
  TextEditingController txtCredit = TextEditingController();
  TextEditingController txtStatus = TextEditingController();
  TextEditingController txtRemark = TextEditingController();

  TextEditingController txtShiptoProvince = TextEditingController();
  TextEditingController txtShiptoAddress = TextEditingController();
  TextEditingController txtShiptoRemark = TextEditingController();
  TextEditingController txtPriceTotal = TextEditingController();
  TextEditingController txtDiscountTotal = TextEditingController();
  TextEditingController txtDiscountBill = TextEditingController();
  TextEditingController txtPriceAfterDiscount = TextEditingController();
  TextEditingController txtVatTotal = TextEditingController();
  TextEditingController txtNetTotal = TextEditingController();

  TextEditingController txtDocuDate = TextEditingController();
  TextEditingController txtShiptoDate = TextEditingController();
  TextEditingController txtOrderDate = TextEditingController();

  TextEditingController txtQuotationNo = TextEditingController();

  // getQuotation() async {
  //   if(widget.header.refSoid != null) {
  //     quotation = await _apiService.getQuotationHeader(widget.header.refSoid);
  //     txtQuotationNo.text = quotation.docuNo;
  //   }
  // }

  setHeader() async {
    try {
      header = widget.header;

      // runningNo = header.docuNo ?? '';
      // refNo = header.refNo ?? '';
      // custPoNo = header.custPono;
      // _docuDate = editedDocuDate == false ? SOHD.docuDate : _docuDate;
      // _shiptoDate = editedShipDate == false ? SOHD.shipDate : _shiptoDate;
      // _docuDate = header.orderDate;
      // _shiptoDate = header.shipDate;
      // _orderDate = header.custPodate;
      // discountBill = header.billDiscAmnt;

      txtRunningNo.text = runningNo;
      txtRefNo.text = refNo;
      txtDocuNo.text = header.no ?? '';
      txtCustPoNo.text = custPoNo;
      txtDocuDate.text = DATE_FORMAT.format(header.orderDate ?? DateTime.now());
      txtShiptoDate.text = header.shipmentDate != null
          ? DATE_FORMAT.format(header.shipmentDate!)
          : '';
      txtShiptoRemark.text = '';
      txtOrderDate.text = header.orderDate != null ? DATE_FORMAT.format(header.orderDate!) : '';
      txtEmpCode.text = '${EMPLOYEE?.code}';
      txtEmpName.text = '${EMPLOYEE?.name ?? ''} (${txtEmpCode.text})';
      txtCustCode.text = MY_CUSTOMERS.firstWhere((e) => e.code == header.sellToCustomerNo)?.code ?? '';
      // txtCustName.text = '${header.customerName ?? ''} (${txtCustCode.text})';
      // txtCredit.text = header.creditDays.toString() ?? '0';
      // txtRemark.text = SOHD.remark ?? '';

      // txtPriceTotal.text = CURRENCY.format(header.am);
      // txtDiscountBill.text = header.billDiscFormula ?? '0.00';
      // txtPriceAfterDiscount.text = CURRENCY.format(header.billAftrDiscAmnt);
      txtVatTotal.text = CURRENCY.format(header.vatamount ?? 0);
      txtNetTotal.text = CURRENCY.format(header.grandtotal);
    } catch (e) {
      Navigator.pop(context);
      return SharedWidgets.showAlert(context, 'Set Header Exception', e.toString());
    }
  }

  setDetail() async {
    try {
      // details = await _apiService.getSODT(header.id);
      details.where((e) => e.documentId == header.systemId)
          .forEach((x) {
            discountTotal += x.discountAmount ?? 0;
          });
    } catch (e) {
      Navigator.pop(context);
      return SharedWidgets.showAlert(context, 'Set Detail Exception', e.toString());
    }
  }

  // setRemark() async {
  //   try {
  //     headerRemark = await _apiService.getHeaderRemark(header.soid);
  //     detailRemark = await _apiService.getDetailRemark(header.soid);
  //
  //     txtRemark.text = headerRemark?.remark ?? '';
  //
  //     print('Length: ${detailRemark.length}');
  //     detailRemark?.forEach((e) => print(
  //         'DTRemark SOID: ${e.soId} ListNo: ${e.refListNo} Remark: ${e.remark}'));
  //
  //     // SODT.forEach((x) {
  //     //   print('SODT SOID: ${x.soid} ListNo:${x.listNo} RefListNo:${x.listNo}');
  //     //   print('---------' + detailRemark
  //     //       .firstWhere((e) => e.soId == x.soid && e.refListNo == x.listNo,
  //     //       orElse: () => null)
  //     //       ?.remark ?? '');
  //     //   x.goodsRemark = detailRemark
  //     //       .firstWhere((e) => e.soId == x.soid && e.refListNo == x.listNo,
  //     //       orElse: () => null)
  //     //       ?.remark ?? '';
  //     // });
  //   } catch (e) {
  //     Navigator.pop(context);
  //     return globals.showAlertDialog(
  //         'Set Remark Exception', e.toString(), context);
  // }

  void setSelectedShipto() {
    // salesShipment.billToAddressLine1 = widget.header?.shipToAddr1 ?? '';
    // salesShipment.billToAddressLine2 = widget.header?.shipToAddr2 ?? '';
    // salesShipment.sell = widget.header?.district ?? '';
    // salesShipment.city = widget.header?.billingPostalAddress?.city ?? '';
    // salesShipment. = widget.header?.billingPostalAddress?.state ?? '';
    // salesShipment.postCode = widget.header?.billingPostalAddress?.postalCode ?? '';
    // salesShipment.remark = widget.header?.billingPostalAddress. ?? '';
  }

  // setFileAttach() async {
  //   try {
  //     attachFile = <File>[];
  //     var files = await _apiService.getFileAttach(header.id);
  //
  //     files.forEach((x) {
  //       attachFile.add(File(globals.publicAddress + x.url));
  //     });
  //   } catch (e) {
  //     Navigator.pop(context);
  //     return globals.showAlertDialog(
  //         'File Attachment Exception', e.toString(), context);
  //   }
  // }

  controllerBinding() {
    setState(() {
      // txtShiptoAddress.text = '${header?.billingPostalAddress!.street ?? ''} '
          // '${header.shipToAddr2 ?? ''} '
          // '${header.district ?? ''} '
          // '${header.billingPostalAddress?.city ?? ''} '
          // '${header.billingPostalAddress?.state ?? ''} '
          // '${header.billingPostalAddress?.postalCode ?? ''}';
      // txtShiptoProvince.text = header.province ?? '';
      // txtShiptoRemark.text = header.remark ?? '';

      txtDiscountTotal.text = CURRENCY.format(discountTotal);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await setHeader();
      // await setDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    Order order = totalSummary(header, details);
    header = order.header;
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
                  Row(
                    children: [
                      Container(
                        width: 350,
                        margin: const EdgeInsets.only(top: 11),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(0)
                          ),
                          color: Theme.of(context).primaryColor,
                          // boxShadow: [
                          //   BoxShadow(color: Colors.green, spreadRadius: 3),
                          // ],
                        ),
                        //color: Colors.indigo,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.header.no ?? '',
                              style: GoogleFonts.kanit(
                                  color: Colors.white, fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(DATE_FORMAT_TH.formatInBuddhistCalendarThai(widget.header.orderDate ?? DateTime.now()), style: const TextStyle(color: Colors.white, fontSize: 14.0)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Row(children: [
                    // Flexible(
                    //   child: Container(
                    //     padding: const EdgeInsets.only(left: 15.0, right: 5.0),
                    //     child: TextFormField(
                    //       readOnly: true,
                    //       controller: txtDocuNo,
                    //       decoration: const InputDecoration(
                    //         border: OutlineInputBorder(),
                    //         contentPadding:
                    //         EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    //         floatingLabelBehavior: FloatingLabelBehavior.always,
                    //         labelText: "เลขที่ใบสั่งขาย",
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: txtQuotationNo,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "เลขที่ใบเสนอราคา",
                          ),
                        ),
                      ),
                    ),
                  ]),

                  SizedBox(height: 20),
                  Row(children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: txtRefNo,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "เลขที่อ้างอิงระบบ",
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(left: 5.0, right: 8.0),
                        child: TextFormField(
                          controller: txtShiptoDate,
                          readOnly: true,
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
                  ]),

                  SizedBox(height: 15),
                  Row(children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                        child: TextField(
                          readOnly: true,
                          controller: txtCustPoNo,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            labelText: 'เลขที่ใบสั่งซื้อลูกค้า',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.only(left: 5.0, right: 8.0),
                        child: TextField(
                          controller: txtOrderDate,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'วันที่สั่งซื้อลูกค้า',
                          ),
                        ),
                      ),
                    ),
                  ]),

                  SizedBox(height: 15),
                  Row(children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: txtEmpName,
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
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          readOnly: true,
                          maxLines: 2,
                          controller: txtCustName,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
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
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(0)),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          'สถานที่จัดส่ง',
                          style: GoogleFonts.kanit(
                              color: Colors.white, fontSize: 20
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: TextFormField(
                      readOnly: true,
                      controller: txtShiptoAddress,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8.0),
                        floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                        labelText: "สถานที่ส่งจริง",
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
                        labelText: 'ส่งจังหวัด',
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
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "หมายเหตุ",
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      SizedBox(height: 80),
                      Container(
                        margin: EdgeInsets.only(top: 11),
                        padding: EdgeInsets.all(10),
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(0)),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          'รายการสินค้า',
                          style: GoogleFonts.kanit(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),

                  saleOrderDetails(),

                  Row(
                    children: [
                      const SizedBox(height: 80),
                      Container(
                        margin: const EdgeInsets.only(top: 11),
                        padding: const EdgeInsets.all(10),
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(0)),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          'ส่วนท้าย ใบสั่งขาย',
                          style: GoogleFonts.kanit(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),

                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     Visibility(
                  //       visible: false,
                  //       child: ElevatedButton.icon(
                  //         onPressed: () {},
                  //         icon: Icon(Icons.add_comment),
                  //         label: Text(
                  //           'ข้อความหมายเหตุ',
                  //           style: TextStyle(fontSize: 16),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                    child: TextFormField(
                      controller: txtRemark,
                      readOnly: true,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                        labelText: "หมายเหตุ",
                        //border: OutlineInputBorder()
                      ),
                    ),
                  ),


                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text('รวมส่วนลด',
                                  // textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.normal)),
                            ),
                            Flexible(
                              child: TextFormField(
                                readOnly: true,
                                controller: txtDiscountTotal,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  //labelText: "0.00",
                                  //border: OutlineInputBorder()
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text('รวมเป็นเงิน',
                                  // textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.normal)
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                readOnly: true,
                                controller: txtPriceTotal,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  //border: OutlineInputBorder()
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text('ส่วนลดท้ายบิล',
                                  // textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal)
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: txtDiscountBill,
                                focusNode: focusDiscount,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  //border: OutlineInputBorder()
                                ),
                              ),
                            ),

                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text('ยอดก่อนรวมภาษี',
                                  // textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal)
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: txtPriceAfterDiscount,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  //border: OutlineInputBorder()
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text('ภาษี 7%',
                                  // textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal)
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: txtVatTotal,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  //border: OutlineInputBorder()
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text('ยอดรวมสุทธิ',
                                  // textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)
                              ),
                            ),
                            Expanded(child: Text(CURRENCY.format(header.grandtotal), textAlign: TextAlign.right, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),))
                            // Expanded(
                            //   child: TextFormField(
                            //     readOnly: true,
                            //     controller: txtNetTotal,
                            //     textAlign: TextAlign.right,
                            //     style: const TextStyle(fontWeight: FontWeight.bold),
                            //     decoration: const InputDecoration(
                            //       // border: OutlineInputBorder()
                            //       border: InputBorder.none,
                            //       contentPadding: EdgeInsets.symmetric(
                            //           horizontal: 0, vertical: 0),
                            //       floatingLabelBehavior:
                            //       FloatingLabelBehavior.never,
                            //       //border: OutlineInputBorder()
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: false,
                    child: Container(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ElevatedButton.icon(
                          onPressed: () async {
                            // var _customer = globals.allCustomer.where((x) => x.custId == widget.header.custId).first ?? null;

                            // await Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => PaymentQRCode(_customer, tempOverdue.where((e) => e.isSelected).toList(), widget.header.netAmnt))
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15.0)
                          ),
                          icon: const Icon(Icons.qr_code),
                          label: const Text('ชำระเงินผ่าน QR Code', style: TextStyle(fontSize: 20))
                      ),
                    ),
                  ),

                  Container(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.replay, size: 28.0,),
                      label: const Text(
                        'สั่งขายเหมือนเดิม',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 15.0)
                      ),
                      onPressed: () {
                        // AwesomeDialog(
                        //   context: context,
                        //   dialogType: DialogType.INFO,
                        //   animType: AnimType.BOTTOMSLIDE,
                        //   width: 450,
                        //   title: 'Duplicate Order ?',
                        //   desc: 'Are you sure to duplicate sales order ?',
                        //   btnCancelOnPress: () {},
                        //   btnOkOnPress: () async {
                        //     isInitial = false;
                        //     globals.isCopyInitial = false;
                        //     globals.discountBillCopy = Discount(
                        //         number: 0, amount: 0, type: 'THB');
                        //     Navigator.pop(context);
                        //     Navigator.pop(context);
                        //
                        //     await Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => OrderCopyPortrait(
                        //                 header: widget.header,
                        //                 detail: SODT)
                        //         )
                        //     );
                        //   },
                        // )..show();

                        //print(jsonEncode(globals.productCart));
                      },
                    ),
                  ),
                  // SizedBox(height: 30,)
                ],
              )
          ),
        ));
  }

  Widget saleOrderDetails() {
    return FutureBuilder(
        future: ApiService().getSalesOrderLine(widget.header.systemId ?? ''),
        builder: (BuildContext context, AsyncSnapshot<Object> snapShot) {
          List<SalesOrderLine> details = [];
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapShot.hasError) {
            return Text('Error: ${snapShot.error}');
          } else {
            if (snapShot.hasData) {
              if (isInitial == false) {
                isInitial = true;
                details = snapShot.data as List<SalesOrderLine>;
              }
            }
            return ListView(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: details.asMap().map((i, e) {
                String goodsCode = ITEMS.firstWhere((goods) => goods.id == e.itemId).code ?? '';
                String goodsName = ITEMS.firstWhere((goods) => goods.id == e.itemId).displayName ?? '';
                String unitName = UNITS.firstWhere((unit) => unit.id == e.unitOfMeasureId).displayName ?? '';

                Color flagFreeColor = e.unitPrice == 0 ? Colors.lightGreen : Colors.orangeAccent;

                return MapEntry(i,
                    ListTile(
                      // leading: Text('${i + 1}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${i + 1}. ($goodsCode) $goodsName', style: const TextStyle(fontSize: 14.0),),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                child: Badge(
                                  backgroundColor: flagFreeColor,
                                  label: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Text(e.unitPrice == 0 ? 'แถมฟรี' : 'เพื่อขาย', style: const TextStyle(color: Colors.white, fontSize: 12.0)),
                                  ),
                                ),
                              ),

                              Text(' ${CURRENCY.format(e.quantity)} x $unitName', style: const TextStyle(fontSize: 14.0),),
                            ],
                          )
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('ส่วนลด ${e.discountType ?? CURRENCY.format(e.discountAmount)}', style: const TextStyle(fontSize: 14.0),)
                          ),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(CURRENCY.format(e.unitPrice)),
                          Text(CURRENCY.format(e.netAmount), style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.normal),),
                        ],
                      ),
                    )
                );
              }).values.toList() ?? [],
            );
          }

          // if (snapShot.connectionState == ConnectionState.none && snapShot.hasData == null) {
          //   return Container();
          // }
        });
  }
}
