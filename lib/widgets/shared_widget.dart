import 'package:badges/badges.dart';
import 'package:dynamics_crm/models/sales_order.dart';
import 'package:dynamics_crm/models/sales_order_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/global_constants.dart';
import '../models/item.dart';

class SharedWidgets {
  // static Widget buildAppBar({String? title}) {
  //   return AppBar(
  //     title: Text(title),
  //   );
  // }
  //
  // static Widget buildButton({
  //   @required String label,
  //   @required VoidCallback onPressed,
  // }) {
  //   return RaisedButton(
  //     child: Text(label),
  //     onPressed: onPressed,
  //   );
  // }

  static Widget discountType(String discountType) {
    if (discountType == 'THB') {
      return const Text('THB');
    } else {
      return const Text('%');
    }
  }

  static showAlert(BuildContext context, String title, String content) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close")
                )
              ]
          );
        }
    );
  }

  static showLoader(BuildContext context, bool dismiss) async {
    // var alert = Consumer<MessageDialog>(
    //   builder: (context, dialog, child) =>
    //       AlertDialog(
    //         content: Container(
    //           height: 120,
    //           child: Column(
    //             children: [
    //               const SizedBox(
    //                   width: 60,
    //                   height: 60,
    //                   child: CircularProgressIndicator(
    //                     strokeWidth: 7.0,
    //                   )
    //               ),
    //               Container(
    //                 // margin: EdgeInsets.only(left: 7),
    //                   padding: EdgeInsets.only(top: 25.0),
    //                   child:Text(dialog.message, style: TextStyle(fontSize: 18.0),)
    //               ),
    //             ],),
    //         ),
    //       ),
    // );

    AlertDialog alert = AlertDialog(
      content: Container(
        height: 120,
        child: Column(
          children: [
            SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 7.0,
                )
            ),
            Container(
              // margin: EdgeInsets.only(left: 7),
                padding: const EdgeInsets.only(top: 25.0),
                child: const Text('กำลังโหลด', style: TextStyle(fontSize: 18.0))
            ),
          ],),
      ),
    );

    await showDialog(
      barrierDismissible: dismiss,
      context: context,
      builder: (BuildContext context) {
        if(dismiss == false){
          return WillPopScope(
              child: alert,
              onWillPop: () async => false);
        }
        else {
          return alert;
        }
      },
    );
  }

  static showConfirm(BuildContext context, String title, String content, String confirmText, String cancelText) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(confirmText)
                ),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(cancelText)
                ),
              ]
          );
        }
    );
  }

  static showStock(BuildContext context, String goodId) async {
    double goodRemainQty = 0;
    String unitName = '';
    var numberFormat = NumberFormat("#,##0.00", "en_US");

    // var reserve = allStockReserve.where((e) => e.goodId == goodId) ?? null;
    var stockByProd = ITEMS
        .where((e) => e.id == goodId)
        .toList();

    // if(reserve.length > 0) {
    //   goodRemainQty = reserve.first.goodRemaQty1;
    //   unitName = reserve.first.goodUnitName;
    // }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('สินค้าคงเหลือ'),
          contentPadding: const EdgeInsets.all(8.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width,
                // alignment: Alignment.center,
                child: ListView(
                  primary: false,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: stockByProd.map((e) => ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Badge(
                            shape: BadgeShape.square,
                            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                            badgeColor: Colors.grey[300]!,
                            // badgeContent: Text(' ${e.inveName}', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold, color: Colors.black54)),
                          ),
                        ),
                        // Text('Lot No. ${e.lotNo}', style: TextStyle(fontSize: 14.0)),
                      ],
                    ),
                    // subtitle: Text('${numberFormat.format(e.remaqty)} ${e.goodUnitCode}'),
                    // title: Row(
                    //   children: [
                    //     Expanded(
                    //       child: Text(e.inveName),
                    //     ),
                    //     Expanded(
                    //       child: Text('Lot No. ' +
                    //           e.lotNo
                    //       ),
                    //     ),
                    //     Expanded(child: Text('คงเหลือ:  ' +
                    //         numberFormat.format(e.remaqty), textAlign: TextAlign.right,))
                    //   ],
                    // ),
                    // subtitle: Row(
                    //   children: [
                    //     Expanded(
                    //       child: Text('คลัง' + e.inveName),
                    //     ),
                    //     Expanded(
                    //       child: Text('หมดอายุ:  ' +
                    //           dateFormat.format(e.expiredate)),
                    //     ),
                    //     Expanded(child: Text('หน่วยนับ: ' + e.goodUnitCode, textAlign: TextAlign.right,))
                    //   ],
                    // ),
                    onTap: () => Navigator.pop(context),
                  )).toList() ?? [],
                ),
              ),
              Column(
                children: [
                  Container(
                    child: goodRemainQty > 0 ? ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Badge(
                            shape: BadgeShape.square,
                            badgeColor: Colors.lightBlue[300]!,
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            badgeContent: const Text('จองไปแล้ว', style: TextStyle(color: Colors.white),),
                          ),
                          Text(numberFormat.format(goodRemainQty))
                        ],
                      ),
                      subtitle: Container(
                          alignment: Alignment.centerRight,
                          child: Text(unitName)
                      ),
                    ) : Text('ยังไม่มียอดจองสินค้า'),
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(8.0),
                  //     alignment: Alignment.center,
                  //     child: goodRemainQty > 0 ? Text('จองไปแล้ว                    ${numberFormat.format(goodRemainQty)}               $unitName') : Text('ยังไม่มียอดจองสินค้า')
                  // ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  static showDiscountType(BuildContext context, SalesOrder header) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            elevation: 0,
            title: const Text('ประเภทส่วนลด'),
            content: Container(
                width: 250,
                height: 180,
                child: ListView(children: [
                  ListTile(
                      onTap: () {
                        header.discountType = 'THB';
                        Navigator.pop(context);

                      },
                      selected: header.discountType == 'THB',
                      selectedTileColor: Colors.black12,
                      title: const Text('THB')),
                  ListTile(
                    onTap: () {
                      header.discountType = 'PER';
                      Navigator.pop(context);

                    },
                    selected: header.discountType == 'PER',
                    selectedTileColor: Colors.black12,
                    title: const Text('%'),
                  )
                ])
            )
        );
      },
    );
  }
}

