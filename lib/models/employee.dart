// To parse this JSON data, do
//
//     final employee = employeeFromJson(jsonString);

import 'dart:convert';

Employee employeeFromJson(String str) => Employee.fromJson(json.decode(str));

String employeeToJson(Employee data) => json.encode(data.toJson());

class Employee {
  Employee({
    this.id,
    this.number,
    this.displayName,
    this.givenName,
    this.middleName,
    this.surname,
    this.jobTitle,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.phoneNumber,
    this.mobilePhone,
    this.email,
    this.personalEmail,
    this.employmentDate,
    this.terminationDate,
    this.status,
    this.birthDate,
    this.statisticsGroupCode,
    this.lastModifiedDateTime,
  });

  String? id;
  String? number;
  String? displayName;
  String? givenName;
  String? middleName;
  String? surname;
  String? jobTitle;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  String? phoneNumber;
  String? mobilePhone;
  String? email;
  String? personalEmail;
  DateTime? employmentDate;
  DateTime? terminationDate;
  String? status;
  DateTime? birthDate;
  String? statisticsGroupCode;
  DateTime? lastModifiedDateTime;

  Employee copyWith({
    String? id,
    String? number,
    String? displayName,
    String? givenName,
    String? middleName,
    String? surname,
    String? jobTitle,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? phoneNumber,
    String? mobilePhone,
    String? email,
    String? personalEmail,
    DateTime? employmentDate,
    DateTime? terminationDate,
    String? status,
    DateTime? birthDate,
    String? statisticsGroupCode,
    DateTime? lastModifiedDateTime,
  }) =>
      Employee(
        id: id ?? this.id,
        number: number ?? this.number,
        displayName: displayName ?? this.displayName,
        givenName: givenName ?? this.givenName,
        middleName: middleName ?? this.middleName,
        surname: surname ?? this.surname,
        jobTitle: jobTitle ?? this.jobTitle,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        postalCode: postalCode ?? this.postalCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        mobilePhone: mobilePhone ?? this.mobilePhone,
        email: email ?? this.email,
        personalEmail: personalEmail ?? this.personalEmail,
        employmentDate: employmentDate ?? this.employmentDate,
        terminationDate: terminationDate ?? this.terminationDate,
        status: status ?? this.status,
        birthDate: birthDate ?? this.birthDate,
        statisticsGroupCode: statisticsGroupCode ?? this.statisticsGroupCode,
        lastModifiedDateTime: lastModifiedDateTime ?? this.lastModifiedDateTime,
      );

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["id"] == null ? null : json["id"],
    number: json["number"] == null ? null : json["number"],
    displayName: json["displayName"] == null ? null : json["displayName"],
    givenName: json["givenName"] == null ? null : json["givenName"],
    middleName: json["middleName"] == null ? null : json["middleName"],
    surname: json["surname"] == null ? null : json["surname"],
    jobTitle: json["jobTitle"] == null ? null : json["jobTitle"],
    addressLine1: json["addressLine1"] == null ? null : json["addressLine1"],
    addressLine2: json["addressLine2"] == null ? null : json["addressLine2"],
    city: json["city"] == null ? null : json["city"],
    state: json["state"] == null ? null : json["state"],
    country: json["country"] == null ? null : json["country"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    mobilePhone: json["mobilePhone"] == null ? null : json["mobilePhone"],
    email: json["email"] == null ? null : json["email"],
    personalEmail: json["personalEmail"] == null ? null : json["personalEmail"],
    employmentDate: json["employmentDate"] == null ? null : DateTime.parse(json["employmentDate"]),
    terminationDate: json["terminationDate"] == null ? null : DateTime.parse(json["terminationDate"]),
    status: json["status"] == null ? null : json["status"],
    birthDate: json["birthDate"] == null ? null : DateTime.parse(json["birthDate"]),
    statisticsGroupCode: json["statisticsGroupCode"] == null ? null : json["statisticsGroupCode"],
    lastModifiedDateTime: json["lastModifiedDateTime"] == null ? null : DateTime.parse(json["lastModifiedDateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "number": number == null ? null : number,
    "displayName": displayName == null ? null : displayName,
    "givenName": givenName == null ? null : givenName,
    "middleName": middleName == null ? null : middleName,
    "surname": surname == null ? null : surname,
    "jobTitle": jobTitle == null ? null : jobTitle,
    "addressLine1": addressLine1 == null ? null : addressLine1,
    "addressLine2": addressLine2 == null ? null : addressLine2,
    "city": city == null ? null : city,
    "state": state == null ? null : state,
    "country": country == null ? null : country,
    "postalCode": postalCode == null ? null : postalCode,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "mobilePhone": mobilePhone == null ? null : mobilePhone,
    "email": email == null ? null : email,
    "personalEmail": personalEmail == null ? null : personalEmail,
    "employmentDate": employmentDate == null ? null : "${employmentDate!.year.toString().padLeft(4, '0')}-${employmentDate!.month.toString().padLeft(2, '0')}-${employmentDate!.day.toString().padLeft(2, '0')}",
    "terminationDate": terminationDate == null ? null : "${terminationDate!.year.toString().padLeft(4, '0')}-${terminationDate!.month.toString().padLeft(2, '0')}-${terminationDate!.day.toString().padLeft(2, '0')}",
    "status": status == null ? null : status,
    "birthDate": birthDate == null ? null : "${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}",
    "statisticsGroupCode": statisticsGroupCode == null ? null : statisticsGroupCode,
    "lastModifiedDateTime": lastModifiedDateTime == null ? null : lastModifiedDateTime!.toIso8601String(),
  };
}

