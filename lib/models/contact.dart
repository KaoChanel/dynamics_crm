// To parse this JSON data, do
//
//     final contact = contactFromJson(jsonString);

import 'dart:convert';

Contact contactFromJson(String str) => Contact.fromJson(json.decode(str));

List<Contact> contactListFromJson(String str) => List<Contact>.from(json.decode(str).map((x) => Contact.fromJson(x)));

String contactToJson(Contact data) => json.encode(data.toJson());

class Contact {
  Contact({
    this.id,
    this.number,
    this.type,
    this.displayName,
    this.companyNumber,
    this.companyName,
    this.businessRelation,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.phoneNumber,
    this.mobilePhoneNumber,
    this.email,
    this.website,
    this.searchName,
    this.privacyBlocked,
    this.lastInteractionDate,
    this.lastModifiedDateTime,
  });

  String? id;
  String? number;
  String? type;             /// Specifies the type of contact, can be "Company" or "Person".
  String? displayName;
  String? companyNumber;
  String? companyName;
  String? businessRelation;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  String? phoneNumber;
  String? mobilePhoneNumber;
  String? email;
  String? website;
  String? searchName;
  bool? privacyBlocked;
  DateTime? lastInteractionDate;
  DateTime? lastModifiedDateTime;

  Contact copyWith({
    String? id,
    String? number,
    String? type,
    String? displayName,
    String? companyNumber,
    String? companyName,
    String? businessRelation,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? phoneNumber,
    String? mobilePhoneNumber,
    String? email,
    String? website,
    String? searchName,
    bool? privacyBlocked,
    double? longitude,
    double? latitude,
    DateTime? lastInteractionDate,
    DateTime? lastModifiedDateTime,
  }) =>
      Contact(
        id: id ?? this.id,
        number: number ?? this.number,
        type: type ?? this.type,
        displayName: displayName ?? this.displayName,
        companyNumber: companyNumber ?? this.companyNumber,
        companyName: companyName ?? this.companyName,
        businessRelation: businessRelation ?? this.businessRelation,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        postalCode: postalCode ?? this.postalCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        mobilePhoneNumber: mobilePhoneNumber ?? this.mobilePhoneNumber,
        email: email ?? this.email,
        website: website ?? this.website,
        searchName: searchName ?? this.searchName,
        privacyBlocked: privacyBlocked ?? this.privacyBlocked,
        lastInteractionDate: lastInteractionDate ?? this.lastInteractionDate,
        lastModifiedDateTime: lastModifiedDateTime ?? this.lastModifiedDateTime,
      );

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    id: json["id"] == null ? null : json["id"],
    number: json["number"] == null ? null : json["number"],
    type: json["type"] == null ? null : json["type"],
    displayName: json["displayName"] == null ? null : json["displayName"],
    companyNumber: json["companyNumber"] == null ? null : json["companyNumber"],
    companyName: json["companyName"] == null ? null : json["companyName"],
    businessRelation: json["businessRelation"] == null ? null : json["businessRelation"],
    addressLine1: json["addressLine1"] == null ? null : json["addressLine1"],
    addressLine2: json["addressLine2"] == null ? null : json["addressLine2"],
    city: json["city"] == null ? null : json["city"],
    state: json["state"] == null ? null : json["state"],
    country: json["country"] == null ? null : json["country"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    mobilePhoneNumber: json["mobilePhoneNumber"] == null ? null : json["mobilePhoneNumber"],
    email: json["email"] == null ? null : json["email"],
    website: json["website"] == null ? null : json["website"],
    searchName: json["searchName"] == null ? null : json["searchName"],
    privacyBlocked: json["privacyBlocked"] == null ? null : json["privacyBlocked"],
    lastInteractionDate: json["lastInteractionDate"] == null ? null : DateTime.parse(json["lastInteractionDate"]),
    lastModifiedDateTime: json["lastModifiedDateTime"] == null ? null : DateTime.parse(json["lastModifiedDateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "number": number == null ? null : number,
    "type": type == null ? null : type,
    "displayName": displayName == null ? null : displayName,
    "companyNumber": companyNumber == null ? null : companyNumber,
    "companyName": companyName == null ? null : companyName,
    "businessRelation": businessRelation == null ? null : businessRelation,
    "addressLine1": addressLine1 == null ? null : addressLine1,
    "addressLine2": addressLine2 == null ? null : addressLine2,
    "city": city == null ? null : city,
    "state": state == null ? null : state,
    "country": country == null ? null : country,
    "postalCode": postalCode == null ? null : postalCode,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "mobilePhoneNumber": mobilePhoneNumber == null ? null : mobilePhoneNumber,
    "email": email == null ? null : email,
    "website": website == null ? null : website,
    "searchName": searchName == null ? null : searchName,
    "privacyBlocked": privacyBlocked == null ? null : privacyBlocked,
    "lastInteractionDate": lastInteractionDate == null ? null : "${lastInteractionDate!.year.toString().padLeft(4, '0')}-${lastInteractionDate!.month.toString().padLeft(2, '0')}-${lastInteractionDate!.day.toString().padLeft(2, '0')}",
    "lastModifiedDateTime": lastModifiedDateTime == null ? null : "${lastModifiedDateTime!.year.toString().padLeft(4, '0')}-${lastModifiedDateTime!.month.toString().padLeft(2, '0')}-${lastModifiedDateTime!.day.toString().padLeft(2, '0')}",
  };
}
