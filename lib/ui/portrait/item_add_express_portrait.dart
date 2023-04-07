import 'dart:async';

import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/inventory.dart';
import 'package:dynamics_crm/models/sales_order.dart';
import 'package:dynamics_crm/models/sales_order_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/activity.dart';
import '../../models/debounce.dart';
import '../../models/item.dart';
import '../../models/order.dart';
import '../../providers/data_provider.dart';
import '../../services/api_service.dart';

class ItemAddExpressPortrait extends ConsumerStatefulWidget {
  const ItemAddExpressPortrait({Key? key, required this.type}) : super(key: key);

  final Activity type;

  @override
  _ItemAddExpressPortraitState createState() => _ItemAddExpressPortraitState();
}

class _ItemAddExpressPortraitState extends ConsumerState<ItemAddExpressPortrait> {
  TextEditingController keyword = TextEditingController();
  ScrollController scroll = ScrollController();
  List<SalesOrderLine> allProducts = [];
  List<SalesOrderLine> allFiltered = [];

  final debouncer = Debouncer(delay: const Duration(milliseconds: 1000));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ref.read(expressItem).clear();
    ref.read(expressCart).clear();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await Provider.of<ExpressOrder>(context, listen: false).setProduct(globals.allProduct);
      // allProducts = Provider.of<ExpressOrder>(context, listen: false).getOrders.take(50).toList();

      ref.read(expressItem.notifier).replace(toSalesOrderLine(ITEMS, null, 1));
      ref.read(expressCart.notifier).replace(ref.read(expressItem));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    keyword.dispose();
    scroll.dispose();
  }

  searching(String value) async {
    debouncer.call(() async {
      var filtered = ref.read(expressItem.notifier).getBy(value);
      ref.read(expressCart.notifier).replace(filtered);

      // allProduct = globals.allProduct
      //     .where((x) => x.goodName1.toString().toLowerCase().contains(value.toString().toLowerCase())
      //     || x.goodCode.toString().toLowerCase().contains(value.toString().toLowerCase())
      //     || x.goodUnitName.toString().toLowerCase().contains(value.toString().toLowerCase())
      //   // || (x.postCode != null ? x.postCode.contains(value) : false)
      // ).take(50).toList() ?? <Customer>[];

      // allProducts = Provider.of<ExpressOrder>(context, listen: false).getOrders
      //     .where((x) => x.goodName1.toString().toLowerCase().contains(value.toString().toLowerCase())
      //     || x.goodCode.toString().toLowerCase().contains(value.toString().toLowerCase())
      //     || x.goodUnitName.toString().toLowerCase().contains(value.toString().toLowerCase())).take(50).toList();
    });
  }

  addToCart(List<SalesOrderLine> cart) {
    /// Calculate discount.
    // cart.forEach((e) {
    //   if(e.discountType == 'PER') {
    //     double total = ((e.discount / 100) * e.goodAmount);
    //     e.discountBase = total;
    //     e.goodAmount = e.goodAmount - total;
    //   }
    //   else{
    //     e.discountBase = e.discount;
    //     e.goodAmount = e.goodAmount - e.discount;
    //   }
    // });

    if (widget.type == Activity.order) {
      ref.read(salesOrderLines.notifier).addAll(cart);
      // globals.productCart.addAll(cart);
      // reorderIndex(globals.productCart);
    }

    else if (widget.type == Activity.copy) {
      ref.read(salesOrderLinesCopy.notifier).addAll(cart);
      // globals.productCartCopy.addAll(cart);
      // reorderIndex(globals.productCartCopy);
    }
    else if(widget.type == Activity.draft) {
      ref.read(salesOrderLinesDraft.notifier).addAll(cart);
      // globals.productCartDraft.addAll(cart);
      // reorderIndex(globals.productCartDraft);

    }
    else if(widget.type == Activity.quotationDraft) {
      ref.read(salesOrderLines.notifier).addAll(cart);
      // globals.productCartQuotDraft.addAll(cart);
      // reorderIndex(globals.productCartQuotDraft);
    }
    else if(widget.type == Activity.quotationCopy) {
      ref.read(salesOrderLines.notifier).addAll(cart);
      // globals.productCartQuotCopy.addAll(cart);
      // reorderIndex(globals.productCartQuotCopy);
    }
    else{
      ref.read(salesOrderLines.notifier).addAll(cart);
      // globals.productCartQuot.addAll(cart);
      // reorderIndex(globals.productCartQuot);
    }

    Navigator.pop(context, cart);
  }

  @override
  Widget build(BuildContext context) {

    allProducts = ref.watch(expressItem);
    allFiltered = ref.watch(expressCart);

    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการสินค้า'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: keyword,
                  decoration: const InputDecoration(
                    hintText: 'ชื่อสินค้า, รหัสสินค้า, หน่วยนับ ...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                  ),
                  onChanged: searching,
                ),
              ),

              ListView(
                primary: false,
                shrinkWrap: true,
                controller: scroll,
                children: myItemExpansionTile(),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.library_add_outlined),
          label: const Text('เพิ่มรายการ'),
          style: ElevatedButton.styleFrom(
              primary: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 15.0)
          ),
          onPressed: () => addToCart(allProducts.where((e) => e.isSelect == true).toList()),
        ),
      ),
    );
  }

  myItemExpansionTile() {
    return allFiltered.take(35).map((e) {
      Inventory stock = Inventory()..goodid = e.id;
      // bool inStock = globals.hasStock(e.goodId);
      // bool isLow = globals.stockLower(stock);
      double remainStock = stockCount(stock);
      // Item item = ITEMS.firstWhere((i) => i.id == e.itemId);
      Item item = ITEMS.firstWhere((i) => i.no == e.itemCode);

      TextEditingController txtPrice = TextEditingController(text: CURRENCY.format(e.unitPrice ?? 0));
      TextEditingController txtQty = TextEditingController(text: CURRENCY.format(e.quantity ?? 0));
      TextEditingController txtDiscount = TextEditingController(text: CURRENCY.format(e.discountNumber ?? 0));

      _onChangePrice(value) async {
        debouncer.call(() async {
          if(double.tryParse(value) != null) {
            e.unitPrice = double.parse(value);
            e.netAmount = (e.quantity ?? 0) * (e.unitPrice ?? 0);
            // Provider.of<ExpressOrder>(context, listen: false).update(e);
            ref.read(expressCart.notifier).edit(e);
            txtPrice.selection = TextSelection(baseOffset: 0, extentOffset: txtPrice.text.length, affinity: TextAffinity.upstream);
          }
        });
      }

      _onChangeQty(value) async {
        debouncer.call(() async {
          if(double.tryParse(value) != null) {
            e.quantity = double.parse(value);
            e.netAmount = (e.quantity ?? 0) * (e.unitPrice ?? 0);
            // Provider.of<ExpressOrder>(context, listen: false).update(e);
            ref.read(expressItem.notifier).edit(e);
            txtQty.selection = TextSelection(baseOffset: 0, extentOffset: txtQty.text.length, affinity: TextAffinity.upstream);
          }
        });
      }

      _onChangeDiscount(value) async {
        debouncer.call(() async {
          if(double.tryParse(value) != null) {
            e.discountNumber = double.parse(value);
          }
          else {
            e.discountNumber = 0;
          }

          bool isPercent = e.discountType == 'PER' ? true : false;
          e = amountCalculate(isPercent, txtDiscount.text, e);
          ref.read(expressItem.notifier).edit(e);

          txtDiscount.selection = TextSelection(baseOffset: 0, extentOffset: txtDiscount.text.length, affinity: TextAffinity.upstream);
        });
      }

      void _onCheckChanged(bool? newValue) async {
        FocusScopeNode().unfocus();
        e.isSelect = newValue ?? false;

        if (e.isSelect) {
          // TODO: Here goes your functionality that remembers the user.
          // e.goodPrice = await ApiService().getPrice(globals.customer.custId, e.goodCode, 1, e.mainGoodUnitId);
        } else {
          // TODO: Forget the user.
        }

        e.netAmount = (e.quantity ?? 0) * (e.unitPrice ?? 0);
        // Provider.of<ExpressOrder>(context, listen: false).update(e);
        ref.read(expressItem.notifier).edit(e);
      }

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ExpansionTile(
            key: e.key,
            leading: Checkbox(
              value: e.isSelect,
              activeColor: Colors.orange,
              onChanged: _onCheckChanged,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${item.no}', style: const TextStyle(fontSize: 12.0)),
                Text('${item.description}', style: const TextStyle(fontSize: 14.0)),
              ],
            ),
            subtitle: Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                // child: Text('หน่วยนับ ${e.goodUnitName}', style: TextStyle(fontSize: 12.0),)
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('คงเหลือ ${remainStock.toInt()} x ${item.baseuomdescription ?? ''} ', style: const TextStyle(fontSize: 12.0),),
                    remainStock == 0 ? const Text('สินค้าหมด !', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14.0))
                        : remainStock < 6 ? const Icon(Icons.trending_down, color: Colors.red,) : const Text('')
                    // isLow ? Icon(Icons.trending_down, color: ,) : null
                  ],
                )
            ),
            onExpansionChanged: _onCheckChanged,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: txtPrice,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'ราคาขาย',
                            hintText: 'ราคาขาย',
                            contentPadding: EdgeInsets.all(5.0),
                            border: OutlineInputBorder()
                        ),
                        onChanged: _onChangePrice,
                        onTap: () => txtPrice.selection = TextSelection(baseOffset: 0, extentOffset: txtPrice.text.length, affinity: TextAffinity.upstream),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: txtQty,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'จำนวน',
                            hintText: 'จำนวน',
                            contentPadding: EdgeInsets.all(5.0),
                            border: OutlineInputBorder()
                        ),
                        onChanged: _onChangeQty,
                        onTap: () => txtQty.selection = TextSelection(baseOffset: 0, extentOffset: txtQty.text.length, affinity: TextAffinity.upstream),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              controller: txtDiscount,
                              textAlign: TextAlign.center,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                  labelText: 'ส่วนลด',
                                  hintText: 'ส่วนลด',
                                  contentPadding: EdgeInsets.all(5.0),
                                  border: OutlineInputBorder()
                              ),
                              onTap: () => txtDiscount.selection = TextSelection(baseOffset: 0, extentOffset: txtDiscount.text.length, affinity: TextAffinity.upstream),
                              onChanged: _onChangeDiscount,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0)
                                ),
                                onPressed: () {
                                  e.discountType = e.discountType == 'PER' ? 'THB' : 'PER';
                                  bool isPercent = e.discountType == 'PER' ? true : false;
                                  e = amountCalculate(isPercent, txtDiscount.text, e);
                                  ref.read(expressItem.notifier).edit(e);
                                },
                                child: Text(e.discountType == 'PER' ? '%' : 'THB', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList() ?? [];
  }
}
