import 'package:dynamics_crm/ui/launcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/global_constants.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // if(!kIsWeb) newVersion.showAlertIfNecessary(context: context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await checkLocation();
      await loadProvince();
      await loadDistrict();
      await loadDistrictSub();
      autoLogIn();
      // await globals.checkConnection(context);
    });

    super.initState();
  }

  autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Launcher(pageIndex: 0)), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.network(globals.splashUrl),
            Image.asset('assets/new-bisgroup-logo.png', fit: BoxFit.contain),
            const CircularProgressIndicator(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 20.0),
            //   child: Text(dialog.message, style: TextStyle(fontSize: 16.0)),
            // )
          ],
        ),
      ),
      bottomNavigationBar: Container(padding: const EdgeInsets.all(15.0), color: Colors.white, child: const Text('version 3.3.4', textAlign: TextAlign.right,)),
    );
  }
}
