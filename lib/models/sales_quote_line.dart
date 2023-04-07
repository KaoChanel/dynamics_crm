// To parse this JSON data, do
//
//     final salesQuoteLine = salesQuoteLineFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

SalesQuoteLine salesQuoteLineFromJson(String str) => SalesQuoteLine.fromJson(json.decode(str));

List<SalesQuoteLine> salesQuoteLineListFromJson(String str) => List<SalesQuoteLine>.from(json.decode(str).map((x) => SalesQuoteLine.fromJson(x)));

String salesQuoteLineToJson(List<SalesQuoteLine> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesQuoteLine {
  SalesQuoteLine({
    this.key,
    this.id,
    this.documentId,
    this.sequence,
    this.itemId,
    this.accountId,
    this.lineType,
    this.lineObjectNumber,
    this.description,
    this.unitOfMeasureId,
    this.unitOfMeasureCode,
    this.unitPrice,
    this.quantity,
    this.discountType,
    this.discountAmount,
    this.discount,
    this.discountAppliedBeforeTax,
    this.taxCode,
    this.taxPercent,
    this.totalTaxAmount,
    this.amountIncludingTax,
    this.amountExcludingTax,
    this.netAmount = 0,
    this.netTaxAmount,
    this.netAmountIncludingTax,
    this.itemVariantId,
    this.isFree = false,
    this.isSelect = false
  });

  GlobalKey? key;
  String? id;
  String? documentId;
  int? sequence;
  String? itemId;
  String? accountId;
  String? lineType;
  String? lineObjectNumber;
  String? description;
  String? unitOfMeasureId;
  String? unitOfMeasureCode;
  double? unitPrice;
  double? quantity;
  String? discountType;
  double? discountAmount;
  double? discount;
  String? discountAppliedBeforeTax;
  String? taxCode;
  String? taxPercent;
  double? totalTaxAmount;
  double? amountIncludingTax;
  double? amountExcludingTax;
  double netAmount;
  double? netTaxAmount;
  double? netAmountIncludingTax;
  String? itemVariantId;
  bool isFree = false;
  bool isSelect = false;

  SalesQuoteLine copyWith({
    String? id,
    String? documentId,
    int? sequence,
    String? itemId,
    String? accountId,
    String? lineType,
    String? lineObjectNumber,
    String? description,
    String? unitOfMeasureId,
    String? unitOfMeasureCode,
    double? unitPrice,
    double? quantity,
    String? discountType = 'PER',
    double? discountAmount,
    double? discount,
    String? discountAppliedBeforeTax,
    String? taxCode,
    String? taxPercent,
    double? totalTaxAmount,
    double? amountIncludingTax,
    double? amountExcludingTax,
    double? netAmount,
    double? netTaxAmount,
    double? netAmountIncludingTax,
    String? itemVariantId,
  }) =>
      SalesQuoteLine(
        id: id ?? this.id,
        documentId: documentId ?? this.documentId,
        sequence: sequence ?? this.sequence,
        itemId: itemId ?? this.itemId,
        accountId: accountId ?? this.accountId,
        lineType: lineType ?? this.lineType,
        lineObjectNumber: lineObjectNumber ?? this.lineObjectNumber,
        description: description ?? this.description,
        unitOfMeasureId: unitOfMeasureId ?? this.unitOfMeasureId,
        unitOfMeasureCode: unitOfMeasureCode ?? this.unitOfMeasureCode,
        unitPrice: unitPrice ?? this.unitPrice,
        quantity: quantity ?? this.quantity,
        discountAmount: discountAmount ?? this.discountAmount,
        discount: discount ?? this.discount,
        discountAppliedBeforeTax: discountAppliedBeforeTax ?? this.discountAppliedBeforeTax,
        amountExcludingTax: amountExcludingTax ?? this.amountExcludingTax,
        taxCode: taxCode ?? this.taxCode,
        taxPercent: taxPercent ?? this.taxPercent,
        totalTaxAmount: totalTaxAmount ?? this.totalTaxAmount,
        amountIncludingTax: amountIncludingTax ?? this.amountIncludingTax,
        netAmount: netAmount ?? this.netAmount,
        netTaxAmount: netTaxAmount ?? this.netTaxAmount,
        netAmountIncludingTax: netAmountIncludingTax ?? this.netAmountIncludingTax,
        itemVariantId: itemVariantId ?? this.itemVariantId,
      );

  factory SalesQuoteLine.fromJson(Map<String, dynamic> json) => SalesQuoteLine(
    id: json["id"] == null ? null : json["id"],
    documentId: json["documentId"] == null ? null : json["documentId"],
    sequence: json["sequence"] == null ? null : json["sequence"],
    itemId: json["itemId"] == null ? null : json["itemId"],
    accountId: json["accountId"] == null ? null : json["accountId"],
    lineType: json["lineType"] == null ? null : json["lineType"],
    lineObjectNumber: json["lineObjectNumber"] == null ? null : json["lineObjectNumber"],
    description: json["description"] == null ? null : json["description"],
    unitOfMeasureId: json["unitOfMeasureId"] == null ? null : json["unitOfMeasureId"],
    unitOfMeasureCode: json["unitOfMeasureCode"] == null ? null : json["unitOfMeasureCode"],
    unitPrice: json["unitPrice"] == null ? null : json["unitPrice"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    discountAmount: json["discountAmount"] == null ? null : json["discountAmount"],
    discount: json["discount"] == null ? null : json["discount"],
    discountAppliedBeforeTax: json["discountAppliedBeforeTax"] == null ? null : json["discountAppliedBeforeTax"],
    amountExcludingTax: json["amountExcludingTax"] == null ? null : json["amountExcludingTax"],
    taxCode: json["taxCode"] == null ? null : json["taxCode"],
    taxPercent: json["taxPercent"] == null ? null : json["taxPercent"],
    totalTaxAmount: json["totalTaxAmount"] == null ? null : json["totalTaxAmount"],
    amountIncludingTax: json["amountIncludingTax"] == null ? null : json["amountIncludingTax"],
    netAmount: json["netAmount"] == null ? null : json["netAmount"],
    netTaxAmount: json["netTaxAmount"] == null ? null : json["netTaxAmount"],
    netAmountIncludingTax: json["netAmountIncludingTax"] == null ? null : json["netAmountIncludingTax"],
    itemVariantId: json["itemVariantId"] == null ? null : json["itemVariantId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "documentId": documentId == null ? null : documentId,
    "sequence": sequence == null ? null : sequence,
    "itemId": itemId == null ? null : itemId,
    "accountId": accountId == null ? null : accountId,
    "lineType": lineType == null ? null : lineType,
    "lineObjectNumber": lineObjectNumber == null ? null : lineObjectNumber,
    "description": description == null ? null : description,
    "unitOfMeasureId": unitOfMeasureId == null ? null : unitOfMeasureId,
    "unitOfMeasureCode": unitOfMeasureCode == null ? null : unitOfMeasureCode,
    "unitPrice": unitPrice == null ? null : unitPrice,
    "quantity": quantity == null ? null : quantity,
    "discountAmount": discountAmount == null ? null : discountAmount,
    "discount": discount == null ? null : discount,
    "discountAppliedBeforeTax": discountAppliedBeforeTax == null ? null : discountAppliedBeforeTax,
    "amountExcludingTax": amountExcludingTax == null ? null : amountExcludingTax,
    "taxCode": taxCode == null ? null : taxCode,
    "taxPercent": taxPercent == null ? null : taxPercent,
    "totalTaxAmount": totalTaxAmount == null ? null : totalTaxAmount,
    "amountIncludingTax": amountIncludingTax == null ? null : amountIncludingTax,
    "netAmount": netAmount == null ? null : netAmount,
    "netTaxAmount": netTaxAmount == null ? null : netTaxAmount,
    "netAmountIncludingTax": netAmountIncludingTax == null ? null : netAmountIncludingTax,
    "itemVariantId": itemVariantId == null ? null : itemVariantId,
  };
}

class SalesQuoteLineNotifier extends StateNotifier<List<SalesQuoteLine>> {
  SalesQuoteLineNotifier(super.state);

  List<SalesQuoteLine> get() {
    return state;
  }

  void add(SalesQuoteLine item) {
    state = [...state, item];
  }

  void edit(SalesQuoteLine item) {
    state = [
      for(var row in state)
        if(row.id == item.id)
          row = item
        else
          row
    ];
  }

  void remove(SalesQuoteLine item) {
    state.removeWhere((e) => e.id == item.id);
  }
}
