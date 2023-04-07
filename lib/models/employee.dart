// To parse this JSON data, do
//
//     final employee = employeeFromJson(jsonString);

import 'dart:convert';

Employee employeeFromJson(String str) => Employee.fromJson(json.decode(str));

List<Employee> employeeListFromJson(String str) => List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(Employee data) => json.encode(data.toJson());

String employeeListToJson(List<Employee> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
  Employee({
    this.id,
    this.code,
    this.name,
    this.eMail,
    this.phoneNo,
    this.targetSalesMonthly,
    this.targetSalesYearly,
    this.initial,
    this.employeeHead,
    this.team,
    this.buddy,
    this.areacode,
    this.employmentDate,
    this.employeeType,
    this.username,
    this.password,
    this.auxiliaryIndex1,
  });

  int? id;
  String? code;
  String? name;
  String? eMail;
  String? phoneNo;
  int? targetSalesMonthly;
  int? targetSalesYearly;
  String? initial;
  String? employeeHead;
  String? team;
  String? buddy;
  String? areacode;
  DateTime? employmentDate;
  String? employeeType;
  String? username;
  String? password;
  String? auxiliaryIndex1;

  Employee copyWith({
    int? id,
    String? code,
    String? name,
    String? eMail,
    String? phoneNo,
    int? targetSalesMonthly,
    int? targetSalesYearly,
    String? initial,
    String? employeeHead,
    String? team,
    String? buddy,
    String? areacode,
    DateTime? employmentDate,
    String? employeeType,
    String? username,
    String? password,
    String? auxiliaryIndex1,
  }) =>
      Employee(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        eMail: eMail ?? this.eMail,
        phoneNo: phoneNo ?? this.phoneNo,
        targetSalesMonthly: targetSalesMonthly ?? this.targetSalesMonthly,
        targetSalesYearly: targetSalesYearly ?? this.targetSalesYearly,
        initial: initial ?? this.initial,
        employeeHead: employeeHead ?? this.employeeHead,
        team: team ?? this.team,
        buddy: buddy ?? this.buddy,
        areacode: areacode ?? this.areacode,
        employmentDate: employmentDate ?? this.employmentDate,
        employeeType: employeeType ?? this.employeeType,
        username: username ?? this.username,
        password: password ?? this.password,
        auxiliaryIndex1: auxiliaryIndex1 ?? this.auxiliaryIndex1,
      );

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    code: json["code"],
    name: json["name"],
    eMail: json["eMail"],
    phoneNo: json["phoneNo"],
    targetSalesMonthly: json["targetSalesMonthly"],
    targetSalesYearly: json["targetSalesYearly"],
    initial: json["initial"],
    employeeHead: json["employeeHead"],
    team: json["team"],
    buddy: json["buddy"],
    areacode: json["areacode"],
    employmentDate: json["employmentDate"] == null ? null : DateTime.parse(json["employmentDate"]),
    employeeType: json["employeeType"],
    username: json["username"],
    password: json["password"],
    auxiliaryIndex1: json["auxiliaryIndex1"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "eMail": eMail,
    "phoneNo": phoneNo,
    "targetSalesMonthly": targetSalesMonthly,
    "targetSalesYearly": targetSalesYearly,
    "initial": initial,
    "employeeHead": employeeHead,
    "team": team,
    "buddy": buddy,
    "areacode": areacode,
    "employmentDate": "${employmentDate!.year.toString().padLeft(4, '0')}-${employmentDate!.month.toString().padLeft(2, '0')}-${employmentDate!.day.toString().padLeft(2, '0')}",
    "employeeType": employeeType,
    "username": username,
    "password": password,
    "auxiliaryIndex1": auxiliaryIndex1,
  };
}
