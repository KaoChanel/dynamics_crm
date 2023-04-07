import 'dart:async';

import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/debounce.dart';
import 'package:dynamics_crm/models/sales_order_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/item.dart';

class ItemEditPortrait extends ConsumerStatefulWidget {
  const ItemEditPortrait({Key? key, required this.editItem}) : super(key: key);

  final SalesOrderLine editItem;

  @override
  ConsumerState<ItemEditPortrait> createState() => _ItemEditPortraitState();
}

class _ItemEditPortraitState extends ConsumerState<ItemEditPortrait> {
  double newPrice = 0;
  double firstPrice = 0;
  bool inStock = false;
  bool isPercent = false;
  TextEditingController txtQty = TextEditingController();
  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtDiscount = TextEditingController();
  TextEditingController txtTotal = TextEditingController();
  TextEditingController txtRemark = TextEditingController();

  Timer? searchOnStoppedTyping;
  bool _longPressCanceled = false;
  final debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  Item itemInfo = Item();
  SalesOrderLine orderItem = SalesOrderLine();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    orderItem = widget.editItem;
    isPercent = orderItem.discountType == 'PER' ? true : false;
    itemInfo = ITEMS.firstWhere((e) => e.id == orderItem.itemId, orElse: () => Item());
    bindingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('สินค้ารายการที่ ${widget.editItem?.sequence ?? 1}'),
      ),
      body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Text(itemInfo.no ?? '', style: const TextStyle(fontSize: 14.0)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(itemInfo.description ?? '', style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Text('${CURRENCY.format(itemInfo.unitPrice ?? 0)} / ${widget.editItem?.unitOfMeasureCode ?? ''}', style: const TextStyle(fontSize: 14.0)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: !inStock ? null : () async {
                          FocusScope.of(context).unfocus();
                          if (widget.editItem == null) {
                            return showDialog(
                                builder: (context) => const AlertDialog(
                                  title: Text('กรุณาเลือกสินค้า'),
                                  content: Text('คุณยังไม่ได้เลือกรายการสินค้า'),
                                ), context: context);
                          } else {
                            // showStock(context, widget.editItem.itemId);
                          }
                        },
                        child: inStock ? const Text('เช็คสต๊อค') : const Text('ไม่มีของ'),
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontSize: 14.0),
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
                    style: const TextStyle(fontSize: 14.0),
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
                          onPressed: (){
                            isPercent = !isPercent;

                            if(isPercent){
                              orderItem.discountType = 'PER';
                            }
                            else{
                              orderItem.discountType = 'THB';
                            }

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
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                //   child: TextFormField(
                //     controller: txtDiscount,
                //     textAlign: TextAlign.right,
                //     style: TextStyle(fontSize: 14.0),
                //     decoration: InputDecoration(
                //       labelText: 'ส่วนลด',
                //       hintText: 'ส่วนลด',
                //       border: OutlineInputBorder(),
                //       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                //     ),
                //     onTap: () => txtDiscount.selection = TextSelection(baseOffset:0, extentOffset: txtDiscount.text.length, affinity: TextAffinity.upstream),
                //     onChanged: _onChangeDiscount,
                //   ),
                // ),
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
                        txtPrice.text = CURRENCY.format(firstPrice);
                        if(newPrice > 0){
                          txtPrice.text = CURRENCY.format(newPrice);
                        }

                        if(price != null){
                          orderItem.unitPrice = itemInfo.unitPrice;
                        }
                        else{
                          // orderItem.unitPrice = await getPrice();
                        }
                      }
                      else{
                        newPrice = price ?? 0;

                        orderItem.unitPrice = itemInfo.unitPrice;
                      }

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
                            child: Icon(Icons.remove, color: Theme.of(context).primaryColor, size: 24.0,),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                side: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0)))
                            ),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              if(orderItem.quantity != 0){
                                orderItem.quantity = orderItem.quantity! - 1;

                                if(newPrice > 0){
                                  orderItem.unitPrice = newPrice;
                                }
                                else{
                                  // orderItem.unitPrice = await getPrice();
                                }
                              }

                              bindingController();
                            },
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
                            style: TextStyle(fontSize: 26.0),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                // orderItem.goodPrice = await getPrice();
                              }

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
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('รวมสุทธิ', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                Text(CURRENCY.format(orderItem.netAmount ?? 0), style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),)
              ],
            ),

            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check, size: 25.0,),
                label: const Text('บันทึกรายการ', style: TextStyle(fontSize: 16.0),),
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15.0)
                ),
                onPressed: orderItem.quantity == 0 ? null : (){
                  update();
                },
              ),
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.delete_forever, size: 25.0,),
              label: const Text('ลบรายการ', style: TextStyle(fontSize: 16.0),),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15.0)
              ),
              onPressed: (){
                Navigator.pop(context, 'Remove');
              },
            ),
          ],
        ),
      ),
    );
  }

  update() {
    String lotFlag = 'N', expireFlag = 'N', serialFlag = 'N';

    if(orderItem.netAmount == 0) {
      orderItem.isFree = true;
    }

    if(orderItem.isFree) {
      orderItem.unitPrice = 0;
      // orderItem.goodPriceEdited = 0;
    }

    // String lotSerialExpireFlag = globals.allProduct.firstWhere((x) => x.goodId == widget.editProduct.goodId).lotSerialExpireFlag;
    //
    // switch(lotSerialExpireFlag) {
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

    // ProductCart item = ProductCart()
    //   ..rowIndex = widget.editProduct.rowIndex
    //   ..goodId = widget.editProduct.goodId
    //   ..goodCode = widget.editProduct.goodCode
    //   ..goodName1 = widget.editProduct.goodName1
    //   ..mainGoodUnitId = widget.editProduct.mainGoodUnitId
    //   ..goodUnitName = widget.editProduct.goodUnitName
    //   ..goodUnitRate = widget.editProduct.goodUnitRate
    //   ..saleGoodUnitId = widget.editProduct.saleGoodUnitId
    //   ..saleGoodUnitName = widget.editProduct.saleGoodUnitName
    //   ..saleGoodUnitRate = widget.editProduct.saleGoodUnitRate
    //   ..vatGroupId = widget.editProduct.vatGroupId
    //   ..vatGroupCode = widget.editProduct.vatGroupCode
    //   ..vatType = widget.editProduct.vatType
    //   ..vatRate = widget.editProduct.vatRate
    //
    //   ..goodQty = productCart.goodQty
    //   ..goodPrice = productCart.goodPrice
    //   ..discount = productCart.discount
    //   ..discountType = productCart.discountType
    //   ..discountBase = productCart.discountBase
    //   ..beforeDiscountAmount = productCart.beforeDiscountAmount
    //   ..goodAmount = productCart.goodAmount
    //   ..isFree = productCart.isFree
    //   ..remark = txtRemark.text
    //   ..lotFlag = lotFlag
    //   ..expireFlag = expireFlag
    //   ..serialFlag = serialFlag;

    Navigator.pop(context, orderItem);
  }

  bindingController() {
    setState(() {
      txtQty.text = NUMBER_FORMAT.format(orderItem.quantity);
      txtPrice.text = CURRENCY.format(orderItem.unitPrice);

      txtTotal.text = CURRENCY.format(orderItem.amountBeforeDiscount);
      txtDiscount.text = CURRENCY.format(orderItem.discountType == 'PER' ? orderItem.discountPercent : orderItem.discountAmount);

      txtQty.selection = TextSelection.fromPosition(TextPosition(offset: txtQty.text.length));
      txtPrice.selection = TextSelection.fromPosition(TextPosition(offset: txtPrice.text.length));
      txtDiscount.selection = TextSelection.fromPosition(TextPosition(offset: txtDiscount.text.length));
    });
  }

  _cancelIncrease() async {
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping!.cancel();
    }

    _longPressCanceled = true;

    if(newPrice > 0){
      orderItem.unitPrice = newPrice;
    }
    else{
      // productCart.goodPrice = await getPrice();
    }

    bindingController();
  }

  _onChangeQty(String value) {
    debouncer.call(() {
      if(double.tryParse(txtQty.text.replaceAll(',', '')) != null){
        orderItem.quantity = double.parse(txtQty.text.replaceAll(',', ''));
      }
      else if(value.isEmpty){
        txtQty.text = '0';
      }
      else{
        txtQty.text = value;
      }

      bindingController();
    });

    // const duration = Duration(milliseconds:800); // set the duration that you want call search() after that.
    // if (searchOnStoppedTyping != null) {
    //   setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    // }
    //
    // searchOnStoppedTyping = Timer(duration, ()
    // {
    //   if(double.tryParse(txtQty.text.replaceAll(',', '')) != null){
    //     orderItem.quantity = double.parse(txtQty.text.replaceAll(',', ''));
    //   }
    //   else if(value.isEmpty){
    //     txtQty.text = '0';
    //   }
    //   else{
    //     txtQty.text = value;
    //   }
    //
    //   bindingController();
    // });
  }

  _onChangePrice(String value) {
    debouncer.call(() {
      if(double.tryParse(txtPrice.text.replaceAll(',', '')) != null){
        orderItem.unitPrice = double.parse(txtPrice.text.replaceAll(',', ''));
        newPrice = orderItem.unitPrice!;

        if(orderItem.unitPrice! > 0){
          orderItem.isFree = false;
        }
        else{
          orderItem.isFree = true;
        }

        bindingController();
      }
      else{
        txtPrice.text = value;
      }
    });

    // const duration = Duration(milliseconds:800); // set the duration that you want call search() after that.
    // if (searchOnStoppedTyping != null) {
    //   setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    // }
    //
    // searchOnStoppedTyping = Timer(duration, ()
    // {
    //   if(double.tryParse(txtPrice.text.replaceAll(',', '')) != null){
    //     orderItem.unitPrice = double.parse(txtPrice.text.replaceAll(',', ''));
    //     newPrice = orderItem.unitPrice!;
    //
    //     if(orderItem.unitPrice! > 0){
    //       orderItem.isFree = false;
    //     }
    //     else{
    //       orderItem.isFree = true;
    //     }
    //
    //     bindingController();
    //   }
    //   else{
    //     txtPrice.text = value;
    //   }
    // });
  }

  _onChangeDiscount(String value) {
    debouncer.call(() {
      if(double.tryParse(txtDiscount.text.replaceAll(',', '')) != null){
        // productCart.discountBase = double.parse(txtDiscount.text.toString().replaceAll(',', ''));
      }
      else if(value.isEmpty){
        txtDiscount.text = '0';
      }
      else{
        txtDiscount.text = value;
      }

      bindingController();
    });

    // const duration = Duration(milliseconds:800); // set the duration that you want call search() after that.
    // if (searchOnStoppedTyping != null) {
    //   setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    // }
    //
    // searchOnStoppedTyping = Timer(duration, ()
    // {
    //   if(double.tryParse(txtDiscount.text.replaceAll(',', '')) != null){
    //     // productCart.discountBase = double.parse(txtDiscount.text.toString().replaceAll(',', ''));
    //   }
    //   else if(value.isEmpty){
    //     txtDiscount.text = '0';
    //   }
    //   else{
    //     txtDiscount.text = value;
    //   }
    //
    //   bindingController();
    // });
  }
}
