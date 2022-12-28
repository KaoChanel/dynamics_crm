// To parse this JSON data, do
//
//     final salesOrderLine = salesOrderLineFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

SalesOrderLine salesOrderLineFromJson(String str) => SalesOrderLine.fromJson(json.decode(str));

List<SalesOrderLine> salesOrderLineListFromJson(String str) => List<SalesOrderLine>.from(json.decode(str).map((x) => SalesOrderLine.fromJson(x)));

String salesOrderLineToJson(SalesOrderLine data) => json.encode(data.toJson());

class SalesOrderLine {
  SalesOrderLine({
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
    this.quantity,
    this.unitPrice,
    this.discountAmount,
    this.discountPercent,
    this.discountAppliedBeforeTax,
    this.amountExcludingTax,
    this.taxCode,
    this.taxPercent,
    this.totalTaxAmount,
    this.amountIncludingTax,
    this.invoiceDiscountAllocation,
    this.netAmount,
    this.netTaxAmount,
    this.netAmountIncludingTax,
    this.shipmentDate,
    this.shippedQuantity,
    this.invoicedQuantity,
    this.invoiceQuantity,
    this.shipQuantity,
    this.itemVariantId,
  });

  String? id;
  String? documentId;
  String? sequence;
  String? itemId;
  String? accountId;
  String? lineType;
  String? lineObjectNumber;
  String? description;
  String? unitOfMeasureId;
  String? unitOfMeasureCode;
  String? quantity;
  String? unitPrice;
  String? discountAmount;
  String? discountPercent;
  String? discountAppliedBeforeTax;
  String? amountExcludingTax;
  String? taxCode;
  String? taxPercent;
  String? totalTaxAmount;
  String? amountIncludingTax;
  String? invoiceDiscountAllocation;
  String? netAmount;
  String? netTaxAmount;
  String? netAmountIncludingTax;
  String? shipmentDate;
  String? shippedQuantity;
  String? invoicedQuantity;
  String? invoiceQuantity;
  String? shipQuantity;
  String? itemVariantId;

  SalesOrderLine copyWith({
    String? id,
    String? documentId,
    String? sequence,
    String? itemId,
    String? accountId,
    String? lineType,
    String? lineObjectNumber,
    String? description,
    String? unitOfMeasureId,
    String? unitOfMeasureCode,
    String? quantity,
    String? unitPrice,
    String? discountAmount,
    String? discountPercent,
    String? discountAppliedBeforeTax,
    String? amountExcludingTax,
    String? taxCode,
    String? taxPercent,
    String? totalTaxAmount,
    String? amountIncludingTax,
    String? invoiceDiscountAllocation,
    String? netAmount,
    String? netTaxAmount,
    String? netAmountIncludingTax,
    String? shipmentDate,
    String? shippedQuantity,
    String? invoicedQuantity,
    String? invoiceQuantity,
    String? shipQuantity,
    String? itemVariantId,
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
        discountAmount: discountAmount ?? this.discountAmount,
        discountPercent: discountPercent ?? this.discountPercent,
        discountAppliedBeforeTax: discountAppliedBeforeTax ?? this.discountAppliedBeforeTax,
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
    discountAmount: json["discountAmount"] == null ? null : json["discountAmount"],
    discountPercent: json["discountPercent"] == null ? null : json["discountPercent"],
    discountAppliedBeforeTax: json["discountAppliedBeforeTax"] == null ? null : json["discountAppliedBeforeTax"],
    amountExcludingTax: json["amountExcludingTax"] == null ? null : json["amountExcludingTax"],
    taxCode: json["taxCode"] == null ? null : json["taxCode"],
    taxPercent: json["taxPercent"] == null ? null : json["taxPercent"],
    totalTaxAmount: json["totalTaxAmount"] == null ? null : json["totalTaxAmount"],
    amountIncludingTax: json["amountIncludingTax"] == null ? null : json["amountIncludingTax"],
    invoiceDiscountAllocation: json["invoiceDiscountAllocation"] == null ? null : json["invoiceDiscountAllocation"],
    netAmount: json["netAmount"] == null ? null : json["netAmount"],
    netTaxAmount: json["netTaxAmount"] == null ? null : json["netTaxAmount"],
    netAmountIncludingTax: json["netAmountIncludingTax"] == null ? null : json["netAmountIncludingTax"],
    shipmentDate: json["shipmentDate"] == null ? null : json["shipmentDate"],
    shippedQuantity: json["shippedQuantity"] == null ? null : json["shippedQuantity"],
    invoicedQuantity: json["invoicedQuantity"] == null ? null : json["invoicedQuantity"],
    invoiceQuantity: json["invoiceQuantity"] == null ? null : json["invoiceQuantity"],
    shipQuantity: json["shipQuantity"] == null ? null : json["shipQuantity"],
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
  SalesOrderLineNotifier(super.state);

  List<SalesOrderLine> get() {
    return state;
  }

  void add(SalesOrderLine item) {
    state = [...state, item];
  }

  void edit(SalesOrderLine item) {
    state = [
      for(var row in state)
        if(row.id == item.id)
          row = item
        else
          row
    ];
  }

  void remove(SalesOrderLine item) {
    state.removeWhere((e) => e.id == item.id);
  }
}
