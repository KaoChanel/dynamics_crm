// To parse this JSON data, do
//
//     final salesOrderLine = salesOrderLineFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

SalesOrderLine salesOrderLineFromJson(String str) => SalesOrderLine.fromJson(json.decode(str));

List<SalesOrderLine> salesOrderLineListFromJson(String str) => List<SalesOrderLine>.from(json.decode(str).map((x) => SalesOrderLine.fromJson(x)));

String salesOrderLineToJson(SalesOrderLine data) => json.encode(data.toJson());

class SalesOrderLine {
  SalesOrderLine({
    this.key,
    this.id,
    this.documentId,
    this.sequence,
    this.itemId,
    this.itemCode = '',
    this.itemName = '',
    this.accountId,
    this.lineType,
    this.lineObjectNumber,
    this.description,
    this.unitOfMeasureId,
    this.unitOfMeasureCode,
    this.quantity = 0,
    this.unitPrice = 0,
    this.discountType,
    this.discountAmount = 0,
    this.discountPercent = 0,
    this.discountNumber = 0,
    this.discountAppliedBeforeTax,
    this.amountBeforeDiscount = 0,
    this.taxCode,
    this.taxPercent,
    this.totalTaxAmount = 0,
    this.amountIncludingTax,
    this.amountExcludingTax,
    this.invoiceDiscountAllocation,
    this.netAmount = 0,
    this.netTaxAmount = 0,
    this.netAmountIncludingTax,
    this.shipmentDate,
    this.shippedQuantity,
    this.invoicedQuantity,
    this.invoiceQuantity,
    this.shipQuantity,
    this.itemVariantId,
    this.isFree = false,
    this.isSelect = false,
  });

  GlobalKey? key;
  String? id;
  String? documentId;
  int? sequence;
  String? itemId;
  String itemCode;
  String itemName;
  String? accountId;
  String? lineType;
  String? lineObjectNumber;
  String? description;
  String? unitOfMeasureId;
  String? unitOfMeasureCode;
  double? quantity = 0;
  double? unitPrice = 0;
  String? discountType;
  double? discountAmount;
  double? discountPercent;
  double? discountNumber;
  bool? discountAppliedBeforeTax;
  String? taxCode;
  double? taxPercent;
  double? totalTaxAmount;
  double? amountIncludingTax;
  double? amountExcludingTax;
  double? amountBeforeDiscount;
  double? invoiceDiscountAllocation;
  double netAmount = 0;
  double? netTaxAmount = 0;
  double? netAmountIncludingTax;
  DateTime? shipmentDate;
  double? shippedQuantity;
  double? invoicedQuantity;
  double? invoiceQuantity;
  double? shipQuantity;
  String? itemVariantId;
  bool isFree = false;
  bool isSelect = false;

  SalesOrderLine copyWith({
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
    double? quantity,
    double? unitPrice,
    String? discountType,
    double? discountAmount,
    double? discountPercent,
    double? discountNumber,
    bool? discountAppliedBeforeTax,
    double? amountBeforeDiscount,
    double? amountExcludingTax,
    String? taxCode,
    double? taxPercent,
    double? totalTaxAmount,
    double? amountIncludingTax,
    double? invoiceDiscountAllocation,
    double? netAmount,
    double? netTaxAmount,
    double? netAmountIncludingTax,
    DateTime? shipmentDate,
    double? shippedQuantity,
    double? invoicedQuantity,
    double? invoiceQuantity,
    double? shipQuantity,
    String? itemVariantId,
    bool isFree = false,
    bool isSelect = false,
  }) =>
      SalesOrderLine(
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
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
        discountType: discountType ?? this.discountType,
        discountAmount: discountAmount ?? this.discountAmount,
        discountPercent: discountPercent ?? this.discountPercent,
        discountNumber: discountNumber ?? this.discountNumber,
        discountAppliedBeforeTax: discountAppliedBeforeTax ?? this.discountAppliedBeforeTax,
        amountBeforeDiscount: amountBeforeDiscount ?? this.amountBeforeDiscount,
        amountExcludingTax: amountExcludingTax ?? this.amountExcludingTax,
        taxCode: taxCode ?? this.taxCode,
        taxPercent: taxPercent ?? this.taxPercent,
        totalTaxAmount: totalTaxAmount ?? this.totalTaxAmount,
        amountIncludingTax: amountIncludingTax ?? this.amountIncludingTax,
        invoiceDiscountAllocation: invoiceDiscountAllocation ?? this.invoiceDiscountAllocation,
        netAmount: netAmount ?? this.netAmount,
        netTaxAmount: netTaxAmount ?? this.netTaxAmount,
        netAmountIncludingTax: netAmountIncludingTax ?? this.netAmountIncludingTax,
        shipmentDate: shipmentDate ?? this.shipmentDate,
        shippedQuantity: shippedQuantity ?? this.shippedQuantity,
        invoicedQuantity: invoicedQuantity ?? this.invoicedQuantity,
        invoiceQuantity: invoiceQuantity ?? this.invoiceQuantity,
        shipQuantity: shipQuantity ?? this.shipQuantity,
        itemVariantId: itemVariantId ?? this.itemVariantId,
        isFree: isFree,
        isSelect: isSelect,
      );

  factory SalesOrderLine.fromJson(Map<String, dynamic> json) => SalesOrderLine(
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
    quantity: json["quantity"] == null ? null : json["quantity"],
    unitPrice: json["unitPrice"] == null ? null : json["unitPrice"],
    discountType: json["discountType"] == null ? null : json["discountType"],
    discountAmount: json["discountAmount"] == null ? null : json["discountAmount"],
    discountPercent: json["discountPercent"] == null ? null : json["discountPercent"],
    discountAppliedBeforeTax: json["discountAppliedBeforeTax"] == null ? null : json["discountAppliedBeforeTax"],
    amountExcludingTax: json["amountExcludingTax"] == null ? null : json["amountExcludingTax"],
    taxCode: json["taxCode"] == null ? null : json["taxCode"],
    taxPercent: json["taxPercent"] == null ? null : json["taxPercent"].toDouble(),
    totalTaxAmount: json["totalTaxAmount"] == null ? null : json["totalTaxAmount"].toDouble(),
    amountIncludingTax: json["amountIncludingTax"] == null ? null : json["amountIncludingTax"].toDouble(),
    invoiceDiscountAllocation: json["invoiceDiscountAllocation"] == null ? null : json["invoiceDiscountAllocation"].toDouble(),
    netAmount: json["netAmount"] == null ? null : json["netAmount"].toDouble(),
    netTaxAmount: json["netTaxAmount"] == null ? null : json["netTaxAmount"].toDouble(),
    netAmountIncludingTax: json["netAmountIncludingTax"] == null ? null : json["netAmountIncludingTax"].toDouble(),
    shipmentDate: json["shipmentDate"] == null ? null : json["shipmentDate"],
    shippedQuantity: json["shippedQuantity"] == null ? null : json["shippedQuantity"].toDouble(),
    invoicedQuantity: json["invoicedQuantity"] == null ? null : json["invoicedQuantity"].toDouble(),
    invoiceQuantity: json["invoiceQuantity"] == null ? null : json["invoiceQuantity"].toDouble(),
    shipQuantity: json["shipQuantity"] == null ? null : json["shipQuantity"].toDouble(),
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
    "quantity": quantity == null ? null : quantity,
    "unitPrice": unitPrice == null ? null : unitPrice,
    "discountAmount": discountAmount == null ? null : discountAmount,
    "discountPercent": discountPercent == null ? null : discountPercent,
    "discountAppliedBeforeTax": discountAppliedBeforeTax == null ? null : discountAppliedBeforeTax,
    "amountExcludingTax": amountExcludingTax == null ? null : amountExcludingTax,
    "taxCode": taxCode == null ? null : taxCode,
    "taxPercent": taxPercent == null ? null : taxPercent,
    "totalTaxAmount": totalTaxAmount == null ? null : totalTaxAmount,
    "amountIncludingTax": amountIncludingTax == null ? null : amountIncludingTax,
    "invoiceDiscountAllocation": invoiceDiscountAllocation == null ? null : invoiceDiscountAllocation,
    "netAmount": netAmount == null ? null : netAmount,
    "netTaxAmount": netTaxAmount == null ? null : netTaxAmount,
    "netAmountIncludingTax": netAmountIncludingTax == null ? null : netAmountIncludingTax,
    "shipmentDate": shipmentDate == null ? null : shipmentDate,
    "shippedQuantity": shippedQuantity == null ? null : shippedQuantity,
    "invoicedQuantity": invoicedQuantity == null ? null : invoicedQuantity,
    "invoiceQuantity": invoiceQuantity == null ? null : invoiceQuantity,
    "shipQuantity": shipQuantity == null ? null : shipQuantity,
    "itemVariantId": itemVariantId == null ? null : itemVariantId,
  };
}

class SalesOrderLineNotifier extends StateNotifier<List<SalesOrderLine>> {
  SalesOrderLineNotifier(): super([]);

  List<SalesOrderLine> get() {
    return state;
  }

  List<SalesOrderLine> getBy(String keyword) {
    List<SalesOrderLine> result = state.where((e) => e.itemCode.toLowerCase().contains(keyword.toLowerCase())
        || e.itemName.toLowerCase().contains(keyword.toLowerCase())
        // || e.itemCategoryCode != null ? e.itemCategoryCode!.toLowerCase().contains(keyword.toLowerCase()) : false
        // || e.unitOfMeasureCode != null ? e.unitOfMeasureCode!.toLowerCase().contains(keyword.toLowerCase()) : true
    ).toList();

    return result;
  }

  void add(SalesOrderLine object) {
    state = [...state, object];
  }

  void addAll(List<SalesOrderLine> objects) {
    int index = 1;
    for(var item in objects) {
      state = [...state, item];
    }

    /// Re-order sequence.
    for(var item in state) {
      item.sequence = index++;
    }
  }

  void replace(List<SalesOrderLine> objects) {
    state = objects;
  }

  void edit(SalesOrderLine object) {
    state = [
      for(var element in state)
        if(element.id == object.id)
          element = object
        else
          element
    ];
  }

  void remove(SalesOrderLine object) {
    state = [
      for (final element in state)
        if (element.id != object.id) element,
    ];

    int i = 1;
    for (SalesOrderLine element in state) {
      element.sequence = i++;
    }
  }

  void clear(){
    state = [];
  }
}

// Finally, we are using StateNotifierProvider to allow the UI to interact
final salesOrderLineProvider = StateNotifierProvider<SalesOrderLineNotifier, List<SalesOrderLine>>((ref) {
  return SalesOrderLineNotifier();
});
