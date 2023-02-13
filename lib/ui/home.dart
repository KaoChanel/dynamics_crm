import 'package:dynamics_crm/ui/portrait/customer_select.dart';
import 'package:dynamics_crm/ui/portrait/sales_quote_create_portrait.dart';
import 'package:flutter/material.dart';

import '../config/global_constants.dart';
import '../ui/sales_order_create.dart';
import '../ui/portrait/sales_order_create_portrait.dart';
import '../ui/portrait/sales_order_list_portrait.dart';

import '../widgets/menu_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double widthRate = 2;

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    widthRate = widthSize > 720 ? 4 : 2;

    TextEditingController txtCustomer = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      //Padding(padding: null)
                      // SizedBox(
                      // width: 60,
                      // child: Text('ลูกค้า : ',
                      //       style: TextStyle(fontSize: 18)),
                      // ),
                      Flexible(
                          child: TextFormField(
                              readOnly: true,
                              controller: txtCustomer,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                prefixIcon: Text(''),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(25.0))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                hintText: "ลูกค้าของคุณ",
                              ),
                              onTap: () async {
                                // globals.customerLocationPage = '';
                                var customer = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const CustomerSelect()));

                                if (customer != null) {
                                  setState(() {
                                    CUSTOMER = customer;
                                    txtCustomer.text = CUSTOMER?.displayName ?? '';
                                  });
                                }
                              })
                      ),
                    ],
                  )
              ),
              Wrap(
                children: <Widget>[
                  SizedBox(
                    width: widthSize / widthRate,
                    child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.white10, //Colors.white, //
                          BlendMode.saturation,
                        ),
                        child: Stack(
                          //height: 200,
                            children: [
                              const MenuCard(title: 'ตารางงาน', path: 'assets/work_schedule_03.jpg'),
                              Positioned.fill(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {
                                          // globals.customer_visit_page = '';
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             CustomerAppointmentTable()));
                                        },
                                      )
                                  )
                              )
                            ])
                    ),
                  ), // ตารางงาน
                  SizedBox(
                      width: widthSize / widthRate,
                      child: Stack(
                        //height: 200,
                          children: [
                            const MenuCard(title: 'ลูกค้าใหม่', path: 'assets/shakehand_02.jpg'),
                            Positioned.fill(
                                child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () async {
                                        // if (MY_COMPANY == null) {
                                        //   return showDialog(
                                        //     context: context,
                                        //     builder: (BuildContext context) =>
                                        //         CupertinoAlertDialog(
                                        //           title: Text("แจ้งเตือน"),
                                        //           content: Text(
                                        //             "กรุณาเลือกลูกค้าของคุณ",
                                        //             style: TextStyle(fontSize: 18),
                                        //           ),
                                        //           actions: [
                                        //             CupertinoDialogAction(
                                        //                 isDefaultAction: true,
                                        //                 onPressed: () =>
                                        //                     Navigator.pop(context),
                                        //                 child: Text("ปิดหน้าต่าง"))
                                        //           ],
                                        //         ),
                                        //   );
                                        // }
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CustomerSelect()));

                                        setState(() {});
                                      },
                                    )
                                )
                            )
                          ]
                      )
                  ),
                  SizedBox(
                      width: widthSize / widthRate,
                      child: Stack(children: [
                        const MenuCard(title: 'เข้าเยี่ยม', path: 'assets/visit_02.jpg'),
                        Positioned.fill(
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () async {
                                    var res = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const SalesOrderCreatePortrait()));

                                    if(res != null){
                                      setState(() {

                                      });
                                    }
                                  },
                                )
                            )
                        )
                      ])
                  ),
                  SizedBox(
                      width: widthSize / widthRate,
                      child: Stack(children: [
                        const MenuCard(title: 'บันทึกการเข้าเยี่ยม', path: 'assets/checkup_farm.jpg'),
                        Positioned.fill(
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () async {
                                    var res = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const SalesOrderCreatePortrait()));

                                    if(res != null){
                                      setState(() {

                                      });
                                    }
                                  },
                                )
                            )
                        )
                      ])
                  ),
                  SizedBox(
                      width: widthSize / widthRate,
                      child: Stack(children: [
                        const MenuCard(title: 'เสนอราคาขาย', path: 'assets/sales_quotation_02.png'),
                        Positioned.fill(
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () async {
                                    var res = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const SalesQuoteCreatePortrait()));

                                    if(res != null){
                                      setState(() {

                                      });
                                    }
                                  },
                                )
                            )
                        )
                      ])
                  ),
                  SizedBox(
                      width: widthSize / widthRate,
                      child: Stack(children: [
                        const MenuCard(title: 'สั่งขายสินค้า', path: 'assets/order_01.jpg'),
                        Positioned.fill(
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () async {
                                    var res = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const SalesOrderCreatePortrait()));

                                    if(res != null){
                                      setState(() {

                                      });
                                    }
                                  },
                                )
                            )
                        )
                      ])
                  ),
                  SizedBox(
                      width: widthSize / widthRate,
                      child: Stack(children: [
                        const MenuCard(title: 'คำสั่งขายของคุณ', path: 'assets/order_03.jpg'),
                        Positioned.fill(
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () async {
                                    var res = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const SalesOrderListPortrait()));

                                    if(res != null){
                                      setState(() {

                                      });
                                    }
                                  },
                                )
                            )
                        )
                      ])
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () async {
          // try {
          //   await globals.loadData(this.context);
          // } catch (error) {
          //   Navigator.pop(context);
          //   globals.showAlertDialog('Exception', error.toString(), context);
          // }
        },
      ),
    );
  }
}
