import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../models/sales_target.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  bool loadSuccess = false;
  bool isShowingMainData = false;
  int touchedIndex = 0;
  double summary = 0;
  String companyLogo = '';
  int star = 0;
  double yearSale = 0;
  double targetAmount = 0;
  String congratsText = '';
  late Color congratsColors;

  List<SalesTarget> target = [];
  // List<Sales> allSales = <Sales>[];
  // List<Sales> allSalesDaily = <Sales>[];
  // List<Sales> allSalesMonthly = <Sales>[];
  // List<Sales> allSalesLastYear = <Sales>[];
  // List<TopCustomer> topCustomers = [];
  // List<TopProduct> topProducts = [];
  // List<TopProvince> topProvinces = [];
  // List<TopOverdue> topOverdue = [];

  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  MapShapeSource? mapSource;
  MapZoomPanBehavior? _zoomPanBehavior;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isShowingMainData = true;

    _tabController = TabController(length: 5, initialIndex: TAB_INDEX.index, vsync: this,);
    _tabController.addListener(() {
      switch(_tabController.index) {
        case 0 : TAB_INDEX = Activity.total;
        break;
        case 1 : TAB_INDEX = Activity.target;
        break;
        case 2 : TAB_INDEX = Activity.topCustomer;
        break;
        case 3 : TAB_INDEX = Activity.topProduct;
        break;
        case 4 : TAB_INDEX = Activity.topProvince;
        break;

        default : TAB_INDEX = Activity.total;
      }
    });

    switch(MY_COMPANY.name) {
      case 'BIO' :
        companyLogo = 'bio.png';
        break;
      case 'NIC' :
        companyLogo = 'nic.png';
        break;
      case 'PEDEX' :
        companyLogo = 'pedex.png';
        break;
      case 'PTK' :
        companyLogo = 'ptk_black.png';
        break;
      case 'SIS' :
        companyLogo = 'sis.png';
        break;
      case 'FAITH' :
        companyLogo = 'faith.png';
        break;

      default : companyLogo = 'pedex.png';
    }
  }

  cycleLabel() {
    String label = '';
    if(CHART_CYCLE == Activity.monthly){
      label = 'ยอดภายในเดือน';
    }
    else if(CHART_CYCLE == Activity.quarterly){
      label = 'ยอดรายไตรมาส';
    }
    else{
      label = 'ยอดรายปี';
    }

    return Text(label, style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal, letterSpacing: 2.0, color: Colors.black38));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/bg_04.jpg"),
                                    fit: BoxFit.fitWidth
                                )
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: Stack(
                                  children: [
                                    Container(
                                      height: 100,
                                      alignment: const Alignment(0.0, 0.0),
                                      child: Image.asset("assets/logo/$companyLogo", width: 300,),
                                    ),
                                    Container(
                                      alignment: const Alignment(0.0, 5.0),
                                      child: const CircleAvatar(
                                        backgroundImage: AssetImage("assets/avatar_01.png"),
                                        radius: 60.0,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                          Text(
                            "${EMPLOYEE.code ?? ''}\n${EMPLOYEE.name ?? ''}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20.0,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Text(
                          //   globals.employee?.postName ?? 'Technician & Product Adviser',
                          //   style: TextStyle(
                          //       fontSize: 18.0,
                          //       color:Colors.black45,
                          //       letterSpacing: 2.0,
                          //       fontWeight: FontWeight.w300
                          //   ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            MY_COMPANY.displayName ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16.0,
                                color:Colors.black45,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w300
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Divider(color: Colors.grey,),
                          ),
                          TabBar(
                            controller: _tabController,
                            labelStyle: GoogleFonts.kanit(fontSize: 14.0, fontWeight: FontWeight.bold),
                            tabs: const [
                              Tab(child: Text('ยอดขาย')),
                              Tab(child: Text('เป้าหมาย')),
                              Tab(child: Text('รายลูกค้า')),
                              Tab(child: Text('รายสินค้า')),
                              Tab(child: Text('จังหวัด')),
                            ],
                            onTap: (index) => index == 0 ? TAB_INDEX = Activity.total
                                : index == 1 ? TAB_INDEX = Activity.target
                                : index == 2 ? TAB_INDEX = Activity.topCustomer
                                : index == 3 ? TAB_INDEX = Activity.topProduct
                                : index == 4 ? TAB_INDEX = Activity.topProvince
                                : TAB_INDEX = Activity.total,
                          )
                        ],
                      )
                  ),
                ];
              },
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                  // labelColor: Colors.green,
                  // labelStyle: Theme.of(context).textTheme.bodyText1,
                  controller: _tabController,
                  children: [
                    ListView(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(20.0),
                            alignment: Alignment.center,
                            child: Text(
                              CURRENCY.format(summary),
                              style: const TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                // fontFamily: 'Anton',
                                // fontFamily: 'Bebas Neue',
                                // shadows: [
                                //   Shadow(
                                //     blurRadius: 10.0,
                                //     color: Colors.black,
                                //     offset: Offset(0.0, 5.0),
                                //   ),
                                // ],
                                // foreground: Paint()..shader = linearGradient
                              ),
                            )
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: cycleLabel(),
                        ),

                        // Container(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: createChart(allSales == null ? <Sales>[] : allSales, isShowingMainData),
                        // ),
                      ],
                    ),
                    ListView(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i=0; i < star; i++)
                                const Icon(Icons.star_rounded, size: 32.0, color: Colors.amber,),
                            ],
                          ),
                        ),
                        Text(CURRENCY.format(targetAmount), style: const TextStyle(fontSize: 24.0), textAlign: TextAlign.center,),
                        SfRadialGauge(
                          axes: [
                            target.length > 0 ? RadialAxis(
                                minimum: 0,
                                maximum: targetAmount,
                                axisLineStyle: const AxisLineStyle(thickness: 0.15, thicknessUnit: GaugeSizeUnit.factor,),
                                ranges: [
                                  GaugeRange(startValue: 0,endValue: (targetAmount / 3.0).toDouble(),color: Colors.red,startWidth: 15,endWidth: 15),
                                  GaugeRange(startValue: (targetAmount / 3.0).toDouble(),endValue: (targetAmount / 1.5).toDouble(),color: Colors.orange,startWidth: 15,endWidth: 15),
                                  GaugeRange(startValue: (targetAmount / 1.5).toDouble(),endValue: (targetAmount).toDouble(),color: Colors.lightGreen,startWidth: 15,endWidth: 15)
                                ],
                                pointers: <GaugePointer>[
                                  NeedlePointer(
                                      value: yearSale ?? 0,
                                      needleStartWidth: 1,
                                      needleEndWidth: 5,
                                      knobStyle: const KnobStyle(
                                          knobRadius: 0.05,
                                          borderColor: Colors.black45,
                                          borderWidth: 0.02,
                                          color: Colors.white)
                                  )],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: Text(NumberFormat.compact().format(yearSale), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                      angle: 90,
                                      positionFactor: 0.5
                                  )
                                ]
                            ) : RadialAxis(
                                minimum: 0,
                                maximum: 180,
                                axisLineStyle: const AxisLineStyle(thickness: 0.15, thicknessUnit: GaugeSizeUnit.factor,),
                                pointers: <GaugePointer>[
                                  NeedlePointer(
                                      value: yearSale ?? 0,
                                      needleStartWidth: 1,
                                      needleEndWidth: 5,
                                      knobStyle: const KnobStyle(
                                          knobRadius: 0.05,
                                          borderColor: Colors.black,
                                          borderWidth: 0.02,
                                          color: Colors.white)
                                  )],
                                ranges: [
                                  GaugeRange(startValue: 0,endValue: 60,color: Colors.red,startWidth: 15,endWidth: 15),
                                  GaugeRange(startValue: 60,endValue: 120,color: Colors.orange,startWidth: 15,endWidth: 15),
                                  GaugeRange(startValue: 120,endValue: 180,color: Colors.lightGreen,startWidth: 15,endWidth: 15)
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: Text(NumberFormat.compact().format(yearSale), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.normal)),
                                      angle: 90,
                                      positionFactor: 0.5
                                  )
                                ]
                            )
                          ],
                        ),
                        Text(congratsText, style: GoogleFonts.kanit(fontWeight: FontWeight.normal, fontSize: 22.0, color: Colors.black38), textAlign: TextAlign.center,)
                      ],
                    ),
                    ListView(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i=0; i < star; i++)
                                const Icon(Icons.star_rounded, size: 32.0, color: Colors.amber,),
                            ],
                          ),
                        ),
                        Text(CURRENCY.format(targetAmount), style: const TextStyle(fontSize: 24.0), textAlign: TextAlign.center,),
                        SfRadialGauge(
                          axes: [
                            target.length > 0 ? RadialAxis(
                                minimum: 0,
                                maximum: targetAmount,
                                axisLineStyle: const AxisLineStyle(thickness: 0.15, thicknessUnit: GaugeSizeUnit.factor,),
                                ranges: [
                                  GaugeRange(startValue: 0,endValue: (targetAmount / 3.0).toDouble(),color: Colors.red,startWidth: 15,endWidth: 15),
                                  GaugeRange(startValue: (targetAmount / 3.0).toDouble(),endValue: (targetAmount / 1.5).toDouble(),color: Colors.orange,startWidth: 15,endWidth: 15),
                                  GaugeRange(startValue: (targetAmount / 1.5).toDouble(),endValue: (targetAmount).toDouble(),color: Colors.lightGreen,startWidth: 15,endWidth: 15)
                                ],
                                pointers: <GaugePointer>[
                                  NeedlePointer(
                                      value: yearSale ?? 0,
                                      needleStartWidth: 1,
                                      needleEndWidth: 5,
                                      knobStyle: const KnobStyle(
                                          knobRadius: 0.05,
                                          borderColor: Colors.black45,
                                          borderWidth: 0.02,
                                          color: Colors.white)
                                  )],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: Text(NumberFormat.compact().format(yearSale), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                      angle: 90,
                                      positionFactor: 0.5
                                  )
                                ]
                            ) : RadialAxis(
                                minimum: 0,
                                maximum: 180,
                                axisLineStyle: const AxisLineStyle(thickness: 0.15, thicknessUnit: GaugeSizeUnit.factor,),
                                pointers: <GaugePointer>[
                                  NeedlePointer(
                                      value: yearSale ?? 0,
                                      needleStartWidth: 1,
                                      needleEndWidth: 5,
                                      knobStyle: const KnobStyle(
                                          knobRadius: 0.05,
                                          borderColor: Colors.black,
                                          borderWidth: 0.02,
                                          color: Colors.white)
                                  )],
                                ranges: [
                                  GaugeRange(startValue: 0,endValue: 60,color: Colors.red,startWidth: 15,endWidth: 15),
                                  GaugeRange(startValue: 60,endValue: 120,color: Colors.orange,startWidth: 15,endWidth: 15),
                                  GaugeRange(startValue: 120,endValue: 180,color: Colors.lightGreen,startWidth: 15,endWidth: 15)
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: Text(NumberFormat.compact().format(yearSale), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.normal)),
                                      angle: 90,
                                      positionFactor: 0.5
                                  )
                                ]
                            )
                          ],
                        ),
                        Text(congratsText, style: GoogleFonts.kanit(fontWeight: FontWeight.normal, fontSize: 22.0, color: Colors.black38), textAlign: TextAlign.center,)
                      ],
                    ),
                    ListView(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i=0; i < star; i++)
                                const Icon(Icons.star_rounded, size: 32.0, color: Colors.amber,),
                            ],
                          ),
                        ),
                        Text(CURRENCY.format(targetAmount), style: const TextStyle(fontSize: 24.0), textAlign: TextAlign.center,),
                        SfRadialGauge(
                          axes: [
                            target.length > 0 ? RadialAxis(
                                minimum: 0,
                                maximum: targetAmount,
                                axisLineStyle: const AxisLineStyle(thickness: 0.15, thicknessUnit: GaugeSizeUnit.factor,),
                                ranges: [
                                  GaugeRange(startValue: 0,endValue: (targetAmount / 3.0).toDouble(),color: Colors.red,startWidth: 15,endWidth: 15),
                                  GaugeRange(startValue: (targetAmount / 3.0).toDouble(),endValue: (targetAmount / 1.5).toDouble(),color: Colors.orange,startWidth: 15,endWidth: 15),
                                  GaugeRange(startValue: (targetAmount / 1.5).toDouble(),endValue: (targetAmount).toDouble(),color: Colors.lightGreen,startWidth: 15,endWidth: 15)
                                ],
                                pointers: <GaugePointer>[
                                  NeedlePointer(
                                      value: yearSale ?? 0,
                                      needleStartWidth: 1,
                                      needleEndWidth: 5,
                                      knobStyle: const KnobStyle(
                                          knobRadius: 0.05,
                                          borderColor: Colors.black45,
                                          borderWidth: 0.02,
                                          color: Colors.white)
                                  )],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: Text(NumberFormat.compact().format(yearSale), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                      angle: 90,
                                      positionFactor: 0.5
                                  )
                                ]
                            ) : RadialAxis(
                                minimum: 0,
                                maximum: 180,
                                axisLineStyle: const AxisLineStyle(thickness: 0.15, thicknessUnit: GaugeSizeUnit.factor,),
                                pointers: <GaugePointer>[
                                  NeedlePointer(
                                      value: yearSale ?? 0,
                                      needleStartWidth: 1,
                                      needleEndWidth: 5,
                                      knobStyle: const KnobStyle(
                                          knobRadius: 0.05,
                                          borderColor: Colors.black,
                                          borderWidth: 0.02,
                                          color: Colors.white)
                                  )],
                                ranges: [
                                  GaugeRange(startValue: 0,endValue: 60,color: Colors.red,startWidth: 15,endWidth: 15),
                                  GaugeRange(startValue: 60,endValue: 120,color: Colors.orange,startWidth: 15,endWidth: 15),
                                  GaugeRange(startValue: 120,endValue: 180,color: Colors.lightGreen,startWidth: 15,endWidth: 15)
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: Text(NumberFormat.compact().format(yearSale), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.normal)),
                                      angle: 90,
                                      positionFactor: 0.5
                                  )
                                ]
                            )
                          ],
                        ),
                        Text(congratsText, style: GoogleFonts.kanit(fontWeight: FontWeight.normal, fontSize: 22.0, color: Colors.black38), textAlign: TextAlign.center,)
                      ],
                    ),
                    // ListView(
                    //   children: [
                    //     topCustomers.length > 0 ? pieChartCustomers() : Container(child: Text('ไม่มีรายงานสั่งซื้อจากลูกค้า'), padding: EdgeInsets.symmetric(vertical: 20.0), alignment: Alignment.center),
                    //     topOverdue.length > 0 ? pieChartOverdue() : Container(child: Text('ไม่มีค้างชำระเกินกำหนด'), padding: EdgeInsets.symmetric(vertical: 20.0), alignment: Alignment.center)
                    //   ],
                    // ),
                    // ListView(
                    //   children: [
                    //     topProducts.length > 0 ? pieChartBoxProducts() : Container(child: Text('ไม่มีรายงานขายสินค้า'), padding: EdgeInsets.symmetric(vertical: 20.0), alignment: Alignment.center,),
                    //   ],
                    // ),
                    Container(
                      // padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                      child: mapSource != null ? SfMaps(
                          layers: [
                            MapShapeLayer(
                              source: mapSource!,
                              showDataLabels: true,
                              legend: const MapLegend.bar(
                                MapElement.shape,
                                position: MapLegendPosition.bottom,
                                labelsPlacement: MapLegendLabelsPlacement.betweenItems,
                                segmentPaintingStyle: MapLegendPaintingStyle.gradient,
                              ),
                              zoomPanBehavior: _zoomPanBehavior,
                              dataLabelSettings: MapDataLabelSettings(textStyle: TextStyle()),
                              loadingBuilder: (context) => CircularProgressIndicator(),
                              // bubbleSettings: const MapBubbleSettings(
                              //   maxRadius: 45,
                              //   minRadius: 15,
                              // ),
                            )
                          ]
                      ) : const Text(''),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
