import 'package:dynamics_crm/config/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:ismart_crm/src/container_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../ui/login.dart';
import '../ui/setting.dart';
import '../ui/sales_order_create.dart';

class NavDrawer extends StatelessWidget {

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('password');
    prefs.remove('company');
    prefs.remove('customer');
    prefs.remove('lockPrice');
    prefs.remove('check_due_date');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListView(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    'SmartSales BIS \nVersion 3.3.4',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                          fit: BoxFit.fill, image: AssetImage('assets/bg_02.jpg'))),
                ),
                // ListTile(
                //   leading: Icon(Icons.refresh),
                //   title: Text('Refresh'),
                //   onTap: () {
                //   },
                // ),
                Visibility(
                  visible: false,
                  child: ListTile(
                    leading: Icon(Icons.shopping_basket),
                    title: Text('Sales Order'),
                    onTap: () => {
                      if (CUSTOMER == null)
                        {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("แจ้งเตือน"),
                              content: const Text(
                                "กรุณาเลือกลูกค้าของคุณ",
                                style: TextStyle(fontSize: 18),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("ปิดหน้าต่าง"))
                              ],
                            ),
                          )
                        }
                      else
                        {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const SalesOrderCreate()))
                        }
                    },
                  ),
                ),
                // ListTile(
                //   leading: Icon(Icons.monetization_on),
                //   title: Text('Commission'),
                //   onTap: () => {Navigator.of(context).pop()},
                // ),
                Visibility(
                  visible: false,
                  child: ListTile(
                    leading: Icon(Icons.people_alt),
                    title: Text('Customers'),
                    onTap: () => {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => ContainerCustomer())
                      // )
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.border_color),
                  title: Text('Feedback'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () => {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Setting()))
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: Icon(Icons.token_outlined),
                  title: Text('My Token'),
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text('My Token'),
                              content: Text(FCM_TOKEN),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () async {
                                      await Clipboard.setData(ClipboardData(text: FCM_TOKEN));
                                    },
                                    child: Text("Copy")
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Close")
                                )
                              ]
                          );
                        }
                    );
                  },
                ),
              ],
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 25.0),
              child: Card(
                color: Colors.white70,
                shape: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () async {
                    // globals.docKeyword = null;
                    CUSTOMER = null;
                    // globals.allCustomer = null;
                    // globals.allCustomerNew = null;
                    // globals.allCustomerByEmp = null;
                    // globals.allShipto = null;
                    // globals.allProduct = null;
                    // globals.editingProductCart = null;
                    //
                    // globals.selectedShipto = null;
                    // globals.selectedShiptoCopy = null;
                    // globals.selectedShiptoDraft = null;
                    //
                    // globals.clearOrder();
                    // globals.clearCopyOrder();
                    // globals.clearDraftOrder();
                    // globals.clearQuotation();
                    // globals.clearCopyQuotation();
                    // globals.clearDraftQuotation();

                    await logout();

                    await Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Login())
                    );
                  },
                ),
              ),
            ),

            // Container(
            //     padding: EdgeInsets.symmetric(vertical: 25.0),
            //     child: Text('Token: ${globals.fcmToken}')
            // )
          ],
        ),
      ),
    );
  }
}
