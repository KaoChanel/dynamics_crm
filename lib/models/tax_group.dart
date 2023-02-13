// To parse this JSON data, do
//
//     final taxGroup = taxGroupFromJson(jsonString);

import 'dart:convert';

TaxGroup? taxGroupFromJson(String str) => TaxGroup.fromJson(json.decode(str));

List<TaxGroup?>? taxGroupListFromJson(String str) => json.decode(str) == null ? [] : List<TaxGroup?>.from(json.decode(str)!.map((x) => TaxGroup.fromJson(x)));

String taxGroupToJson(TaxGroup? data) => json.encode(data!.toJson());

String taxGroupListToJson(List<TaxGroup?>? data) => json.encode(data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())));

class TaxGroup {
  TaxGroup({
    this.id,
    this.code,
    this.displayName,
    this.taxType,
    this.lastModifiedDateTime,
  });

  String? id;
  String? code;
  String? displayName;
  String? taxType;
  DateTime? lastModifiedDateTime;

  TaxGroup copyWith({
    String? id,
    String? code,
    String? displayName,
    String? taxType,
    DateTime? lastModifiedDateTime,
  }) =>
      TaxGroup(
        id: id ?? this.id,
        code: code ?? this.code,
        displayName: displayName ?? this.displayName,
        taxType: taxType ?? this.taxType,
        lastModifiedDateTime: lastModifiedDateTime ?? this.lastModifiedDateTime,
      );

  factory TaxGroup.fromJson(Map<String, dynamic> json) => TaxGroup(
    id: json["id"],
    code: json["code"],
    displayName: json["displayName"],
    taxType: json["taxType"],
    lastModifiedDateTime: json["lastModifiedDateTime"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "displayName": displayName,
    "taxType": taxType,
    "lastModifiedDateTime": lastModifiedDateTime,
  };
}
