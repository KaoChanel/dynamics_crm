// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

List<Item> itemListFromJson(String str) => List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  Item({
    this.id,
    this.code,
    this.number,
    this.displayName,
    this.type,
    this.itemCategoryId,
    this.itemCategoryCode,
    this.blocked,
    this.gtin,
    this.inventory = 0,
    this.priceIncludesTax,
    this.unitPrice = 0,
    this.unitCost = 0,
    this.vatRate,
    this.taxGroupId,
    this.taxGroupCode,
    this.baseUnitOfMeasureId,
    this.baseUnitOfMeasureCode,
    this.lastModifiedDateTime,
  });

  String? id;
  String? code;
  String? number;
  String? displayName;
  String? type;
  String? itemCategoryId;
  String? itemCategoryCode;
  bool? blocked;
  String? gtin;
  int? inventory;
  bool? priceIncludesTax;
  double? unitPrice;
  double? unitCost;
  double? vatRate;
  String? taxGroupId;
  String? taxGroupCode;
  String? baseUnitOfMeasureId;
  String? baseUnitOfMeasureCode;
  DateTime? lastModifiedDateTime;

  Item copyWith({
    String? id,
    String? code,
    String? number,
    String? displayName,
    String? type,
    String? itemCategoryId,
    String? itemCategoryCode,
    bool? blocked,
    String? gtin,
    int? inventory,
    double? unitPrice,
    double? vatRate,
    bool? priceIncludesTax,
    double? unitCost,
    String? taxGroupId,
    String? taxGroupCode,
    String? baseUnitOfMeasureId,
    String? baseUnitOfMeasureCode,
    DateTime? lastModifiedDateTime,
  }) =>
      Item(
        id: id ?? this.id,
        code: code ?? this.id,
        number: number ?? this.number,
        displayName: displayName ?? this.displayName,
        type: type ?? this.type,
        itemCategoryId: itemCategoryId ?? this.itemCategoryId,
        itemCategoryCode: itemCategoryCode ?? this.itemCategoryCode,
        blocked: blocked ?? this.blocked,
        gtin: gtin ?? this.gtin,
        inventory: inventory ?? this.inventory,
        unitPrice: unitPrice ?? this.unitPrice,
        vatRate: vatRate ?? this.vatRate,
        priceIncludesTax: priceIncludesTax ?? this.priceIncludesTax,
        unitCost: unitCost ?? this.unitCost,
        taxGroupId: taxGroupId ?? this.taxGroupId,
        taxGroupCode: taxGroupCode ?? this.taxGroupCode,
        baseUnitOfMeasureId: baseUnitOfMeasureId ?? this.baseUnitOfMeasureId,
        baseUnitOfMeasureCode: baseUnitOfMeasureCode ?? this.baseUnitOfMeasureCode,
        lastModifiedDateTime: lastModifiedDateTime ?? this.lastModifiedDateTime,
      );

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"] == null ? null : json["id"],
    code: json["code"] == null ? null : json["code"],
    number: json["number"] == null ? null : json["number"],
    displayName: json["displayName"] == null ? null : json["displayName"],
    type: json["type"] == null ? null : json["type"],
    itemCategoryId: json["itemCategoryId"] == null ? null : json["itemCategoryId"],
    itemCategoryCode: json["itemCategoryCode"] == null ? null : json["itemCategoryCode"],
    blocked: json["blocked"] == null ? null : json["blocked"],
    gtin: json["gtin"] == null ? null : json["gtin"],
    inventory: json["inventory"] == null ? null : json["inventory"],
    unitPrice: json["unitPrice"] == null ? null : json["unitPrice"].toDouble(),
    priceIncludesTax: json["priceIncludesTax"] == null ? null : json["priceIncludesTax"],
    unitCost: json["unitCost"] == null ? null : json["unitCost"].toDouble(),
    taxGroupId: json["taxGroupId"] == null ? null : json["taxGroupId"],
    taxGroupCode: json["taxGroupCode"] == null ? null : json["taxGroupCode"],
    baseUnitOfMeasureId: json["baseUnitOfMeasureId"] == null ? null : json["baseUnitOfMeasureId"],
    baseUnitOfMeasureCode: json["baseUnitOfMeasureCode"] == null ? null : json["baseUnitOfMeasureCode"],
    lastModifiedDateTime: json["lastModifiedDateTime"] == null ? null : DateTime.parse(json["lastModifiedDateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "code": code == null ? null : code,
    "number": number == null ? null : number,
    "displayName": displayName == null ? null : displayName,
    "type": type == null ? null : type,
    "itemCategoryId": itemCategoryId == null ? null : itemCategoryId,
    "itemCategoryCode": itemCategoryCode == null ? null : itemCategoryCode,
    "blocked": blocked == null ? null : blocked,
    "gtin": gtin == null ? null : gtin,
    "inventory": inventory == null ? null : inventory,
    "unitPrice": unitPrice == null ? null : unitPrice,
    "priceIncludesTax": priceIncludesTax == null ? null : priceIncludesTax,
    "unitCost": unitCost == null ? null : unitCost,
    "taxGroupId": taxGroupId == null ? null : taxGroupId,
    "taxGroupCode": taxGroupCode == null ? null : taxGroupCode,
    "baseUnitOfMeasureId": baseUnitOfMeasureId == null ? null : baseUnitOfMeasureId,
    "baseUnitOfMeasureCode": baseUnitOfMeasureCode == null ? null : baseUnitOfMeasureCode,
    "lastModifiedDateTime": lastModifiedDateTime == null ? null : lastModifiedDateTime!.toIso8601String(),
  };
}

class ItemNotifier extends StateNotifier<List<Item>> {
  ItemNotifier(super.state);

  void add(Item object) {
    state = [...state, object];
  }

  void addList(List<Item> elements) {
    state = elements;
  }

  void edit(Item object) {
    state = [
      for(var row in state)
        if(row.id == object.id)
          row = object
        else
          row
    ];
  }

  void remove(Item object) {
    state = [
      for (final element in state)
        if (element.id != object.id) element,
    ];
  }
}
