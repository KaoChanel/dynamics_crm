import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/activity.dart';
import 'package:dynamics_crm/models/sales_order.dart';
import 'package:dynamics_crm/models/sales_order_line.dart';
import 'package:dynamics_crm/models/sales_quote.dart';
import 'package:dynamics_crm/models/sales_quote_line.dart';
import 'package:dynamics_crm/providers/data_provider.dart';
import 'package:dynamics_crm/ui/portrait/item_add_express_portrait.dart';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';

import '../../models/customer.dart';
import 'customer_select.dart';
import 'item_select.dart';

class SalesQuoteCreatePortrait extends ConsumerStatefulWidget {
  const SalesQuoteCreatePortrait({Key? key}) : super(key: key);

  @override
  _SalesQuoteCreatePortraitState createState() => _SalesQuoteCreatePortraitState();
}

class _SalesQuoteCreatePortraitState extends ConsumerState<SalesQuoteCreatePortrait> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    txtCustName.text = ref.read(myCustomerProvider).displayName ?? '';
  }


  @override
  Widget build(BuildContext context) {
    final Customer customer = ref.watch(myCustomerProvider);
    final SalesQuote myQuote = ref.watch(salesQuote);
    final List<SalesQuoteLine> myQuoteDetail= ref.read(salesQuoteLines);

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
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          enabled: false,
                          controller: txtDocuNo,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "เลขที่ใบสั่งสินค้า",
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0, right: 5.0),
                        child: TextFormField(
                          controller: txtDocuDate,
                          // initialValue: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                          enabled: false,
                          onTap: () async {
                            // _docuDate = await showDatePicker(
                            //   context: context,
                            //   initialDate:
                            //       _docuDate != null ? _docuDate : DateTime.now(),
                            //   firstDate: DateTime(1995),
                            //   lastDate: DateTime(2030),
                            // );
                            //
                            // setState(() {
                            //   if (_docuDate == null) _docuDate = DateTime.now();
                            //   txtDocuDate.text = DateFormat('dd/MM/yyyy').format(_docuDate);
                            // });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "วันที่เอกสาร",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 5.0, right: 10.0),
                        child: DropdownButtonFormField(
                          items: [
                            DropdownMenuItem(
                                value: true,
                                child: Text('แสดงวันที่')
                            ),
                            DropdownMenuItem(
                                value: false,
                                child: Text('ไม่แสดงวันที่')
                            ),
                          ],
                          value: showDate,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0)
                          ),
                          onChanged: (bool? value) {
                            setState(() {
                              showDate = value ?? false;
                            });
                          },
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 5.0, top: 10.0, bottom: 10.0, right: 10.0),
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
                              lastDate:
                              DateTime.now().add(const Duration(days: 180)),
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 5.0),
                        child: TextFormField(
                          controller: txtValidityPrice,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            // filled: true,
                            // fillColor: Colors.amberAccent[100],
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "ยืนราคาภายใน / วัน",
                          ),
                          onChanged: (value) {
                            if(txtValidityPrice.text.isNotEmpty){
                              if(int.tryParse(txtValidityPrice.text) != null){
                                // calValidityExpire(int.parse(value));
                              }
                              else{
                                // calValidityExpire(0);
                              }
                            }
                          },
                          onTap: (){
                            txtValidityPrice.selection = TextSelection(baseOffset: 0, extentOffset: txtValidityPrice.text.length);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0, right: 10.0),
                          child: TextFormField(
                            enabled: false,
                            controller: txtValidityExpire,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              // filled: true,
                              // fillColor: Colors.amberAccent[100],
                              border: OutlineInputBorder(),
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: "หมดอายุยืนราคา",
                            ),
                          ),
                        )
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    enabled: false,
                    initialValue: '${EMPLOYEE?.name} (${EMPLOYEE?.code})',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'ชื่อพนักงาน',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    enabled: false,
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
                // Row(children: [
                //   Flexible(
                //     flex: 6,
                //     child: ListTile(
                //       title: TextFormField(
                //         readOnly: true,
                //         //initialValue: globals.customer?.,
                //         decoration: InputDecoration(
                //           border: OutlineInputBorder(),
                //           contentPadding:
                //               EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                //           floatingLabelBehavior: FloatingLabelBehavior.always,
                //           labelText: "หมายเหตุ",
                //         ),
                //       ),
                //     ),
                //   ),
                // ]),

                Container(
                  padding: EdgeInsets.all(10.0),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.person_rounded),
                    label: Text('เปลี่ยนลูกค้า'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 10.0)
                    ),
                    onPressed: () async {
                      Customer? res = await Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerSelect(lookNewCustomer: true)));

                      if(res != null){
                        setState(() {
                          setCustomer(res);
                          // setAddress(res);
                        });
                      }
                    },
                  ),
                ),

                Row(
                  children: [
                    SizedBox(height: 80),
                    Container(
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
                    maxLines: 3,
                    enabled: false,
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

                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(height: 80),
                  // Flexible(
                  //   flex: 6,
                  //   child: ListTile(
                  //     title: TextFormField(
                  //       readOnly: true,
                  //       //initialValue: globals.customer?.,
                  //       controller: txtShiptoAddress,
                  //       decoration: InputDecoration(
                  //         border: OutlineInputBorder(),
                  //         contentPadding: EdgeInsets.symmetric(
                  //             horizontal: 10, vertical: 0),
                  //         floatingLabelBehavior:
                  //             FloatingLabelBehavior.always,
                  //         labelText: "สถานที่ส่งจริง",
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 5.0),
                        child: ElevatedButton.icon(
                            icon: Icon(Icons.local_shipping_outlined),
                            label: Text('สถานที่ส่ง'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            ),
                            onPressed: () {
                              //_showShiptoDialog(context);
                              // _showDialog(context);
                            }
                        ),
                      )
                  ),

                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 5.0, right: 15.0),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.refresh),
                          label: Text('ค่าเริ่มต้น'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueGrey,
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.0))),
                          ),

                          onPressed: () {
                            setState(() {

                              // if(globals.allShipto.any((e) => e.custId == myCustomer.custId)){
                              //   globals.selectedShiptoQuot = globals.allShipto
                              //       .firstWhere((e) => e.custId == myCustomer.custId
                              //       && e.isDefault == 'Y');
                              // }
                              //
                              // setAddress(myCustomer);

                            });

                            SharedWidgets.showAwesomeSnackBar(context, ContentType.success, 'ใช้ค่าเริ่มต้นเรียบร้อย', '');

                            // Fluttertoast.showToast(
                            //     msg: "ใช้ค่าเริ่มต้นเรียบร้อย",
                            //     toastLength: Toast.LENGTH_SHORT,
                            //     gravity: ToastGravity.BOTTOM,
                            //     timeInSecForIosWeb: 1,
                            //     backgroundColor: Colors.black54,
                            //     textColor: Colors.white,
                            //     fontSize: 18.0);
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
                  ],
                ),

                SharedWidgets.saleQuoteDetail(context, myQuoteDetail),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10, left: 18, right: 5.0),
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
                              //             OrderPromo(fromPage: 'Q',)
                              //     )
                              // );

                              // if(res != null) {
                              //
                              // }
                            },
                            icon: Icon(Icons.list, color: Colors.white),
                            label: Text(
                              'รายการโปรโมชั่น',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                          )
                      ),
                    ),

                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10, left: 5.0, right: 18.0),
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

                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ItemAddExpressPortrait(type: Activity.quotation,)
                                  )
                              );

                              // calculateSummary();
                            },
                            icon: Icon(Icons.local_fire_department,
                                color: Colors.white),
                            label: Text(
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
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // globals.editingProductCart = null;

                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ItemSelect(type: Activity.quotation))
                        );

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
                        // splashColor: Colors.green,
                        padding: EdgeInsets.all(10),
                      ),
                    )
                ),

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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // _showRemarkDialog(context);
                        },
                        icon: Icon(Icons.add_comment),
                        label: Text(
                          'ข้อความหมายเหตุ',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 10.0,
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: TextFormField(
                    maxLines: 6,
                    maxLength: 80,
                    controller: txtRemark,
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

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Expanded(
                //       flex: 1,
                //       child: TextFormField(
                //         readOnly: true,
                //         textAlign: TextAlign.right,
                //         maxLines: 8,
                //         decoration: InputDecoration(
                //           border: OutlineInputBorder(),
                //           contentPadding:
                //               EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                //           floatingLabelBehavior: FloatingLabelBehavior.always,
                //           labelText: "หมายเหตุ",
                //           //border: OutlineInputBorder()
                //         ),
                //       ),
                //     ),
                //     Spacer(),
                //     Expanded(
                //       flex: 1,
                //         child:
                //         Row(
                //             children: [
                //               Expanded(child: Row(
                //                 children: [
                //                   Text('ส่วนลดท้ายบิล'),
                //                   Expanded(flex:6,child: TextField())
                //                 ],
                //               )),
                //               Expanded(flex:8,child: Row(
                //                 children: [
                //                   Text('ส่วนลดท้ายบิล'),
                //                   Expanded(child: TextField())
                //                 ],
                //               )),
                //               // Expanded(child: TextField()),
                //               // Text('ส่วนลดท้ายบิล'),
                //               // Expanded(child: TextField()),
                //             ],
                //           ),
                //
                //         ),
                //   ],
                // ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('รวมส่วนลด',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: txtDiscountTotal,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior:
                            FloatingLabelBehavior.never,
                            //labelText: "0.00",
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
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 35.0, right: 8.0),
                        child: Text('รวมเงิน',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
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

                                    changeDiscountType(myQuote.discountType ?? 'PER');
                                  },
                                  child: SharedWidgets.discountType(myQuote.discountType ?? 'PER')),
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            onTap: () {
                              txtDiscountBill.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                  txtDiscountBill.value.text.length);
                            },
                            onEditingComplete: () async {
                              if(txtDiscountBill.text.isEmpty) {
                                return await QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.warning,
                                  title: 'กรอกตัวเลขได้ไม่เกิน 100',
                                  text: 'ส่วนลดเปอร์เซ็นกรอกได้ไม่เกินหนึ่งร้อย');
                              }

                              if (myQuote.discountType == 'PER' &&
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

                                await QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    title: 'กรอกตัวเลขได้ไม่เกิน 100',
                                    text: 'ส่วนลดเปอร์เซ็นกรอกได้ไม่เกินหนึ่งร้อย'
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

                                } else if (myQuote.discountType ==
                                    'PER') {
                                  myQuote.discount =
                                      double.tryParse(txtDiscountBill.text
                                          .replaceAll(',', ''));
                                } else {
                                  double disc = double.tryParse(txtDiscountBill.text.replaceAll(',', '')) ?? 0;

                                  myQuote.discount = disc;
                                  myQuote.discountAmount = disc;
                                }

                                setState(() {
                                  FocusScope.of(context).unfocus();
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
                            controller: txtPriceAfterDiscount,
                            textAlign: TextAlign.right,
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
                            controller: txtVatTotal,
                            textAlign: TextAlign.right,
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
                          controller: txtNetTotal,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            floatingLabelBehavior:
                            FloatingLabelBehavior.never,
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
                      visible: false,
                      child: Expanded(
                          child: Container(
                            height: 100,
                            padding: const EdgeInsets.only(top: 30.0),
                            child: ElevatedButton(
                              child: Text('แนบเอกสาร', style: TextStyle(fontSize: 20),),
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.orange.shade600)
                              ),
                              onPressed: () async {
                                // await Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             FileAttachManager(globals.attachQuot, "QUOTATION")
                                //     )
                                // );
                              },
                            ),
                          )
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.save_alt, size: 24,),
                          label: Text('บันทึกฉบับร่าง', style: TextStyle(fontSize: 16),),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 10.0)
                          ),
                          onPressed: () async {
                            // var isConfirm = await orderValidation();
                            //
                            // if(isConfirm == true) {
                            //   AwesomeDialog(
                            //     context: context,
                            //     dialogType: DialogType.INFO,
                            //     animType: AnimType.BOTTOMSLIDE,
                            //     width: 450,
                            //     title: 'Save Draft',
                            //     desc: 'Are you sure to save draft ?',
                            //     btnCancelOnPress: () {},
                            //     btnOkOnPress: () async {
                            //       // setState(() {});
                            //       // await postSaleOrder('D');
                            //       // Navigator.pop(context);
                            //       TaskEvent event =
                            //       await _apiService.saveQuotation(
                            //           'D',
                            //           showDate ? 'Y' : 'N',
                            //           myCustomer,
                            //           globals.selectedShiptoQuot,
                            //           globals.productCartQuot,
                            //           _docuDate,
                            //           validity,
                            //           _expireDate,
                            //           _shiptoDate,
                            //           txtRemark.text,
                            //           priceTotal,
                            //           globals.discountBillQuot,
                            //           priceAfterDiscount,
                            //           vatTotal,
                            //           netTotal,
                            //           globals.attachQuot);
                            //
                            //       if (event.isComplete) {
                            //         txtRemark.text = '';
                            //
                            //         Navigator.pop(context);
                            //
                            //         showDialog<void>(
                            //             context: context,
                            //             builder: (BuildContext context) {
                            //               return RichAlertDialog(
                            //                 //uses the custom alert dialog
                            //                 alertTitle: richTitle(
                            //                     event.title),
                            //                 alertSubtitle:
                            //                 richSubtitle(event.message),
                            //                 alertType: event.eventCode,
                            //               );
                            //             });
                            //
                            //         // Navigator.pop(context);
                            //         Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (context) => StatusQuotation()
                            //             )
                            //         );
                            //       } else {
                            //         Navigator.pop(context);
                            //         return showDialog<void>(
                            //             context: context,
                            //             builder: (BuildContext context) {
                            //               return RichAlertDialog(
                            //                 //uses the custom alert dialog
                            //                 alertTitle: richTitle(
                            //                     event.title),
                            //                 alertSubtitle:
                            //                 richSubtitle(event.message),
                            //                 alertType: event.eventCode,
                            //               );
                            //             });
                            //       }
                            //     },
                            //   )
                            //     ..show();
                            // }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 20,)

                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: () async {

                      // var isConfirm = await orderValidation();
                      //
                      // if(isConfirm == true) {
                      //   AwesomeDialog(
                      //     context: context,
                      //     dialogType: DialogType.INFO,
                      //     animType: AnimType.BOTTOMSLIDE,
                      //     width: 450,
                      //     title: 'Create Quotation ?',
                      //     desc: 'Are you sure to create quotation ?',
                      //     btnCancelOnPress: () {},
                      //     btnOkOnPress: () async {
                      //       if (this.txtDocuNo.text == '') {}
                      //       // setState(() {});
                      //       // await postSaleOrder('N');
                      //       // Navigator.pushReplacement(
                      //       //     context,
                      //       //     MaterialPageRoute(
                      //       //         builder: (context) =>
                      //       //             StatusTransferDoc()));
                      //       // postSaleOrder().then((value) => setState((){}));
                      //
                      //       TaskEvent event =
                      //       await _apiService.saveQuotation(
                      //           'Q',
                      //           showDate ? 'Y' : 'N',
                      //           myCustomer,
                      //           globals.selectedShiptoQuot,
                      //           globals.productCartQuot,
                      //           _docuDate,
                      //           validity,
                      //           _expireDate,
                      //           _shiptoDate,
                      //           txtRemark.text,
                      //           priceTotal,
                      //           globals.discountBillQuot,
                      //           priceAfterDiscount,
                      //           vatTotal,
                      //           netTotal,
                      //           globals.attachQuot);
                      //
                      //       if (event.isComplete) {
                      //         txtRemark.text = '';
                      //         Navigator.pop(context);
                      //         showDialog<void>(
                      //             context: context,
                      //             builder: (BuildContext context) {
                      //               return RichAlertDialog(
                      //                 //uses the custom alert dialog
                      //                 alertTitle: richTitle(
                      //                     event.title),
                      //                 alertSubtitle:
                      //                 richSubtitle(event.message),
                      //                 alertType: event.eventCode,
                      //               );
                      //             });
                      //
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     StatusQuotation()));
                      //       } else {
                      //         Navigator.pop(context);
                      //         return showDialog<void>(
                      //             context: context,
                      //             builder: (BuildContext context) {
                      //               return RichAlertDialog(
                      //                 //uses the custom alert dialog
                      //                 alertTitle: richTitle(
                      //                     event.title),
                      //                 alertSubtitle:
                      //                 richSubtitle(event.message),
                      //                 alertType: event.eventCode,
                      //               );
                      //             });
                      //       }
                      //     },
                      //   )
                      //     ..show();
                      // }
                      //print(jsonEncode(globals.productCartQuot));
                    },
                    icon: Icon(Icons.description_outlined, size: 28,),
                    label: Text(
                      'สร้างใบเสนอราคา',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.0)
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  String runningNo = '';
  String docuNo = '';
  String refNo = '';
  String custPONo = '';
  String creditState = '';
  int validity = 30;
  double vat = 0.07;
  double priceTotal = 0;
  double discountTotal = 0;
  double discountBill = 0;
  double priceAfterDiscount = 0;
  double vatTotal = 0.0;
  double netTotal = 0.0;
  bool showDate = true;
  Customer myCustomer = Customer();
  DateTime _docuDate = DateTime.now();
  DateTime _expireDate = DateTime.now().add(Duration(days: 30));
  DateTime _shiptoDate = DateTime.now().add(Duration(hours: 24));
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

  TextEditingController txtValidityPrice = TextEditingController();
  TextEditingController txtValidityExpire = TextEditingController();
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

  setCustomer(Customer myCustomer){
    ref.read(myCustomerProvider.notifier).edit(myCustomer);
    txtCustName.text = myCustomer.displayName ?? '';
  }
}
