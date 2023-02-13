import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/sales_quote.dart';
import 'package:dynamics_crm/models/sales_shipment.dart';
import 'package:dynamics_crm/models/sales_shipment.dart';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:flutter/material.dart';
import '../../models/sales_order.dart';
import '../../models/sales_order_line.dart';

class SalesOrderViewPortrait extends StatefulWidget {
  final SalesOrder header;

  const SalesOrderViewPortrait({Key? key, required this.header}) : super(key: key);

  @override
  State<SalesOrderViewPortrait> createState() => _SalesOrderViewPortraitState();
}

class _SalesOrderViewPortraitState extends State<SalesOrderViewPortrait> {
  SalesQuote quotation = SalesQuote();
  SalesOrder header = SalesOrder();
  List<SalesOrderLine> details = <SalesOrderLine>[];
  SalesShipment salesShipment = SalesShipment();

  // List<File> attachFile = <File>[];

  String runningNo = '';
  String docuNo = '';
  String refNo = '';
  String custPoNo = '';
  double vat = 0.7;
  double priceTotal = 0;
  double discountTotal = 0;
  double discountBill = 0;
  double priceAfterDiscount = 0;
  double vatTotal = 0.0;
  double netTotal = 0.0;
  late DateTime _docuDate;
  late DateTime _shiptoDate;
  late DateTime _orderDate;
  bool isInitial = false;
  bool editedDocuDate = false;
  bool editedShipDate = false;

  FocusNode focusDiscount = FocusNode();
  TextEditingController txtRunningNo = TextEditingController();
  TextEditingController txtDocuNo = TextEditingController();
  TextEditingController txtRefNo = TextEditingController();
  TextEditingController txtCustPoNo = TextEditingController();
  TextEditingController txtEmpCode = TextEditingController();
  TextEditingController txtEmpName = TextEditingController();
  TextEditingController txtCustCode = TextEditingController();
  TextEditingController txtCustName = TextEditingController();
  TextEditingController txtCustRemark = TextEditingController();
  TextEditingController txtCreditType = TextEditingController();
  TextEditingController txtCredit = TextEditingController();
  TextEditingController txtStatus = TextEditingController();
  TextEditingController txtRemark = TextEditingController();

  TextEditingController txtShiptoProvince = TextEditingController();
  TextEditingController txtShiptoAddress = TextEditingController();
  TextEditingController txtShiptoRemark = TextEditingController();
  TextEditingController txtPriceTotal = TextEditingController();
  TextEditingController txtDiscountTotal = TextEditingController();
  TextEditingController txtDiscountBill = TextEditingController();
  TextEditingController txtPriceAfterDiscount = TextEditingController();
  TextEditingController txtVatTotal = TextEditingController();
  TextEditingController txtNetTotal = TextEditingController();

  TextEditingController txtDocuDate = TextEditingController();
  TextEditingController txtShiptoDate = TextEditingController();
  TextEditingController txtOrderDate = TextEditingController();

  TextEditingController txtQuotationNo = TextEditingController();

  // getQuotation() async {
  //   if(widget.header.refSoid != null) {
  //     quotation = await _apiService.getQuotationHeader(widget.header.refSoid);
  //     txtQuotationNo.text = quotation.docuNo;
  //   }
  // }

  setHeader() async {
    try {
      header = widget.header;

      // runningNo = header.docuNo ?? '';
      // refNo = header.refNo ?? '';
      // custPoNo = header.custPono;
      // _docuDate = editedDocuDate == false ? SOHD.docuDate : _docuDate;
      // _shiptoDate = editedShipDate == false ? SOHD.shipDate : _shiptoDate;
      // _docuDate = header.orderDate;
      // _shiptoDate = header.shipDate;
      // _orderDate = header.custPodate;
      // discountBill = header.billDiscAmnt;

      txtRunningNo.text = runningNo;
      txtRefNo.text = refNo;
      txtDocuNo.text = header.number.toString();
      txtCustPoNo.text = custPoNo;
      txtDocuDate.text = DATE_FORMAT.format(_docuDate);
      txtShiptoDate.text = _shiptoDate != null
          ? DATE_FORMAT.format(_shiptoDate)
          : '';
      txtShiptoRemark.text = '';
      txtOrderDate.text =
      _orderDate != null ? DATE_FORMAT.format(_orderDate) : '';
      txtEmpCode.text = '${EMPLOYEE?.code}';
      txtEmpName.text =
      '${EMPLOYEE?.displayName ?? ''} (${txtEmpCode.text})';
      txtCustCode.text = MY_CUSTOMERS.firstWhere((e) => e.id == header.customerId)?.code ?? '';
      txtCustName.text = '${header.customerName ?? ''} (${txtCustCode.text})';
      // txtCredit.text = header.creditDays.toString() ?? '0';
      // txtRemark.text = SOHD.remark ?? '';

      // txtPriceTotal.text = CURRENCY.format(header.am);
      // txtDiscountBill.text = header.billDiscFormula ?? '0.00';
      // txtPriceAfterDiscount.text = CURRENCY.format(header.billAftrDiscAmnt);
      txtVatTotal.text = CURRENCY.format(header.totalTaxAmount ?? 0);
      txtNetTotal.text = CURRENCY.format(header.netAmount);
    } catch (e) {
      Navigator.pop(context);
      return SharedWidgets.showAlert(context, 'Set Header Exception', e.toString());
    }
  }

  setDetail() async {
    try {
      // details = await _apiService.getSODT(header.id);

      details.where((e) => e.documentId == header.id)
          .forEach((x) {
            discountTotal += x.discountAmount ?? 0;
          });
    } catch (e) {
      Navigator.pop(context);
      return SharedWidgets.showAlert(context, 'Set Detail Exception', e.toString());
    }
  }

  // setRemark() async {
  //   try {
  //     headerRemark = await _apiService.getHeaderRemark(header.soid);
  //     detailRemark = await _apiService.getDetailRemark(header.soid);
  //
  //     txtRemark.text = headerRemark?.remark ?? '';
  //
  //     print('Length: ${detailRemark.length}');
  //     detailRemark?.forEach((e) => print(
  //         'DTRemark SOID: ${e.soId} ListNo: ${e.refListNo} Remark: ${e.remark}'));
  //
  //     // SODT.forEach((x) {
  //     //   print('SODT SOID: ${x.soid} ListNo:${x.listNo} RefListNo:${x.listNo}');
  //     //   print('---------' + detailRemark
  //     //       .firstWhere((e) => e.soId == x.soid && e.refListNo == x.listNo,
  //     //       orElse: () => null)
  //     //       ?.remark ?? '');
  //     //   x.goodsRemark = detailRemark
  //     //       .firstWhere((e) => e.soId == x.soid && e.refListNo == x.listNo,
  //     //       orElse: () => null)
  //     //       ?.remark ?? '';
  //     // });
  //   } catch (e) {
  //     Navigator.pop(context);
  //     return globals.showAlertDialog(
  //         'Set Remark Exception', e.toString(), context);
  // }

  void setSelectedShipto() {
    // salesShipment.billToAddressLine1 = widget.header?.shipToAddr1 ?? '';
    // salesShipment.billToAddressLine2 = widget.header?.shipToAddr2 ?? '';
    // salesShipment.sell = widget.header?.district ?? '';
    salesShipment.billToCity = widget.header?.billingPostalAddress?.city ?? '';
    salesShipment.billToState = widget.header?.billingPostalAddress?.state ?? '';
    salesShipment.billToPostCode = widget.header?.billingPostalAddress?.postalCode ?? '';
    // salesShipment.remark = widget.header?.billingPostalAddress. ?? '';
  }

  // setFileAttach() async {
  //   try {
  //     attachFile = <File>[];
  //     var files = await _apiService.getFileAttach(header.id);
  //
  //     files.forEach((x) {
  //       attachFile.add(File(globals.publicAddress + x.url));
  //     });
  //   } catch (e) {
  //     Navigator.pop(context);
  //     return globals.showAlertDialog(
  //         'File Attachment Exception', e.toString(), context);
  //   }
  // }

  controllerBinding() {
    setState(() {
      txtShiptoAddress.text = '${header?.billingPostalAddress!.street ?? ''} '
          // '${header.shipToAddr2 ?? ''} '
          // '${header.district ?? ''} '
          '${header.billingPostalAddress?.city ?? ''} '
          '${header.billingPostalAddress?.state ?? ''} '
          '${header.billingPostalAddress?.postalCode ?? ''}';
      // txtShiptoProvince.text = header.province ?? '';
      // txtShiptoRemark.text = header.remark ?? '';

      txtDiscountTotal.text = CURRENCY.format(discountTotal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
