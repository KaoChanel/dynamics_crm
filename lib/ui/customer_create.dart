import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/district.dart';
import 'package:dynamics_crm/models/district_sub.dart';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../models/activity.dart';
import '../models/business_type.dart';
import '../models/province.dart';
import '../models/billing_note.dart';
import 'location_maps.dart';

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
  LatLng companyLocation = DEFAULT_LOCATION;
  late GoogleMapController mapController;

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
  var txtOrderQty = TextEditingController();
  var txtCreditTerm = TextEditingController();

  var txtQuantity = TextEditingController();
  var txtBreederQty = TextEditingController();
  var txtFishSpecies = TextEditingController();
  var txtFishQty = TextEditingController();
  var txtLivestockGroup = TextEditingController();
  var txtLivestockType = TextEditingController();
  var txtPetGroup = TextEditingController();

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
      txtCustomerName.text = '?????????????????????????????????';
      txtLastname.text = '??????????????????';
      txtAddress1.text = '56/217 The Connect ???????????????????????????????????????????????? 9 ????????????????????????????????? ';
      txtIdentificationNumber.text = '1570500212370';
      currentProvince = PROVINCES.first;
      currentDistrict = DISTRICTS.first;
      currentDistrictSub = DISTRICT_SUB.first;
      txtBirthDate.text = dateBirthDay != null ? DATE_FORMAT.format(dateBirthDay!) : '';
      txtZipCode.text = '${currentDistrictSub?.zipCode ?? ''}';

      txtCompanyName.text = '?????????????????? ???????????????????????? ????????? ???????????????';
      txtBillingDate.text = '??????????????????????????? $cycleBillingDay ???????????? $cycleBillingHour.${LEADING_ZERO.format(cycleBillingMinute)} ???.';
      txtPaymentDate.text = '??????????????????????????? $cycleChequeDay ???????????? $cycleChequeHour.${LEADING_ZERO.format(cycleChequeMinute)} ???.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('?????????????????????????????????????????????'),
        centerTitle: true,
      ),
      body: Container(
        child: Stepper(
            currentStep: _currentStep,
            type: stepperType,
            // physics: ,
            steps: <Step>[
              Step(
                title: StepState.indexed == 0 ? const Text('??????????????????') : const Text('??????????????????'),
                content: Form(
                  key: formKey1,
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: ExpansionTile(
                            title: const Text('????????????????????????????????????'),
                          initiallyExpanded: true,
                          childrenPadding: const EdgeInsets.all(15.0),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: txtCustomerName,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: '????????????????????????',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                ),
                                validator: (value) {
                                  return checkEmpty(value, '??????????????????????????????????????????');
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: txtLastname,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: '?????????????????????',
                                border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                ),
                                validator: (value) {
                                  return checkEmpty(value, '?????????????????????????????????');
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
                                    labelText: '?????????/???????????????/?????? ????????????',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                ),
                                validator: (value) {
                                  return checkEmpty(value, '?????????????????????????????????');
                                },
                                onTap: () async {
                                  dateBirthDay = await SharedWidgets.datePicker(context, dateBirthDay, maxYear: 0);
                                  bindingController();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                maxLength: 13,
                                controller: txtIdentificationNumber,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: '???????????????????????????????????????????????????',
                                border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                ),
                                validator: (value) {
                                  return checkEmpty(value, '???????????????????????????????????????????????????????????????');
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                maxLength: 100,
                                maxLines: 3,
                                controller: txtAddress1,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: '???????????????????????????????????????????????????????????????',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0)
                                ),
                                validator: (value) {
                                  return checkEmpty(value, '???????????????????????????????????????????????????');
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                maxLength: 100,
                                maxLines: 3,
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
                                hint: const Text('?????????????????????'),
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
                                hint: const Text('????????? / ???????????????'),
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
                                hint: const Text('???????????? / ????????????'),
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
                                    labelText: '????????????????????????????????????',
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
                                    labelText: '?????????????????????????????????',
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
                            title: const Text('????????????????????????????????????'),
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.all(15.0),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  controller: txtCompanyName,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                      labelText: '??????????????????????????????',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  maxLength: 100,
                                  maxLines: 3,
                                  // minLines: 2,
                                  controller: txtCompanyAddress1,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                      labelText: '???????????????????????????????????????',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  maxLength: 13,
                                  controller: txtIdentificationNumber,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                      labelText: '??????????????????????????????????????????',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: DropdownButtonFormField<Province>(
                                  hint: const Text('?????????????????????'),
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
                                  hint: const Text('????????? / ???????????????'),
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
                                  hint: const Text('???????????? / ????????????'),
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
                                      labelText: '????????????????????????????????????',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: '?????????',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: '???????????????',
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
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                width: MediaQuery.of(context).size.width, // or use fixed size like 200
                                height: MediaQuery.of(context).size.height / 2,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(target: companyLocation, zoom: 18),
                                  markers: (companyLocation == null)
                                      ? <Marker>{}
                                      : {
                                    Marker(
                                      markerId: MarkerId('mark1'),
                                      position: companyLocation ?? DEFAULT_LOCATION,
                                    ),
                                  },
                                  onMapCreated: (GoogleMapController controller){
                                    setState(() {
                                      mapController = controller;
                                    });
                                  },
                                  onTap: (LatLng tapLocation) async {
                                    LatLng? res = await Navigator.push(context, MaterialPageRoute(builder: (context) => LocationMaps(location: companyLocation, activity: Activity.locationCollect)));

                                    if(res != null) {
                                      setState(() {
                                        companyLocation = res;

                                        // specified current users location
                                        CameraPosition cameraPosition = CameraPosition(
                                          target: LatLng(companyLocation.latitude, companyLocation.longitude),
                                          zoom: 18,
                                        );

                                        mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
                                      });
                                    }
                                  },
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
                            title: const Text('???????????????????????????????????????????????????'),
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.all(15.0),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  controller: txtCompanyName,
                                  decoration: const InputDecoration(
                                      labelText: '??????????????????????????????',
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
                                      labelText: '??????????????????????????????',
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
                                      labelText: '?????????????????????????????????????????????????????????',
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
                            title: const Text('??????????????????????????????????????????????????? & ????????????????????????'),
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.all(15.0),
                            children: [
                              const Text("??????????????????",
                                style: TextStyle(fontSize: 18),
                              ),
                              const Divider(),
                              RadioListTile(
                                title: const Text("???????????????????????????????????????"),
                                value: BillingNote.no_billing,
                                groupValue: currentBilling,
                                onChanged: (BillingNote? value){
                                  setState(() {
                                    currentBilling = value!;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("??????????????????????????? & ??????????????????"),
                                value: BillingNote.delivery_billling,
                                groupValue: currentBilling,
                                onChanged: (BillingNote? value){
                                  setState(() {
                                    currentBilling = value!;
                                  });
                                },
                              ),

                              RadioListTile(
                                title: const Text("???????????????????????????????????????"),
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
                                          labelText: '???????????????????????????',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                      ),
                                      onTap: () async {
                                        // await datetimePicker(context, DateTime.now());
                                        var res = await SharedWidgets.dayPicker(context, cycleBillingDay, cycleBillingHour, cycleBillingMinute);

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
                              const Text("????????????????????????",
                                style: TextStyle(fontSize: 18),
                              ),

                              RadioListTile(
                                title: const Text("??????????????????"),
                                value: '??????????????????',
                                groupValue: currentPaymentMethod,
                                onChanged: (String? value){
                                  setState(() {
                                    currentPaymentMethod = value!;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("?????????????????????"),
                                value: '?????????????????????',
                                groupValue: currentPaymentMethod,
                                onChanged: (String? value){
                                  setState(() {
                                    currentPaymentMethod = value!;
                                  });
                                },
                              ),

                              Visibility(
                                visible: currentPaymentMethod == '?????????????????????',
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: txtPaymentDate,
                                    decoration: const InputDecoration(
                                        labelText: '???????????????????????????',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                    ),
                                    onTap: () async {
                                      var res = await SharedWidgets.dayPicker(context, cycleChequeDay, cycleChequeHour, cycleChequeMinute);

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
                title: StepState.indexed == 1 ? const Text('???????????????????????????') : const Text('???????????????????????????'),
                content: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<BusinessType>(
                        hint: const Text('???????????????????????????????????????'),
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
                    Visibility(
                      visible: currentLivestock?.displayName == '???????????? ???',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: txtLivestockGroup,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              labelText: '???????????????????????????????????????????????????',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                          ),
                          validator: (value) {
                            return checkEmpty(value, '???????????????????????????????????????????????????');
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<BusinessType>(
                        hint: const Text('?????????????????????????????????'),
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
                    Visibility(
                      visible: currentLivestockType?.displayName == '???????????? ???',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: txtLivestockGroup,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              labelText: '?????????????????????????????????????????????',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                          ),
                          validator: (value) {
                            return checkEmpty(value, '?????????????????????????????????????????????');
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: currentLivestockType?.displayName == '????????????',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: txtBreederQty,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              labelText: '?????????????????????????????????????????? (?????????)',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                          ),
                          validator: (value) {
                            return checkEmpty(value, '??????????????????????????????????????????????????????');
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: currentLivestockType != null && currentLivestockType?.displayName != '?????????',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: txtQuantity,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              labelText: '??????????????? (?????????)',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                          ),
                          validator: (value) {
                            return checkEmpty(value, '???????????????????????????');
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: currentLivestockType?.displayName == '?????????',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: txtFishSpecies,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              labelText: '???????????????????????????????????????',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                          ),
                          validator: (value) {
                            return checkEmpty(value, '???????????????????????????????????????');
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: currentLivestockType?.displayName == '?????????',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: txtFishQty,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              labelText: '???????????????????????? (?????????????????? / ?????????)',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                          ),
                          validator: (value) {
                            return checkEmpty(value, '????????????????????????????????????');
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<BusinessType>(
                        hint: const Text('????????????????????????????????????????????????'),
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
                    Visibility(
                      visible: currentPet?.displayName == '???????????? ???',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: txtLivestockGroup,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              labelText: '????????????????????????????????????????????????????????????',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                          ),
                          validator: (value) {
                            return checkEmpty(value, '????????????????????????????????????????????????????????????');
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<BusinessType>(
                        hint: const Text('????????????????????????????????????'),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: txtLivestockGroup,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            labelText: '?????????????????????????????????????????????????????? / ???????????????',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                        ),
                        validator: (value) {
                          return checkEmpty(value, '????????????????????????????????????????????????');
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: txtLivestockGroup,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            labelText: '???????????????????????????????????? (?????????)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                        ),
                        validator: (value) {
                          return checkEmpty(value, '????????????????????????????????????????????????');
                        },
                      ),
                    ),
                  ],
                ),
                isActive: _currentStep >= 1,
                state: _currentStep > 1 ? StepState.complete : _currentStep == 1 ? StepState.editing : StepState.disabled,
              ),
              Step(
                  title: StepState.indexed == 2 ? const Text('????????????') : const Text('????????????'),
                  content: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          child: ExpansionTile(
                            title: const Text('????????????????????????????????????'),
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.all(15.0),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('${txtCustomerName.text} ${txtLastname.text}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('${txtAddress1.text} ${txtAddress2.text}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  controller: txtCompanyName,
                                  decoration: const InputDecoration(
                                      labelText: '??????????????????????????????',
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
                                      labelText: '?????????????????????????????????????????????????????????',
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
                            title: const Text('????????????????????????????????????'),
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.all(15.0),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(txtCompanyName.text),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(txtCompanyAddress1.text),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  controller: txtCompanyAddress1,
                                  decoration: const InputDecoration(
                                      labelText: '?????????????????????????????????????????????????????????',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                isActive:_currentStep >= 2,
                state: _currentStep > 2 ? StepState.complete : _currentStep == 2 ? StepState.editing : StepState.disabled,
              ),
              // Step(
              //   title: StepState.indexed == 3 ? const Text('????????????????????????????????????') : const Text(''),
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
              //   title: StepState.indexed == 4 ? const Text('????????????????????????????????????') : const Text(''),
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
