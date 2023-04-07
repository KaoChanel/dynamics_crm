import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dynamics_crm/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:badges/badges.dart';
import 'package:dynamics_crm/models/sales_order.dart';
import 'package:dynamics_crm/models/sales_order_line.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../config/global_constants.dart';
import '../models/activity.dart';
import '../models/item.dart';
import '../models/remark.dart';
import '../models/sales_quote_line.dart';
import '../ui/location_maps.dart';
import '../ui/portrait/item_edit_portrait.dart';

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
      return Text('THB');
    } else {
      return Text('%');
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

    await showDialog(
      barrierDismissible: dismiss,
      context: context,
      builder: (BuildContext context) {
        return Consumer(builder: (context, ref, _) {
          AlertDialog alert = AlertDialog(
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        strokeWidth: 7.0,
                      )
                  ),
                  Container(
                    // margin: EdgeInsets.only(left: 7),
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Text(ref.watch(loadingMessage), style: const TextStyle(fontSize: 18.0))
                  ),
                ],),
            ),
          );

          if(dismiss == false){
            return WillPopScope(
                child: alert,
                onWillPop: () async => false);
          }
          else {
            return alert;
          }
        });
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

  static showRemark(BuildContext context, List<Remark> allRemarks) async {
    List<ListTile> tiles = [];

    for (var obj in allRemarks) {
      tiles.add(ListTile(
        title: Text(obj.remark ?? ''),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        onTap: () => Navigator.pop(context, obj)
      ));
    }

    var alert = AlertDialog(
        elevation: 0,
        title: const Text('ข้อความ'),
        content: Container(
            width: 500,
            height: 300,
            child: ListView(children: tiles)
        )
    );

    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
                            backgroundColor: Colors.grey[300]!,
                          ),
                          // child: Badge(
                          //   shape: BadgeShape.square,
                          //   borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                          //   badgeColor: Colors.grey[300]!,
                          //   // badgeContent: Text(' ${e.inveName}', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold, color: Colors.black54)),
                          // ),
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

                          ),
                          // Badge(
                          //   shape: BadgeShape.square,
                          //   badgeColor: Colors.lightBlue[300]!,
                          //   padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                          //   borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          //   badgeContent: const Text('จองไปแล้ว', style: TextStyle(color: Colors.white),),
                          // ),
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

  static datePicker(BuildContext context, DateTime? initialDate, {int minYear = 1985, int maxYear = 5}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(), // Refer step 1
      firstDate: DateTime(minYear),
      lastDate: DateTime(DateTime.now().year + maxYear, DateTime.now().month, DateTime.now().day),
    );

    if (picked != null && picked != initialDate) {
      initialDate = picked;
    }

    return picked;
  }

  static datetimePicker(BuildContext context, DateTime? initialDate, {int minYear = 1985, int maxYear = 5}) async {
    await DatePicker.showTimePicker(context,
        showTitleActions: true,
        locale: LocaleType.th,
        // minTime: DateTime(minYear),
        // maxTime: DateTime(maxYear),
        currentTime: initialDate,
        onChanged: (date) {
          print('change $date');
        },
        onConfirm: (date) {
          print('confirm $date');
        });
  }

  static Future<DateTime?> dayPicker(BuildContext context, int cycleDay, int cycleHour, int cycleMinute) async {
    int dayInMonth = 31;
    int hour = 24;
    DateTime cycle = DateTime(2020, 1, cycleDay, cycleHour, cycleMinute);

    return await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => Container(
          height: 220,
          padding: const EdgeInsets.only(top: 5.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: Scaffold(
            body: SafeArea(
              top: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.pop(context);
                      //   },
                      //   child: Text('ยกเลิก', textAlign: TextAlign.left, style: TextStyle(color: Colors.grey),),
                      // ),
                      Container(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, cycle);
                        },
                        child: const Text('ตกลง', textAlign: TextAlign.right,),
                      )
                    ],
                  ),
                  Row(
                    children: const [
                      Expanded(child: Text('รอบวันที่', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
                      Expanded(child: Text('ชั่วโมง', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
                      Expanded(child: Text('นาที', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)))
                    ],
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: 32,
                            scrollController: FixedExtentScrollController(initialItem: cycleDay - 1),
                            // This is called when selected item is changed.
                            onSelectedItemChanged: (int selectedItem) {
                              cycleDay = selectedItem + 1;
                              cycle = DateTime(2000, 1, cycleDay, cycleHour, cycleMinute);
                            },
                            children:
                            List<Widget>.generate(dayInMonth, (int index) {
                              return Center(
                                child: Text(
                                  '${index + 1}',
                                ),
                              );
                            }),
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: 32,
                            scrollController: FixedExtentScrollController(initialItem: cycleHour - 1),
                            // This is called when selected item is changed.
                            onSelectedItemChanged: (int selectedItem) {
                              cycleHour = selectedItem + 1;
                              cycle = DateTime(2000, 1, cycleDay, cycleHour, cycleMinute);
                            },
                            children:
                            List<Widget>.generate(hour, (int index) {
                              return Center(
                                child: Text(
                                  LEADING_ZERO.format(index + 1),
                                ),
                              );
                            }),
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: 32,
                            scrollController: FixedExtentScrollController(initialItem: (cycleMinute / 5).round()),
                            // This is called when selected item is changed.
                            onSelectedItemChanged: (int selectedItem) {
                              cycleMinute = selectedItem * 5;
                              cycle = DateTime(2000, 1, cycleDay, cycleHour, cycleMinute);
                            },
                            children:
                            List<Widget>.generate(12, (int index) {
                              return Center(
                                child: Text(
                                  LEADING_ZERO.format((index) * 5),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  static launchInBrowser(String url) async {
    Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        // forceSafariVC: false,
        // forceWebView: false,
        // headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static miniMap(BuildContext context, LatLng myLocation) {
    late GoogleMapController mapController;
    Marker myMarkers = Marker(
        markerId: const MarkerId('mark1'),
        position: LatLng(myLocation.latitude, myLocation.longitude),
        infoWindow: const InfoWindow(title: 'ตำแหน่งของฉัน', snippet: 'BIS Group Office')
    );

    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: myLocation, zoom: 18),
      markers: (myLocation == null)
          ? <Marker>{}
          : {
        Marker(
          markerId: MarkerId('mark1'),
          position: myLocation ?? DEFAULT_LOCATION,
        ),
      },
      onMapCreated: _onMapCreated,
      onTap: (LatLng tapLocation) async {
        LatLng? res = await Navigator.push(context, MaterialPageRoute(builder: (context) => LocationMaps(location: myLocation, activity: Activity.locationCollect,)));

        if(res != null) {
          myLocation = res;
        }
      },
    );
  }

  static Widget inlineInfo(String leading, String message, [String trailing = '']) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading.isEmpty ? const Text('') : Expanded(flex: 1,child: Text('$leading ', style: GREY_STYLE,),),
          Expanded(child: Text('$message $trailing')),
        ],
      ),
    );
  }

  static showAwesomeSnackBar(BuildContext context, ContentType type, String title, String message) async {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      // margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.30),
      content: AwesomeSnackbarContent(
        title: title,
        message: message,

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: type,
      ),
    );

    return ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static showAwesomeMaterial(BuildContext context, ContentType type, String title, String message) async {
    final materialBanner = MaterialBanner(
      elevation: 0,
      backgroundColor: Colors.transparent,
      forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
        // to configure for material banner
        inMaterialBanner: true,
      ),
      actions: const [SizedBox.shrink()],
    );

    return ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(materialBanner);
  }

  static saleQuoteDetail(BuildContext context, List<SalesQuoteLine> orders) {
    return ListView(
      primary: false,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),

      children: orders.map((e) {

        String goodsCode = ITEMS.firstWhere((item) => item.id == e.itemId).code ?? '';
        String goodsName = ITEMS.firstWhere((item) => item.id == e.itemId).displayName ?? '';
        String unitName = UNITS.firstWhere((unit) => unit.id == e.unitOfMeasureId).displayName ?? '';

        Color flagFreeColor = e.unitPrice == 0 ? Colors.lightGreen : Colors.orangeAccent;

        return ListTile(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${e.sequence}. ($goodsCode) $goodsName', style: const TextStyle(fontSize: 14.0),),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      child: Badge(
                        // toAnimate: false,
                        // shape: BadgeShape.square,
                        backgroundColor: flagFreeColor,
                        // borderRadius: BorderRadius.circular(15.0),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text('สินค้า${e.unitPrice == 0 ? 'แถมฟรี' : 'เพื่อขาย'}', style: const TextStyle(color: Colors.white, fontSize: 12.0)),
                        ),
                      ),
                    ),

                    Text(' ${CURRENCY.format(e.quantity)} x $unitName', style: const TextStyle(fontSize: 14.0),),
                  ],
                )
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('ส่วนลด ${e.discountType == 'PER' ? '${CURRENCY.format(e.discountAmount)}%' : CURRENCY.format(e.discountAmount)}', style: const TextStyle(fontSize: 14.0),)
              ),
              Row(
                children: [
                  TextButton(
                    child: const Text('แก้ไข'),
                    onPressed: () async {
                      var res = await Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => ItemEditPortrait(editItem: toSalesOrderLineSingle(quote: e))
                          )
                      );

                      if(res != null) {
                        // if(res == 'Remove') {
                        //   globals.productCartQuot.removeWhere((x) => x.rowIndex == e.sequence);
                        //
                        //   /// Re-Index
                        //   int row = 1;
                        //   globals.productCartQuot.forEach((x) => x.rowIndex = row++);
                        // }
                        // else{
                        //   globals.productCartQuot[globals.productCartQuot.indexWhere((x) => x.rowIndex == e.rowIndex)] = res;
                        // }
                      }
                    },
                  ),

                  TextButton(
                      onPressed: (){
                        int index = 1;
                        // globals.productCartQuot.removeWhere(
                        //         (element) => element.rowIndex == e.rowIndex);
                        // globals.productCartQuot.forEach((element) {
                        //   element.rowIndex = index++;
                        // });
                        // globals.editingProductCart = null;
                        // print(globals.productCartQuot?.length.toString());
                      },
                      child: const Text('ลบรายการ')
                  )
                ],
              )
              // Expanded(
              //     child: Text('฿ ${currency.format(e.goodAmnt)}', textAlign: TextAlign.right,)
              // )
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CURRENCY.format(e.unitPrice)),
              Text(CURRENCY.format(e.netAmount), style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),),
            ],
          ),
        );
      }).toList(),
    );
  }

  static saleOrderDetail(BuildContext context, List<SalesOrderLine> orders) {
    return ListView(
      primary: false,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),

      children: orders.map((e) {

        String goodsCode = ITEMS.firstWhere((item) => item.id == e.itemId).code ?? '';
        String goodsName = ITEMS.firstWhere((item) => item.id == e.itemId).displayName ?? '';
        String unitName = UNITS.firstWhere((unit) => unit.id == e.unitOfMeasureId).displayName ?? '';

        Color flagFreeColor = e.unitPrice == 0 ? Colors.lightGreen : Colors.orangeAccent;

        return ListTile(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${e.sequence}. ($goodsCode) $goodsName', style: const TextStyle(fontSize: 14.0),),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      child: Badge(
                        // toAnimate: false,
                        // shape: BadgeShape.square,
                        backgroundColor: flagFreeColor,
                        // borderRadius: BorderRadius.circular(15.0),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text('สินค้า${e.unitPrice == 0 ? 'แถมฟรี' : 'เพื่อขาย'}', style: const TextStyle(color: Colors.white, fontSize: 12.0)),
                        ),
                      ),
                    ),

                    Text(' ${CURRENCY.format(e.quantity)} x $unitName', style: const TextStyle(fontSize: 14.0),),
                  ],
                )
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('ส่วนลด ${e.discountType == 'PER' ? '${CURRENCY.format(e.discountAmount)}%' : CURRENCY.format(e.discountAmount)}', style: const TextStyle(fontSize: 14.0),)
              ),
              Row(
                children: [
                  TextButton(
                    child: const Text('แก้ไข'),
                    onPressed: () async {
                      var res = await Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => ItemEditPortrait(editItem: e)
                          )
                      );

                      if(res != null) {
                        // if(res == 'Remove') {
                        //   globals.productCartQuot.removeWhere((x) => x.rowIndex == e.sequence);
                        //
                        //   /// Re-Index
                        //   int row = 1;
                        //   globals.productCartQuot.forEach((x) => x.rowIndex = row++);
                        // }
                        // else{
                        //   globals.productCartQuot[globals.productCartQuot.indexWhere((x) => x.rowIndex == e.rowIndex)] = res;
                        // }
                      }
                    },
                  ),

                  TextButton(
                      onPressed: (){
                        int index = 1;
                        // globals.productCartQuot.removeWhere(
                        //         (element) => element.rowIndex == e.rowIndex);
                        // globals.productCartQuot.forEach((element) {
                        //   element.rowIndex = index++;
                        // });
                        // globals.editingProductCart = null;
                        // print(globals.productCartQuot?.length.toString());
                      },
                      child: const Text('ลบรายการ')
                  )
                ],
              )
              // Expanded(
              //     child: Text('฿ ${currency.format(e.goodAmnt)}', textAlign: TextAlign.right,)
              // )
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CURRENCY.format(e.unitPrice)),
              Text(CURRENCY.format(e.netAmount), style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),),
            ],
          ),
        );
      }).toList(),
    );
  }
}

