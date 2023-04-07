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
    this.no,
    this.no2,
    this.displayName,
    this.description,
    this.description2,
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
    // this.baseUnitOfMeasureId,
    // this.baseUnitOfMeasureCode,
    this.baseUnitOfMeasure,
    this.purchUnitofMeasure,
    this.salesUnitofMeasure,
    this.baseuomdescription,
    this.purchuomdescription,
    this.saleuomdescription,
    this.lastModifiedDateTime,
  });

  String? id;
  String? code;
  String? no;
  String? no2;
  String? displayName;
  String? description;
  String? description2;
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
  // String? baseUnitOfMeasureId;
  // String? baseUnitOfMeasureCode;
  String? baseUnitOfMeasure;
  String? purchUnitofMeasure;
  String? salesUnitofMeasure;
  String? baseuomdescription;
  String? purchuomdescription;
  String? saleuomdescription;
  DateTime? lastModifiedDateTime;

  Item copyWith({
    String? id,
    String? code,
    String? no,
    String? no2,
    String? displayName,
    String? description,
    String? description2,
    String? type,
    String? itemCategoryId,
    String? itemCategoryCode,
    bool? blocked,
    String? gtin,
    int? inventory,
    double? vatRate,
    bool? priceIncludesTax,
    double? unitPrice,
    double? unitCost,
    String? taxGroupId,
    String? taxGroupCode,
    // String? baseUnitOfMeasureId,
    // String? baseUnitOfMeasureCode,
    String? baseUnitOfMeasure,
    String? purchUnitofMeasure,
    String? salesUnitofMeasure,
    String? baseuomdescription,
    String? purchuomdescription,
    String? saleuomdescription,
    DateTime? lastModifiedDateTime,
  }) =>
      Item(
        id: id ?? this.id,
        code: code ?? this.id,
        no: no ?? this.no,
        displayName: displayName ?? this.displayName,
        type: type ?? this.type,
        itemCategoryId: itemCategoryId ?? this.itemCategoryId,
        itemCategoryCode: itemCategoryCode ?? this.itemCategoryCode,
        blocked: blocked ?? this.blocked,
        gtin: gtin ?? this.gtin,
        inventory: inventory ?? this.inventory,
        vatRate: vatRate ?? this.vatRate,
        priceIncludesTax: priceIncludesTax ?? this.priceIncludesTax,
        unitPrice: unitPrice ?? this.unitPrice,
        unitCost: unitCost ?? this.unitCost,
        taxGroupId: taxGroupId ?? this.taxGroupId,
        taxGroupCode: taxGroupCode ?? this.taxGroupCode,
        // baseUnitOfMeasureId: baseUnitOfMeasureId ?? this.baseUnitOfMeasureId,
        // baseUnitOfMeasureCode: baseUnitOfMeasureCode ?? this.baseUnitOfMeasureCode,
        baseUnitOfMeasure: baseUnitOfMeasure ?? this.baseUnitOfMeasure,
        purchUnitofMeasure: purchUnitofMeasure ?? this.purchUnitofMeasure,
        salesUnitofMeasure: salesUnitofMeasure ?? this.salesUnitofMeasure,
        baseuomdescription: baseuomdescription ?? this.baseuomdescription,
        purchuomdescription: purchuomdescription ?? this.purchuomdescription,
        saleuomdescription: saleuomdescription ?? this.saleuomdescription,
        lastModifiedDateTime: lastModifiedDateTime ?? this.lastModifiedDateTime,
      );

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"] == null ? null : json["id"],
    code: json["code"] == null ? null : json["code"],
    no: json["no"] == null ? null : json["no"],
    no2: json["no2"] == null ? null : json["no2"],
    displayName: json["displayName"] == null ? null : json["displayName"],
    description: json["description"] == null ? null : json["description"],
    description2: json["description2"] == null ? null : json["description2"],
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
    // baseUnitOfMeasureId: json["baseUnitOfMeasureId"] == null ? null : json["baseUnitOfMeasureId"],
    // baseUnitOfMeasureCode: json["baseUnitOfMeasureCode"] == null ? null : json["baseUnitOfMeasureCode"],
    baseUnitOfMeasure: json["baseUnitOfMeasure"],
    purchUnitofMeasure: json["purchUnitofMeasure"],
    salesUnitofMeasure: json["salesUnitofMeasure"],
    baseuomdescription: json["baseuomdescription"],
    purchuomdescription: json["purchuomdescription"],
    saleuomdescription: json["saleuomdescription"],
    lastModifiedDateTime: json["lastModifiedDateTime"] == null ? null : DateTime.parse(json["lastModifiedDateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "code": code == null ? null : code,
    "no": no == null ? null : no,
    "no2": no2 == null ? null : no2,
    "displayName": displayName == null ? null : displayName,
    "description": description == null ? null : description,
    "description2": description2 == null ? null : description2,
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
    // "baseUnitOfMeasureId": baseUnitOfMeasureId == null ? null : baseUnitOfMeasureId,
    // "baseUnitOfMeasureCode": baseUnitOfMeasureCode == null ? null : baseUnitOfMeasureCode,
    "baseUnitOfMeasure": baseUnitOfMeasure,
    "purchUnitofMeasure": purchUnitofMeasure,
    "salesUnitofMeasure": salesUnitofMeasure,
    "baseuomdescription": baseuomdescription,
    "purchuomdescription": purchuomdescription,
    "saleuomdescription": saleuomdescription,
    "lastModifiedDateTime": lastModifiedDateTime == null ? null : lastModifiedDateTime!.toIso8601String(),
  };
}

class ItemNotifier extends StateNotifier<List<Item>> {
  ItemNotifier(super.state);

  List<Item> get() => state;

  List<Item> getBy(String keyword) {
    List<Item> result = state.where((e) => e.code != null ? e.code!.toLowerCase().contains(keyword.toLowerCase()) : false
        || e.displayName != null ? e.displayName!.toLowerCase().contains(keyword.toLowerCase()) : false
        || e.itemCategoryCode != null ? e.itemCategoryCode!.toLowerCase().contains(keyword.toLowerCase()) : false
        || e.baseUnitOfMeasure != null ? e.baseUnitOfMeasure!.toLowerCase().contains(keyword.toLowerCase()) : false
    ).toList();
    return result;
  }

  void add(Item object) {
    state = [...state, object];
  }

  void addAll(List<Item> objects) {
    for(var item in objects) {
      state = [...state, item];
    }
  }

  void replace(List<Item> elements) {
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

  void clear() => state = [];
}
