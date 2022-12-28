// To parse this JSON data, do
//
//     final company = companyFromJson(jsonString);

import 'dart:convert';

Company companyFromJson(String str) => Company.fromJson(json.decode(str));

String companyToJson(Company data) => json.encode(data.toJson());

class Company {
  Company({
    this.id,
    this.systemVersion,
    this.name,
    this.displayName,
    this.businessProfileId,
    this.systemCreatedAt,
    this.systemCreatedBy,
    this.systemModifiedAt,
    this.systemModifiedBy,
  });

  String? id;
  String? systemVersion;
  String? name;
  String? displayName;
  String? businessProfileId;
  DateTime? systemCreatedAt;
  String? systemCreatedBy;
  DateTime? systemModifiedAt;
  String? systemModifiedBy;

  Company copyWith({
    String? id,
    String? systemVersion,
    String? name,
    String? displayName,
    String? businessProfileId,
    DateTime? systemCreatedAt,
    String? systemCreatedBy,
    DateTime? systemModifiedAt,
    String? systemModifiedBy,
  }) =>
      Company(
        id: id ?? this.id,
        systemVersion: systemVersion ?? this.systemVersion,
        name: name ?? this.name,
        displayName: displayName ?? this.displayName,
        businessProfileId: businessProfileId ?? this.businessProfileId,
        systemCreatedAt: systemCreatedAt ?? this.systemCreatedAt,
        systemCreatedBy: systemCreatedBy ?? this.systemCreatedBy,
        systemModifiedAt: systemModifiedAt ?? this.systemModifiedAt,
        systemModifiedBy: systemModifiedBy ?? this.systemModifiedBy,
      );

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"] == null ? null : json["id"],
    systemVersion: json["systemVersion"] == null ? null : json["systemVersion"],
    name: json["name"] == null ? null : json["name"],
    displayName: json["displayName"] == null ? null : json["displayName"],
    businessProfileId: json["businessProfileId"] == null ? null : json["businessProfileId"],
    systemCreatedAt: json["systemCreatedAt"] == null ? null : DateTime.parse(json["systemCreatedAt"]),
    systemCreatedBy: json["systemCreatedBy"] == null ? null : json["systemCreatedBy"],
    systemModifiedAt: json["systemModifiedAt"] == null ? null : DateTime.parse(json["systemModifiedAt"]),
    systemModifiedBy: json["systemModifiedBy"] == null ? null : json["systemModifiedBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "systemVersion": systemVersion == null ? null : systemVersion,
    "name": name == null ? null : name,
    "displayName": displayName == null ? null : displayName,
    "businessProfileId": businessProfileId == null ? null : businessProfileId,
    "systemCreatedAt": systemCreatedAt == null ? null : systemCreatedAt!.toIso8601String(),
    "systemCreatedBy": systemCreatedBy == null ? null : systemCreatedBy,
    "systemModifiedAt": systemModifiedAt == null ? null : systemModifiedAt!.toIso8601String(),
    "systemModifiedBy": systemModifiedBy == null ? null : systemModifiedBy,
  };
}
