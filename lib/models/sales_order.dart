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
    this.id,
    this.number,
    this.orderDate,
    this.customerId,
    this.contactId,
    this.customerNumber,
    this.customerName,
    this.billingPostalAddress,
    this.currencyId,
    this.currencyCode,
    this.pricesIncludeTax,
    this.paymentTermsId,
    this.salesperson,
    this.partialShipping,
    this.requestedDeliveryDate,
    this.discountAmount,
    this.discountAppliedBeforeTax,
    this.totalAmountExcludingTax,
    this.totalTaxAmount,
    this.totalAmountIncludingTax,
    this.fullyShipped,
    this.status,
    this.lastModifiedDateTime,
  });

  String? id;
  String? number;
  DateTime? orderDate;
  String? customerId;
  String? contactId;
  String? customerNumber;
  String? customerName;
  BillingPostalAddress? billingPostalAddress;
  String? currencyId;
  String? currencyCode;
  bool? pricesIncludeTax;
  String? paymentTermsId;
  String? salesperson;
  bool? partialShipping;
  DateTime? requestedDeliveryDate;
  int? discountAmount;
  bool? discountAppliedBeforeTax;
  double? totalAmountExcludingTax;
  double? totalTaxAmount;
  double? totalAmountIncludingTax;
  bool? fullyShipped;
  String? status;
  DateTime? lastModifiedDateTime;

  SalesOrder copyWith({
    String? id,
    String? number,
    DateTime? orderDate,
    String? customerId,
    String? contactId,
    String? customerNumber,
    String? customerName,
    BillingPostalAddress? billingPostalAddress,
    String? currencyId,
    String? currencyCode,
    bool? pricesIncludeTax,
    String? paymentTermsId,
    String? salesperson,
    bool? partialShipping,
    DateTime? requestedDeliveryDate,
    int? discountAmount,
    bool? discountAppliedBeforeTax,
    double? totalAmountExcludingTax,
    double? totalTaxAmount,
    double? totalAmountIncludingTax,
    bool? fullyShipped,
    String? status,
    DateTime? lastModifiedDateTime,
  }) =>
      SalesOrder(
        id: id ?? this.id,
        number: number ?? this.number,
        orderDate: orderDate ?? this.orderDate,
        customerId: customerId ?? this.customerId,
        contactId: contactId ?? this.contactId,
        customerNumber: customerNumber ?? this.customerNumber,
        customerName: customerName ?? this.customerName,
        billingPostalAddress: billingPostalAddress ?? this.billingPostalAddress,
        currencyId: currencyId ?? this.currencyId,
        currencyCode: currencyCode ?? this.currencyCode,
        pricesIncludeTax: pricesIncludeTax ?? this.pricesIncludeTax,
        paymentTermsId: paymentTermsId ?? this.paymentTermsId,
        salesperson: salesperson ?? this.salesperson,
        partialShipping: partialShipping ?? this.partialShipping,
        requestedDeliveryDate: requestedDeliveryDate ?? this.requestedDeliveryDate,
        discountAmount: discountAmount ?? this.discountAmount,
        discountAppliedBeforeTax: discountAppliedBeforeTax ?? this.discountAppliedBeforeTax,
        totalAmountExcludingTax: totalAmountExcludingTax ?? this.totalAmountExcludingTax,
        totalTaxAmount: totalTaxAmount ?? this.totalTaxAmount,
        totalAmountIncludingTax: totalAmountIncludingTax ?? this.totalAmountIncludingTax,
        fullyShipped: fullyShipped ?? this.fullyShipped,
        status: status ?? this.status,
        lastModifiedDateTime: lastModifiedDateTime ?? this.lastModifiedDateTime,
      );

  factory SalesOrder.fromJson(Map<String, dynamic> json) => SalesOrder(
    id: json["id"] == null ? null : json["id"],
    number: json["number"] == null ? null : json["number"],
    orderDate: json["orderDate"] == null ? null : DateTime.parse(json["orderDate"]),
    customerId: json["customerId"] == null ? null : json["customerId"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    customerNumber: json["customerNumber"] == null ? null : json["customerNumber"],
    customerName: json["customerName"] == null ? null : json["customerName"],
    billingPostalAddress: json["billingPostalAddress"] == null ? null : BillingPostalAddress.fromJson(json["billingPostalAddress"]),
    currencyId: json["currencyId"] == null ? null : json["currencyId"],
    currencyCode: json["currencyCode"] == null ? null : json["currencyCode"],
    pricesIncludeTax: json["pricesIncludeTax"] == null ? null : json["pricesIncludeTax"],
    paymentTermsId: json["paymentTermsId"] == null ? null : json["paymentTermsId"],
    salesperson: json["salesperson"] == null ? null : json["salesperson"],
    partialShipping: json["partialShipping"] == null ? null : json["partialShipping"],
    requestedDeliveryDate: json["requestedDeliveryDate"] == null ? null : DateTime.parse(json["requestedDeliveryDate"]),
    discountAmount: json["discountAmount"] == null ? null : json["discountAmount"],
    discountAppliedBeforeTax: json["discountAppliedBeforeTax"] == null ? null : json["discountAppliedBeforeTax"],
    totalAmountExcludingTax: json["totalAmountExcludingTax"] == null ? null : json["totalAmountExcludingTax"].toDouble(),
    totalTaxAmount: json["totalTaxAmount"] == null ? null : json["totalTaxAmount"].toDouble(),
    totalAmountIncludingTax: json["totalAmountIncludingTax"] == null ? null : json["totalAmountIncludingTax"].toDouble(),
    fullyShipped: json["fullyShipped"] == null ? null : json["fullyShipped"],
    status: json["status"] == null ? null : json["status"],
    lastModifiedDateTime: json["lastModifiedDateTime"] == null ? null : DateTime.parse(json["lastModifiedDateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "number": number == null ? null : number,
    "orderDate": orderDate == null ? null : "${orderDate!.year.toString().padLeft(4, '0')}-${orderDate!.month.toString().padLeft(2, '0')}-${orderDate!.day.toString().padLeft(2, '0')}",
    "customerId": customerId == null ? null : customerId,
    "contactId": contactId == null ? null : contactId,
    "customerNumber": customerNumber == null ? null : customerNumber,
    "customerName": customerName == null ? null : customerName,
    "billingPostalAddress": billingPostalAddress == null ? null : billingPostalAddress!.toJson(),
    "currencyId": currencyId == null ? null : currencyId,
    "currencyCode": currencyCode == null ? null : currencyCode,
    "pricesIncludeTax": pricesIncludeTax == null ? null : pricesIncludeTax,
    "paymentTermsId": paymentTermsId == null ? null : paymentTermsId,
    "salesperson": salesperson == null ? null : salesperson,
    "partialShipping": partialShipping == null ? null : partialShipping,
    "requestedDeliveryDate": requestedDeliveryDate == null ? null : "${requestedDeliveryDate!.year.toString().padLeft(4, '0')}-${requestedDeliveryDate!.month.toString().padLeft(2, '0')}-${requestedDeliveryDate!.day.toString().padLeft(2, '0')}",
    "discountAmount": discountAmount == null ? null : discountAmount,
    "discountAppliedBeforeTax": discountAppliedBeforeTax == null ? null : discountAppliedBeforeTax,
    "totalAmountExcludingTax": totalAmountExcludingTax == null ? null : totalAmountExcludingTax,
    "totalTaxAmount": totalTaxAmount == null ? null : totalTaxAmount,
    "totalAmountIncludingTax": totalAmountIncludingTax == null ? null : totalAmountIncludingTax,
    "fullyShipped": fullyShipped == null ? null : fullyShipped,
    "status": status == null ? null : status,
    "lastModifiedDateTime": lastModifiedDateTime == null ? null : lastModifiedDateTime!.toIso8601String(),
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

class SalesOrderNotifier extends StateNotifier<List<SalesOrder>> {
  SalesOrderNotifier(super.state);

  List<SalesOrder> get() {
    return state;
  }

  void add(SalesOrder item) {
    state = [...state, item];
  }

  void edit(SalesOrder item) {
    state = [
      for(var row in state)
        if(row.id == item.id)
          row = item
        else
          row
    ];
  }

  void remove(SalesOrder item) {
    state.removeWhere((e) => e.id == item.id);
  }
}
