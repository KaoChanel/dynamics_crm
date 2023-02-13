import 'package:dynamics_crm/ui/portrait/sales_order_create_portrait.dart';
import 'package:flutter/material.dart';

import '../widgets/menu_card.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  double widthRate = 2;

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    widthRate = widthSize > 720 ? 4 : 2;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
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
                              const MenuCard(title:'ประวัติเข้าเยี่ยม', path:'assets/checkin_01.jpg'),
                              Positioned.fill(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius:
                                        BorderRadius.circular(10),
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
                            const MenuCard(title:'ประวัติการสั่งซื้อ', path:'assets/order_02.jpg'),
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
                                                const SalesOrderCreatePortrait()));

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
                        const MenuCard(title:'วิเคราะห์ขาย สินค้า', path:'assets/analysis_02.jpg'),
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
                        const MenuCard(title:'วิเคราะห์ขาย ลูกค้า', path:'assets/analysis_05.jpg'),
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
                        const MenuCard(title:'สินค้าคงคลัง', path:'assets/business_inventory.jpg'),
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
                        const MenuCard(title:'บิลค้างชำระ', path:'assets/overdue_01.jpg'),
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
                        const MenuCard(title: 'ใบเสนอราคา', path: 'assets/sales_quotation_01.jpg'),
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
                        const MenuCard(title:'เอกสารของคุณ', path:'assets/invoices_01.jpg'),
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
