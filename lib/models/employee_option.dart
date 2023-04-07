import 'dart:convert';

// List<TbmEmployeeOption> tbmEmployeeOptionFromJson(String str) => List<TbmEmployeeOption>.from(json.decode(str).map((x) => TbmEmployeeOption.fromJson(x)));
//
// String tbmEmployeeOptionToJson(List<TbmEmployeeOption> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

EmployeeOption employeeOptionFromJson(String str) => EmployeeOption.fromJson(json.decode(str));

String employeeOptionToJson(EmployeeOption data) => json.encode(data.toJson());

class EmployeeOption {
  EmployeeOption({
    this.rowId,
    this.empId,
    this.empCode,
    this.empName,
    this.emailAlertAppointment,
    this.createDate,
    this.createBy,
    this.updateDate,
    this.updateBy,
  });

  int? rowId;
  int? empId;
  String? empCode;
  String? empName;
  String? emailAlertAppointment;
  DateTime? createDate;
  int? createBy;
  DateTime? updateDate;
  int? updateBy;

  factory EmployeeOption.fromJson(Map<String, dynamic> json) => EmployeeOption(
    rowId: json["rowID"] == null ? null : json["rowID"],
    empId: json["empId"] == null ? null : json["empId"],
    empCode: json["empCode"] == null ? null : json["empCode"],
    empName: json["empName"] == null ? null : json["empName"],
    emailAlertAppointment: json["emailAlertAppointment"] == null ? null : json["emailAlertAppointment"],
    createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
    createBy: json["createBy"] == null ? null : json["createBy"],
    updateDate: json["updateDate"] == null ? null : DateTime.parse(json["updateDate"]),
    updateBy: json["updateBy"] == null ? null : json["updateBy"],
  );

  Map<String, dynamic> toJson() => {
    "rowID": rowId == null ? null : rowId,
    "empId": empId == null ? null : empId,
    "empCode": empCode == null ? null : empCode,
    "empName": empName == null ? null : empName,
    "emailAlertAppointment": emailAlertAppointment == null ? null : emailAlertAppointment,
    "createDate": createDate == null ? null : createDate!.toIso8601String(),
    "createBy": createBy == null ? null : createBy,
    "updateDate": updateDate == null ? null : updateDate!.toIso8601String(),
    "updateBy": updateBy == null ? null : updateBy,
  };
}
