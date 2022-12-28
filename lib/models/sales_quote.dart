// To parse this JSON data, do
//
//     final salesQuote = salesQuoteFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

SalesQuote salesQuoteFromJson(String str) => SalesQuote.fromJson(json.decode(str));

List<SalesQuote> salesQuoteListFromJson(String str) => List<SalesQuote>.from(json.decode(str).map((x) => SalesQuote.fromJson(x)));

String salesQuoteToJson(SalesQuote data) => json.encode(data.toJson());

class SalesQuote {
  SalesQuote({
    this.id,
    this.number,
    this.externalDocumentNumber,
    this.documentDate,
    this.dueDate,
    this.customerId,
    this.contactId,
    this.customerNumber,
    this.customerName,
    this.billingPostalAddress,
    this.currencyId,
    this.currencyCode,
    this.paymentTermsId,
    this.shipmentMethodId,
    this.shipmentMethod,
    this.salesperson,
    this.discountAmount,
    this.totalAmountExcludingTax,
    this.totalTaxAmount,
    this.totalAmountIncludingTax,
    this.status,
    this.sentDate,
    this.validUntilDate,
    this.acceptedDate,
    this.lastModifiedDateTime,
  });

  String? id;
  String? number;
  String? externalDocumentNumber;
  DateTime? documentDate;
  DateTime? dueDate;
  String? customerId;
  String? contactId;
  String? customerNumber;
  String? customerName;
  BillingPostalAddress? billingPostalAddress;
  String? currencyId;
  String? currencyCode;
  String? paymentTermsId;
  String? shipmentMethodId;
  String? shipmentMethod;
  String? salesperson;
  int? discountAmount;
  double? totalAmountExcludingTax;
  double? totalTaxAmount;
  double? totalAmountIncludingTax;
  String? status;
  DateTime? sentDate;
  DateTime? validUntilDate;
  DateTime? acceptedDate;
  DateTime? lastModifiedDateTime;

  SalesQuote copyWith({
    String? id,
    String? number,
    String? externalDocumentNumber,
    DateTime? documentDate,
    DateTime? dueDate,
    String? customerId,
    String? contactId,
    String? customerNumber,
    String? customerName,
    BillingPostalAddress? billingPostalAddress,
    String? currencyId,
    String? currencyCode,
    String? paymentTermsId,
    String? shipmentMethodId,
    String? shipmentMethod,
    String? salesperson,
    int? discountAmount,
    double? totalAmountExcludingTax,
    double? totalTaxAmount,
    double? totalAmountIncludingTax,
    String? status,
    DateTime? sentDate,
    DateTime? validUntilDate,
    DateTime? acceptedDate,
    DateTime? lastModifiedDateTime,
  }) =>
      SalesQuote(
        id: id ?? this.id,
        number: number ?? this.number,
        externalDocumentNumber: externalDocumentNumber ?? this.externalDocumentNumber,
        documentDate: documentDate ?? this.documentDate,
        dueDate: dueDate ?? this.dueDate,
        customerId: customerId ?? this.customerId,
        contactId: contactId ?? this.contactId,
        customerNumber: customerNumber ?? this.customerNumber,
        customerName: customerName ?? this.customerName,
        billingPostalAddress: billingPostalAddress ?? this.billingPostalAddress,
        currencyId: currencyId ?? this.currencyId,
        currencyCode: currencyCode ?? this.currencyCode,
        paymentTermsId: paymentTermsId ?? this.paymentTermsId,
        shipmentMethodId: shipmentMethodId ?? this.shipmentMethodId,
        shipmentMethod: shipmentMethod ?? this.shipmentMethod,
        salesperson: salesperson ?? this.salesperson,
        discountAmount: discountAmount ?? this.discountAmount,
        totalAmountExcludingTax: totalAmountExcludingTax ?? this.totalAmountExcludingTax,
        totalTaxAmount: totalTaxAmount ?? this.totalTaxAmount,
        totalAmountIncludingTax: totalAmountIncludingTax ?? this.totalAmountIncludingTax,
        status: status ?? this.status,
        sentDate: sentDate ?? this.sentDate,
        validUntilDate: validUntilDate ?? this.validUntilDate,
        acceptedDate: acceptedDate ?? this.acceptedDate,
        lastModifiedDateTime: lastModifiedDateTime ?? this.lastModifiedDateTime,
      );

  factory SalesQuote.fromJson(Map<String, dynamic> json) => SalesQuote(
    id: json["id"] == null ? null : json["id"],
    number: json["number"] == null ? null : json["number"],
    externalDocumentNumber: json["externalDocumentNumber"] == null ? null : json["externalDocumentNumber"],
    documentDate: json["documentDate"] == null ? null : DateTime.parse(json["documentDate"]),
    dueDate: json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
    customerId: json["customerId"] == null ? null : json["customerId"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    customerNumber: json["customerNumber"] == null ? null : json["customerNumber"],
    customerName: json["customerName"] == null ? null : json["customerName"],
    billingPostalAddress: json["billingPostalAddress"] == null ? null : BillingPostalAddress.fromJson(json["billingPostalAddress"]),
    currencyId: json["currencyId"] == null ? null : json["currencyId"],
    currencyCode: json["currencyCode"] == null ? null : json["currencyCode"],
    paymentTermsId: json["paymentTermsId"] == null ? null : json["paymentTermsId"],
    shipmentMethodId: json["shipmentMethodId"] == null ? null : json["shipmentMethodId"],
    shipmentMethod: json["shipmentMethod"] == null ? null : json["shipmentMethod"],
    salesperson: json["salesperson"] == null ? null : json["salesperson"],
    discountAmount: json["discountAmount"] == null ? null : json["discountAmount"],
    totalAmountExcludingTax: json["totalAmountExcludingTax"] == null ? null : json["totalAmountExcludingTax"].toDouble(),
    totalTaxAmount: json["totalTaxAmount"] == null ? null : json["totalTaxAmount"].toDouble(),
    totalAmountIncludingTax: json["totalAmountIncludingTax"] == null ? null : json["totalAmountIncludingTax"].toDouble(),
    status: json["status"] == null ? null : json["status"],
    sentDate: json["sentDate"] == null ? null : DateTime.parse(json["sentDate"]),
    validUntilDate: json["validUntilDate"] == null ? null : DateTime.parse(json["validUntilDate"]),
    acceptedDate: json["acceptedDate"] == null ? null : DateTime.parse(json["acceptedDate"]),
    lastModifiedDateTime: json["lastModifiedDateTime"] == null ? null : DateTime.parse(json["lastModifiedDateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "number": number == null ? null : number,
    "externalDocumentNumber": externalDocumentNumber == null ? null : externalDocumentNumber,
    "documentDate": documentDate == null ? null : "${documentDate!.year.toString().padLeft(4, '0')}-${documentDate!.month.toString().padLeft(2, '0')}-${documentDate!.day.toString().padLeft(2, '0')}",
    "dueDate": dueDate == null ? null : "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
    "customerId": customerId == null ? null : customerId,
    "contactId": contactId == null ? null : contactId,
    "customerNumber": customerNumber == null ? null : customerNumber,
    "customerName": customerName == null ? null : customerName,
    "billingPostalAddress": billingPostalAddress == null ? null : billingPostalAddress!.toJson(),
    "currencyId": currencyId == null ? null : currencyId,
    "currencyCode": currencyCode == null ? null : currencyCode,
    "paymentTermsId": paymentTermsId == null ? null : paymentTermsId,
    "shipmentMethodId": shipmentMethodId == null ? null : shipmentMethodId,
    "shipmentMethod": shipmentMethod == null ? null : shipmentMethod,
    "salesperson": salesperson == null ? null : salesperson,
    "discountAmount": discountAmount == null ? null : discountAmount,
    "totalAmountExcludingTax": totalAmountExcludingTax == null ? null : totalAmountExcludingTax,
    "totalTaxAmount": totalTaxAmount == null ? null : totalTaxAmount,
    "totalAmountIncludingTax": totalAmountIncludingTax == null ? null : totalAmountIncludingTax,
    "status": status == null ? null : status,
    "sentDate": sentDate == null ? null : sentDate!.toIso8601String(),
    "validUntilDate": validUntilDate == null ? null : "${validUntilDate!.year.toString().padLeft(4, '0')}-${validUntilDate!.month.toString().padLeft(2, '0')}-${validUntilDate!.day.toString().padLeft(2, '0')}",
    "acceptedDate": acceptedDate == null ? null : "${acceptedDate!.year.toString().padLeft(4, '0')}-${acceptedDate!.month.toString().padLeft(2, '0')}-${acceptedDate!.day.toString().padLeft(2, '0')}",
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

class SalesQuoteNotifier extends StateNotifier<List<SalesQuote>> {
  SalesQuoteNotifier(super.state);

  List<SalesQuote> get() {
    return state;
  }

  void add(SalesQuote item) {
    state = [...state, item];
  }

  void edit(SalesQuote item) {
    state = [
      for(var row in state)
        if(row.id == item.id)
          row = item
        else
          row
    ];
  }

  void remove(SalesQuote item) {
    state.removeWhere((e) => e.id == item.id);
  }
}
