// To parse this JSON data, do
//
//     final salesOrder = salesOrderFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

SalesOrder salesOrderFromJson(String str) => SalesOrder.fromJson(json.decode(str));

List<SalesOrder> salesOrderListFromJson(String str) => List<SalesOrder>.from(json.decode(str).map((x) => SalesOrder.fromJson(x)));

String salesOrderToJson(SalesOrder data) => json.encode(data.toJson());

class SalesOrder {
  SalesOrder({
    this.systemId,
    this.documentType,
    this.documentDate,
    this.no,
    this.quoteno,
    this.salespersonCode,
    this.completelyshipped,
    this.sellToCustomerNo,
    this.yourReference,
    this.shipToCode,
    this.orderDate,
    this.dueDate,
    this.postingDate,
    this.shipmentDate,
    this.paymentTermsCode,
    this.shipmentMethodCode,
    this.locationCode,
    this.shortcutDimension1Code,
    this.shortcutDimension2Code,
    this.currencyCode,
    this.customerPostingGroup,
    this.externalDocumentNo,
    this.paymentMethodCode,
    this.shippingAgentCode,
    this.subtotal = 0,
    this.vatamount = 0,
    this.discountType = 'PER',
    this.invdiscountamt = 0,
    this.invdiscountpct = 0,
    this.aftrdiscountTotal = 0,
    this.grandtotal = 0,
    this.status,
    this.bisStatus,
    this.bisSalesPerson,
    this.smartsalesref,
    this.salecmttxt = '',
    this.createDateTime,
    // this.id,
    // this.number,
    // this.orderDate,
    // this.customerId,
    // this.contactId,
    // this.customerNumber,
    // this.customerName,
    // this.billingPostalAddress,
    // this.currencyId,
    // this.currencyCode,
    // this.pricesIncludeTax,
    // this.paymentTermsId,
    // this.salesperson,
    // this.partialShipping,
    // this.requestedDeliveryDate,
    // this.discountType = 'PER',
    // this.discountAmount = 0,
    // this.discountAppliedBeforeTax,
    // this.totalAmountExcludingTax,
    // this.totalTaxAmount,
    // this.totalAmountIncludingTax,
    // this.netAmount = 0,
    // this.fullyShipped,
    // this.status,
    // this.lastModifiedDateTime,
    // this.remark = ''
  });

  String? systemId;
  String? documentType;
  DateTime? documentDate;
  String? no;
  String? quoteno;
  bool? completelyshipped;
  String? sellToCustomerNo;
  String? yourReference;
  String? shipToCode;
  DateTime? orderDate;
  DateTime? dueDate;
  DateTime? postingDate;
  DateTime? shipmentDate;
  String? paymentTermsCode;
  String? shipmentMethodCode;
  String? locationCode;
  String? shortcutDimension1Code;     // Department
  String? shortcutDimension2Code;     // Branch
  String? currencyCode;
  String? customerPostingGroup;
  String? salespersonCode;
  String? externalDocumentNo;
  String? paymentMethodCode;
  String? shippingAgentCode;
  double? subtotal;
  double? nonvatamount;
  double? vatbaseamount;
  double? vatamount;
  String discountType;
  double? invdiscountamt;
  double? invdiscountpct;
  double? aftrdiscountTotal;
  double? grandtotal;
  String? status;
  String? bisStatus;
  String? bisSalesPerson;
  String? smartsalesref;
  String salecmttxt;
  DateTime? createDateTime;
  // String? id;
  // String? number;
  // String? referenceNumber;
  // DateTime? orderDate;
  // String? customerId;
  // String? contactId;
  // String? customerNumber;
  // String? customerName;
  // BillingPostalAddress? billingPostalAddress;
  // String? currencyId;
  // String? currencyCode;
  // bool? pricesIncludeTax = false;
  // String? paymentTermsId;
  // String? salesperson;
  // bool? partialShipping;
  // DateTime? requestedDeliveryDate;
  // String? discountType;
  // double? discount = 0;
  // double? discountAmount = 0;
  // bool? discountAppliedBeforeTax;
  // double? totalAmountExcludingTax = 0;
  // double? totalTaxAmount = 0;
  // double? totalAmountIncludingTax = 0;
  // double netAmount = 0;
  // bool? fullyShipped = false;
  // String? status = 'OPEN';
  // String? lastDocumentNumber;
  // DateTime? lastModifiedDateTime;
  // String remark;

  SalesOrder copyWith({
    String? systemId,
    String? documentType,
    DateTime? documentDate,
    String? no,
    String? quoteno,
    bool? completelyshipped,
    String? sellToCustomerNo,
    String? yourReference,
    String? shipToCode,
    DateTime? orderDate,
    DateTime? postingDate,
    DateTime? shipmentDate,
    String? paymentTermsCode,
    DateTime? dueDate,
    String? shipmentMethodCode,
    String? locationCode,
    String? shortcutDimension1Code,
    String? shortcutDimension2Code,
    String? currencyCode,
    String? customerPostingGroup,
    String? salespersonCode,
    String? externalDocumentNo,
    String? paymentMethodCode,
    String? shippingAgentCode,
    double? subtotal = 0,
    double? vatamount = 0,
    String discountType = 'PER',
    double? invdiscountamt = 0,
    double? invdiscountpct = 0,
    double? aftrdiscountTotal = 0,
    double? grandtotal = 0,
    String? status = '',
    String? bisStatus = '',
    String? bisSalesPerson = '',
    String? smartsalesref = '',
    String salecmttxt = '',
  }) =>
      SalesOrder(
        systemId: systemId ?? this.systemId,
        documentType: documentType ?? this.documentType,
        no: no ?? this.no,
        quoteno: quoteno ?? this.quoteno,
        completelyshipped: completelyshipped ?? this.completelyshipped,
        sellToCustomerNo: sellToCustomerNo ?? this.sellToCustomerNo,
        yourReference: yourReference ?? this.yourReference,
        shipToCode: shipToCode ?? this.shipToCode,
        orderDate: orderDate ?? this.orderDate,
        postingDate: postingDate ?? this.postingDate,
        shipmentDate: shipmentDate ?? this.shipmentDate,
        paymentTermsCode: paymentTermsCode ?? this.paymentTermsCode,
        dueDate: dueDate ?? this.dueDate,
        shipmentMethodCode: shipmentMethodCode ?? this.shipmentMethodCode,
        locationCode: locationCode ?? this.locationCode,
        shortcutDimension1Code: shortcutDimension1Code ?? this.shortcutDimension1Code,
        shortcutDimension2Code: shortcutDimension2Code ?? this.shortcutDimension2Code,
        currencyCode: currencyCode ?? this.currencyCode,
        customerPostingGroup: customerPostingGroup ?? this.customerPostingGroup,
        salespersonCode: salespersonCode ?? this.salespersonCode,
        documentDate: documentDate ?? this.documentDate,
        externalDocumentNo: externalDocumentNo ?? this.externalDocumentNo,
        paymentMethodCode: paymentMethodCode ?? this.paymentMethodCode,
        shippingAgentCode: shippingAgentCode ?? this.shippingAgentCode,
        status: status ?? this.status,
        bisStatus: bisStatus ?? this.bisStatus,
        bisSalesPerson: bisSalesPerson ?? this.bisSalesPerson,
        smartsalesref: smartsalesref ?? this.smartsalesref,
        subtotal: subtotal ?? this.subtotal,
        vatamount: vatamount ?? this.vatamount,
        invdiscountamt: invdiscountamt ?? this.invdiscountamt,
        invdiscountpct: invdiscountpct ?? this.invdiscountpct,
        aftrdiscountTotal: aftrdiscountTotal ?? this.aftrdiscountTotal,
        grandtotal: grandtotal ?? this.grandtotal,
      );

  factory SalesOrder.fromJson(Map<String, dynamic> json) => SalesOrder(
    systemId: json["systemId"],
    documentType: json["documentType"],
    no: json["no"],
    quoteno: json["quoteno"],
    subtotal: json["subtotal"],
    vatamount: json["vatamount"],
    invdiscountamt: json["invdiscountamt"],
    invdiscountpct: json["invdiscountpct"],
    grandtotal: json["grandtotal"],
    completelyshipped: json["completelyshipped"],
    sellToCustomerNo: json["sellToCustomerNo"],
    yourReference: json["yourReference"],
    shipToCode: json["shipToCode"],
    orderDate: json["orderDate"] == null ? null : DateTime.parse(json["orderDate"]),
    postingDate: json["postingDate"] == null ? null : DateTime.parse(json["postingDate"]),
    shipmentDate: json["shipmentDate"] == null ? null : DateTime.parse(json["shipmentDate"]),
    paymentTermsCode: json["paymentTermsCode"],
    dueDate: json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
    shipmentMethodCode: json["shipmentMethodCode"],
    locationCode: json["locationCode"],
    shortcutDimension1Code: json["shortcutDimension1Code"],
    shortcutDimension2Code: json["shortcutDimension2Code"],
    currencyCode: json["currencyCode"],
    customerPostingGroup: json["customerPostingGroup"],
    salespersonCode: json["salespersonCode"],
    documentDate: json["documentDate"] == null ? null : DateTime.parse(json["documentDate"]),
    externalDocumentNo: json["externalDocumentNo"],
    paymentMethodCode: json["paymentMethodCode"],
    shippingAgentCode: json["shippingAgentCode"],
    status: json["status"],
    bisStatus: json["bisStatus"],
    bisSalesPerson: json["bisSalesPerson"],
    smartsalesref: json["smartsalesref"],
  );

  Map<String, dynamic> toJson() => {
    "systemId": systemId,
    "documentType": documentType,
    "no": no,
    "quoteno": quoteno,
    "subtotal": subtotal,
    "vatamount": vatamount,
    "invdiscountamt": invdiscountamt,
    "invdiscountpct": invdiscountpct,
    "grandtotal": grandtotal,
    "completelyshipped": completelyshipped,
    "sellToCustomerNo": sellToCustomerNo,
    "yourReference": yourReference,
    "shipToCode": shipToCode,
    "orderDate": "${orderDate!.year.toString().padLeft(4, '0')}-${orderDate!.month.toString().padLeft(2, '0')}-${orderDate!.day.toString().padLeft(2, '0')}",
    "postingDate": "${postingDate!.year.toString().padLeft(4, '0')}-${postingDate!.month.toString().padLeft(2, '0')}-${postingDate!.day.toString().padLeft(2, '0')}",
    "shipmentDate": "${shipmentDate!.year.toString().padLeft(4, '0')}-${shipmentDate!.month.toString().padLeft(2, '0')}-${shipmentDate!.day.toString().padLeft(2, '0')}",
    "paymentTermsCode": paymentTermsCode,
    "dueDate": "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
    "shipmentMethodCode": shipmentMethodCode,
    "locationCode": locationCode,
    "shortcutDimension1Code": shortcutDimension1Code,
    "shortcutDimension2Code": shortcutDimension2Code,
    "currencyCode": currencyCode,
    "customerPostingGroup": customerPostingGroup,
    "salespersonCode": salespersonCode,
    "documentDate": "${documentDate!.year.toString().padLeft(4, '0')}-${documentDate!.month.toString().padLeft(2, '0')}-${documentDate!.day.toString().padLeft(2, '0')}",
    "externalDocumentNo": externalDocumentNo,
    "paymentMethodCode": paymentMethodCode,
    "shippingAgentCode": shippingAgentCode,
    "status": status,
    "bisStatus": bisStatus,
    "bisSalesPerson": bisSalesPerson,
    "smartsalesref": smartsalesref,
  };
}

class BillingPostalAddress {
  BillingPostalAddress({
    this.street,
    this.city,
    this.state,
    this.countryLetterCode,
    this.postalCode,
  });

  String? street;
  String? city;
  String? state;
  String? countryLetterCode;
  String? postalCode;

  BillingPostalAddress copyWith({
    String? street,
    String? city,
    String? state,
    String? countryLetterCode,
    String? postalCode,
  }) =>
      BillingPostalAddress(
        street: street ?? this.street,
        city: city ?? this.city,
        state: state ?? this.state,
        countryLetterCode: countryLetterCode ?? this.countryLetterCode,
        postalCode: postalCode ?? this.postalCode,
      );

  factory BillingPostalAddress.fromJson(Map<String, dynamic> json) => BillingPostalAddress(
    street: json["street"] == null ? null : json["street"],
    city: json["city"] == null ? null : json["city"],
    state: json["state"] == null ? null : json["state"],
    countryLetterCode: json["countryLetterCode"] == null ? null : json["countryLetterCode"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
  );

  Map<String, dynamic> toJson() => {
    "street": street == null ? null : street,
    "city": city == null ? null : city,
    "state": state == null ? null : state,
    "countryLetterCode": countryLetterCode == null ? null : countryLetterCode,
    "postalCode": postalCode == null ? null : postalCode,
  };
}

class SalesOrderNotifier extends StateNotifier<SalesOrder> {
  SalesOrderNotifier(): super(SalesOrder());

  SalesOrder get() {
    return state;
  }

  void edit(SalesOrder item) {
    state = item;
  }

  void remove(SalesOrder item) {
    state = SalesOrder();
  }
}

class SalesOrderListNotifier extends StateNotifier<List<SalesOrder>> {
  SalesOrderListNotifier(super.state);

  List<SalesOrder> get() => state;

  List<SalesOrder> getBy(String keyword) {
    List<SalesOrder> result = state.where((e) => e.no != null ? e.no!.toLowerCase().contains(keyword.toLowerCase()) : false
        || e.quoteno != null ? e.quoteno!.toLowerCase().contains(keyword.toLowerCase()) : false
        || e.salespersonCode != null ? e.salespersonCode!.toLowerCase().contains(keyword.toLowerCase()) : false
        || e.sellToCustomerNo != null ? e.sellToCustomerNo!.toLowerCase().contains(keyword.toLowerCase()) : false
        || e.status != null ? e.status!.toLowerCase().contains(keyword.toLowerCase()) : false
        || e.bisStatus != null ? e.bisStatus!.toLowerCase().contains(keyword.toLowerCase()) : false
        || e.grandtotal != null ? e.grandtotal!.toString().contains(keyword.toLowerCase()) : false
    ).toList();

    return result;
  }

  void add(SalesOrder object) {
    state = [...state, object];
  }

  void addAll(List<SalesOrder> objects) {
    for(var item in objects) {
      state = [...state, item];
    }
  }

  void replace(List<SalesOrder> elements) {
    state = elements;
  }

  void edit(SalesOrder object) {
    state = [
      for(var row in state)
        if(row.systemId == object.systemId)
          row = object
        else
          row
    ];
  }

  void remove(SalesOrder object) {
    state = [
      for (final element in state)
        if (element.systemId != object.systemId) element,
    ];
  }

  void clear() => state = [];
}
