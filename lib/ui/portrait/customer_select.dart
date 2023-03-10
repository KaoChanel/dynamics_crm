import 'dart:async';

import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/customer.dart';
import '../customer_create.dart';
import 'customer_detail.dart';
import 'customer_edit_portrait.dart';

class CustomerSelect extends StatefulWidget {
  const CustomerSelect({super.key, this.lookNewCustomer = false, this.lookAll = true});

  final bool lookNewCustomer;
  final bool lookAll;

  @override
  State<CustomerSelect> createState() => _CustomerSelectState();
}

class _CustomerSelectState extends State<CustomerSelect> {
  List<Customer> allCustomer = <Customer>[];
  List<Customer> tmpCustomer = <Customer>[];

  late Timer searchOnStoppedTyping;

  ScrollController scroll = ScrollController();
  TextEditingController keyword = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // globals.allCustomerByEmp.forEach((e) => e.contTel == null ? e.contTel = '' : e.contTel);
    setCustomer();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<ScrollVisible>(context, listen: false).setVisible(false);
    // });
    //
    // scroll = ScrollController();
    // scroll.addListener(() {
    //   Provider.of<ScrollVisible>(context, listen: false).setVisible(scroll.position.userScrollDirection == ScrollDirection.forward);
    // });

    if(CUSTOMER != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await getScrollAtElement(tmpCustomer.indexWhere((x) => x.code == CUSTOMER!.code));
      });
    }
  }

  getScrollAtElement(int index) async {
    if (scroll.hasClients) {
      await scroll.animateTo(
          (190.0 * index),
          // 100 is the height of container and index of 6th element is 5
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('????????????????????????????????????'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerCreate()));
                  },
                icon: const Icon(Icons.person_add)
            )
          ],
        ),
        body: SingleChildScrollView(
          controller: scroll,
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    controller: keyword,
                    decoration: const InputDecoration(
                        hintText: '??????????????????????????????, ??????????????????????????????, ?????????????????????, ?????????????????????????????????, ?????????????????????????????????',
                        hintStyle: TextStyle(fontSize: 14.0),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0)
                    ),
                    onChanged: _onChangeHandler,
                    // onChanged: (String value) {
                    //   if(!mounted) return false;
                    //   setState(() {
                    //     allCustomer = globals.allCustomerByEmp
                    //         .where((x) => x.custName.contains(value)
                    //         || x.custCode.contains(value)
                    //         || x.custStatus.contains(value)
                    //         || (x.custAddr1 != null ? x.custAddr1.contains(value) : false)
                    //         || (x.province != null ? x.province.contains(value) : false)
                    //         || (x.postCode != null ? x.postCode.contains(value) : false)
                    //         || (x.contTel != null ? x.contTel.contains(value) : false)
                    //     ).toList() ?? <Customer>[];
                    //   });
                    // },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text('???????????????????????? ${allCustomer.length} ?????????', style: TextStyle(fontSize: 14.0),),
                    ),
                  ],
                ),
                ListView(
                  primary: false,
                  shrinkWrap: true,
                  // controller: scroll,
                  children: myCustomerList(),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 300),
          child: FloatingActionButton(
            child: Icon(widget.lookNewCustomer ? Icons.person_add : Icons.arrow_upward),
            onPressed: () async {
              if(widget.lookNewCustomer){
                var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerCreate()));

                if(res != null) {
                  allCustomer = [];
                  // globals.allCustomerNew = await ApiService().getCustomersNew();

                  setState(() => setCustomer());
                }
              }
              else{
                goToElement(1);
              }
            },
          ),
          // opacity: scroll.visible ? 1 : 0,
        )
    );
  }

  void goToElement(int index) {
    scroll.animateTo((100.0 * index), // 100 is the height of container and index of 6th element is 5
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut);

    // if(index == 1) {
    //   Provider.of<ScrollVisible>(context, listen: false).setVisible(false);
    // }
  }

  setCustomer(){
    if(widget.lookNewCustomer){
      allCustomer.addAll(MY_CUSTOMERS);
    }

    if(widget.lookAll){
      allCustomer.addAll(MY_CUSTOMERS);
    }

    tmpCustomer = allCustomer;
  }

  selectCustomer(Customer customer) async {
    if(widget.lookNewCustomer) {
      return Navigator.pop(context, customer);
    }

    if(SYSTEM_OPTION.isLockCust == 'Y') {
      switch(customer.blocked) {
        case 'I':
          return SharedWidgets.showAlert(context, 'In-Active Customer', '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????');
          break;
        case 'H':
          return SharedWidgets.showAlert(context, 'Holding Customer', '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????');
      }
    }

    if(SYSTEM_OPTION.isCheckCredit == 'Y') {
      // double limitCreditAmount = customer.creditBalance ?? 0 + customer.creditTempIncrease ?? 0;
      double limitCreditAmount = CUSTOMER_FINANCIAL?.balance ?? 0;
      if(limitCreditAmount < 1) {
        return SharedWidgets.showAlert(context, '????????????????????????????????????????????????', '??????????????????????????????????????????????????????????????? ????????????????????? ${NUMBER_FORMAT.format(limitCreditAmount)} ?????????');
      }
    }

    // var shipTo = globals.allShipto?.firstWhere((e) => e.custId == CUSTOMER?.id && e.isDefault == 'Y', orElse: () => null);

    var shipTo = SHIPMENT;

    if (shipTo == null) {
      return showDialog(
          builder: (context) =>
              AlertDialog(
                title: const Text('????????????????????????????????? Ship To Address'),
                content: const Text('??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? WinSpeed'),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: const Text('????????????'))
                ],
              ), context: context);
    }
    else {
      // globals.clearOrder();
      CUSTOMER = customer;
      SHIPMENT = shipTo;
      // globals.selectedShiptoQuot = shipTo;
      print('Transport ID: ${SHIPMENT.id}');

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('customer', CUSTOMER?.id ?? '');

      Navigator.pop(context, CUSTOMER?.id ?? '');
    }
  }

  myCustomerList(){
    return allCustomer.take(35).map((e) =>
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Card(
            color: e == CUSTOMER ? Colors.grey.shade200 : Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: Text(e.code ?? '', style: TextStyle(fontSize: 13.0)),),
                      Expanded(
                          child: Text(e.blocked == 'All' ? '??????????????????????????????' : e.blocked == '' ? '???????????????????????????' : e.blocked,
                              textAlign:  TextAlign.right,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: e.blocked == 'All' ? Colors.orange : e.blocked == '????????????' ? Colors.green : Colors.red
                              )
                          )
                      )
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(e.displayName ?? '', style: const TextStyle(fontSize: 14.0)),
                  Text('${e.addressLine1} ${e.addressLine2 ?? ''} ${''} ${e.city ?? ''} ${e.state ?? ''} ${e.postalCode ?? ''}', style: TextStyle(color: Colors.black54, fontSize: 13.0)),
                  Text(e.phoneNumber ?? '', style: const TextStyle(color: Colors.black54, fontSize: 14.0)),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(),
                  Row(children: [
                    Expanded(
                        child: TextButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('?????????????????????????????????', style: TextStyle(fontSize: 16.0)),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          onPressed: () {
                            selectCustomer(e);
                          },
                        )
                    ),
                    Expanded(
                        child: TextButton.icon(
                          icon: const Icon(Icons.info_outline),
                          label: const Text('??????????????????????????????', style: TextStyle(fontSize: 16.0)),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          onPressed: () async {
                            if(e.blocked == 'All') {
                              var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerEditPortrait(customer: e)));
                              if(res != null) {
                                allCustomer = [];
                                // globals.allCustomerNew = await ApiService().getCustomersNew();

                                setState(() => setCustomer());
                              }
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerDetail(customer: e)));
                            }
                          },
                        )
                    )
                  ],)
                ],
              ),
            ),
          ),
        )).toList() ?? Text('???????????????????????????????????????????????????');
  }

  _onChangeHandler(String value) {
    const duration = Duration(milliseconds:800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }

    searchOnStoppedTyping = Timer(
        duration, () => setState(() => allCustomer = tmpCustomer
        .where((x) => x.displayName!.toLowerCase().contains(value.toLowerCase())
        || x.code!.toLowerCase().contains(value.toLowerCase())
        // || (x.custAddr1 != null ? x.custAddr1.contains(value) : false)
        || (x.state != null ? x.state!.contains(value) : false)
        || (x.postalCode != null ? x.postalCode!.contains(value) : false)
        // || (x.contTel != null ? x.contTel.contains(value) : false)
    ).toList() ?? <Customer>[]));
  }
}
