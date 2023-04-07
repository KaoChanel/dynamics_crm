import 'package:dynamics_crm/providers/data_provider.dart';
import 'package:dynamics_crm/services/api_service.dart';
import 'package:dynamics_crm/ui/launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/global_constants.dart';
import 'login.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    // if(!kIsWeb) newVersion.showAlertIfNecessary(context: context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await checkLocation();
      await autoLogIn();
      // await globals.checkConnection(context);
    });

    super.initState();
  }

  autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('access') != null && prefs.getString('company') != null) {
      if(prefs.getBool('access')!){
        await loadProvince();
        await loadDistrict();
        await loadDistrictSub();
        MY_COMPANY = await ApiService().getCompany(prefs.getString('company')!);
        EMPLOYEE = await ApiService().getEmployee(prefs.getString('username')!, prefs.getString('password')!);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Launcher(pageIndex: 3)));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String msg = ref.watch(loadingMessage);
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
            Text(msg),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 20.0),
            //   child: Text(dialog.message, style: TextStyle(fontSize: 16.0)),
            // )
          ],
        ),
      ),
      bottomNavigationBar: Container(padding: const EdgeInsets.all(15.0), color: Colors.white, child: const Text('version 1.0.0', textAlign: TextAlign.right,)),
    );
  }
}
