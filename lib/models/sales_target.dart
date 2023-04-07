// To parse this JSON data, do
//
//     final salesTarget = salesTargetFromJson(jsonString);

import 'dart:convert';

List<SalesTarget> salesTargetFromJson(String str) => List<SalesTarget>.from(json.decode(str).map((x) => SalesTarget.fromJson(x)));

String salesTargetToJson(List<SalesTarget> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesTarget {
  SalesTarget({
    this.periodId,
    this.listNo,
    this.periodTarget,
    this.empId,
    this.saleAreaId,
    this.saleArea,
  });

  int? periodId;
  int? listNo;
  double? periodTarget;
  int? empId;
  int? saleAreaId;
  String ? saleArea = '';

  factory SalesTarget.fromJson(Map<String, dynamic> json) => SalesTarget(
    periodId: json["periodId"] == null ? null : json["periodId"],
    listNo: json["listNo"] == null ? null : json["listNo"],
    periodTarget: json["periodTarget"] == null ? null : json["periodTarget"].toDouble(),
    empId: json["empId"] == null ? null : json["empId"],
    saleAreaId: json["saleAreaId"] == null ? null : json["saleAreaId"],
    saleArea: json["saleArea"] == null ? null : json["saleArea"],
  );

  Map<String, dynamic> toJson() => {
    "periodId": periodId == null ? null : periodId,
    "listNo": listNo == null ? null : listNo,
    "periodTarget": periodTarget == null ? null : periodTarget,
    "empId": empId == null ? null : empId,
    "saleAreaId": saleAreaId == null ? null : saleAreaId,
    "saleArea": saleArea == null ? null : saleArea,
  };
}
