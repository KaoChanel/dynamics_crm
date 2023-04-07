import 'package:dynamics_crm/models/sales_order_line.dart';
import 'package:dynamics_crm/models/sales_quote_line.dart';
import 'package:dynamics_crm/ui/portrait/sales_order_copy_portrait.dart';
import 'package:dynamics_crm/ui/portrait/sales_quote_copy_portrait.dart';
import 'package:dynamics_crm/ui/portrait/sales_quote_draft_portrait.dart';
import 'package:dynamics_crm/ui/portrait/sales_quote_view_portrait.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/global_constants.dart';
import '../../models/customer.dart';
import '../../models/dropdown.dart';
import '../../models/sales_quote.dart';
import 'package:dynamics_crm/services/api_service.dart';

class SalesQuotePortrait extends ConsumerStatefulWidget {
  const SalesQuotePortrait({Key? key}) : super(key: key);

  @override
  _SalesQuotePortraitState createState() => _SalesQuotePortraitState();
}

class _SalesQuotePortraitState extends ConsumerState<SalesQuotePortrait> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ใบเสนอราคา"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 5.0, right: 8.0,),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'สถานะ',
                          labelStyle: Theme.of(context)
                              .primaryTextTheme
                              .caption
                              ?.copyWith(color: Colors.black, fontSize: 15),
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(15.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            isDense: true,
                            autofocus: true,
                            // Reduces the dropdowns height by +/- 50%
                            icon: Icon(Icons.keyboard_arrow_down),
                            value: _selectedStatus,
                            items: _status.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item.title),
                              );
                            }).toList(),
                            onChanged: (selectedItem) => setState (() {
                              _selectedStatus = _status.firstWhere((element) => element == selectedItem);
                              // String docStatusValue = _selectedStatus == 'รอดำเนินการ' ? 'N' : _selectedStatus == 'ฉบับร่าง' ? 'D' : _selectedStatus == 'เข้าระบบแล้ว' ? 'Y' : 'A';
                              // globals.tempSOHD.where((element) => element.isTransfer == _selectedStatus.value);
                              FocusScope.of(context).requestFocus(FocusNode());
                              print('onChange => is Transfer: ' + _selectedStatus.value + ' => ' + _selectedStatus.title);
                            }
                            ),
                          ),
                        ),
                      ),
                    )),
                Expanded(
                    child:
                    Container(
                      padding: EdgeInsets.only(top: 5.0),
                      child: TextFormField(
                        controller: txtKeyword,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'ค้นหา',
                          labelStyle: Theme.of(context)
                              .primaryTextTheme
                              .caption
                              ?.copyWith(color: Colors.black, fontSize: 15),
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(15.0),
                        ),
                        onEditingComplete: () {
                          setState(() {
                            // globals.docKeyword = txtKeyword.text;
                            // globals.tempSOHD.where((element) => element.custName.contains(txtKeyword.text));
                          });
                        },
                      ),
                    )),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 11),
                padding: EdgeInsets.all(10),
                width: 350,
                child: docCounter(),
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
          Row(
            children: [
              FutureBuilder(
                  future: ApiService().getMyQuotes(EMPLOYEE?.code ?? ''),
                  builder:
                      (BuildContext context, AsyncSnapshot snapShot) {
                    if (snapShot.hasData) {
                      List<SalesQuote> data = snapShot.data;

                      // streamController.add(data.where((x) =>
                      // _selectedStatus.value != 'A'
                      //     ? x.bisStatus == _selectedStatus.value && x.customerName!.contains(txtKeyword.text)
                      //     : x.customerName!.contains(txtKeyword.text)).length);

                      print('snapShot ==>> ${snapShot.data}');
                      return Expanded(
                          child: myQuotation(data
                              .where((x) =>
                          x.customerName!.contains(txtKeyword.text) &&
                              _selectedStatus.value != 'A'
                              ? x.bisStatus == _selectedStatus.value && x.customerName!.contains(txtKeyword.text)
                              : x.customerName!.contains(txtKeyword.text))
                              .toList()));
                    } else {
                      // return Expanded(child: Center(child: CircularProgressIndicator()));
                      return Expanded(
                        //child: dataBody(List<SaleOrderHeader>()),
                        child: Container(
                            padding: const EdgeInsets.all(20.0),
                            child: const Center(child: CircularProgressIndicator())),
                      );
                    }
                  })
            ],
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {});
        },
      ),
    );
  }

  bool sort = true;
  int docCount = 0;
  List<SalesQuote> quotationHeader = [];
  late SalesQuote selectedItem;
  List<SalesQuote> selectedQuotHeader = <SalesQuote>[];
  List<Customer> allCustomers = <Customer>[];
  late Dropdown _selectedType;
  late Dropdown _selectedStatus;
  String _selectedSort = 'สถานะเอกสาร (Z-A)';
  TextEditingController txtKeyword = TextEditingController();
  // StreamController<int> streamController = new StreamController<int>();

  final _status = <Dropdown>[
    Dropdown(
      value: 'A',
      title: 'ทั้งหมด',
    ),
    Dropdown(
      value: 'D',
      title: 'ฉบับร่าง',
    ),
    Dropdown(
      value: 'Q',
      title: 'ใบเสนอราคา',
    ),
  ];

  Widget docCounter() {
    return Text(
      'รายการเอกสาร (0 เอกสาร)',
      style: TextStyle(color: Colors.white, fontSize: 20),
    );
  }

  Widget myQuotation(List<SalesQuote> dataList) {
    return ListView(
      primary: false,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: dataList.asMap().map((i, element) {

        String customerCode = allCustomers.firstWhere((e) => e.id == element.customerId, orElse: () => Customer()).code ?? '';
        String status = element.bisStatus == null ? ''
            : element.bisStatus == 'N' ? 'รอดำเนินการ'
            : element.bisStatus == 'D' ? 'ฉบับร่าง'
            : element.bisStatus == 'S' ? 'สั่งขายแล้ว'
            : element.bisStatus == 'C' ? 'ยกเลิกเอกสาร'
            : 'ใบเสนอราคา';

        String docuDate = element.documentDate == null ? '' : DATE_FORMAT.format(element.documentDate!);
        String shipDate = element.sentDate == null ? '' : DATE_FORMAT.format(element.sentDate!);
        Color? statusColor = element.bisStatus == 'N' ? Colors.orange[600]
            : element.bisStatus == 'D' ? Colors.blue
            : element.bisStatus == 'C' ? Colors.red
            : Colors.green;

        return MapEntry(i,
            Container(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 5,
                        child: Text('${i+1}. ${element.customerName} ($customerCode)', style: const TextStyle(fontSize: 14.0),)),
                    Expanded(
                        flex: 2,
                        child: Text('$docuDate', style: TextStyle(fontSize: 12.0), textAlign: TextAlign.right)
                    )
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Badge(
                              // showBadge: true,
                              // shape: BadgeShape.square,
                              // borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              backgroundColor: Colors.grey[300],
                              label: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: RichText(
                                    text: TextSpan(
                                        children: [
                                          WidgetSpan(child: Icon(Icons.account_balance_wallet_outlined, size: 15.0, color: Colors.black54)),
                                          TextSpan(text: ' ${CURRENCY.format(element.netAmount)}', style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold, color: Colors.black54)),
                                        ]
                                    )
                                ),
                              )  //Text('${element.lastDocNo}', style: TextStyle(fontSize: 12.0),),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Text('$status', style: TextStyle(fontSize: 14.0, color: statusColor), textAlign: TextAlign.right)
                        )
                      ],
                    ),
                  ],
                ),
                onTap: () async {
                  selectedItem = element;
                  if(MY_CUSTOMERS.any((e) => e.id == selectedItem.id)){
                    if(selectedItem.status == 'S'){
                      var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalesQuoteViewPortrait(header: selectedItem))
                      );

                      if(res != null){
                        setState(() {});
                      }
                    }
                    else if(selectedItem.bisStatus == 'D'){
                      // globals.isDraftInitial = false;
                      // globals.productCartQuotDraft = <ProductCart>[];

                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalesQuoteDraftPortrait(
                                header: selectedItem,
                              )
                          )
                      );
                    }
                    else{
                      openMenu();
                    }
                  }
                  else{
                    if(selectedItem.bisStatus == 'D'){
                      // globals.isDraftInitial = false;
                      // globals.productCartQuotDraft = <ProductCart>[];

                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalesQuoteDraftPortrait(header: selectedItem,
                              )
                          )
                      );

                    }
                    else{
                      var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalesQuoteViewPortrait(header: selectedItem))
                      );

                      if(res != null){
                        setState(() {});
                      }
                    }
                  }
                },
                selected: selectedItem == element ? true : false,
              ),
            ));}).values?.toList() ?? [],
    );
  }

  void openMenu () {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('ดูใบเสนอราคา'),
                onTap: () async {
                  Navigator.pop(context);
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SalesQuoteViewPortrait(header: selectedItem))
                  );

                  if(res != null){
                    setState(() {});
                  }
                },
              ),

              ListTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: const Text('สร้างคำสั่งขาย'),
                onTap: () async {
                  // List<SalesQuoteLine> detail = await ApiService().getQuotationDetail(selectedItem.quotid);
                  List<SalesOrderLine> soDetails = <SalesOrderLine>[];

                  Navigator.pop(context);
                  Navigator.pop(context);
                  // await Navigator.push(context, MaterialPageRoute(builder: (context) => SalesOrderCopyPortrait(header: soHeader, detail: soDetails)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.replay),
                title: const Text('สร้างรายการเดิม'),
                onTap: () async {
                  // globals.isCopyInitial = false;
                  // globals.discountBillCopy = Discount(
                  //     number: 0, amount: 0, type: 'THB');

                  // List<SalesQuoteLine> details = await ApiService().getQuotationDetail(selectedItem.quotid);
                  List<SalesQuoteLine> details = [];

                  Navigator.pop(context);
                  Navigator.pop(context);

                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SalesQuoteCopyPortrait(header: selectedItem, detail: details))
                  );
                },
              ),
            ],
          );
        });
  }
}
