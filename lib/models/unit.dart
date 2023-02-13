// To parse this JSON data, do
//
//     final unit = unitFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

Unit unitFromJson(String str) => Unit.fromJson(json.decode(str));

List<Unit> unitListFromJson(String str) => List<Unit>.from(json.decode(str).map((x) => Unit.fromJson(x)));

String unitToJson(List<Unit> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Unit {
  Unit({
    this.id,
    this.code,
    this.displayName,
    this.internationalStandardCode,
    this.symbol,
    this.lastModifiedDateTime,
  });

  String? id;
  String? code;
  String? displayName;
  String? internationalStandardCode;
  String? symbol;
  DateTime? lastModifiedDateTime;

  Unit copyWith({
    String? id,
    String? code,
    String? displayName,
    String? internationalStandardCode,
    String? symbol,
    DateTime? lastModifiedDateTime,
  }) =>
      Unit(
        id: id ?? this.id,
        code: code ?? this.code,
        displayName: displayName ?? this.displayName,
        internationalStandardCode: internationalStandardCode ?? this.internationalStandardCode,
        symbol: symbol ?? this.symbol,
        lastModifiedDateTime: lastModifiedDateTime ?? this.lastModifiedDateTime,
      );

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    id: json["id"] == null ? null : json["id"],
    code: json["code"] == null ? null : json["code"],
    displayName: json["displayName"] == null ? null : json["displayName"],
    internationalStandardCode: json["internationalStandardCode"] == null ? null : json["internationalStandardCode"],
    symbol: json["symbol"] == null ? null : json["symbol"],
    lastModifiedDateTime: json["lastModifiedDateTime"] == null ? null : DateTime.parse(json["lastModifiedDateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "code": code == null ? null : code,
    "displayName": displayName == null ? null : displayName,
    "internationalStandardCode": internationalStandardCode == null ? null : internationalStandardCode,
    "symbol": symbol == null ? null : symbol,
    "lastModifiedDateTime": lastModifiedDateTime == null ? null : lastModifiedDateTime!.toIso8601String(),
  };
}

class UnitNotifier extends StateNotifier<List<Unit>> {
  UnitNotifier(): super([]);

  void add(Unit object) {
    state = [...state, object];
  }

  void edit(Unit object) {
    state = [
      for(var element in state)
        if(element.id == object.id)
          element = object
        else
          element
    ];
  }

  void remove(Unit object) {
    state = [
      for (final element in state)
        if (element.id != object.id) element,
    ];
  }
}

// Finally, we are using StateNotifierProvider to allow the UI to interact
final unitsProvider = StateNotifierProvider<UnitNotifier, List<Unit>>((ref) {
  return UnitNotifier();
});
