// To parse this JSON data, do
//
//     final salesShipment = salesShipmentFromJson(jsonString);

import 'dart:convert';

List<SalesShipment> salesShipmentFromJson(String str) => List<SalesShipment>.from(json.decode(str).map((x) => SalesShipment.fromJson(x)));

String salesShipmentToJson(List<SalesShipment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesShipment {
  SalesShipment({
    this.systemId,
    this.customerNo,
    this.code,
    this.name,
    this.name2,
    this.address,
    this.address2,
    this.city,
    this.contact,
    this.phoneNo,
    this.telexNo,
    this.shipmentMethodCode,
    this.shippingAgentCode,
    this.placeOfExport,
    this.countryRegionCode,
    this.lastDateModified,
    this.locationCode,
    this.faxNo,
    this.telexAnswerBack,
    this.gln,
    this.postCode,
    this.county,
    this.eMail,
    this.homePage,
    this.taxAreaCode,
    this.taxLiable,
    this.shippingAgentServiceCode,
    this.serviceZoneCode,
    this.thambon,
    this.amphur,
    this.receiveGoodCondition,
    this.defaultcode,
  });

  String? systemId;
  String? customerNo;
  String? code;
  String? name;
  String? name2;
  String? address;
  String? address2;
  String? city;
  String? contact;
  String? phoneNo;
  String? telexNo;
  String? shipmentMethodCode;
  String? shippingAgentCode;
  String? placeOfExport;
  String? countryRegionCode;
  DateTime? lastDateModified;
  String? locationCode;
  String? faxNo;
  String? telexAnswerBack;
  String? gln;
  String? postCode;
  String? county;
  String? eMail;
  String? homePage;
  String? taxAreaCode;
  bool? taxLiable;
  String? shippingAgentServiceCode;
  String? serviceZoneCode;
  String? thambon;
  String? amphur;
  String? receiveGoodCondition;
  bool? defaultcode;

  SalesShipment copyWith({
    String? systemId,
    String? customerNo,
    String? code,
    String? name,
    String? name2,
    String? address,
    String? address2,
    String? city,
    String? contact,
    String? phoneNo,
    String? telexNo,
    String? shipmentMethodCode,
    String? shippingAgentCode,
    String? placeOfExport,
    String? countryRegionCode,
    DateTime? lastDateModified,
    String? locationCode,
    String? faxNo,
    String? telexAnswerBack,
    String? gln,
    String? postCode,
    String? county,
    String? eMail,
    String? homePage,
    String? taxAreaCode,
    bool? taxLiable,
    String? shippingAgentServiceCode,
    String? serviceZoneCode,
    String? thambon,
    String? amphur,
    String? receiveGoodCondition,
    bool? defaultcode,
  }) =>
      SalesShipment(
        systemId: systemId ?? this.systemId,
        customerNo: customerNo ?? this.customerNo,
        code: code ?? this.code,
        name: name ?? this.name,
        name2: name2 ?? this.name2,
        address: address ?? this.address,
        address2: address2 ?? this.address2,
        city: city ?? this.city,
        contact: contact ?? this.contact,
        phoneNo: phoneNo ?? this.phoneNo,
        telexNo: telexNo ?? this.telexNo,
        shipmentMethodCode: shipmentMethodCode ?? this.shipmentMethodCode,
        shippingAgentCode: shippingAgentCode ?? this.shippingAgentCode,
        placeOfExport: placeOfExport ?? this.placeOfExport,
        countryRegionCode: countryRegionCode ?? this.countryRegionCode,
        lastDateModified: lastDateModified ?? this.lastDateModified,
        locationCode: locationCode ?? this.locationCode,
        faxNo: faxNo ?? this.faxNo,
        telexAnswerBack: telexAnswerBack ?? this.telexAnswerBack,
        gln: gln ?? this.gln,
        postCode: postCode ?? this.postCode,
        county: county ?? this.county,
        eMail: eMail ?? this.eMail,
        homePage: homePage ?? this.homePage,
        taxAreaCode: taxAreaCode ?? this.taxAreaCode,
        taxLiable: taxLiable ?? this.taxLiable,
        shippingAgentServiceCode: shippingAgentServiceCode ?? this.shippingAgentServiceCode,
        serviceZoneCode: serviceZoneCode ?? this.serviceZoneCode,
        thambon: thambon ?? this.thambon,
        amphur: amphur ?? this.amphur,
        receiveGoodCondition: receiveGoodCondition ?? this.receiveGoodCondition,
        defaultcode: defaultcode ?? this.defaultcode,
      );

  factory SalesShipment.fromJson(Map<String, dynamic> json) => SalesShipment(
    systemId: json["SystemId"],
    customerNo: json["customerNo"],
    code: json["code"],
    name: json["name"],
    name2: json["name2"],
    address: json["address"],
    address2: json["address2"],
    city: json["city"],
    contact: json["contact"],
    phoneNo: json["phoneNo"],
    telexNo: json["telexNo"],
    shipmentMethodCode: json["shipmentMethodCode"],
    shippingAgentCode: json["shippingAgentCode"],
    placeOfExport: json["placeOfExport"],
    countryRegionCode: json["countryRegionCode"],
    lastDateModified: json["lastDateModified"] == null ? null : DateTime.parse(json["lastDateModified"]),
    locationCode: json["locationCode"],
    faxNo: json["faxNo"],
    telexAnswerBack: json["telexAnswerBack"],
    gln: json["gln"],
    postCode: json["postCode"],
    county: json["county"],
    eMail: json["eMail"],
    homePage: json["homePage"],
    taxAreaCode: json["taxAreaCode"],
    taxLiable: json["taxLiable"],
    shippingAgentServiceCode: json["shippingAgentServiceCode"],
    serviceZoneCode: json["serviceZoneCode"],
    thambon: json["thambon"],
    amphur: json["amphur"],
    receiveGoodCondition: json["receiveGoodCondition"],
    defaultcode: json["defaultcode"],
  );

  Map<String, dynamic> toJson() => {
    "SystemId": systemId,
    "customerNo": customerNo,
    "code": code,
    "name": name,
    "name2": name2,
    "address": address,
    "address2": address2,
    "city": city,
    "contact": contact,
    "phoneNo": phoneNo,
    "telexNo": telexNo,
    "shipmentMethodCode": shipmentMethodCode,
    "shippingAgentCode": shippingAgentCode,
    "placeOfExport": placeOfExport,
    "countryRegionCode": countryRegionCode,
    "lastDateModified": "${lastDateModified!.year.toString().padLeft(4, '0')}-${lastDateModified!.month.toString().padLeft(2, '0')}-${lastDateModified!.day.toString().padLeft(2, '0')}",
    "locationCode": locationCode,
    "faxNo": faxNo,
    "telexAnswerBack": telexAnswerBack,
    "gln": gln,
    "postCode": postCode,
    "county": county,
    "eMail": eMail,
    "homePage": homePage,
    "taxAreaCode": taxAreaCode,
    "taxLiable": taxLiable,
    "shippingAgentServiceCode": shippingAgentServiceCode,
    "serviceZoneCode": serviceZoneCode,
    "thambon": thambon,
    "amphur": amphur,
    "receiveGoodCondition": receiveGoodCondition,
    "defaultcode": defaultcode,
  };
}
