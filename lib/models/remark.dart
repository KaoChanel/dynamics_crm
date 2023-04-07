// To parse this JSON data, do
//
//     final remark = remarkFromJson(jsonString);

import 'dart:convert';

List<Remark> remarkFromJson(String str) => List<Remark>.from(json.decode(str).map((x) => Remark.fromJson(x)));

String remarkToJson(List<Remark> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Remark {
  Remark({
    this.rowId,
    this.remark,
    this.remarkGroup,
    this.sequence,
  });

  int? rowId;
  String? remark;
  dynamic remarkGroup;
  int? sequence;

  Remark copyWith({
    int? rowId,
    String? remark,
    dynamic remarkGroup,
    int? sequence,
  }) =>
      Remark(
        rowId: rowId ?? this.rowId,
        remark: remark ?? this.remark,
        remarkGroup: remarkGroup ?? this.remarkGroup,
        sequence: sequence ?? this.sequence,
      );

  factory Remark.fromJson(Map<String, dynamic> json) => Remark(
    rowId: json["rowId"],
    remark: json["remark"],
    remarkGroup: json["remarkGroup"],
    sequence: json["sequence"],
  );

  Map<String, dynamic> toJson() => {
    "rowId": rowId,
    "remark": remark,
    "remarkGroup": remarkGroup,
    "sequence": sequence,
  };
}
