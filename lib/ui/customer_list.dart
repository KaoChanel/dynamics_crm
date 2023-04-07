import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/sales_shipment.dart';
import 'package:dynamics_crm/providers/data_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/activity.dart';
import '../models/customer.dart';
import '../models/debounce.dart';
import '../widgets/shared_widget.dart';

class CustomerList extends ConsumerStatefulWidget {
  const CustomerList({Key? key, this.type}) : super(key: key);

  final Activity? type;

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends ConsumerState<CustomerList> {

  @override
  Widget build(BuildContext context) {
    final Customer? sellToCustomer = ref.watch(myCustomerProvider);
    selectedItem ??= sellToCustomer;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ลูกค้าของคุณ'),
      ),
      body: Row(
        children: [
          customerList(),
          Flexible(
            flex: 4,
            child: customerDetail(),
          ),
          Flexible(
            flex: 1,
            child: buttonSide(),
          ),
        ],
      ),
    );
  }

  Customer? selectedItem;
  List<Customer> allCustomer = MY_CUSTOMERS;
  TextEditingController txtKeyword = TextEditingController();
  TextEditingController txtCustName = TextEditingController();
  TextEditingController txtCustCode = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtContact = TextEditingController();
  TextEditingController txtTel = TextEditingController();
  TextEditingController txtRemark = TextEditingController();
  TextEditingController txtCustGroup = TextEditingController();
  TextEditingController txtCustType = TextEditingController();
  TextEditingController txtCustTaxId = TextEditingController();
  TextEditingController txtBranch = TextEditingController();
  TextEditingController txtCreditType = TextEditingController();
  TextEditingController txtCreditDays = TextEditingController();
  TextEditingController txtCreditAmnt = TextEditingController();
  TextEditingController txtCreditTemp = TextEditingController();
  TextEditingController txtCreditPaidAmnt = TextEditingController();
  TextEditingController txtCreditBalance = TextEditingController();
  TextEditingController txtCreditState = TextEditingController();
  TextEditingController txtInactive = TextEditingController();
  TextEditingController txtLatLng = TextEditingController();
  final ScrollController _scroll = ScrollController();

  final debouncer = Debouncer();

  _onChangeHandler(String keyword) {
    debouncer.call(() {
      setState(() {
        allCustomer = MY_CUSTOMERS
            .where((x) => x.displayName != null ? x.displayName!.toLowerCase().contains(keyword.toLowerCase()) : false
            || x.code!.toLowerCase().contains(keyword.toLowerCase())
            || (x.addressLine1 != null ? x.addressLine1!.contains(keyword) : false)
            || (x.addressLine2 != null ? x.addressLine2!.contains(keyword) : false)
            || (x.city != null ? x.city!.contains(keyword) : false)
            || (x.state != null ? x.state!.contains(keyword) : false)
            || (x.postalCode != null ? x.postalCode!.contains(keyword) : false)
            || (x.phoneNumber != null ? x.phoneNumber!.contains(keyword) : false)).toList();
      });
    });
  }

  Widget customerList() {
    // return (globals.customerLocationPage == 'create_checkin' || globals.customerLocationPage == 'edit_checkin')
    //     ? // ถ้า เพจ เป็นแบบสำหรับ CheckIn
    //   Expanded(
    //     flex: 2,
    //     child:
    //     (customerImagesCount == 0 )
    //         ?
    //     Column(
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Container(
    //               width: double.infinity,
    //               height: MediaQuery.of(context).size.height * 0.20,
    //               decoration: const BoxDecoration(
    //                 image: DecorationImage(
    //                   image: ExactAssetImage('assets/avatar_01.png'),
    //                   fit: BoxFit.fitHeight,
    //                 ),
    //               )),
    //           // Container(
    //           //   width: double.infinity,
    //           //   height: MediaQuery.of(context).size.height*0.20,
    //           //   child: Container(
    //           //
    //           //     //alignment: Alignment(0.0, 5.0),
    //           //     child: CircleAvatar(
    //           //       backgroundImage: AssetImage("assets/avatar_01.png"),
    //           //       radius: 0.0,
    //           //     ),
    //           //   ),
    //           // ),
    //         ),
    //       ],
    //       //     Padding(
    //       //       padding: const EdgeInsets.all(8.0),
    //       //       child: InkWell(
    //       //         child: Container(
    //       //           height: MediaQuery.of(context).size.height*0.25,
    //       //           //color: Colors.red,
    //       //           child: getThumbnail(e.path),//new Text(e.path),
    //       //         ),
    //       //         onTap: () {
    //       //           Navigator.push(context, MaterialPageRoute(builder: (context) => AttachView(path: e.path, fromPage: '',)));
    //       //         },
    //       //       ),
    //     )
    //         :
    //     Column(
    //       children: fileImages.map((e) =>
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: InkWell(
    //               child: Container(
    //                 height: MediaQuery.of(context).size.height*0.25,
    //                 //color: Colors.red,
    //                 child: getThumbnail(e.path),//new Text(e.path),
    //               ),
    //               onTap: () {
    //                 Navigator.push(context, MaterialPageRoute(builder: (context) => AttachView(path: e.path, fromPage: '',)));
    //               },
    //             ),
    //           )
    //       ).toList(),
    //     ),
    //   )
    //     :
      return Expanded(
        flex: 2,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 30,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
          child: Column(children: <Widget>[
            TextFormField(
              controller: txtKeyword,
              decoration: const InputDecoration(
                hintStyle: TextStyle(fontStyle: FontStyle.italic),
                hintText: 'ชื่อลูกค้า, รหัสลูกค้า, ที่อยู่, เบอร์ติดต่อ',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0)
              ),
              onChanged: _onChangeHandler,
            ),
            Container(
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 0.0),
              padding: const EdgeInsets.all(20.0),
              child: Center(
                  child: Text(
                    'ลูกค้าทั้งหมด ${allCustomer.isNotEmpty ? allCustomer.length.toString() : '0'} ราย',
                    style: const TextStyle(fontSize: 18.0, color: Colors.white),)),
            ),
            Expanded(
              flex: 6,
              child: ListTileTheme(
                selectedTileColor: Color.fromRGBO(50, 54, 130, 1.0),
                selectedColor: Color.fromRGBO(50, 54, 130, 1.0),
                style: ListTileStyle.list,
                child: Scrollbar(
                  controller: _scroll,
                  isAlwaysShown: false,
                  thickness: 3.0,
                  radius: Radius.circular(20.0),
                  child: ListView(
                    controller: _scroll,
                    // children: widget.allCustomer?.map((item) {
                    children: allCustomer.map((item) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                BorderSide(width: 0.5, color: Colors.black26)
                            )
                        ),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              item.blocked != null ? Text('') : const Icon(Icons.fiber_new, color: Colors.orange,),
                              Text(item?.displayName ?? ''),
                            ],
                          ),
                          subtitle: Text(item?.code ?? ''),
                          onTap: () {
                            setState(() {
                              selectedItem = item;
                            });
                          },
                          selected: selectedItem != null ? selectedItem!.code == item?.code : false,
                          hoverColor: Colors.grey.shade200,
                          selectedTileColor: Colors.grey[200],
                          trailing: selectedItem?.code == item?.code ? const Icon(Icons.arrow_forward_ios_rounded) : Text(""),
                        ),
                      );
                    })?.toList() ?? [],
                  ),
                ),
              )
            ),
          ]),
        ),
      );
  }

  buttonSide() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child:
      Column(children: [
        SizedBox(
          height: 15,
        ),
        SizedBox(
          width: 130,
          height: 45,
          child: ElevatedButton.icon(
              onPressed: () async {
                if(selectedItem == null) {
                  return showDialog(
                      builder: (context) => AlertDialog(
                        title: const Text('แจ้งเตือน'),
                        content: const Text('กรุณาเลือกลูกค้า'),
                        actions: [
                          ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('ตกลง')
                          )
                        ],
                      ), context: context);
                }
                // if(_selectedItem.inactive == 'I' || _selectedItem.inactive == 'H'){
                //   return showDialog(
                //       builder: (context) => AlertDialog(
                //         title: _selectedItem.inactive == 'I' ? Text('ลูกค้ารายนี้อยู่ในสถานะ In-Active') : Text('ลูกค้ารายนี้อยู่ในสถานะ On-Hold'),
                //         content: Text('โปรดแจ้งแผนกธุรการเพื่อดำเนินการต่อไป'),
                //         actions: [
                //           ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text('ตกลง'))
                //         ],
                //       ), context: context);
                // }
                else {
                  if(widget.type != Activity.quotation && widget.type != Activity.quotationDraft && widget.type != Activity.quotationCopy) {
                    if(SYSTEM_OPTION.isLockCust == 'Y') {
                      switch(selectedItem?.blocked) {
                        case 'I':
                          return SharedWidgets.showAlert(context, 'In-Active Customer', 'ลูกค้ารายนี้อยู่ในสถานะที่ไม่พร้อมทำการซื้อขาย');
                        case 'H':
                          return SharedWidgets.showAlert(context, 'Holding Customer', 'ลูกค้ารายนี้อยู่ในสถานะที่ไม่พร้อมทำการซื้อขาย');
                      }
                    }

                    if(SYSTEM_OPTION.isCheckCredit == 'Y') {
                      double limitCreditAmount = selectedItem?.creditBalance ?? 0;

                      if(limitCreditAmount < 1) {
                        return SharedWidgets.showAlert(context, 'เครดิตไม่เพียงพอ', 'วงเงินเครดิตของลูกค้า คงเหลือ ${NUMBER_FORMAT.format(limitCreditAmount)} บาท');
                      }
                    }

                    var _shipto = CUSTOMER_SHIPMENTS.firstWhere(
                            (element) => element.systemId == selectedItem?.id && element.defaultcode == true,
                        orElse: () => SalesShipment());

                    if (_shipto == null) {
                      return showDialog(
                          builder: (context) =>
                              AlertDialog(
                                title: const Text('ไม่มีข้อมูล Ship to'),
                                content: const Text('ลูกค้ารายนี้ยังไม่มีข้อมูลการจัดส่งในระบบ WinSpeed'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('ตกลง'))
                                ],
                              ), context: context);
                    }
                    else {
                      // globals.clearOrder();
                      // globals.customer = _selectedItem;
                      // globals.selectedShipto = _shipto;
                      // globals.selectedShiptoQuot = _shipto;
                      // print('Transport ID: ${globals.selectedShipto.transpId}');

                      ref.read(myCustomerProvider.notifier).edit(selectedItem!);

                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('customer', selectedItem?.id ?? '');

                      Navigator.pop(context, selectedItem);
                    }
                  }
                  else{
                    Navigator.pop(context, selectedItem);
                  }
                }
                // print(globals.selectedShipto?.shiptoAddr1 ?? '');
              },
              icon: const Icon(Icons.check_outlined),
              label: const Text(
                'เลือก',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12), primary: Colors.green)
          ),
        ),

        SizedBox(
          height: 21,
        ),
        SizedBox(
          width: 130, // <-- match_parent
          height: 45,
          child: ElevatedButton.icon(
              onPressed: selectedItem == null || selectedItem?.latitude == null ? null : () async {
                setState(() {
                  SharedWidgets.launchInBrowser('https://www.google.com/maps/search/?api=1&query=${selectedItem?.latitude},${selectedItem?.longitude}');
                });
              },
              icon: const Icon(Icons.map),
              label: const Text('แผนที่', style: TextStyle(fontSize: 16,),textAlign:TextAlign.right, ),
              // style: ElevatedButton.styleFrom(
              //     padding: EdgeInsets.all(12),
              //     primary: globals.objCustomersLocation == null ? Colors.grey : Colors.blueAccent)
          ),
        ),

        // SizedBox(
        //   height: 21,
        // ),
        // SizedBox(
        //   width: 130,
        //   height: 45,
        //   child: ElevatedButton.icon(
        //     icon: Icon(Icons.image_outlined),
        //     label: Text('ดูรูปภาพ', style: TextStyle(fontSize: 16,),textAlign:TextAlign.right, ),
        //     style: ElevatedButton.styleFrom(
        //         padding: EdgeInsets.all(12), //primary: Colors.deepOrangeAccent
        //         primary: customerImagesCount == 0 ? Colors.grey : Colors.deepOrangeAccent
        //     ),
        //     onPressed: (){
        //       if(customerImagesCount != 0){
        //         _showDialog_CustomerImage(context);
        //       }
        //       // FocusScope.of(context).unfocus();
        //       // Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerGallery(customerId: _selectedItem.custId,)));
        //     },
        //   ),
        // ),
        //
        SizedBox(
          height: 21,
        ),
        SizedBox(
          width: 130,
          height: 45,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.calendar_month),
            label: const Text('นัดหมาย', style: TextStyle(fontSize: 16,), textAlign:TextAlign.center),
            // style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.all(0), //primary: Colors.deepOrangeAccent
            //     primary: (globals.customer?.custId != null || selectedItem != null) ? Colors.blue : Colors.grey //customerImagesCount == 0 ? Colors.grey : Colors.deepOrangeAccent
            // ),
            onPressed: selectedItem == null ? null : () async {
              // if(globals.customer?.custId != null || selectedItem != null){ // ถ้าเลือกลูกค้าไว้แล้ว
              //   _showDialog_Appointment(context);
              // }
            },
          ),
        ),

      ]),
    );
  }

  customerDetail(){
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('รหัสลูกค้า',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16)
                    )
                ),
                Flexible(
                  flex: 4,
                  child: ListTile(
                    //
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCustCode,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "รหัสลูกค้า",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('ชื่อลูกค้า',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16)
                    )
                ),
                Flexible(
                    flex: 5,
                    child: ListTile(
                      title: TextFormField(
                        //initialValue: txtCustName,
                        readOnly: true,
                        controller: txtCustName,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          // floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "ชื่อลูกค้า",
                        ),
                      ),
                    )
                ),

                // Flexible(
                //   flex: 2,
                //     child: ElevatedButton.icon(
                //         onPressed: () {
                //           setState(() {
                //             globals.customer = widget.customer;
                //           });
                //
                //           Navigator.pop(context);
                //         },
                //         icon: Icon(Icons.check_circle_sharp),
                //         label: Text(
                //           'เลือกลูกค้า',
                //           style: TextStyle(fontSize: 18),
                //         ),
                //         style:
                //         ElevatedButton.styleFrom(padding: EdgeInsets.all(12), primary: Colors.green)
                //     ),
                // ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('ที่อยู่',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16)
                    )
                ),
                Flexible(
                  child: ListTile(
                    //
                    title: TextFormField(
                      readOnly: true,
                      controller: txtAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        //floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "ที่อยู่",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('ผู้ติดต่อ',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16)
                    )
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      initialValue: '',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "ผู้ติดต่อ",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtTel,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "โทรศัพท์",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('กลุ่มลูกค้า',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16)
                    )
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    //
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCustGroup,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "กลุ่มลูกค้า",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('สถานะลูกค้า',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16)
                    )
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    //
                    title: TextFormField(
                      readOnly: true,
                      controller: txtInactive,
                      // controller: txtCustType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "สถานะลูกค้า",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('เลขประจำตัวผู้เสียภาษี',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16)
                    )
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    //
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCustTaxId,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "เลขประจำตัวผู้เสียภาษี",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtBranch,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "สาขา",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('วงเงินทั้งหมด',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16)
                    )
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCreditAmnt,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "วงเงินทั้งหมด",
                      ),
                    ),
                  ),
                ),

                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCreditPaidAmnt,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "วงเงินที่ใช้ไป",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('วงเงินคงเหลือ',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16)
                    )
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCreditBalance,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "วงเงินคงเหลือ",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCreditState,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "สถานะ",
                      ),
                    ),
                  ),
                ),

              ],
            ),

            // ประเภทเครดิต
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('ประเภทเครดิต',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16))
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCreditType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "ประเภทเครดิต",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtCreditDays,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "เครดิต / วัน",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // DSO ชำระเงินครั้งล่าสุด
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('ชำระเงินครั้งล่าสุด',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16)
                    )
                ),
                // Flexible(
                //   flex: 6,
                //   child: ListTile(
                //     title: TextFormField(
                //       readOnly: true,
                //       initialValue: '',
                //       decoration: const InputDecoration(
                //         border: OutlineInputBorder(),
                //         contentPadding:
                //         EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                //         labelText: "DSO",
                //       ),
                //     ),
                //   ),
                // ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      initialValue: '',
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "ชำระเงินครั้งล่าสุด",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ตำแหน่งพิกัด
            //SizedBox(height: 20,),
            selectedItem?.latitude == null ? SizedBox(height: 0,)
                : Padding(
              padding: const EdgeInsets.only(left: 0.0,top: 20.0,right: 0.0,bottom: 0.0),
              child: Row(
                children: [
                  SizedBox(
                      width: 100,
                      child: Text('ตำแหน่งพิกัด',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 16)
                      )
                  ),
                  Flexible(
                    flex: 6,
                    child: ListTile(
                      title: TextFormField(
                        readOnly: true,
                        controller: txtLatLng,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          //labelText: "ตำแหน่งพิกัด",
                          hintText: '${selectedItem?.latitude},${selectedItem?.longitude}',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // หมายเหตุ
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Text('หมายเหตุ',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16))
                ),
                Flexible(
                  flex: 6,
                  child: ListTile(
                    title: TextFormField(
                      readOnly: true,
                      controller: txtRemark,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        labelText: "หมายเหตุ",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //นัดวันเข้าเยี่ยม (สัปดาห์)
            const Divider(
              height: 10,
              thickness: 3, //ความหนา
              indent: 20,
              endIndent: 20,
            ),
          ],
        )
      ],
    );
  }
}
