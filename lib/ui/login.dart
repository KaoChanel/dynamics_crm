import 'dart:developer';
import 'dart:io';

import 'package:dynamics_crm/models/employee.dart';
import 'package:dynamics_crm/services/api_service.dart';
import 'package:dynamics_crm/widgets/shared_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/global_constants.dart';
import '../models/company.dart';
import '../widgets/customer_clipper.dart';
import 'launcher.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Company? compValue;
  bool isPassword = true;
  List<Company> companies = [];
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  getCompany() async {
    try {
      companies = await ApiService().getCompanies();

      setState(() {

      });
    }catch(error) {
      log(error.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getCompany();
    });
  }

  @override
  void dispose() {
    super.dispose();
    txtUsername.dispose();
    txtPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .11,
                  // right: -MediaQuery
                  //     .of(context)
                  //     .size
                  //     .width * .4,
                  child: bezierContainer()
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // SizedBox(height: height * .1),
                    _title(),
                    // Text('For Tester', style: TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 20),
                    _emailPasswordWidget(),
                    const SizedBox(height: 20),
                    _companySelect(),
                    const SizedBox(height: 45),
                    _submitButton(),
                    // Container(
                    //   width: MediaQuery
                    //       .of(context)
                    //       .size
                    //       .width / 2,
                    //   padding: EdgeInsets.symmetric(vertical: 10),
                    //   alignment: Alignment.centerRight,
                    //   child: Text('Forgot Password ?',
                    //       style: TextStyle(
                    //           fontSize: 14, fontWeight: FontWeight.w500)),
                    // ),
                    // _divider(),
                    //_facebookButton(),
                    SizedBox(height: height * .035),
                    _createAccountLabel(),
                  ],
                ),
              ),
              // Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        )
    );
  }

  // getUser(String company, String username, String password) async {
  //   try
  //   {
  //     SharedWidgets.showLoader(context, false);
  //     String strUrl = '${globals.publicAddress}/api/login/LoginByEmpCode/$company/$username/$password';
  //     http.Response response = await http.get(Uri.parse(strUrl));
  //     Navigator.pop(context);
  //
  //     if(response.body.isNotEmpty) {
  //       var decode = jsonDecode(response.body);
  //
  //       if (decode['empId'] != 0) {
  //         globals.employee = employeeFromJson(response.body);
  //         if(globals.employee.empHead == null) globals.employee.empHead = globals.employee.empId;
  //         globals.company = company;
  //
  //         if(globals.employee.isLock == 'Y') {
  //           return showAlertDialog(context, 'คุณไม่มีสิทธิเข้าใช้งานแล้ว');
  //         }
  //
  //         final SharedPreferences prefs = await SharedPreferences.getInstance();
  //         await prefs.setString('username', globals.employee.empCode);
  //         await prefs.setString('password', password);
  //         await prefs.setString('company', company);
  //
  //         globals.isLockPrice = globals.employee.isLockPrice == 'Y' ? true : false;
  //         final int customerId = prefs.getInt('customer');
  //
  //         if(customerId != null) {
  //           globals.customer = await _apiService.getCustomer(globals.employee.empId, customerId);
  //
  //           if(globals.customer != null){
  //             globals.selectedShipto = await _apiService.getShiptoByCustomer(customerId);
  //             globals.selectedShiptoQuot = globals.selectedShipto;
  //           }
  //           else{
  //             prefs.remove('customer');
  //           }
  //         }
  //
  //         await _apiService.getCompany();
  //         await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Launcher(pageIndex: globals.company != 'IDEXX' ? 3 : 1)));
  //
  //       }
  //       else {
  //         // Navigator.pop(context);
  //         return showAlertDialog(context, 'ไม่พบข้อมูลพนักงาน');
  //       }
  //     }
  //     else {
  //       // Navigator.pop(context);
  //       return showAlertDialog(context, 'เข้าสู่ระบบไม่สำเร็จ');
  //     }
  //   }
  //   on SocketException {
  //     // Navigator.pop(context);
  //     return SharedWidgets.showAlert(context, 'Internet Disconnect', 'ไม่สามารถเชื่อมต่อกับอินเตอร์เน็ต');
  //   }
  //   catch(error) {
  //     // Navigator.pop(context);
  //     return SharedWidgets.showAlert(context, 'Checking User Error', '$error');
  //   }
  // }

  Widget _entryField(String title, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
              controller: controller,
              obscureText: isPassword ? isPassword : false,
              textInputAction: TextInputAction.next,
              textCapitalization: isPassword == true ? TextCapitalization.none : TextCapitalization.characters,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: const Color(0xfff3f3f4),
                  filled: true,
                  suffix: isPassword ? GestureDetector(
                    child: Icon(isPassword ? Icons.visibility : Icons.visibility_off),
                    onTap: _togglePasswordView,
                  ) : const Text('')
              )
          )
        ],
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      isPassword = !isPassword;
    });
  }

  showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("แจ้งเตือน"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _submitButton() {
    return InkWell(
      onTap: () async {
        // if(compValue?.id == null || txtUsername.text == '' || txtPassword.text == '') {
        //   return SharedWidgets.showAlert(context, 'แจ้งเตือน', 'โปรดกรอกข้อมูล');
        // }

        // await getUser(compValue.compCode, txtUsername.text, txtPassword.text);
        // Navigator.pop(context);

        Employee emp = await ApiService().getEmployee(txtUsername.text, txtPassword.text);

        if(emp != Employee()){
          EMPLOYEE = emp;
          MY_COMPANY = compValue!;

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('access', true);
          prefs.setString('username', EMPLOYEE.code ?? '');
          prefs.setString('password', EMPLOYEE.password ?? '');
          prefs.setString('company', MY_COMPANY.id!);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Launcher(pageIndex: 3)));
        }

        if (kDebugMode) {
          print("Username: ${txtUsername.text} Password: ${txtPassword.text}");
        }
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 1.2,
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)]
            )
        ),
        child: const Text(
          'เข้าสู่ระบบ',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
      ),
    );
  }

  Widget _title() {
    return const Image(
      height: 300,
      image: AssetImage('assets/bisgroup_logo_contrast.png'),
    );
  }

  Widget _emailPasswordWidget() {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width / 1.2,
      child: Column(
        children: <Widget>[
          _entryField("Username :", txtUsername, isPassword: false),
          _entryField("Password :", txtPassword, isPassword: true),
        ],
      ),
    );
  }

  Widget _companySelect() {
    return SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width / 1.2,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Company :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<Company>(
                  value: compValue,
                  isExpanded: true,
                  hint: const Text('เลือกบริษัท'),
                  items: companies.map((Company value) {
                    return DropdownMenuItem<Company>(
                      value: value,
                      child: Text(value.name ?? ''),
                    );
                  }).toList(),
                  // onTap: () => FocusScopeNode().unfocus(),
                  onChanged: (Company? value) {
                    setState(() {
                      if(value != null){
                        compValue = value!;
                        MY_COMPANY = compValue!;

                        FocusScope.of(context).requestFocus(FocusNode());
                        if (kDebugMode) {
                          print(compValue?.name);
                        }
                      }
                    });
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true)
              )
            ]
        )
    );
  }

  Widget bezierContainer() {
    return Transform.rotate(
      angle: 0,
      child: ClipPath(
        clipper: ClipPainter(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF5D62C0), Color(0xFF323682)]
                // colors: [Color(0xfffbb448), Color(0xffe46b10)]
              )
          ),
        ),
      ),
    );
  }
}
