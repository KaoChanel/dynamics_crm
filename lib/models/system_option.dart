// To parse this JSON data, do
//
//     final option = optionFromJson(jsonString);

import 'dart:convert';

List<SystemOption> systemOptionFromJson(String str) => List<SystemOption>.from(json.decode(str).map((x) => SystemOption.fromJson(x)));

String systemOptionToJson(List<SystemOption> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SystemOption {
  SystemOption({
    this.brchId,
    this.vatgroupId,
    this.era,
    this.postGl,
    this.multiCurrency,
    this.showMoneySign,
    this.signPosition,
    this.amntdec,
    this.qtydec,
    this.unitamntdec,
    this.timeAlertFlag,
    this.timeAlert,
    this.runOption,
    this.logobrch,
    this.isLockPrice,
    this.isLockPriceLower,
    this.isLockCust,
    this.isLockStockLower,
    this.isCheckCredit,
    this.checkCustAfter,
    this.checkCreditAfter,
    this.checkOverdue,
    this.checkOverdueAfter,
    this.sendMailOnPass,
    this.sendMailOnFail,
    this.loadDocDays = 90,
    this.loadDocItem = 50,
    this.limitRadius = 50
  });

  int? brchId;
  int? vatgroupId;
  String? era;
  String? postGl;
  String? multiCurrency;
  dynamic showMoneySign;
  dynamic signPosition;
  dynamic amntdec;
  int? qtydec;
  int? unitamntdec;
  String? timeAlertFlag;
  dynamic timeAlert;
  String? runOption;
  dynamic logobrch;
  String? isLockPrice;
  String? isLockPriceLower;
  String? isLockCust;
  String? isCheckCredit;
  String? isLockStockLower;
  String? checkCustAfter;
  String? checkCreditAfter;
  String? checkOverdue;
  String? checkOverdueAfter;
  String? sendMailOnPass;
  String? sendMailOnFail;
  int loadDocDays;
  int loadDocItem;
  double limitRadius;

  factory SystemOption.fromJson(Map<String, dynamic> json) => SystemOption(
    brchId: json["brchId"] == null ? null : json["brchId"],
    vatgroupId: json["vatgroupId"] == null ? null : json["vatgroupId"],
    era: json["era"] == null ? null : json["era"],
    postGl: json["postGl"] == null ? null : json["postGl"],
    multiCurrency: json["multiCurrency"] == null ? null : json["multiCurrency"],
    showMoneySign: json["showMoneySign"],
    signPosition: json["signPosition"],
    amntdec: json["amntdec"],
    qtydec: json["qtydec"] == null ? null : json["qtydec"],
    unitamntdec: json["unitamntdec"] == null ? null : json["unitamntdec"],
    timeAlertFlag: json["timeAlertFlag"] == null ? null : json["timeAlertFlag"],
    timeAlert: json["timeAlert"],
    runOption: json["runOption"] == null ? null : json["runOption"],
    logobrch: json["logobrch"],
    isLockPrice: json["isLockPrice"] == null ? null : json["isLockPrice"],
    isLockPriceLower: json["isLockPriceLower"] == null ? null : json["isLockPriceLower"],
    isLockCust: json["isLockCust"] == null ? null : json["isLockCust"],
    isLockStockLower: json["isLockStockLower"] == null ? null : json["isLockStockLower"],
    isCheckCredit: json["isCheckCredit"] == null ? null : json["isCheckCredit"],
    checkCustAfter: json["checkCustAfter"] == null ? null : json["checkCustAfter"],
    checkCreditAfter: json["checkCreditAfter"] == null ? null : json["checkCreditAfter"],
    checkOverdue: json["checkOverdue"] == null ? null : json["checkOverdue"],
    checkOverdueAfter: json["checkOverdueAfter"] == null ? null : json["checkOverdueAfter"],
    sendMailOnPass: json["sendMailOnPass"] == null ? null : json["sendMailOnPass"],
    sendMailOnFail: json["sendMailOnFail"] == null ? null : json["sendMailOnFail"],
    loadDocDays: json["loadDocDays"] == null ? null : json["loadDocDays"],
    loadDocItem: json["loadDocItem"] == null ? null : json["loadDocItem"],
    limitRadius: json["limitRadius"] == null ? null : json["limitRadius"],
  );

  Map<String, dynamic> toJson() => {
    "brchId": brchId == null ? null : brchId,
    "vatgroupId": vatgroupId == null ? null : vatgroupId,
    "era": era == null ? null : era,
    "postGl": postGl == null ? null : postGl,
    "multiCurrency": multiCurrency == null ? null : multiCurrency,
    "showMoneySign": showMoneySign,
    "signPosition": signPosition,
    "amntdec": amntdec,
    "qtydec": qtydec == null ? null : qtydec,
    "unitamntdec": unitamntdec == null ? null : unitamntdec,
    "timeAlertFlag": timeAlertFlag == null ? null : timeAlertFlag,
    "timeAlert": timeAlert,
    "runOption": runOption == null ? null : runOption,
    "logobrch": logobrch,
    "isLockPrice": isLockPrice == null ? null : isLockPrice,
    "isLockPriceLower": isLockPriceLower == null ? null : isLockPriceLower,
    "isLockCust": isLockCust == null ? null : isLockCust,
    "isLockStockLower": isLockStockLower == null ? null : isLockStockLower,
    "isCheckCredit": isCheckCredit == null ? null : isCheckCredit,
    "checkCustAfter": checkCustAfter == null ? null : checkCustAfter,
    "checkCreditAfter": checkCreditAfter == null ? null : checkCreditAfter,
    "checkOverdue": checkOverdue == null ? null : checkOverdue,
    "checkOverdueAfter": checkOverdueAfter == null ? null : checkOverdueAfter,
    "sendMailOnPass": sendMailOnPass == null ? null : sendMailOnPass,
    "sendMailOnFail": sendMailOnFail == null ? null : sendMailOnFail,
    "loadDocDays": loadDocDays == null ? null : loadDocDays,
    "loadDocItem": loadDocItem == null ? null : loadDocItem,
    "limitRadius": limitRadius == null ? null : limitRadius,
  };
}