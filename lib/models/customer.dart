// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

List<Customer> customerListFromJson(String str) => List<Customer>.from(json.decode(str).map((x) => Customer.fromJson(x)));

String customerToJson(List<Customer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Customer {
  Customer({
    this.id,
    this.number,
    this.displayName,
    this.type,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.phoneNumber,
    this.email,
    this.website,
    this.taxLiable,
    this.taxAreaId,
    this.taxAreaDisplayName,
    this.taxRegistrationNumber,
    this.currencyId,
    this.currencyCode,
    this.paymentTermsId,
    this.shipmentMethodId,
    this.paymentMethodId,
    this.blocked,
    this.lastModifiedDateTime,
  });

  String? id;
  String? number;
  String? displayName;
  String? type;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  String? phoneNumber;
  String? email;
  String? website;
  bool? taxLiable;
  String? taxAreaId;
  String? taxAreaDisplayName;
  String? taxRegistrationNumber;
  String? currencyId;
  String? currencyCode;
  String? paymentTermsId;
  String? shipmentMethodId;
  String? paymentMethodId;
  String? blocked;
  DateTime? lastModifiedDateTime;

  Customer copyWith({
    String? id,
    String? number,
    String? displayName,
    String? type,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? phoneNumber,
    String? email,
    String? website,
    bool? taxLiable,
    String? taxAreaId,
    String? taxAreaDisplayName,
    String? taxRegistrationNumber,
    String? currencyId,
    String? currencyCode,
    String? paymentTermsId,
    String? shipmentMethodId,
    String? paymentMethodId,
    String? blocked,
    DateTime? lastModifiedDateTime,
  }) =>
      Customer(
        id: id ?? this.id,
        number: number ?? this.number,
        displayName: displayName ?? this.displayName,
        type: type ?? this.type,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        postalCode: postalCode ?? this.postalCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        website: website ?? this.website,
        taxLiable: taxLiable ?? this.taxLiable,
        taxAreaId: taxAreaId ?? this.taxAreaId,
        taxAreaDisplayName: taxAreaDisplayName ?? this.taxAreaDisplayName,
        taxRegistrationNumber: taxRegistrationNumber ?? this.taxRegistrationNumber,
        currencyId: currencyId ?? this.currencyId,
        currencyCode: currencyCode ?? this.currencyCode,
        paymentTermsId: paymentTermsId ?? this.paymentTermsId,
        shipmentMethodId: shipmentMethodId ?? this.shipmentMethodId,
        paymentMethodId: paymentMethodId ?? this.paymentMethodId,
        blocked: blocked ?? this.blocked,
        lastModifiedDateTime: lastModifiedDateTime ?? this.lastModifiedDateTime,
      );

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"] == null ? null : json["id"],
    number: json["number"] == null ? null : json["number"],
    displayName: json["displayName"] == null ? null : json["displayName"],
    type: json["type"] == null ? null : json["type"],
    addressLine1: json["addressLine1"] == null ? null : json["addressLine1"],
    addressLine2: json["addressLine2"] == null ? null : json["addressLine2"],
    city: json["city"] == null ? null : json["city"],
    state: json["state"] == null ? null : json["state"],
    country: json["country"] == null ? null : json["country"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    email: json["email"] == null ? null : json["email"],
    website: json["website"] == null ? null : json["website"],
    taxLiable: json["taxLiable"] == null ? null : json["taxLiable"],
    taxAreaId: json["taxAreaId"] == null ? null : json["taxAreaId"],
    taxAreaDisplayName: json["taxAreaDisplayName"] == null ? null : json["taxAreaDisplayName"],
    taxRegistrationNumber: json["taxRegistrationNumber"] == null ? null : json["taxRegistrationNumber"],
    currencyId: json["currencyId"] == null ? null : json["currencyId"],
    currencyCode: json["currencyCode"] == null ? null : json["currencyCode"],
    paymentTermsId: json["paymentTermsId"] == null ? null : json["paymentTermsId"],
    shipmentMethodId: json["shipmentMethodId"] == null ? null : json["shipmentMethodId"],
    paymentMethodId: json["paymentMethodId"] == null ? null : json["paymentMethodId"],
    blocked: json["blocked"] == null ? null : json["blocked"],
    lastModifiedDateTime: json["lastModifiedDateTime"] == null ? null : DateTime.parse(json["lastModifiedDateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "number": number == null ? null : number,
    "displayName": displayName == null ? null : displayName,
    "type": type == null ? null : type,
    "addressLine1": addressLine1 == null ? null : addressLine1,
    "addressLine2": addressLine2 == null ? null : addressLine2,
    "city": city == null ? null : city,
    "state": state == null ? null : state,
    "country": country == null ? null : country,
    "postalCode": postalCode == null ? null : postalCode,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "email": email == null ? null : email,
    "website": website == null ? null : website,
    "taxLiable": taxLiable == null ? null : taxLiable,
    "taxAreaId": taxAreaId == null ? null : taxAreaId,
    "taxAreaDisplayName": taxAreaDisplayName == null ? null : taxAreaDisplayName,
    "taxRegistrationNumber": taxRegistrationNumber == null ? null : taxRegistrationNumber,
    "currencyId": currencyId == null ? null : currencyId,
    "currencyCode": currencyCode == null ? null : currencyCode,
    "paymentTermsId": paymentTermsId == null ? null : paymentTermsId,
    "shipmentMethodId": shipmentMethodId == null ? null : shipmentMethodId,
    "paymentMethodId": paymentMethodId == null ? null : paymentMethodId,
    "blocked": blocked == null ? null : blocked,
    "lastModifiedDateTime": lastModifiedDateTime == null ? null : lastModifiedDateTime!.toIso8601String(),
  };
}