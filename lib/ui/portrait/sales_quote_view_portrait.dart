import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/employee.dart';
import 'package:dynamics_crm/models/sales_quote.dart';
import 'package:dynamics_crm/models/sales_quote_line.dart';
import 'package:dynamics_crm/models/sales_quote_line.dart';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/customer.dart';

class SalesQuoteViewPortrait extends ConsumerStatefulWidget {
  const SalesQuoteViewPortrait({Key? key, required this.header}) : super(key: key);

  final SalesQuote header;

  @override
  _SalesQuoteViewPortraitState createState() => _SalesQuoteViewPortraitState();
}

class _SalesQuoteViewPortraitState extends ConsumerState<SalesQuoteViewPortrait> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Sales Quotation"),
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
                      margin: EdgeInsets.only(top: 11),
                      padding: EdgeInsets.all(10),
                      width: 350,
                      //color: Colors.indigo,
                      child: Text(
                        'หัวบิล การสั่งสินค้า',
                        style: TextStyle(
                            color: Colors.white, fontSize: 20),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  child: TextFormField(
                    //initialValue: '00001',
                    readOnly: true,
                    controller: txtDocuNo,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "เลขที่ใบสั่งสินค้า",
                    ),
                  ),
                ),
                Row(children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom:10, left: 10.0, right: 5.0),
                      child: TextFormField(
                        controller: txtDocuDate,
                        // initialValue: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "วันที่เอกสาร",
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom:10.0, left: 5.0, right: 10.0),
                      child: TextFormField(
                        controller: txtShiptoDate,
                        readOnly: true,
                        decoration: InputDecoration(
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 5.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: txtValidDays,
                          decoration: InputDecoration(
                            // filled: true,
                            // fillColor: Colors.amberAccent[100],
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "ยืนราคากายใน / วัน",
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 10.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: txtExpireDate,
                          decoration: InputDecoration(
                            // filled: true,
                            // fillColor: Colors.amberAccent[100],
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "วันที่หมดอายุยืนราคา",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: '${EMPLOYEE?.name} (${EMPLOYEE?.code})',
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'ชื่อพนักงาน',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    readOnly: true,
                    maxLines: 2,
                    controller: txtCustName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'ชื่อลูกค้า',
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
                      child: Text(
                        'สถานที่จัดส่ง',
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

                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    readOnly: true,
                    //initialValue: globals.customer?.,
                    maxLines: 3,
                    controller: txtShiptoAddress,
                    decoration: InputDecoration(
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
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: txtShiptoProvince,
                    decoration: InputDecoration(
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
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: txtShiptoRemark,
                    decoration: InputDecoration(
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
                    SizedBox(height: 10),
                  ],
                ),

                SharedWidgets.saleQuoteDetail(context, QuotDT),

                Row(
                  children: [
                    SizedBox(height: 80),
                    Container(
                      margin: EdgeInsets.only(top: 11),
                      padding: EdgeInsets.all(10),
                      width: 350,
                      child: Text(
                        'ท้ายบิล การสั่งสินค้า',
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

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: txtRemark,
                    readOnly: true,
                    maxLines: 6,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      floatingLabelBehavior:
                      FloatingLabelBehavior.always,
                      labelText: "หมายเหตุท้ายบิล",
                      //border: OutlineInputBorder()
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text('รวมส่วนลด',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.normal)
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: txtDiscountTotal,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
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
                          Expanded(
                            child: Text('รวมเงิน',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.normal)),
                          ),
                          Flexible(
                            child: TextFormField(
                              readOnly: true,
                              controller: txtPriceTotal,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
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
                          Expanded(
                            child: Text('ส่วนลดท้ายบิล',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal)
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 8.0),
                          //   child: ElevatedButton(
                          //       onPressed: () {
                          //         showDiscountTypeDialog();
                          //         //focusDiscount.requestFocus();
                          //       },
                          //       child: setDiscountType()),
                          // ),
                          Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: txtDiscountBill,
                                focusNode: focusDiscount,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  //border: OutlineInputBorder()
                                ),
                              )
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('ก่อนรวมภาษี',
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
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  //border: OutlineInputBorder()
                                ),
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('ภาษี 7%',
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
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  //border: OutlineInputBorder()
                                ),
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('รวมสุทธิ',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: txtNetTotal,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
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
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                  child: ElevatedButton.icon(
                      icon: Icon(Icons.description_outlined),
                      label: Text('แสดงเอกสาร', style: TextStyle(fontSize: 20)),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10.0)
                      ),
                      onPressed: () async {
                        // String strUrl = '${globals.publicAddress}/api/report/${globals.company}/${widget.header.quotid}';
                        // await viewPdf(strUrl);


                        // await openPdf(strUrl);
                        // var file = await _download(strUrl);
                        // if(file != null) {
                        //   await openPdf(file.path);
                        //   // await _launch(file.path);
                        // }
                        // await _launchInBrowser(strUrl);


                      }
                  ),
                ),

                Container(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.replay, size: 30,),
                    label: Text(
                      'ทำรายการซ้ำ',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 20.0)
                    ),
                    onPressed: () async {
                      // AwesomeDialog(
                      //   context: context,
                      //   dialogType: DialogType.INFO,
                      //   animType: AnimType.BOTTOMSLIDE,
                      //   width: 450,
                      //   title: 'Duplicate Order ?',
                      //   desc: 'Are you sure to duplicate sales order ?',
                      //   btnCancelOnPress: () {},
                      //   btnOkOnPress: () {
                      //     isInitial = false;
                      //     globals.isCopyInitial = false;
                      //     globals.discountBillCopy = Discount(number: 0, amount: 0, type: 'THB');
                      //     Navigator.pop(context);
                      //     Navigator.pop(context);
                      //
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => QuotationCopyPortrait(header:widget.header, detail:QuotDT)));
                      //   },
                      // )..show();
                      //print(jsonEncode(globals.productCart));
                    },
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  List<Customer> allCustomers = <Customer>[];
  SalesQuote QuotHD = SalesQuote();
  List<SalesQuoteLine> QuotDT = <SalesQuoteLine>[];
  // Shipto selectedShipTo = Shipto();
  // List<File> attachFile = <File>[];

  String runningNo = '';
  String docuNo = '';
  String refNo = '';
  String custCode = '';
  String custPoNo = '';
  double vat = 0.7;
  double priceTotal = 0;
  double discountTotal = 0;
  double discountBill = 0;
  double priceAfterDiscount = 0;
  double vatTotal = 0.0;
  double netTotal = 0.0;
  int validDays = 0;
  DateTime _docuDate = DateTime.now();
  DateTime _expireDate = DateTime.now();
  DateTime _shiptoDate = DateTime.now();
  DateTime _orderDate = DateTime.now();
  bool isInitial = false;
  bool editedDocuDate = false;
  bool editedShipDate = false;

  FocusNode focusDiscount = FocusNode();
  TextEditingController txtRunningNo = TextEditingController();
  TextEditingController txtDocuNo = TextEditingController();
  TextEditingController txtRefNo = TextEditingController();
  TextEditingController txtSONo = TextEditingController();
  TextEditingController txtDeptCode = TextEditingController();
  TextEditingController txtCopyDocuNo = TextEditingController();
  TextEditingController txtValidDays = TextEditingController();
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

  TextEditingController txtDocuDate = TextEditingController();
  TextEditingController txtExpireDate = TextEditingController();
  TextEditingController txtShiptoDate = TextEditingController();
  TextEditingController txtOrderDate = TextEditingController();
}
