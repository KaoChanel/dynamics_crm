import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
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
      autoLogIn();
      // await globals.checkConnection(context);
    });

    super.initState();
  }

  Future<void> autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
