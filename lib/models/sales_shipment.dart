// To parse this JSON data, do
//
//     final salesShipment = salesShipmentFromJson(jsonString);

import 'dart:convert';

SalesShipment salesShipmentFromJson(String str) => SalesShipment.fromJson(json.decode(str));

List<SalesShipment> salesShipmentListFromJson(String str) => List<SalesShipment>.from(json.decode(str).map((x) => SalesShipment.fromJson(x)));

String salesShipmentToJson(SalesShipment data) => json.encode(data.toJson());

class SalesShipment {
  SalesShipment({
    this.id,
    this.number,
    this.externalDocumentNumber,
    this.invoiceDate,
    this.postingDate,
    this.dueDate,
    this.customerPurchaseOrderReference,
    this.customerNumber,
    this.customerName,
    this.billToName,
    this.billToCustomerNumber,
    this.shipToName,
    this.shipToContact,
    this.sellToAddressLine1,
    this.sellToAddressLine2,
    this.sellToCity,
    this.sellToCountry,
    this.sellToState,
    this.sellToPostCode,
    this.billToAddressLine1,
    this.billToAddressLine2,
    this.billToCity,
    this.billToCountry,
    this.billToState,
    this.billToPostCode,
    this.shipToAddressLine1,
    this.shipToAddressLine2,
    this.shipToCity,
    this.shipToCountry,
    this.shipToState,
    this.shipToPostCode,
    this.currencyCode,
    this.orderNumber,
    this.paymentTermsCode,
    this.shipmentMethodCode,
    this.salesperson,
    this.pricesIncludeTax,
    this.lastModifiedDateTime,
    this.phoneNumber,
    this.email,
  });

  String? id;
  String? number;
  String? externalDocumentNumber;
  String? invoiceDate;
  String? postingDate;
  String? dueDate;
  String? customerPurchaseOrderReference;
  String? customerNumber;
  String? customerName;
  String? billToName;
  String? billToCustomerNumber;
  String? shipToName;
  String? shipToContact;
  String? sellToAddressLine1;
  String? sellToAddressLine2;
  String? sellToCity;
  String? sellToCountry;
  String? sellToState;
  String? sellToPostCode;
  String? billToAddressLine1;
  String? billToAddressLine2;
  String? billToCity;
  String? billToCountry;
  String? billToState;
  String? billToPostCode;
  String? shipToAddressLine1;
  String? shipToAddressLine2;
  String? shipToCity;
  String? shipToCountry;
  String? shipToState;
  String? shipToPostCode;
  String? currencyCode;
  String? orderNumber;
  String? paymentTermsCode;
  String? shipmentMethodCode;
  String? salesperson;
  String? pricesIncludeTax;
  String? lastModifiedDateTime;
  String? phoneNumber;
  String? email;

  SalesShipment copyWith({
    String? id,
    String? number,
    String? externalDocumentNumber,
    String? invoiceDate,
    String? postingDate,
    String? dueDate,
    String? customerPurchaseOrderReference,
    String? customerNumber,
    String? customerName,
    String? billToName,
    String? billToCustomerNumber,
    String? shipToName,
    String? shipToContact,
    String? sellToAddressLine1,
    String? sellToAddressLine2,
    String? sellToCity,
    String? sellToCountry,
    String? sellToState,
    String? sellToPostCode,
    String? billToAddressLine1,
    String? billToAddressLine2,
    String? billToCity,
    String? billToCountry,
    String? billToState,
    String? billToPostCode,
    String? shipToAddressLine1,
    String? shipToAddressLine2,
    String? shipToCity,
    String? shipToCountry,
    String? shipToState,
    String? shipToPostCode,
    String? currencyCode,
    String? orderNumber,
    String? paymentTermsCode,
    String? shipmentMethodCode,
    String? salesperson,
    String? pricesIncludeTax,
    String? lastModifiedDateTime,
    String? phoneNumber,
    String? email,
  }) =>
      SalesShipment(
        id: id ?? this.id,
        number: number ?? this.number,
        externalDocumentNumber: externalDocumentNumber ?? this.externalDocumentNumber,
        invoiceDate: invoiceDate ?? this.invoiceDate,
        postingDate: postingDate ?? this.postingDate,
        dueDate: dueDate ?? this.dueDate,
        customerPurchaseOrderReference: customerPurchaseOrderReference ?? this.customerPurchaseOrderReference,
        customerNumber: customerNumber ?? this.customerNumber,
        customerName: customerName ?? this.customerName,
        billToName: billToName ?? this.billToName,
        billToCustomerNumber: billToCustomerNumber ?? this.billToCustomerNumber,
        shipToName: shipToName ?? this.shipToName,
        shipToContact: shipToContact ?? this.shipToContact,
        sellToAddressLine1: sellToAddressLine1 ?? this.sellToAddressLine1,
        sellToAddressLine2: sellToAddressLine2 ?? this.sellToAddressLine2,
        sellToCity: sellToCity ?? this.sellToCity,
        sellToCountry: sellToCountry ?? this.sellToCountry,
        sellToState: sellToState ?? this.sellToState,
        sellToPostCode: sellToPostCode ?? this.sellToPostCode,
        billToAddressLine1: billToAddressLine1 ?? this.billToAddressLine1,
        billToAddressLine2: billToAddressLine2 ?? this.billToAddressLine2,
        billToCity: billToCity ?? this.billToCity,
        billToCountry: billToCountry ?? this.billToCountry,
        billToState: billToState ?? this.billToState,
        billToPostCode: billToPostCode ?? this.billToPostCode,
        shipToAddressLine1: shipToAddressLine1 ?? this.shipToAddressLine1,
        shipToAddressLine2: shipToAddressLine2 ?? this.shipToAddressLine2,
        shipToCity: shipToCity ?? this.shipToCity,
        shipToCountry: shipToCountry ?? this.shipToCountry,
        shipToState: shipToState ?? this.shipToState,
        shipToPostCode: shipToPostCode ?? this.shipToPostCode,
        currencyCode: currencyCode ?? this.currencyCode,
        orderNumber: orderNumber ?? this.orderNumber,
        paymentTermsCode: paymentTermsCode ?? this.paymentTermsCode,
        shipmentMethodCode: shipmentMethodCode ?? this.shipmentMethodCode,
        salesperson: salesperson ?? this.salesperson,
        pricesIncludeTax: pricesIncludeTax ?? this.pricesIncludeTax,
        lastModifiedDateTime: lastModifiedDateTime ?? this.lastModifiedDateTime,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
      );

  factory SalesShipment.fromJson(Map<String, dynamic> json) => SalesShipment(
    id: json["id"] == null ? null : json["id"],
    number: json["number"] == null ? null : json["number"],
    externalDocumentNumber: json["externalDocumentNumber"] == null ? null : json["externalDocumentNumber"],
    invoiceDate: json["invoiceDate"] == null ? null : json["invoiceDate"],
    postingDate: json["postingDate"] == null ? null : json["postingDate"],
    dueDate: json["dueDate"] == null ? null : json["dueDate"],
    customerPurchaseOrderReference: json["customerPurchaseOrderReference"] == null ? null : json["customerPurchaseOrderReference"],
    customerNumber: json["customerNumber"] == null ? null : json["customerNumber"],
    customerName: json["customerName"] == null ? null : json["customerName"],
    billToName: json["billToName"] == null ? null : json["billToName"],
    billToCustomerNumber: json["billToCustomerNumber"] == null ? null : json["billToCustomerNumber"],
    shipToName: json["shipToName"] == null ? null : json["shipToName"],
    shipToContact: json["shipToContact"] == null ? null : json["shipToContact"],
    sellToAddressLine1: json["sellToAddressLine1"] == null ? null : json["sellToAddressLine1"],
    sellToAddressLine2: json["sellToAddressLine2"] == null ? null : json["sellToAddressLine2"],
    sellToCity: json["sellToCity"] == null ? null : json["sellToCity"],
    sellToCountry: json["sellToCountry"] == null ? null : json["sellToCountry"],
    sellToState: json["sellToState"] == null ? null : json["sellToState"],
    sellToPostCode: json["sellToPostCode"] == null ? null : json["sellToPostCode"],
    billToAddressLine1: json["billToAddressLine1"] == null ? null : json["billToAddressLine1"],
    billToAddressLine2: json["billToAddressLine2"] == null ? null : json["billToAddressLine2"],
    billToCity: json["billToCity"] == null ? null : json["billToCity"],
    billToCountry: json["billToCountry"] == null ? null : json["billToCountry"],
    billToState: json["billToState"] == null ? null : json["billToState"],
    billToPostCode: json["billToPostCode"] == null ? null : json["billToPostCode"],
    shipToAddressLine1: json["shipToAddressLine1"] == null ? null : json["shipToAddressLine1"],
    shipToAddressLine2: json["shipToAddressLine2"] == null ? null : json["shipToAddressLine2"],
    shipToCity: json["shipToCity"] == null ? null : json["shipToCity"],
    shipToCountry: json["shipToCountry"] == null ? null : json["shipToCountry"],
    shipToState: json["shipToState"] == null ? null : json["shipToState"],
    shipToPostCode: json["shipToPostCode"] == null ? null : json["shipToPostCode"],
    currencyCode: json["currencyCode"] == null ? null : json["currencyCode"],
    orderNumber: json["orderNumber"] == null ? null : json["orderNumber"],
    paymentTermsCode: json["paymentTermsCode"] == null ? null : json["paymentTermsCode"],
    shipmentMethodCode: json["shipmentMethodCode"] == null ? null : json["shipmentMethodCode"],
    salesperson: json["salesperson"] == null ? null : json["salesperson"],
    pricesIncludeTax: json["pricesIncludeTax"] == null ? null : json["pricesIncludeTax"],
    lastModifiedDateTime: json["lastModifiedDateTime"] == null ? null : json["lastModifiedDateTime"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    email: json["email"] == null ? null : json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "number": number == null ? null : number,
    "externalDocumentNumber": externalDocumentNumber == null ? null : externalDocumentNumber,
    "invoiceDate": invoiceDate == null ? null : invoiceDate,
    "postingDate": postingDate == null ? null : postingDate,
    "dueDate": dueDate == null ? null : dueDate,
    "customerPurchaseOrderReference": customerPurchaseOrderReference == null ? null : customerPurchaseOrderReference,
    "customerNumber": customerNumber == null ? null : customerNumber,
    "customerName": customerName == null ? null : customerName,
    "billToName": billToName == null ? null : billToName,
    "billToCustomerNumber": billToCustomerNumber == null ? null : billToCustomerNumber,
    "shipToName": shipToName == null ? null : shipToName,
    "shipToContact": shipToContact == null ? null : shipToContact,
    "sellToAddressLine1": sellToAddressLine1 == null ? null : sellToAddressLine1,
    "sellToAddressLine2": sellToAddressLine2 == null ? null : sellToAddressLine2,
    "sellToCity": sellToCity == null ? null : sellToCity,
    "sellToCountry": sellToCountry == null ? null : sellToCountry,
    "sellToState": sellToState == null ? null : sellToState,
    "sellToPostCode": sellToPostCode == null ? null : sellToPostCode,
    "billToAddressLine1": billToAddressLine1 == null ? null : billToAddressLine1,
    "billToAddressLine2": billToAddressLine2 == null ? null : billToAddressLine2,
    "billToCity": billToCity == null ? null : billToCity,
    "billToCountry": billToCountry == null ? null : billToCountry,
    "billToState": billToState == null ? null : billToState,
    "billToPostCode": billToPostCode == null ? null : billToPostCode,
    "shipToAddressLine1": shipToAddressLine1 == null ? null : shipToAddressLine1,
    "shipToAddressLine2": shipToAddressLine2 == null ? null : shipToAddressLine2,
    "shipToCity": shipToCity == null ? null : shipToCity,
    "shipToCountry": shipToCountry == null ? null : shipToCountry,
    "shipToState": shipToState == null ? null : shipToState,
    "shipToPostCode": shipToPostCode == null ? null : shipToPostCode,
    "currencyCode": currencyCode == null ? null : currencyCode,
    "orderNumber": orderNumber == null ? null : orderNumber,
    "paymentTermsCode": paymentTermsCode == null ? null : paymentTermsCode,
    "shipmentMethodCode": shipmentMethodCode == null ? null : shipmentMethodCode,
    "salesperson": salesperson == null ? null : salesperson,
    "pricesIncludeTax": pricesIncludeTax == null ? null : pricesIncludeTax,
    "lastModifiedDateTime": lastModifiedDateTime == null ? null : lastModifiedDateTime,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "email": email == null ? null : email,
  };
}
