import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dynamics_crm/models/activity.dart';
import 'package:dynamics_crm/models/billing_note.dart';
import 'package:dynamics_crm/models/inventory.dart';
import 'package:dynamics_crm/models/sales_quote.dart';
import 'package:dynamics_crm/models/sales_quote_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:dynamics_crm/models/business_type.dart';
import 'package:dynamics_crm/models/customer.dart';
import 'package:dynamics_crm/models/customer_financial_detail.dart';
import 'package:dynamics_crm/models/district.dart';
import 'package:dynamics_crm/models/employee.dart';
import 'package:dynamics_crm/models/employee_option.dart';
import 'package:dynamics_crm/models/province.dart';
import 'package:dynamics_crm/models/sales_order.dart';
import 'package:dynamics_crm/models/sales_shipment.dart';
import 'package:dynamics_crm/models/system_option.dart';
import 'package:dynamics_crm/models/tax_group.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

import '../models/company.dart';
import '../models/customer_group.dart';
import '../models/customer_type.dart';
import '../models/district_sub.dart';
import '../models/dropdown.dart';
import '../models/item.dart';
import '../models/item_category.dart';
import '../models/item_group.dart';
import '../models/item_type.dart';
import '../models/order.dart';
import '../models/sales_order_line.dart';
import '../models/unit.dart';
import '../models/zipcode.dart';
import '../ui/location_maps.dart';

import 'package:dynamics_crm/providers/data_provider.dart';

const String APP_NAME = 'SmartSales BIS';

// color for apps
const Color PRIMARY_COLOR = Color.fromRGBO(50, 54, 130, 1.0);
const Color ASSENT_COLOR = Color(0xFFe2e92b);

// TextStyle
const TextStyle GREY_STYLE = TextStyle(color: Colors.grey,);

Company MY_COMPANY = Company(
    name: 'BioScience Animal Health', displayName: 'BioScience Animal Health');
String SERVER_ERP_URL = 'http://app05.naviworldth.com:19028/BIS_Live/api/nwth/bis/v2.0/';
String SERVER_BIS_URL = 'https://smartsalesbis.com/api/';
String GOOGLE_MAP_API = 'AIzaSyCgCn4EebVBR3d0dXLFBwlXa8I1_WXSQDI';
String FCM_TOKEN = '';
LatLng DEFAULT_LOCATION = const LatLng(13.9271307, 100.5330154);

List<Item> ITEMS = [];

// late List<Item> ITEMS = [
//   Item(
//       id: '1001',
//       code: 'P1000',
//       displayName: 'อาหารสุนัข',
//       baseUnitOfMeasureId: '1000',
//       baseUnitOfMeasureCode: 'Bag',
//       unitPrice: 159
//   ),
//   Item(
//       id: '1002',
//       code: 'P1001',
//       displayName: 'อาหารแมว',
//       baseUnitOfMeasureId: '1000',
//       baseUnitOfMeasureCode: 'Bag',
//       unitPrice: 115
//   ),
//   Item(
//       id: '1003',
//       code: 'P1002',
//       displayName: 'อาหารหมู',
//       baseUnitOfMeasureId: '1000',
//       baseUnitOfMeasureCode: 'Bag',
//       unitPrice: 95
//   ),
//   Item(
//       id: '1004',
//       code: 'P1003',
//       displayName: 'อาหารปลา',
//       baseUnitOfMeasureId: '1000',
//       baseUnitOfMeasureCode: 'Bag',
//       unitPrice: 65
//   ),
//   Item(
//       id: '1005',
//       code: 'P1004',
//       displayName: 'อาหารไก่และเป็ด',
//       baseUnitOfMeasureId: '1000',
//       baseUnitOfMeasureCode: 'Bag',
//       unitPrice: 80
//   ),
//   Item(
//       id: '1006',
//       code: 'P1005',
//       displayName: 'วัคซีน Vaccine',
//       baseUnitOfMeasureId: '1001',
//       baseUnitOfMeasureCode: 'Pack',
//       unitPrice: 890
//   )
// ];

// late List<Unit> UNITS = [
//   Unit(id: '1000', code: 'PCS', displayName: 'PCS'),
//   Unit(id: '1001', code: 'Box', displayName: 'Box'),
//   Unit(id: '1002', code: 'Bag', displayName: 'Bag'),
//   Unit(id: '1003', code: 'Pack', displayName: 'Pack')
// ];

List<Unit> UNITS = [];

Activity TAB_INDEX = Activity.total;
Activity CHART_CYCLE = Activity.monthly;
late TaxGroup TAX = TaxGroup();
late SystemOption SYSTEM_OPTION = SystemOption(loadDocItem: 50, limitRadius: 50.0);
late Customer CUSTOMER = Customer();
late SalesShipment SHIPMENT = SalesShipment();
late CustomerFinancialDetail? CUSTOMER_FINANCIAL;
late LocationData? CUSTOMER_LOCATION = null;
List<SalesShipment> CUSTOMER_SHIPMENTS = [];
Employee EMPLOYEE = Employee();
late EmployeeOption? EMPLOYEE_OPTION;
late List<Inventory> INVENTORY = [];

List<Province> PROVINCES = [];
List<District> DISTRICTS = [];
List<DistrictSub> DISTRICT_SUB = [];
List<ZipCode> ZIPCODE = [];

List<ItemCategory> ITEM_CATEGORY = [
  ItemCategory(displayName: 'กลุ่มลูกค้าเป้าหมาย'),
  ItemCategory(displayName: 'วางบิล'),
  ItemCategory(displayName: 'เก็บเช็ค'),
  ItemCategory(displayName: 'อื่น ๆ'),
];

List<ItemGroup> ITEM_GROUP = [
  ItemGroup(displayName: 'กลุ่มลูกค้าเป้าหมาย'),
  ItemGroup(displayName: 'วางบิล'),
  ItemGroup(displayName: 'เก็บเช็ค'),
  ItemGroup(displayName: 'อื่น ๆ'),
];

List<ItemType> ITEM_TYPE = [
  ItemType(displayName: 'กลุ่มลูกค้าเป้าหมาย'),
  ItemType(displayName: 'วางบิล'),
  ItemType(displayName: 'เก็บเช็ค'),
  ItemType(displayName: 'อื่น ๆ'),
];

List<BusinessType> LIVESTOCK_GROUP = [
  BusinessType(displayName: 'วัสถุดิบ'),
  BusinessType(displayName: 'สารเสริม'),
  BusinessType(displayName: 'Vaccine'),
  BusinessType(displayName: 'อาหารเม็ด'),
  BusinessType(displayName: 'อื่น ๆ'),
];

List<BusinessType> LIVESTOCK_TYPE = [
  BusinessType(displayName: 'สุกร'),
  BusinessType(displayName: 'ไก่เนื้อ'),
  BusinessType(displayName: 'ไก่ไข่'),
  BusinessType(displayName: 'เป็ด'),
  BusinessType(displayName: 'วัว'),
  BusinessType(displayName: 'ปลา'),
  BusinessType(displayName: 'อื่น ๆ'),
];

List<BusinessType> PET_TYPE = [
  BusinessType(displayName: 'ผลิตภัณฑ์ - อาหารสัตว์เลี้ยง / วัคซีน'),
  BusinessType(displayName: 'เครื่องตรวจเลือด'),
  BusinessType(displayName: 'อื่น ๆ'),
];

List<BusinessType> BUSINESS_TYPE = [
  BusinessType(displayName: 'โรงพยาบาลสัตว์'),
  BusinessType(displayName: 'คลินิค'),
  BusinessType(displayName: 'เพ็ทชอป'),
  BusinessType(displayName: 'สถานพยาบาล'),
  BusinessType(displayName: 'หน่วยงานราชการ'),
  BusinessType(displayName: 'บริษัท'),
  BusinessType(displayName: 'บุคคลธรรมดา'),
  BusinessType(displayName: 'ฟาร์ม'),
  BusinessType(displayName: 'Agent'),
  BusinessType(displayName: 'Integrate'),
  BusinessType(displayName: 'Feed Mills'),
  BusinessType(displayName: 'Distributor'),
];

List<CustomerGroup> CUSTOMER_GROUP = [
  CustomerGroup(title: 'กลุ่มลูกค้าเป้าหมาย', sequence: 1),
  CustomerGroup(title: 'วางบิล', sequence: 2),
  CustomerGroup(title: 'เก็บเช็ค', sequence: 3),
  CustomerGroup(title: 'อื่น ๆ', sequence: 4),
];

List<CustomerType> CUSTOMER_TYPE = [
  CustomerType(title: 'กลุ่มลูกค้าเป้าหมาย', sequence: 1),
  CustomerType(title: 'วางบิล', sequence: 2),
  CustomerType(title: 'เก็บเช็ค', sequence: 3),
  CustomerType(title: 'อื่น ๆ', sequence: 4),
];

final ORDER_STATUS = <Dropdown>[
  Dropdown(
    value: 'ALL',
    title: 'ทั้งหมด',
  ),
  Dropdown(
    value: 'OPEN',
    title: 'ฉบับร่าง',
  ),
  Dropdown(
    value: 'RELEASE',
    title: 'รอดำเนินการ',
  ),
];

List<Customer> MY_CUSTOMERS = [
  Customer(id: '1', code: '10-100-001', displayName: 'บริษัท เมืองทอง รักสัตว์ จำกัด (สาขา 1)', latitude: DEFAULT_LOCATION.latitude.toString(), longitude: DEFAULT_LOCATION.longitude.toString()),
  Customer(id: '2', code: '10-100-002', displayName: 'บริษัท เมืองทอง รักสัตว์ จำกัด (สาขา 2)'),
  Customer(id: '3', code: '10-100-003', displayName: 'บริษัท เมืองทอง รักสัตว์ จำกัด (สาขา 3)'),
  Customer(id: '4', code: '10-100-004', displayName: 'บริษัท เมืองทอง รักสัตว์ จำกัด (สาขา 4)'),
  Customer(id: '5', code: '10-100-005', displayName: 'บริษัท เมืองทอง รักสัตว์ จำกัด (สาขา 5)'),
  Customer(id: '6', code: '10-100-006', displayName: 'บริษัท เมืองทอง รักสัตว์ จำกัด (สาขา 6)'),
];

List<SalesOrder> SALES_ORDER = [];
// List<SalesOrder> SALES_ORDER = [
//   SalesOrder(customerId: '1', customerNumber: '10-100-001', customerName: 'บริษัท เมืองทอง รักสัตว์ จำกัด (สาขา 1)', id: '1', number: 'SO-230113-0002', requestedDeliveryDate: DateTime.now(), discountType: 'PER', discountAmount: 5, status: 'DRAFT'),
//   SalesOrder(customerId: '2', customerNumber: '10-100-002', customerName: 'บริษัท เมืองทอง รักสัตว์ จำกัด (สาขา 2)', id: '3', number: 'SO-230112-0002', requestedDeliveryDate: DateTime.now(), discountType: 'PER', discountAmount: 3, status: 'OPEN'),
//   SalesOrder(customerId: '1', customerNumber: '10-100-001', customerName: 'บริษัท เมืองทอง รักสัตว์ จำกัด (สาขา 1)', id: '1', number: 'SO-230112-0001', requestedDeliveryDate: DateTime.now(), discountType: 'THB', discountAmount: 99, status: 'OPEN'),
// ];

List<SalesOrderLine> SALES_ORDER_LINES = [
  SalesOrderLine(
    documentId: '1',
    sequence: 1,
    itemId: '1001',
    quantity: 1,
    unitOfMeasureId: '1001',
    unitPrice: 100,
    discountType: 'PER',
    discountPercent: 0,
    discountAmount: 0,
    netAmount: 100
  ),
  SalesOrderLine(
    documentId: '1',
    sequence: 2,
    itemId: '1004',
    quantity: 3,
    unitOfMeasureId: '1001',
    unitPrice: 100,
    discountType: 'PER',
    discountPercent: 0,
    discountAmount: 0,
    netAmount: 300
  ),
  SalesOrderLine(
    documentId: '1',
    sequence: 3,
    itemId: '1001',
    quantity: 1,
    unitOfMeasureId: '1001',
    unitPrice: 100,
    discountType: 'PER',
    discountPercent: 0,
    discountAmount: 0,
    netAmount: 100
  ),
  SalesOrderLine(
    documentId: '3',
    sequence: 1,
    itemId: '1004',
    quantity: 1,
    unitOfMeasureId: '1001',
    unitPrice: 100,
    discountType: 'PER',
    discountPercent: 0,
    discountAmount: 0,
    netAmount: 100
  ),
  SalesOrderLine(
    documentId: '3',
    sequence: 2,
    itemId: '1001',
    quantity: 1,
    unitOfMeasureId: '1001',
    unitPrice: 100,
    discountType: 'PER',
    discountPercent: 0,
    discountAmount: 0,
    netAmount: 100
  ),
  SalesOrderLine(
    documentId: '3',
    sequence: 3,
    itemId: '1006',
    quantity: 2,
    unitOfMeasureId: '1001',
    unitPrice: 800,
    discountType: 'PER',
    discountPercent: 0,
    discountAmount: 0,
    netAmount: 1600
  ),
];

var companies = <Company>[
  Company(
    name: 'BIO',
    displayName: 'BioScience Animal Health'
  ),
  Company(
    name: 'NIC',
    displayName: 'Nutrition Improvement Company'
  ),
  Company(
    name: 'SIS',
    displayName: 'Special Ingredient Services'
  ),
  Company(
    name: 'FAITH',
    displayName: 'Feed And Ingredient Technology Hub'
  ),
  Company(
    name: 'PEDEX',
    displayName: 'PedEx'
  ),
  Company(
    name: 'IDEXX',
    displayName: 'IDEXX'
  ),
  // Company(
  //   compCode: 'PEDEXTEST',
  //   compName: 'PED EX (Test)',
  // ),
  Company(
    name: 'PTK',
    displayName: 'Pro Test-Kit'
  ),
  // Company(
  //   compCode: 'BIOTEST',
  //   compName: 'BioScience Animal Health (Test)',
  // ),
  // Company(
  //   compCode: 'NICTEST',
  //   compName: 'Nutrition Improvement (Test)',
  // ),
  // Company(
  //   compCode: 'IDEXXTEST',
  //   compName: 'IDEXX (Test)',
  // ),
  // Company(
  //   compCode: 'PEDEXTEST',
  //   compName: 'PED EX (Test)',
  // ),

  // Company(
  //   compCode: 'PTKTEST',
  //   compName: 'PROTEST KIT (Test)',
  // ),

  // Company(
  //   compCode: 'SISTEST',
  //   compName: 'Special Ingredient Services (Test)',
  // ),
  // Company(
  //   compCode: 'FAITHTEST',
  //   compName: 'Feed And Ingredients Technological Hub (Test)',
  // ),
];

NumberFormat NUMBER_FORMAT = NumberFormat('#,###', 'en_US');
NumberFormat CURRENCY = NumberFormat('#,##0.00', 'en_US');
NumberFormat LEADING_ZERO = NumberFormat('#,#00', 'en_US');
DateFormat DATE_FORMAT = DateFormat('dd/MM/yyyy');
DateFormat DATE_FORMAT_TH = DateFormat('dd MMMM yyyy', 'th');

String COMPANIES_API = "${SERVER_ERP_URL}companies";
String EMPLOYEE_API = "${SERVER_ERP_URL}companies(${MY_COMPANY.id})/bissalepersons";
String CUSTOMER_API = "${SERVER_ERP_URL}companies(${MY_COMPANY.id})/customers";
String MY_CUSTOMER_API = "${SERVER_ERP_URL}customers?\$filter=id=''";
String ALL_CUSTOMER_API = "${SERVER_ERP_URL}customers?\$expand=picture, currency, paymentMethod";
String QUOTATION_API = "${SERVER_ERP_URL}companies(${MY_COMPANY.id})/salesquote";
String ORDERS_API = "${SERVER_ERP_URL}companies(${MY_COMPANY.id})/bissalesheaders";
String ORDERS_LINE_API = "${SERVER_ERP_URL}companies(${MY_COMPANY.id})/bissaleslines";
String SHIPMENT_API = "${SERVER_ERP_URL}companies(${MY_COMPANY.id})/bisshiptoaddresses";
String ITEMS_API = "${SERVER_ERP_URL}companies(${MY_COMPANY.id})/bisItemAPIs";
String UNITS_API = "${SERVER_ERP_URL}companies(${MY_COMPANY.id})/bisunitofmeasures";
String REMARK_API = "${SERVER_BIS_URL}SaleOrderHeader/GetTbmRemark/";
String NEWS_API = "${SERVER_BIS_URL}News/${MY_COMPANY.name}/";

extension ThaiDateFormatter on DateFormat {
  String formatInBuddhistCalendarThai(DateTime dateTime) {
    if (pattern!.contains('y')) {
      var buddhistDateTime = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond);

      if (locale.contains('th') || locale.contains('TH')) {
        var normalYear = buddhistDateTime.year ?? DateTime.now().year;
        var dateTimeString =
        format(buddhistDateTime).replaceAll('ค.ศ.', 'พ.ศ.');

        dateTimeString = dateTimeString.replaceAll(
            normalYear.toString(), (normalYear + 543).toString());

        if (pattern!.contains('yy')) {
          String thaiYearTwoDigit =
          (normalYear + 543).toString().substring(2, 4);

          dateTimeString =
              dateTimeString.substring(0, dateTimeString.length - 2);
          dateTimeString += thaiYearTwoDigit;
        }

        return dateTimeString;
      } else {
        var result = format(buddhistDateTime);
        return result;
      }
    }
    return format(dateTime);
  }
}

extension ListUtility<T> on List<T> {
  num sumBy(num Function(T element) f) {
    num sum = 0;
    for(var item in this) {
      sum += f(item);
    }
    return sum;
  }
}

readThailandInfo() async {
  // Read the JSON file
  // final file = File('assets/thailand_information/thailand.json');
  // final jsonString = await file.readAsString();

  // Parse the JSON
  final jsonString = await rootBundle.loadString('assets/thailand_information/thailand.json');
  return jsonDecode(jsonString);
}

loadProvince() async {
  String temp = '';
  PROVINCES = [];
  final data = await readThailandInfo();
  loadingMessage = StateProvider((ref) => 'ข้อมูลจังหวัด');

  data.forEach((obj) {
    if(obj != null) {
      if(temp != obj['province']) {
        temp = obj['province'];
        PROVINCES.add(Province(code: obj['province_code'], name: obj['province']));
      }
    }
  });
}

loadDistrict() async {
  String temp = '';
  DISTRICTS = [];
  final data = await readThailandInfo();
  loadingMessage = StateProvider((ref) => 'ข้อมูลอำเภอ');

  data.forEach((obj) {
    if(obj != null) {
      if(temp != obj['amphoe']) {
        temp = obj['amphoe'];
        DISTRICTS.add(District(code: obj['amphoe_code'], provinceName: obj['province'], name: obj['amphoe']));
      }
    }
  });
}

loadDistrictSub() async {
  String temp = '';
  DISTRICT_SUB = [];
  final data = await readThailandInfo();
  loadingMessage = StateProvider((ref) => 'ข้อมูลตำบล');

  data.forEach((obj) {
    if(obj != null) {
      if(temp != obj['district']) {
        temp = obj['district'];
        DISTRICT_SUB.add(DistrictSub(districtName: obj['amphoe'], code: obj['district_code'], name: obj['district'], zipCode: obj['zipcode'] == '' ? null : obj['zipcode']));
      }
    }
  });
}

checkEmpty(Object? value, [String errorText = 'ข้อมูลจำเป็น']) {
  if (value == null) {
    return errorText;
  }
  else{
    if(value.toString().isEmpty){
      return errorText;
    }
  }

  return null;
}

checkEmail(String? value) {
  checkEmpty(value);

  return null;
}

checkTaxId(String value) {
  checkEmpty(value);

  if(value.length == 13) {
    if(int.tryParse(value) == null){
      return 'ข้อมูลตัวเลขเท่านั้น';
    }
  }
  else{
    return 'จำนวนเลขไม่ครบ 13 หลัก';
  }

  return null;
}

bool checkQuantity(double qty) {
  if (qty == 0) {
    return false;
  }

  return true;
}

double stockCount(Inventory stock) {
  double amount = 0;
  INVENTORY.where((e) => e.goodid == stock.goodid).toList().forEach((e) => amount += e.remaqty ?? 0);

  return amount;
}

bool checkCredit(double netTotal) {
  if (SYSTEM_OPTION.isLockPriceLower == 'Y') {
    double limitAmount = CUSTOMER_FINANCIAL?.balance ?? 0;
    // double limitAmount = CUSTOMER_FINANCIAL. ?? 0 + CUSTOMER_FINANCIAL.creditTempIncrease ?? 0;
    if (limitAmount < netTotal) {
      return false;
    }
  }
  return true;
}

bool checkMixedVat(List<SalesOrderLine> items) {
  int vatAdded = items.where((e) => e.taxPercent! > 0).length;
  int vatFree = items.where((e) => e.taxPercent == 0).length;
  int itemCount = items.length;

  if (vatAdded == itemCount) {
    return true;
  }

  if (vatFree == itemCount) {
    return true;
  }

  return false;
}

bool canEditPrice() {
  if (SYSTEM_OPTION.isLockPrice == 'Y') {
    return true;
  }

  return false;
}

bool checkLowerPrice() {
  if (SYSTEM_OPTION.isLockPriceLower == 'Y') {
    return false;
  }

  return false;
}

changeDiscountType(String type){
  if(type == 'PER'){
    return 'THB';
  }

  return type;
}

changeCustomer(Customer customer) {
  CUSTOMER = customer;

  // globals.selectedShipto = globals.allShipto.firstWhere((e) => e.custId == customer.custId && e.isDefault == 'Y');
  // globals.selectedShiptoDraft = globals.selectedShipto;

  // widget.header.custId = customer.custId;
  // widget.header.custName = customer.custName;
  // widget.header.shipToCode = globals.selectedShipto.shiptoCode;
}

SalesOrderLine discountCalculate(bool type, String discount, SalesOrderLine orderItem) {
  if(discount.isNotEmpty) {
    double? discountNumber = double.tryParse(discount.replaceAll(',', ''));

    if(discountNumber != null){
      orderItem.discountAmount = discountNumber;

      if(type){
        orderItem.discountType = 'PER';
        orderItem.discountPercent = discountNumber;
        orderItem.discountAmount = orderItem.amountBeforeDiscount! * (orderItem.discountPercent! / 100);
      }
      else{
        orderItem.discountType = 'THB';
        orderItem.discountAmount = orderItem.discountAmount;
      }
    }
  }

  return orderItem;
}

amountCalculate(bool isPercent, String discount, SalesOrderLine orderItem) {
  if(orderItem.isFree) {
    orderItem.unitPrice = 0;
  }

  orderItem.amountBeforeDiscount = orderItem.quantity! * (orderItem.unitPrice ?? 0);
  orderItem = discountCalculate(isPercent, discount, orderItem);
  orderItem.netAmount = orderItem.amountBeforeDiscount! - orderItem.discountAmount!;

  return orderItem;
}

totalPrice() {

}

Order totalSummary(SalesOrder header, List<SalesOrderLine> orders) {
  try {
    double priceTotal = 0;
    double discountTotal = 0;
    double discountBill = 0;
    double priceAfterDiscount = 0;
    double vatTotal = 0.0;
    double netTotal = 0.0;

    if (orders.isNotEmpty) {

      for (var element in orders) {
        priceTotal += element.netAmount ?? 0;
        discountTotal += element.discountAmount ?? 0;
      }

    }

    discountBill = header.invdiscountamt ?? 0;
    //priceTotal = priceTotal - discountTotal;

    if (header.discountType == 'PER') {
      double percentDiscount = (header.invdiscountamt ?? 0) / 100;
      header.invdiscountamt = (percentDiscount * priceTotal);
      priceAfterDiscount = priceTotal - header.invdiscountamt!;
    } else {
      header.invdiscountamt = discountBill;
      priceAfterDiscount = priceTotal - header.invdiscountamt!;
    }

    double sumGoodsHasVat = 0;
    double sumGoodsHasNoVat = 0;

    if (orders.isNotEmpty) {
      orders
          .where((x) => x.taxPercent != null ? x.taxPercent! > 0 : false)
          .forEach((e) => sumGoodsHasVat += e.netAmount ?? 0);

      orders
          .where((x) => x.taxPercent != null ? x.taxPercent == 0 : false)
          .forEach((e) => sumGoodsHasNoVat += e.netAmount ?? 0);
    }

    // sumGoodsHasVat = sumGoodsHasVat - globals.discountBillDraft.amount;
    if(sumGoodsHasVat != 0) {
      sumGoodsHasVat = sumGoodsHasVat - header.grandtotal!;
    }
    else{
      sumGoodsHasNoVat = sumGoodsHasNoVat - header.grandtotal!;
    }

    print('sumGoodsHasVat : $sumGoodsHasVat');
    print('sumGoodsHasNoVat : $sumGoodsHasNoVat');

    double vatBase = 0;
    if (TAX.code == 'IN7') {
      vatBase = sumGoodsHasVat / 1.07;
      vatTotal = vatBase * 0.07;
      priceAfterDiscount = priceAfterDiscount - vatTotal;
      netTotal = vatBase + vatTotal + sumGoodsHasNoVat;

    } else if (TAX.code == 'EX7') {
      vatBase = sumGoodsHasVat;
      vatTotal = vatBase * 0.07;
      netTotal = vatBase + vatTotal + sumGoodsHasNoVat;
    } else {
      netTotal = priceAfterDiscount;
    }

    header.vatbaseamount = vatBase;
    header.invdiscountamt = discountBill;
    header.grandtotal = netTotal;

    return Order(header, orders);

  } catch (e) {
    throw Exception(e.toString());
  }
}

Widget docCounter(StreamController streamController) {
  return StreamBuilder(
    stream: streamController.stream,
    builder: (context, snapshot) {
      return Row(
        children: [
          const Expanded(
            child: Text(
              'รายการเอกสาร ',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Expanded(
            child: Text(
              '${snapshot.data ?? 0} รายการ',
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      );
    },
  );
}

double deg2rad(double deg) {
  return deg * pi / 180.0;
}
double rad2deg(double rad) {
  return rad * 180.0 / pi;
}

double distanceCalculate(LocationData customerLocation, LocationData currentLocation, String unit) {
  double theta = customerLocation.longitude! - currentLocation.latitude!;
  double dist = sin(deg2rad(customerLocation.longitude!)) * sin(deg2rad(currentLocation.latitude!)) + cos(deg2rad(customerLocation.longitude!)) * cos(deg2rad(currentLocation.latitude!)) * cos(deg2rad(theta));

  dist = acos(dist);
  dist = rad2deg(dist);
  dist = dist * 60 * 1.1515;

  if (unit == 'K') {
    dist = dist * 1.609344;
  } else if (unit == 'N') {
    dist = dist * 0.8684;
  }

  return double.parse(dist.toStringAsFixed(3));
}

double vatInclude(double summary, double vatBase) {
  double vatTotal = (summary / 1.07) * 0.07;
  return vatBase + vatTotal;
}

double vatExclude(double summary, double vatBase) {
  double vatTotal = vatBase * 0.07;
  return vatBase + vatTotal;
}

checkIn() {

}

// created method for getting user current location
Future<Position> getMyLocation() async {

  await Geolocator.requestPermission().then((value){
  }).onError((error, stackTrace) async {
    await Geolocator.requestPermission();
    print("ERROR"+error.toString());
  });

  return await Geolocator.getCurrentPosition();
}

changeLocationMarker(LatLng location) {
  // marker added for current users location.
  var markers = <Marker>{};
  markers.add(
      Marker(
        markerId: const MarkerId("01"),
        position: location,
        infoWindow: const InfoWindow(title: 'ตำแหน่งของฉัน',),
      )
  );

  return markers;
}

changeCameraPosition(LatLng location) {
  // specified current users location
  return CameraPosition(zoom: 22, target: location);
}

getBillingNote(BillingNote? note, [int? day, int? hour, int? minute]) {
  switch(note) {
    case BillingNote.no_billing :
      return 'ไม่ต้องวางบิล';
    case BillingNote.billing_note :
      return 'ต้องการวางบิล';
      case BillingNote.delivery_billling :
        return 'ส่งสินค้า & วางบิล';
  }
}

SalesQuoteLine toSalesQuote(SalesOrderLine orderItem) {
  SalesQuoteLine object = SalesQuoteLine()
    ..key = GlobalKey()
    ..itemId = orderItem.itemId
    ..id = const Uuid().v4()
    ..sequence = orderItem.sequence
    ..quantity = orderItem.quantity
    ..unitOfMeasureId = orderItem.unitOfMeasureId
    ..unitOfMeasureCode = orderItem.unitOfMeasureCode
    ..unitPrice = orderItem.unitPrice
    ..discount = orderItem.discountPercent
    ..discountAmount = orderItem.discountAmount
    ..totalTaxAmount = orderItem.totalTaxAmount
    ..amountIncludingTax = orderItem.amountIncludingTax
    ..amountExcludingTax = orderItem.amountExcludingTax
    ..netAmount = orderItem.netAmount
    ..netTaxAmount = orderItem.netTaxAmount
    ..netAmountIncludingTax = orderItem.netAmountIncludingTax
    ..isFree = false
    ..isSelect = false;

  return object;
}

toSalesOrder(SalesQuote quote){
  return SalesOrder()
    ..salespersonCode = quote.salesperson
    ..sellToCustomerNo = quote.customerNumber
    ..discountType = quote.discountType!
    ..invdiscountpct = quote.discount
    ..invdiscountamt = quote.discountAmount
    ..grandtotal = quote.netAmount ?? 0
    ..salecmttxt = quote.remark
    ..status = quote.status;
}

toSalesOrderLineSingle({Item? item, SalesQuoteLine? quote}) {
  if(item != null){
    return SalesOrderLine()
      ..key = GlobalKey()
      ..id = const Uuid().v4()
      ..itemId = item.id
      ..itemCode = item.no ?? ''
      ..itemName = item.description ?? ''
      ..unitOfMeasureId = item.baseUnitOfMeasure
      ..unitOfMeasureCode = item.baseuomdescription
      ..unitPrice = item.unitPrice
      ..isFree = false
      ..isSelect = false;
  }
  else{
    return SalesOrderLine()
      ..itemId = quote!.itemId
      ..itemVariantId = quote.itemVariantId
      ..sequence = quote.sequence
      ..quantity = quote.quantity
      ..unitOfMeasureId = quote.unitOfMeasureId
      ..unitOfMeasureCode = quote.unitOfMeasureCode
      ..unitPrice = quote.unitPrice
      ..discountType = quote.discountType
      ..discountAmount = quote.discountAmount
      ..netAmount = quote.netAmount;
  }

}

toSalesOrderLine(List<Item> items, [List<SalesQuoteLine>? quote, double qty = 0]) {
  List<SalesOrderLine> saleOrderDetails = [];
  List<SalesQuoteLine> saleQuoteDetails = [];

  if(quote != null) {
    return saleQuoteDetails;
  }
  else {
    int index = 0;
    for (var e in items) {
      index++;
      SalesOrderLine value = SalesOrderLine()
        ..key = GlobalKey()
        ..id = const Uuid().v4()
        ..itemId = e.id
        ..itemCode = e.no ?? ''
        ..itemName = e.description ?? ''
        ..sequence = index
        ..quantity = qty
        ..unitOfMeasureId = e.baseUnitOfMeasure
        ..unitOfMeasureCode = e.baseuomdescription
        ..unitPrice = e.unitPrice
        ..isFree = false
        ..isSelect = false;
      saleOrderDetails.add(value);
    }

    return saleOrderDetails;
  }
}
