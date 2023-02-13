// To parse this JSON data, do
//
//     final customerFinancialDetail = customerFinancialDetailFromJson(jsonString);

import 'dart:convert';

CustomerFinancialDetail customerFinancialDetailFromJson(String str) => CustomerFinancialDetail.fromJson(json.decode(str));

List<CustomerFinancialDetail> customerFinancialDetailListFromJson(String str) => List<CustomerFinancialDetail>.from(json.decode(str).map((x) => CustomerFinancialDetail.fromJson(x)));

String customerFinancialDetailToJson(List<CustomerFinancialDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerFinancialDetail {
  CustomerFinancialDetail({
    this.id,
    this.number,
    this.balance,
    this.totalSalesExcludingTax,
    this.overdueAmount,
  });

  String? id;
  String? number;
  double? balance;
  double? totalSalesExcludingTax;
  double? overdueAmount;

  CustomerFinancialDetail copyWith({
    String? id,
    String? number,
    double? balance,
    double? totalSalesExcludingTax,
    double? overdueAmount,
  }) =>
      CustomerFinancialDetail(
        id: id ?? this.id,
        number: number ?? this.number,
        balance: balance ?? this.balance,
        totalSalesExcludingTax: totalSalesExcludingTax ?? this.totalSalesExcludingTax,
        overdueAmount: overdueAmount ?? this.overdueAmount,
      );

  factory CustomerFinancialDetail.fromJson(Map<String, dynamic> json) => CustomerFinancialDetail(
    id: json["id"] == null ? null : json["id"],
    number: json["number"] == null ? null : json["number"],
    balance: json["balance"] == null ? null : json["balance"],
    totalSalesExcludingTax: json["totalSalesExcludingTax"] == null ? null : json["totalSalesExcludingTax"],
    overdueAmount: json["overdueAmount"] == null ? null : json["overdueAmount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "number": number == null ? null : number,
    "balance": balance == null ? null : balance,
    "totalSalesExcludingTax": totalSalesExcludingTax == null ? null : totalSalesExcludingTax,
    "overdueAmount": overdueAmount == null ? null : overdueAmount,
  };
}