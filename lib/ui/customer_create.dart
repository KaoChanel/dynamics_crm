import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/district.dart';
import 'package:dynamics_crm/models/district_sub.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/business_type.dart';
import '../models/province.dart';
import '../models/billing_note.dart';

class CustomerCreate extends StatefulWidget {
  const CustomerCreate({Key? key}) : super(key: key);

  @override
  State<CustomerCreate> createState() => _CustomerCreateState();
}

class _CustomerCreateState extends State<CustomerCreate> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  /// Section 1 : Customer Information
  Province? currentProvince;
  District? currentDistrict;
  DistrictSub? currentDistrictSub;
  var txtCustomerName = TextEditingController();
  var txtLastname = TextEditingController();
  var txtIdentificationNumber = TextEditingController();
  var txtBirthDate = TextEditingController();
  var txtAddress1 = TextEditingController();
  var txtAddress2 = TextEditingController();
  var txtDistrictSub = TextEditingController();
  var txtDistrict = TextEditingController();
  var txtProvince = TextEditingController();
  var txtZipCode = TextEditingController();
  var txtCustomerTel = TextEditingController();
  var txtEmail = TextEditingController();
  DateTime? dateBirthDay = DateTime.now();

  /// Section 1 : Company Information
  Province? currentCompanyProvince;
  District? currentCompanyDistrict;
  DistrictSub? currentCompanyDistrictSub;
  var txtCompanyName = TextEditingController();
  var txtCompanyAddress1 = TextEditingController();
  var txtCompanyAddress2 = TextEditingController();
  var txtCompanyDistrictSub = TextEditingController();
  var txtCompanyDistrict = TextEditingController();
  var txtCompanyProvince = TextEditingController();
  var txtCompanyZipCode = TextEditingController();
  var txtTaxId = TextEditingController();
  var txtFax = TextEditingController();
  var txtCompanyTel = TextEditingController();
  var txtCompanyEmail = TextEditingController();

  /// Section 1 : Shipment Condition


  /// Section 1 : Payment Condition
  BillingNote? currentBilling;
  String? currentPaymentMethod;
  int cycleBillingDay = 1;
  int cycleBillingHour = 12;
  int cycleBillingMinute = 0;
  int cycleChequeDay = 1;
  int cycleChequeHour = 12;
  int cycleChequeMinute = 0;
  DateTime? billingDate = DateTime.now();
  DateTime? paymentDate = DateTime.now();
  var txtBillingDate = TextEditingController();
  var txtPaymentDate = TextEditingController();

  /// Section 2 : Item
  BusinessType? currentLivestock;
  BusinessType? currentLivestockType;
  BusinessType? currentPet;
  BusinessType? currentBusinessType;
  var txtOrderQuality = TextEditingController();
  var txtCreditTerm = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    bindingController();
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   setState(() {
    //
    //   });
    // });
  }

  bindingController() {
    setState(() {
      txtCustomerName.text = '.';
      txtLastname.text = '.';
      txtAddress1.text = '.';
      txtIdentificationNumber.text = '.';
      currentProvince = PROVINCES.first;
      currentDistrict = DISTRICTS.first;
      currentDistrictSub = DISTRICT_SUB.first;
      txtBirthDate.text = dateBirthDay != null ? DATE_FORMAT.format(dateBirthDay!) : '';
      txtZipCode.text = '${currentDistrictSub?.zipCode ?? ''}';
      txtBillingDate.text = 'ทุกวันที่ $cycleBillingDay เวลา $cycleBillingHour.${LEADING_ZERO.format(cycleBillingMinute)} น.';
      txtPaymentDate.text = 'ทุกวันที่ $cycleChequeDay เวลา $cycleChequeHour.${LEADING_ZERO.format(cycleChequeMinute)} น.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มลูกค้าใหม่'),
        centerTitle: true,
      ),
      body: Container(
        child: Stepper(
            currentStep: _currentStep,
            type: stepperType,
            // physics: ,
            steps: <Step>[
              Step(
                title: StepState.indexed == 0 ? const Text('ลูกค้า') : const Text('ลูกค้า'),
                content: Form(
                  key: formKey1,
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: ExpansionTile(
                            title: const Text('ข้อมูลลูกค้า'),
                          initiallyExpanded: true,
                          childrenPadding: const EdgeInsets.all(15.0),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: txtCustomerName,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: 'ชื่อจริง',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                ),
                                validator: (value) {
                                  return checkEmpty(value, 'ระบุชื่อลูกค้า');
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: txtLastname,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: 'นามสกุล',
                                border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                ),
                                validator: (value) {
                                  return checkEmpty(value, 'ระบุนามสกุล');
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                readOnly: true,
                                controller: txtBirthDate,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: 'วัน/เดือน/ปี เกิด',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                ),
                                validator: (value) {
                                  return checkEmpty(value, 'ระบุวันเกิด');
                                },
                                onTap: () async {
                                  dateBirthDay = await datePicker(context, dateBirthDay, maxYear: 0);
                                  bindingController();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: txtIdentificationNumber,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: 'เลขที่บัตรประชาชน',
                                border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                ),
                                validator: (value) {
                                  return checkEmpty(value, 'ระบุเลขที่บัตรประชาชน');
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: txtAddress1,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: 'ที่อยู่ตามบัตรประชาชน',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                ),
                                validator: (value) {
                                  return checkEmpty(value, 'ระบุที่อยู่ลูกค้า');
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: txtAddress2,
                                decoration: const InputDecoration(
                                    labelText: '',
                                border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                ),
                                validator: (value) {
                                  // return validateEmpty(value, '');
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: DropdownButtonFormField<Province>(
                                hint: const Text('จังหวัด'),
                                value: currentProvince,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                                items: PROVINCES.map((e) =>
                                    DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name)
                                    )
                                ).toList() ?? [],
                                validator: (value) => checkEmpty(value),
                                onChanged: (Province? value) {
                                  currentProvince = value!;
                                  currentDistrict = null;
                                  currentDistrictSub = null;
                                  // Focus.of(context).nextFocus();
                                  bindingController();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: DropdownButtonFormField<District>(
                                hint: const Text('เขต / อำเภอ'),
                                value: currentDistrict,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                                items: DISTRICTS.where((i) => i.provinceName == currentProvince?.name).map((e) =>
                                    DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name ?? '')
                                    )
                                ).toList() ?? [],
                                validator: (value) => checkEmpty(value),
                                onChanged: (District? value) {
                                  currentDistrict = value!;
                                  bindingController();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: DropdownButtonFormField<DistrictSub>(
                                hint: const Text('แขวง / ตำบล'),
                                value: currentDistrictSub,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                                items: DISTRICT_SUB.where((i) => i.districtName == currentDistrict?.name).map((e) =>
                                    DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name)
                                    )
                                ).toList() ?? [],
                                validator: (value) => checkEmpty(value),
                                onChanged: (DistrictSub? value) {
                                  currentDistrictSub = value!;
                                  bindingController();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: txtZipCode,
                                decoration: const InputDecoration(
                                    labelText: 'รหัสไปรษณีย์',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: txtCustomerTel,
                                decoration: const InputDecoration(
                                    labelText: 'เบอร์ติดต่อ',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: txtEmail,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: 'E-mail',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          child: ExpansionTile(
                            title: const Text('ข้อมูลบริษัท'),
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.all(15.0),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  controller: txtCompanyName,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                      labelText: 'ชื่อบริษัท',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  controller: txtCompanyAddress1,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                      labelText: 'ที่อยู่บริษัท',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  controller: txtIdentificationNumber,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                      labelText: 'เลขผู้เสียภาษี',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: DropdownButtonFormField<Province>(
                                  hint: const Text('จังหวัด'),
                                  value: currentCompanyProvince,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                  items: PROVINCES.map((e) =>
                                      DropdownMenuItem(
                                          value: e,
                                          child: Text(e.name)
                                      )
                                  ).toList(),
                                  onChanged: (Province? value) {
                                    setState(() {
                                      currentCompanyProvince = value!;
                                      currentCompanyDistrict = null;
                                      currentCompanyDistrictSub = null;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: DropdownButtonFormField<District>(
                                  hint: const Text('เขต / อำเภอ'),
                                  value: currentCompanyDistrict,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                  items: DISTRICTS.where((i) => i.provinceName == currentCompanyProvince?.name).map((e) =>
                                      DropdownMenuItem(
                                          value: e,
                                          child: Text(e.name ?? '')
                                      )
                                  ).toList(),
                                  onChanged: (District? value) {
                                    setState(() {
                                      currentCompanyDistrict = value!;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: DropdownButtonFormField<DistrictSub>(
                                  hint: const Text('แขวง / ตำบล'),
                                  value: currentCompanyDistrictSub,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                  items: DISTRICT_SUB.where((i) => i.districtName == currentCompanyDistrict?.name).map((e) =>
                                      DropdownMenuItem(
                                          value: e,
                                          child: Text(e.name)
                                      )
                                  ).toList(),
                                  onChanged: (DistrictSub? value) {
                                    setState(() {
                                      currentCompanyDistrictSub = value!;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'รหัสไปรษณีย์',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'โทร',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'แฟกซ์',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'E-Mail',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          child: ExpansionTile(
                            title: const Text('เงื่อนไขการจัดส่ง'),
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.all(15.0),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  controller: txtCompanyName,
                                  decoration: const InputDecoration(
                                      labelText: 'ชื่อบริษัท',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  controller: txtCompanyName,
                                  decoration: const InputDecoration(
                                      labelText: 'ชื่อบริษัท',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  controller: txtCompanyAddress1,
                                  decoration: const InputDecoration(
                                      labelText: 'สถานที่จัดส่งสินค้า',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          child: ExpansionTile(
                            title: const Text('เงื่อนไขการวางบิล & ชำระเงิน'),
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.all(15.0),
                            children: [
                              const Text("วางบิล",
                                style: TextStyle(fontSize: 18),
                              ),
                              const Divider(),
                              RadioListTile(
                                title: const Text("ไม่ต้องวางบิล"),
                                value: BillingNote.no_billing,
                                groupValue: currentBilling,
                                onChanged: (BillingNote? value){
                                  setState(() {
                                    currentBilling = value!;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("ส่งสินค้า & วางบิล"),
                                value: BillingNote.delivery_billling,
                                groupValue: currentBilling,
                                onChanged: (BillingNote? value){
                                  setState(() {
                                    currentBilling = value!;
                                  });
                                },
                              ),

                              RadioListTile(
                                title: const Text("ต้องการวางบิล"),
                                value: BillingNote.billing_note,
                                groupValue: currentBilling,
                                onChanged: (BillingNote? value){
                                  setState(() {
                                    currentBilling = value!;
                                  });
                                },
                              ),

                              Visibility(
                                visible: currentBilling == BillingNote.billing_note,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: txtBillingDate,
                                      decoration: const InputDecoration(
                                          labelText: 'รอบวันที่',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                      ),
                                      onTap: () async {
                                        // await datetimePicker(context, DateTime.now());
                                        var res = await dayPicker(context, cycleBillingDay, cycleBillingHour, cycleBillingMinute);

                                        if(res != null){
                                          cycleBillingDay = res.day;
                                          cycleBillingHour = res.hour;
                                          cycleBillingMinute = res.minute;
                                          bindingController();
                                        }
                                      },
                                    ),
                                  ),
                              ),

                              const Divider(),
                              const Text("ชำระเงิน",
                                style: TextStyle(fontSize: 18),
                              ),

                              RadioListTile(
                                title: const Text("เงินสด"),
                                value: 'เงินสด',
                                groupValue: currentPaymentMethod,
                                onChanged: (String? value){
                                  setState(() {
                                    currentPaymentMethod = value!;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("รับเช็ค"),
                                value: 'รับเช็ค',
                                groupValue: currentPaymentMethod,
                                onChanged: (String? value){
                                  setState(() {
                                    currentPaymentMethod = value!;
                                  });
                                },
                              ),

                              Visibility(
                                visible: currentPaymentMethod == 'รับเช็ค',
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: txtPaymentDate,
                                    decoration: const InputDecoration(
                                        labelText: 'รอบวันที่',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                    ),
                                    onTap: () async {
                                      var res = await dayPicker(context, cycleChequeDay, cycleChequeHour, cycleChequeMinute);

                                      if(res != null){
                                        cycleChequeDay = res.day;
                                        cycleChequeHour = res.hour;
                                        cycleChequeMinute = res.minute;
                                        bindingController();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                isActive: _currentStep >= 0,
                state: _currentStep > 0 ? StepState.complete : _currentStep == 0 ? StepState.editing : StepState.disabled
              ),
              Step(
                title: StepState.indexed == 1 ? const Text('ผลิตภัณฑ์') : const Text('ผลิตภัณฑ์'),
                content: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Home Address'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Postcode'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<BusinessType>(
                        hint: const Text('กลุ่มปศุสัตว์'),
                        value: currentLivestock,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        items: LIVESTOCK_GROUP.map((e) =>
                            DropdownMenuItem(
                                value: e,
                                child: Text(e.displayName ?? '')
                            )
                        ).toList(),
                        onChanged: (BusinessType? value) {
                          setState(() {
                            currentLivestock = value!;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<BusinessType>(
                        hint: const Text('ประเภทสัตว์'),
                        value: currentLivestockType,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        items: LIVESTOCK_TYPE.map((e) =>
                            DropdownMenuItem(
                                value: e,
                                child: Text(e.displayName ?? '')
                            )
                        ).toList(),
                        onChanged: (BusinessType? value) {
                          setState(() {
                            currentLivestockType = value!;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<BusinessType>(
                        hint: const Text('กลุ่มสัตว์เลี้ยง'),
                        value: currentPet,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        items: PET_TYPE.map((e) =>
                            DropdownMenuItem(
                                value: e,
                                child: Text(e.displayName ?? '')
                            )
                        ).toList(),
                        onChanged: (BusinessType? value) {
                          setState(() {
                            currentPet = value!;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<BusinessType>(
                        hint: const Text('ประเภทธุรกิจ'),
                        value: currentBusinessType,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        items: BUSINESS_TYPE.map((e) =>
                            DropdownMenuItem(
                                value: e,
                                child: Text(e.displayName ?? '')
                            )
                        ).toList(),
                        onChanged: (BusinessType? value) {
                          setState(() {
                            currentBusinessType = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                isActive: _currentStep >= 1,
                state: _currentStep > 1 ? StepState.complete : _currentStep == 1 ? StepState.editing : StepState.disabled,
              ),
              Step(
                  title: StepState.indexed == 2 ? const Text('สรุป') : const Text('สรุป'),
                  content: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Mobile Number'),
                      ),
                    ],
                  ),
                isActive:_currentStep >= 2,
                state: _currentStep > 2 ? StepState.complete : _currentStep == 2 ? StepState.editing : StepState.disabled,
              ),
              // Step(
              //   title: StepState.indexed == 3 ? const Text('ข้อมูลทั่วไป') : const Text(''),
              //   content: Column(
              //     children: <Widget>[
              //       TextFormField(
              //         decoration: InputDecoration(labelText: 'Mobile Number'),
              //       ),
              //     ],
              //   ),
              //   isActive:_currentStep >= 3,
              //   state: _currentStep > 3 ? StepState.complete : _currentStep == 3 ? StepState.editing : StepState.disabled,
              // ),
              // Step(
              //   title: StepState.indexed == 4 ? const Text('ข้อมูลทั่วไป') : const Text(''),
              //   content: Column(
              //     children: <Widget>[
              //       TextFormField(
              //         decoration: InputDecoration(labelText: 'Mobile Number'),
              //       ),
              //     ],
              //   ),
              //   isActive:_currentStep >= 4,
              //   state: _currentStep > 4 ? StepState.complete : _currentStep == 4 ? StepState.editing : StepState.disabled,
              // )
            ],
          onStepContinue: () {
              setState(() {
                if(formKey1.currentState!.validate()) {
                  if(_currentStep < (StepState.values.length - 2)) {
                    _currentStep++;
                  }
                  else {
                    /// Last Step.
                  }
                }
              });
          },
          onStepCancel: _currentStep == 0 ? null : () {
              setState(() {
                _currentStep--;
              });
          },
          onStepTapped: (int index) {
            setState(() {
              _currentStep = index;
            });
          },
        ),
      ),
    );
  }
}
