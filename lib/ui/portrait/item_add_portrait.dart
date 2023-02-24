import 'dart:async';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:flutter/material.dart';
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/activity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamics_crm/providers/data_provider.dart';
import 'package:intl/intl.dart';

import '../../models/item.dart';
import '../../models/sales_order_line.dart';

class ItemAddPortrait extends ConsumerStatefulWidget {
  const ItemAddPortrait({Key? key, required this.type, required this.selectedItem}) : super(key: key);

  final Activity type;
  final Item selectedItem;

  @override
  ConsumerState<ItemAddPortrait> createState() => _ItemAddPortraitState();
}

class _ItemAddPortraitState extends ConsumerState<ItemAddPortrait> {
  double newPrice = 0;
  double firstPrice = 0;
  bool inStock = true;
  bool isPercent = true;
  NumberFormat currency = NumberFormat('#,##0.00', 'en_US');
  NumberFormat quantityFormat = NumberFormat('#,###', 'en_US');
  // ProductCart productCart = ProductCart();
  TextEditingController txtQty = TextEditingController();
  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtDiscount = TextEditingController();
  TextEditingController txtTotal = TextEditingController();
  TextEditingController txtRemark = TextEditingController();

  Timer? searchOnStoppedTyping;
  bool _longPressCanceled = false;

  late List<Item> allItems = ref.read(itemsCart);
  late List<SalesOrderLine> myOrders = ref.watch(salesOrderLines);
  SalesOrderLine orderItem = SalesOrderLine(quantity: 1, discountAmount: 0, discountPercent: 0, discountType: 'PER');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    orderItem.unitPrice = widget.selectedItem.unitPrice;
    amountCalculate();
    bindingController();
  }

  @override
  Widget build(BuildContext context) {

    if(widget.type == Activity.order) {
      myOrders = ref.watch(salesOrderLines);
    }
    else if(widget.type == Activity.draft) {
      myOrders = ref.watch(salesOrderLinesDraft);
    }
    else if(widget.type == Activity.copy) {
      myOrders = ref.watch(salesOrderLinesCopy);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('สินค้ารายการที่ ${myOrders.length + 1}'),
      ),
      body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Text(widget.selectedItem?.code ?? '', style: TextStyle(fontSize: 14.0)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(widget.selectedItem?.displayName ?? '', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Text('${currency.format(widget.selectedItem?.unitPrice)} / ${widget.selectedItem?.baseUnitOfMeasureCode ?? ''}', style: TextStyle(fontSize: 14.0)),
                ),
                SizedBox(
                  height: 0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        child: inStock ? Text('เช็คสต๊อค') : Text('ไม่มีของ'),
                        onPressed: !inStock ? null : () async {
                          FocusScope.of(context).unfocus();
                          if (widget.selectedItem == null) {
                            return await showDialog(
                                builder: (context) => const AlertDialog(
                                  title: Text('กรุณาเลือกสินค้า'),
                                  content: Text('คุณยังไม่ได้เลือกรายการสินค้า'),
                                ), context: context);
                          } else {
                            SharedWidgets.showStock(context, widget.selectedItem.id!);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: TextFormField(
                    readOnly: canEditPrice(),
                    textAlign: TextAlign.right,
                    controller: txtPrice,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(fontSize: 14.0),
                    decoration: const InputDecoration(
                      labelText: 'ราคา / หน่วย',
                      hintText: 'ราคาขาย',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    ),
                    onTap: () => txtPrice.selection = TextSelection(baseOffset:0, extentOffset: txtPrice.text.length, affinity: TextAffinity.upstream),
                    onChanged: _onChangePrice,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: txtTotal,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14.0),
                    decoration: const InputDecoration(
                      labelText: 'รวมราคา',
                      hintText: 'รวมราคา',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ElevatedButton(
                          child: isPercent ? Text('%', style: TextStyle(fontSize: 16),) : Text('THB', style: TextStyle(fontSize: 16),),
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 0)
                          ),
                          onPressed: () {
                            isPercent = !isPercent;

                            if(isPercent) {
                              orderItem.discountType = 'PER';
                            }
                            else {
                              orderItem.discountType = 'THB';
                            }

                            amountCalculate();
                            bindingController();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                        child: TextFormField(
                          controller: txtDiscount,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 14.0),
                          decoration: const InputDecoration(
                            labelText: 'ส่วนลด',
                            hintText: 'ส่วนลด',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          ),
                          onTap: () => txtDiscount.selection = TextSelection(baseOffset:0, extentOffset: txtDiscount.text.length, affinity: TextAffinity.upstream),
                          onChanged: _onChangeDiscount,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14.0),
                    decoration: const InputDecoration(
                      labelText: 'หมายเหตุ',
                      hintText: 'หมายเหตุ',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
                    ),
                  ),
                ),
                Container(
                  child: SwitchListTile(
                    title: const Text('แถมฟรี'),
                    activeColor: Colors.green,
                    value: orderItem.isFree,
                    onChanged: (bool value) async {
                      orderItem.isFree = value;
                      double? price = double.tryParse(txtPrice.text.replaceAll(',', ''));

                      if(value == false){
                        txtPrice.text = currency.format(firstPrice);
                        if(newPrice > 0){
                          txtPrice.text = currency.format(newPrice);
                        }

                        if(price != null){
                          orderItem.unitPrice = widget.selectedItem.unitPrice;
                        }
                        else{
                          // orderItem.unitPrice = await getPrice();
                        }
                      }
                      else{
                        newPrice = price ?? 0;

                        orderItem.unitPrice = widget.selectedItem.unitPrice;
                      }

                      amountCalculate();
                      bindingController();
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 55,
                        width: 55,
                        child: GestureDetector(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                side: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0)))
                            ),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              if(orderItem.quantity != 0){
                                orderItem.quantity = orderItem.quantity! - 1;

                                if(newPrice > 0){
                                  orderItem.unitPrice = newPrice;
                                }
                                else{
                                  SharedWidgets.showLoader(context, false);
                                  // orderItem.unitPrice = await getPrice();
                                  Navigator.pop(context);
                                }
                              }

                              amountCalculate();
                              bindingController();
                            },
                            child: Icon(Icons.remove, color: Theme.of(context).primaryColor, size: 24.0,),
                          ),
                          onLongPress: () async {
                            _longPressCanceled = false;
                            Future.delayed(const Duration(milliseconds: 200), () {
                              if (!_longPressCanceled) {
                                searchOnStoppedTyping = Timer.periodic(const Duration(milliseconds: 150), (timer) async {
                                  FocusScope.of(context).unfocus();

                                  if(orderItem.quantity != 0){
                                    orderItem.quantity = orderItem.quantity! - 1;
                                  }

                                  amountCalculate();
                                  bindingController();
                                });
                              }
                            });
                          },
                          onLongPressUp: () async {
                            await _cancelIncrease();
                          },
                          onLongPressEnd: (LongPressEndDetails longPressEndDetails) async {
                            await _cancelIncrease();
                          },
                          onLongPressMoveUpdate:
                              (LongPressMoveUpdateDetails longPressMoveUpdateDetails) async {
                            if (longPressMoveUpdateDetails
                                .localOffsetFromOrigin.distance >
                                20) {
                              await _cancelIncrease();
                            }
                          },
                        ),
                      ),

                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextFormField(
                            controller: txtQty,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26.0),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              hintText: 'จำนวน',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            ),
                            onTap: () => txtQty.selection = TextSelection(baseOffset:0, extentOffset: txtQty.text.length, affinity: TextAffinity.upstream),
                            onChanged: _onChangeQty,
                          ),
                        ),
                      ),

                      Container(
                        height: 55,
                        width: 55,
                        child: GestureDetector(
                          child: ElevatedButton(
                            // child: Text('+', textAlign: TextAlign.center, style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
                            child: Icon(Icons.add, color: Theme.of(context).primaryColor, size: 24.0,),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                alignment: Alignment.center,
                                side: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0)))
                            ),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              orderItem.quantity = orderItem.quantity! + 1;

                              if(newPrice > 0){
                                orderItem.unitPrice = newPrice;
                              }
                              else{
                                SharedWidgets.showLoader(context, false);
                                // orderItem.unitPrice = await getPrice();
                                Navigator.pop(context);
                              }

                              amountCalculate();
                              bindingController();
                            },
                          ),
                          onLongPress: () async {
                            _longPressCanceled = false;
                            Future.delayed(const Duration(milliseconds: 300), () {
                              if (!_longPressCanceled) {
                                searchOnStoppedTyping = Timer.periodic(const Duration(milliseconds: 150), (timer) async {
                                  FocusScope.of(context).unfocus();

                                  orderItem.quantity = orderItem.quantity! + 1;
                                  amountCalculate();
                                  bindingController();

                                });
                              }
                            });
                          },
                          onLongPressUp: () async {
                            await _cancelIncrease();
                          },
                          onLongPressEnd: (LongPressEndDetails longPressEndDetails) async {
                            await _cancelIncrease();
                          },
                          onLongPressMoveUpdate:
                              (LongPressMoveUpdateDetails longPressMoveUpdateDetails) async {
                            if (longPressMoveUpdateDetails
                                .localOffsetFromOrigin.distance >
                                20) {
                              await _cancelIncrease();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('รวมสุทธิ', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                  Text(currency.format(orderItem.netAmount ?? 0), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),)
                ],
              ),
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 25.0,),
              label: const Text('เพิ่มรายการสินค้า', style: TextStyle(fontSize: 16.0),),
              style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15.0)
              ),
              onPressed: orderItem.quantity == 0 ? null : (){
                addToCart();
              },
            ),
          ],
        ),
      ),
    );
  }

  // getPrice() async {
  //   return await ApiService().getPrice(
  //       globals.customer.custId, widget.selectedProduct?.goodCode, productCart.goodQty, widget.selectedProduct?.saleGoodUnitId ?? widget.selectedProduct?.mainGoodUnitId);
  // }

  amountCalculate() {
    if(orderItem.isFree) {
      orderItem.unitPrice = 0;
      newPrice = 0;
    }

    orderItem.amountBeforeDiscount = orderItem.quantity! * orderItem.unitPrice!;
    orderItem = discountCalculate(isPercent, txtDiscount.text, orderItem);
    orderItem.netAmount = orderItem.amountBeforeDiscount! - orderItem.discountAmount!;
  }

  bindingController() {
    if(!mounted) return;
    setState(() {
      txtQty.text = quantityFormat.format(orderItem.quantity);
      txtPrice.text = NumberFormat('#,###.##').format(orderItem.unitPrice);

      txtTotal.text = currency.format(orderItem.amountBeforeDiscount);
      txtDiscount.text = NumberFormat('#,###.##').format(orderItem.discountType == 'PER' ? orderItem.discountPercent : orderItem.discountAmount);

      txtQty.selection = TextSelection.fromPosition(TextPosition(offset: txtQty.text.length));
      txtPrice.selection = TextSelection.fromPosition(TextPosition(offset: txtPrice.text.length));
      txtDiscount.selection = TextSelection.fromPosition(TextPosition(offset: txtDiscount.text.length));
    });
  }

  addToCart() {
    int row = 1;
    String lotFlag = 'N', expireFlag = 'N', serialFlag = 'N';

    if(orderItem.netAmount == 0) {
      orderItem.isFree = true;
    }

    if(orderItem.isFree) {
      orderItem.unitPrice = 0;
      // orderItem.goodPriceEdited = 0;
    }

    // print('lotSerialExpireFlag : ${widget.selectedItem.lotSerialExpireFlag}');
    // switch(widget.selectedItem.lotSerialExpireFlag) {
    //   case '0': {
    //     lotFlag = 'N'; expireFlag = 'N'; serialFlag = 'N';
    //     break;
    //   }
    //   case '1': {
    //     lotFlag = 'Y'; expireFlag = 'N'; serialFlag = 'N';
    //     break;
    //   }
    //   case '3': {
    //     lotFlag = 'Y'; expireFlag = 'N'; serialFlag = 'Y';
    //     break;
    //   }
    //   case '4': {
    //     lotFlag = 'Y'; expireFlag = 'Y'; serialFlag = 'N';
    //   }
    // }

    print('$lotFlag $expireFlag $serialFlag');

    // SalesOrderLine order = SalesOrderLine();
    // ProductCart order = new ProductCart()
    //   ..productCartId = UniqueKey().toString()
    //   ..rowIndex = 1
    //   ..goodId = widget.selectedProduct.goodId
    //   ..goodCode = widget.selectedProduct.goodCode
    //   ..goodName1 = widget.selectedProduct.goodName1
    //   ..mainGoodUnitId = widget.selectedProduct.mainGoodUnitId
    //   ..goodUnitName = widget.selectedProduct.goodUnitName
    //   ..goodUnitRate = widget.selectedProduct.goodUnitRate
    //   ..saleGoodUnitId = widget.selectedProduct.saleGoodUnitId
    //   ..saleGoodUnitName = widget.selectedProduct.saleGoodUnitName
    //   ..saleGoodUnitRate = widget.selectedProduct.saleGoodUnitRate
    //   ..goodQty = productCart.goodQty
    //   ..goodPrice = productCart.goodPrice
    //   ..discount = productCart.discount
    //   ..discountType = productCart.discountType
    //   ..discountBase = productCart.discountBase
    //   ..beforeDiscountAmount = productCart.beforeDiscountAmount
    //   ..goodAmount = productCart.goodAmount
    //   ..isFree = productCart.isFree
    //   ..vatGroupId = widget.selectedProduct.vatGroupId
    //   ..vatGroupCode = widget.selectedProduct.vatGroupCode
    //   ..vatType = widget.selectedProduct.vatType
    //   ..vatRate = widget.selectedProduct.vatRate
    //   ..remark = txtRemark.text
    //   ..lotFlag = lotFlag
    //   ..expireFlag = expireFlag
    //   ..serialFlag = serialFlag;

    // if (editedPrice > 0) {
    //   order.goodPrice = globals.newPrice;
    // }

    // if (myOrders.isNotEmpty) {
    //   orderItem.sequence = myOrders.length + 1;
    //   orderItem.itemId = widget.selectedItem.id;
    //   orderItem.unitOfMeasureId = widget.selectedItem.baseUnitOfMeasureId;
    //   orderItem.unitOfMeasureCode = widget.selectedItem.baseUnitOfMeasureCode;
    // }

    // print('Add Order: ' + order.goodName1);
    // myOrders.add(orderItem);

    orderItem.id = UniqueKey().toString();
    orderItem.sequence = myOrders.length + 1;
    orderItem.itemId = widget.selectedItem.id;
    orderItem.unitOfMeasureId = widget.selectedItem.baseUnitOfMeasureId;
    orderItem.unitOfMeasureCode = widget.selectedItem.baseUnitOfMeasureCode;
    ref.watch(salesOrderLines.notifier).add(orderItem);

    Navigator.pop(context);
    Navigator.pop(context, orderItem);
  }

  _cancelIncrease() async {
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping!.cancel();
    }
    _longPressCanceled = true;

    if(newPrice > 0) {
      orderItem.unitPrice = newPrice;
    }
    else{
      // orderItem.unitPrice = await getPrice();
    }

    amountCalculate();
    bindingController();
  }

  _onChangeQty(value) {
    const duration = Duration(milliseconds:1000); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    }

    searchOnStoppedTyping = Timer(duration, ()
    {
      if(double.tryParse(txtQty.text.toString().replaceAll(',', '')) != null){
        orderItem.quantity = double.parse(txtQty.text.toString().replaceAll(',', ''));
      }
      else if(value.toString().isEmpty) {
        orderItem.quantity = 0;
        txtQty.text = '0';
      }
      else {
        txtQty.text = value;
      }

      amountCalculate();
      bindingController();
    });
  }

  _onChangePrice(value) {
    const duration = Duration(milliseconds:2000); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    }

    searchOnStoppedTyping = Timer(duration, () {
      if(double.tryParse(txtPrice.text.replaceAll(',', '')) != null){
        orderItem.unitPrice = double.parse(txtPrice.text.replaceAll(',', ''));
        newPrice = orderItem.unitPrice!;
      }
      else{
        txtPrice.text = value;
      }

      amountCalculate();
      bindingController();
    });
  }

  _onChangeDiscount(String value) {
    const duration = Duration(milliseconds:800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    }

    searchOnStoppedTyping = Timer(duration, ()
    {
      if(double.tryParse(txtDiscount.text.replaceAll(',', '')) != null){
      }
      else if(value.isEmpty){
        txtDiscount.text = '0';
      }
      else{
        txtDiscount.text = value;
      }

      amountCalculate();
      bindingController();
    });
  }
}
