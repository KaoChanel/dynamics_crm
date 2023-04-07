// To parse this JSON data, do
//
//     final stock = stockFromJson(jsonString);

import 'dart:convert';

List<Inventory> inventoryFromJson(String str) => List<Inventory>.from(json.decode(str).map((x) => Inventory.fromJson(x)));

String inventoryToJson(List<Inventory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Inventory {
  Inventory({
    this.orderNumber,
    this.goodid,
    this.goodCode,
    this.goodName1,
    this.goodUnitCode,
    this.remaqty,
    this.lotNo,
    this.expiredate,
    this.vendorlotno,
    this.producedate,
    this.inveid,
    this.inveName,
    this.locaid,
    this.serialNo,
  });

  String key = '';
  int? orderNumber;
  String? goodid;
  String? goodCode;
  String? goodName1;
  String? goodUnitCode;
  double? remaqty;
  String? lotNo;
  DateTime? expiredate;
  String? vendorlotno;
  DateTime? producedate;
  String? inveid;
  String? inveName;
  String? locaid;
  String? serialNo;

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
    goodid: json["goodid"] == null ? null : json["goodid"],
    goodCode: json["goodCode"] == null ? null : json["goodCode"],
    goodName1: json["goodName1"] == null ? null : json["goodName1"],
    goodUnitCode: json["goodUnitCode"] == null ? null : json["goodUnitCode"],
    remaqty: json["remaqty"] == null ? null : json["remaqty"],
    lotNo: json["lotNo"] == null ? null : json["lotNo"],
    expiredate: json["expiredate"] == null ? null : DateTime.parse(json["expiredate"]),
    vendorlotno: json["vendorlotno"] == null ? null : json["vendorlotno"],
    producedate: json["producedate"] == null ? null : DateTime.parse(json["producedate"]),
    inveid: json["inveid"] == null ? null : json["inveid"],
    inveName: json["inveName"] == null ? null : json["inveName"],
    locaid: json["locaid"] == null ? null : json["locaid"],
    serialNo: json["serialNo"] == null ? null : json["serialNo"],
  );

  Map<String, dynamic> toJson() => {
    "goodid": goodid == null ? null : goodid,
    "goodCode": goodCode == null ? null : goodCode,
    "goodName1": goodName1 == null ? null : goodName1,
    "goodUnitCode": goodUnitCode == null ? null : goodUnitCode,
    "remaqty": remaqty == null ? null : remaqty,
    "lotNo": lotNo == null ? null : lotNo,
    "expiredate": expiredate == null ? null : expiredate!.toIso8601String(),
    "vendorlotno": vendorlotno == null ? null : vendorlotno,
    "producedate": producedate == null ? null : producedate!.toIso8601String(),
    "inveid": inveid == null ? null : inveid,
    "inveName": inveName == null ? null : inveName,
    "locaid": locaid == null ? null : locaid,
    "serialNo": serialNo == null ? null : serialNo,
  };
}
