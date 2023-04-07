import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/providers/data_provider.dart';
import 'package:dynamics_crm/ui/portrait/sales_order_portrait.dart';
import 'package:dynamics_crm/ui/sales_order_draft.dart';
import 'package:dynamics_crm/ui/sales_order_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/customer.dart';
import '../models/dropdown.dart';
import '../models/sales_order.dart';
import '../services/api_service.dart';

class SalesOrderList extends ConsumerStatefulWidget {
  const SalesOrderList({Key? key}) : super(key: key);

  @override
  _SalesOrderListState createState() => _SalesOrderListState();
}

class _SalesOrderListState extends ConsumerState<SalesOrderList> {
  @override
  Widget build(BuildContext context) {
    final List<SalesOrder> myOrders = ref.watch(mySalesOrder);
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return isPortrait ? const SalesOrderPortrait() : Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("คำสั่งขายของคุณ"),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'สถานะเอกสาร',
                              labelStyle: Theme.of(context).primaryTextTheme.caption?.copyWith(color: Colors.black, fontSize: 16),
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
                          ),)
                    ),
                    Expanded(
                        child:
                        TextFormField(
                          controller: txtKeyword,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: 'ค้นหา',
                            labelStyle: Theme.of(context)
                                .primaryTextTheme
                                .caption
                                ?.copyWith(color: Colors.black, fontSize: 16),
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.all(15.0),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: (){
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                          onEditingComplete: () {
                            // globals.docKeyword = txtKeyword.text;
                            FocusScope.of(context).unfocus();
                            // if(!mounted) return;
                            // setState(() {
                            //   globals.docKeyword = txtKeyword.text;
                            //   // globals.tempSOHD.where((element) => element.custName.contains(txtKeyword.text));
                            // });
                          },
                        )
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 11),
                    padding: EdgeInsets.all(10),
                    width: 350,
                    child: Text('${myOrders.length}'),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(0)
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              FutureBuilder(
                  future: ApiService().getMyOrders(EMPLOYEE?.code ?? ''),
                  builder:
                      (BuildContext context, AsyncSnapshot snapShot) {
                    if (snapShot.hasData) {
                      tempSOHD = snapShot.data;
                      // txtKeyword.text = globals.docKeyword;

                      // var filtered = tempSOHD
                      //     .where((x) => x.customerName!.contains(txtKeyword.text) && _selectedStatus.value != 'A'
                      //     ? x. == _selectedStatus.value && x.customerName!.contains(txtKeyword.text)
                      //     || x.refNo.toLowerCase().contains(txtKeyword.text.toLowerCase())
                      //     : x.customerName!.contains(txtKeyword.text)
                      //     || x.refNo.toLowerCase().contains(txtKeyword.text.toLowerCase())
                      // );

                      var filtered = tempSOHD;

                      // streamController.add(filtered.length);
                      // return Expanded(
                      //     child: dataBody(filtered.take(globals.options.loadDocItem).toList()));

                      return ordersList(filtered.take(SYSTEM_OPTION.loadDocItem).toList());
                    } else {
                      // return Expanded(child: Center(child: CircularProgressIndicator()));
                      // txtKeyword.text = globals.docKeyword;

                      // var filtered = tempSOHD
                      //     .where((x) => x.customerName!.toLowerCase().contains(txtKeyword.text.toLowerCase())
                      //     && _selectedStatus.value != 'A'
                      //     ? x.bis == _selectedStatus.value && x.customerName!.toLowerCase().contains(txtKeyword.text.toLowerCase())
                      //     || x.doc .toLowerCase().contains(txtKeyword.text.toLowerCase())
                      //     : x.customerName!.contains(txtKeyword.text)
                      //     || x.refNo.toLowerCase().contains(txtKeyword.text.toLowerCase())
                      // ).toList();

                      // streamController.add(filtered.length);
                      // return filtered != null ? Expanded(
                      //     child: dataBody(filtered.take(globals.options.loadDocItem).toList()))
                      // : Expanded(
                      //   child: Container(
                      //       padding: EdgeInsets.all(20.0),
                      //       child: Center(child: CircularProgressIndicator())),
                      // );
                      return Container(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: CircularProgressIndicator()));
                    }
                  }),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          setState(() {});
        },
      ),
    );
  }

  bool sort = true;
  List<SalesOrder> tempSOHD = [];
  late SalesOrder selectedItem;
  List<SalesOrder> selectedTempSOHD = [];
  late Dropdown _selectedStatus;
  int docCount = 0;
  int maxItemList = 25;
  int incrementItem = 20;
  TextEditingController txtKeyword = TextEditingController();
  // StreamController<int> streamController = StreamController<int>.broadcast();
  ScrollController scrollController = ScrollController();

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
      value: 'N',
      title: 'รอดำเนินการ',
    ),
    Dropdown(
      value: 'Y',
      title: 'เข้าระบบแล้ว',
    ),
  ];

  Widget ordersList(List<SalesOrder> dataSet) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        itemCount: dataSet == null ? 1 : dataSet.length + 1,
        itemBuilder: (context, index) {
          if(index == 0) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(child: Text('ลำดับ', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),), width: 50,),
                  Container(child: Text('สถานะ', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)), width: 100,),
                  Container(child: Text('วันที่เอกสาร', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)), padding: EdgeInsets.symmetric(horizontal: 15.0)),
                  Container(child: Text('วันที่สั่ง', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)), padding: EdgeInsets.symmetric(horizontal: 15.0)),
                  Container(child: Text('วันที่จัดส่ง', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)), padding: EdgeInsets.symmetric(horizontal: 20.0)),
                  Container(child: Text('เลขที่อ้างอิง', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)), padding: EdgeInsets.symmetric(horizontal: 80.0)),
                  Container(child: Text('เอกสารล่าสุด', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold)), width: 130,),
                  Container(child: Text('รหัสลูกค้า', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold)), width: 100,),
                  Expanded(child: Text('ชื่อลูกค้า', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            );
          }
          else{
            index -= 1;
            return GestureDetector(
              onTap: () async {
                if (dataSet[index].bisStatus != 'Draft') {

                  if(dataSet[index].no != null) {
                    await openDialog(dataSet[index]);
                  }
                  else {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalesOrderView(header: dataSet[index])
                        )
                    );
                  }

                  // var res = await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => SaleOrderView(header: dataSet[index])));
                  //
                  // if(res != null){
                  //   setState(() {});
                  // }
                } else {
                  // globals.isDraftInitial = false;
                  // globals.productCartDraft = <ProductCart>[];
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SalesOrderDraft(
                            header: dataSet[index],
                          )
                      )
                  );

                  if(res != null){
                    setState(() {});
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[350]!, width: 1.0))),
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Container(child: Text('${index + 1}', textAlign: TextAlign.center), width: 50,),
                    Container(
                      child: Text('${dataSet[index].bisStatus == 'Y' ? 'เข้าระบบแล้ว'
                          : dataSet[index].bisStatus == 'N' ? 'รอดำเนินการ'
                          : dataSet[index].bisStatus == 'D' ? 'ฉบับร่าง'
                          : 'ยกเลิก'}',

                          style: TextStyle(color: dataSet[index].bisStatus == 'N' ? Colors.orange[600]
                              : dataSet[index].bisStatus == 'D' ? Colors.blue
                              : dataSet[index].bisStatus == 'C' ? Colors.red
                              : Colors.green),
                          textAlign: TextAlign.center),
                      width: 100,
                    ),
                    Container(child: Text('${dataSet[index].documentDate != null ? DATE_FORMAT.format(dataSet[index].documentDate!) : ''}'), padding: EdgeInsets.symmetric(horizontal: 15.0)),
                    Container(child: Text('${dataSet[index].createDateTime != null ? DATE_FORMAT.format(dataSet[index].createDateTime!) : ''}'), padding: EdgeInsets.symmetric(horizontal: 25.0)),
                    Container(child: Text('${dataSet[index].shipmentDate != null ? DATE_FORMAT.format(dataSet[index].shipmentDate!) : ''}'), padding: EdgeInsets.symmetric(horizontal: 15.0)),
                    // Container(child: Text('${dataSet[index].refNo}'), padding: EdgeInsets.symmetric(horizontal: 20.0)),
                    // Container(child: Text('${dataSet[index].lastDocNo ?? ''}'), width: 150),
                    Container(child: Text('${MY_CUSTOMERS.firstWhere((e) => e.code == dataSet[index].sellToCustomerNo, orElse: () => Customer()).code ?? ''}'), width: 100,),
                    // Expanded(child: Text('${dataSet[index].custName}'))
                  ],
                ),
              ),
            );
          }
        }
    );
  }

  openDialog(SalesOrder header) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            content: Container(
              padding: EdgeInsets.all(20.0),
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      decoration: BoxDecoration(
                          border: Border(right: BorderSide(color: Colors.grey))
                      ),
                      child: InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: Icon(Icons.description_outlined, size: 100, color: Colors.black45),
                            ),
                            Text('รายการสั่งขาย', style: TextStyle(fontSize: 30),),
                          ],
                        ),
                        onTap: () async {
                          Navigator.pop(context);

                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SalesOrderView(header: header)
                              )
                          );

                          if(res != null) {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Icon(Icons.fact_check_outlined, size: 100, color: Colors.black45),
                          ),
                          Text('ความคืบหน้า', style: TextStyle(fontSize: 30),),
                        ],
                      ),
                      onTap: () async {
                        // var customerInvoices = await ApiService().getReport_vGetSalesDocStatus(header.custId.toString());
                        // DocumentStatus document = globals.allDocumentStatusByCustomers.firstWhere((x) => x.soRefno == header.refNo, orElse: () => DocumentStatus());
                        //
                        // if(document.custId == null){
                        //   document = DocumentStatus()
                        //     ..custId = header.custId
                        //     ..custCode = globals.allCustomer.firstWhere((e) => e.custId == header.custId).custCode
                        //     ..custName = header.custName
                        //     ..soid = header.soid;
                        // }
                        //
                        // Navigator.pop(context);
                        // var res = await Navigator.push(context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ReportStatusSub(document: document)
                        //     )
                        // );
                        //
                        // if(res != null) {
                        //   setState(() {});
                        // }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
