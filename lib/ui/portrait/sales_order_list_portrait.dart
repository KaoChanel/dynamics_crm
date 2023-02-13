import 'dart:async';

import 'package:badges/badges.dart';
import 'package:dynamics_crm/providers/data_provider.dart';
import 'package:dynamics_crm/ui/portrait/sales_order_draft_portrait.dart';
import 'package:dynamics_crm/ui/portrait/sales_order_view_portrait.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../config/global_constants.dart';
import '../../models/customer.dart';
import '../../models/dropdown.dart';
import '../../models/sales_order.dart';
import '../../services/api_service.dart';

class SalesOrderListPortrait extends ConsumerStatefulWidget {
  const SalesOrderListPortrait({Key? key}) : super(key: key);

  @override
  ConsumerState<SalesOrderListPortrait> createState() => _SalesOrderListPortraitState();
}

class _SalesOrderListPortraitState extends ConsumerState<SalesOrderListPortrait> {
  bool sort = true;
  bool isSearch = false;
  List<SalesOrder> tempSOHD = [];
  SalesOrder selectedItem = SalesOrder();
  List<SalesOrder> selectedTempSOHD = [];
  Dropdown _selectedStatus = ORDER_STATUS.first;
  // Dropdown _selectedType = Dropdown(value: '', title: '');
  // String _selectedSort = 'สถานะเอกสาร (Z-A)';
  int docCount = 0;
  late String keyword = ref.watch(keywordOfSalesOrder);
  TextEditingController txtKeyword = TextEditingController();
  StreamController<int> streamController = StreamController<int>();

  int _currentMax = 50;
  List<SalesOrder> orderList = SALES_ORDER;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        keyword = ref.watch(keywordOfSalesOrder);
        txtKeyword.text = keyword;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    keyword = ref.watch(keywordOfSalesOrder);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: isSearch ? _searchTextField() : const Text("ใบสั่งขายของคุณ"),
          actions: !isSearch
              ? [
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    isSearch = true;
                  });
                })
          ]
              : [
            IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    isSearch = false;
                  });
                }
            )
          ]
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'สถานะเอกสาร',
                          labelStyle: Theme.of(context)
                              .primaryTextTheme
                              .caption
                              ?.copyWith(color: Colors.grey, fontSize: 16),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            isDense: true,
                            autofocus: true,
                            // Reduces the dropdowns height by +/- 50%
                            icon: const Icon(Icons.keyboard_arrow_down),
                            value: _selectedStatus,
                            items: ORDER_STATUS.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item.title),
                              );
                            }).toList(),
                            onChanged: (selectedItem) =>
                                setState (() {
                                  _selectedStatus = ORDER_STATUS.firstWhere((e) => e == selectedItem);
                                  // String docStatusValue = _selectedStatus == 'รอดำเนินการ' ? 'N' : _selectedStatus == 'ฉบับร่าง' ? 'D' : _selectedStatus == 'เข้าระบบแล้ว' ? 'Y' : 'A';
                                  // globals.tempSOHD.where((element) => element.isTransfer == _selectedStatus.value);

                                  if(_selectedStatus.value != 'ALL'){
                                    orderList = SALES_ORDER.where((e) => e.status == _selectedStatus.value).toList();
                                  }
                                  else{
                                    orderList = SALES_ORDER;
                                  }

                                  FocusScope.of(context).requestFocus(FocusNode());

                                  if (kDebugMode) {
                                    print('Status: [${_selectedStatus.value}] ${_selectedStatus.title}');
                                  }
                                }
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                // margin: EdgeInsets.only(top: 11),
                padding: const EdgeInsets.all(10),
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(0)),
                  color: Theme.of(context).primaryColor,
                ),
                child: docCounter(streamController),
              ),
              const SizedBox(height: 10),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: orderListView(orderList.take(SYSTEM_OPTION.loadDocItem ?? 0).toList())
              )
              // FutureBuilder(
              //     future: ApiService().getMyOrders(EMPLOYEE?.id ?? ''),
              //     builder: (BuildContext context, AsyncSnapshot<Object> snapShot) {
              //       if (snapShot.hasData) {
              //         // globals.tempSOHD = snapShot.data;
              //
              //         final objects = snapShot.data as List<SalesOrder>;
              //
              //         orderList = objects.where((x) =>
              //         x.customerName!.contains(txtKeyword.text) && _selectedStatus.value != 'APPROVE' ''
              //             ? x.status == _selectedStatus.value && x.customerName!.contains(txtKeyword.text)
              //             : x.customerName!.contains(txtKeyword.text)
              //         ).toList();
              //
              //         streamController.add(orderList.length);
              //
              //         return Expanded(
              //             child: orderListView(orderList.take(SYSTEM_OPTION.loadDocItem!).toList())
              //         );
              //       } else {
              //         // var filtered = globals.tempSOHD
              //         //     .where((x) =>
              //         // x.custName.contains(txtKeyword.text)
              //         //     && _selectedStatus.value != 'A'
              //         //     ? x.isTransfer == _selectedStatus.value && x.custName.contains(txtKeyword.text)
              //         //     : x.custName.contains(txtKeyword.text));
              //         //
              //         // streamController.add(filtered.length);
              //
              //
              //         // return filtered != null ? Expanded(
              //         //     child: orderListView(filtered.take(globals.options.loadDocItem).toList()))
              //         //     : Expanded(
              //         //   child: Container(
              //         //       padding: EdgeInsets.all(20.0),
              //         //       child: Center(child: CircularProgressIndicator())),
              //         // );
              //         return Expanded(
              //           child: Container(
              //               padding: EdgeInsets.all(20.0),
              //               child: Center(child: CircularProgressIndicator())),
              //         );
              //       }
              //     }
              //     )
            ],
          ),
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

  openMenu () async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: const Text('รายการสั่งขาย'),
                onTap: () async {

                  Navigator.pop(context);
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SalesOrderViewPortrait(header: selectedItem))
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.fact_check_outlined),
                title: const Text('ความคืบหน้า'),
                onTap: () async {

                  // DocumentStatus document = globals.allDocumentStatusByCustomers.firstWhere((x) => x.soRefno == selectedItem.number, orElse: () => DocumentStatus());
                  //
                  // if(document.custId == null) {
                  //   document = DocumentStatus()
                  //     ..custId = selectedItem.customerId
                  //     ..custCode = globals.allCustomer.firstWhere((e) => e.custId == selectedItem.customerId).custCode
                  //     ..soid = selectedItem.soid;
                  // }
                  // Navigator.pop(context);
                  //
                  // await Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => ReportDocumentView(document: document))
                  // );
                },
              ),
            ],
          );
        });
  }

  Widget _searchTextField() {
    return TextFormField(
      controller: txtKeyword,
      autofocus: true, //Display the keyboard when TextField is displayed
      cursorColor: PRIMARY_COLOR,
      style: const TextStyle(
        color: PRIMARY_COLOR,
        fontSize: 16,
      ),
      textInputAction: TextInputAction.search, //Specify the action button on the keyboard
      decoration: InputDecoration( //Style of TextField
        enabledBorder: UnderlineInputBorder( //Default TextField border
            borderSide: BorderSide(color: Colors.grey[300]!)
        ),
        focusedBorder: UnderlineInputBorder( //Borders when a TextField is in focus
            borderSide: BorderSide(color: Colors.grey[300]!)
        ),
        hintText: 'Search', //Text that is displayed when nothing is entered.
        hintStyle: const TextStyle( //Style of hintText
          color: Colors.white60,
          fontSize: 16,
        ),
      ),
      onEditingComplete: () {
        ref.read(keywordOfSalesOrder.notifier).state = txtKeyword.text;
      },
    );
  }

  Widget orderListView(List<SalesOrder> dataList) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        // controller: _scrollController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {

          String customerCode = MY_CUSTOMERS.firstWhere((e) => e.id == dataList[index].customerId, orElse: () => Customer()).code ?? '';
          String status = dataList[index].status == null ? ''
              : dataList[index].status == 'RELEASE' ? 'รอดำเนินการ'
              : dataList[index].status == 'OPEN' ? 'ฉบับร่าง'
              : dataList[index].status == 'REJECT' ? 'ยกเลิกเอกสาร'
              : 'เข้าระบบแล้ว';

          String docuDate = dataList[index].orderDate == null ? '' : DateFormat('dd/MM/yyyy').format(dataList[index].orderDate!);
          String shipDate = dataList[index].requestedDeliveryDate == null ? '' : DateFormat('dd MMM yyyy').format(dataList[index].requestedDeliveryDate!);
          Color? statusColor = dataList[index].status == 'RELEASE' ? Colors.orange[600]
              : dataList[index].status == 'OPEN' ? Colors.blue
              : dataList[index].status == 'C' ? Colors.red
              : Colors.green;

          return Container(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${index + 1}. ${dataList[index].number}', style: TextStyle(
                                fontSize: 14.0),),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 5.0),
                                  child: Badge(
                                      showBadge: true,
                                      shape: BadgeShape.square,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      badgeColor: Colors.grey[300]!,
                                      badgeContent: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: RichText(
                                            text: TextSpan(
                                                children: [
                                                  WidgetSpan(child: Icon(Icons
                                                      .account_balance_wallet_outlined,
                                                      size: 15.0,
                                                      color: Colors.black54)),
                                                  TextSpan(
                                                      text: ' ${NumberFormat
                                                          .decimalPattern()
                                                          .format(
                                                          dataList[index].netAmount ?? 0)}',
                                                      style: TextStyle(
                                                          fontSize: 11.0,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          color: Colors
                                                              .black54)),
                                                ]
                                            )
                                        ),
                                      ) //Text('${element.lastDocNo}', style: TextStyle(fontSize: 12.0),),
                                  ),
                                ),

                                dataList[index].lastDocumentNumber != null
                                    ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 5.0),
                                  child: Badge(
                                      showBadge: true,
                                      shape: BadgeShape.square,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      badgeColor: Colors.grey[300]!,
                                      badgeContent: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: RichText(
                                            text: TextSpan(
                                                children: [
                                                  WidgetSpan(child: Icon(
                                                      Icons.description,
                                                      size: 15.0,
                                                      color: Colors.black54)),
                                                  TextSpan(text: ' ${dataList[index].lastDocumentNumber}',
                                                      style: TextStyle(
                                                          fontSize: 10.0,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          color: Colors
                                                              .black54)),
                                                ]
                                            )
                                        ),
                                      ) //Text('${element.lastDocNo}', style: TextStyle(fontSize: 12.0),),
                                  ),
                                )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 2,
                      child: Text(docuDate, style: TextStyle(fontSize: 12.0),
                          textAlign: TextAlign.right)
                  )
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text('${dataList[index].customerName} ($customerCode)',
                                style: TextStyle(fontSize: 14.0))
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(status, style: TextStyle(
                              fontSize: 14.0, color: statusColor),
                              textAlign: TextAlign.right)
                      )
                    ],
                  ),
                  // Text('${element.shipToAddr1} ${element.shipToAddr2 ?? ''} ${element.amphur ?? ''} ${element.district ?? ''} ${element.province ?? ''} ${element.postCode ?? ''}'),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: RichText(
                        text: TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons
                                  .local_shipping_outlined, size: 18.0,
                                  color: Colors.grey)),
                              TextSpan(text: ' $shipDate', style: TextStyle(
                                  color: Colors.grey, fontSize: 13.0)),
                            ]
                        )
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.only(top: 5.0),
                  //   child: Text('${NumberFormat.decimalPattern().format(element.netAmnt)}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                  // )
                ],
              ),
              onTap: () async {
                var res;
                selectedItem = dataList[index];

                if (selectedItem.status != 'OPEN') {
                  if(selectedItem.lastDocumentNumber != null) {
                    res = await openMenu();
                  }
                  else {
                    res = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SalesOrderViewPortrait(header: selectedItem))
                    );
                  }

                  if (res != null) {
                    setState(() {});
                  }
                } else {
                  // globals.isDraftInitial = false;
                  // globals.productCartDraft = <ProductCart>[];
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SalesOrderDraftPortrait(header: dataList[index],)
                      )
                  );
                  setState(() {});
                }
              },
              selected: selectedItem == dataList[index] ? true : false,
            ),
          );
        }
    );
  }
}
