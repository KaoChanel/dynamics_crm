import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:dynamics_crm/ui/profile.dart';
import 'package:dynamics_crm/ui/report.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:provider/provider.dart';
// import 'package:ismart_crm/models/count_alarm.dart';
import '../widgets/nav_drawer.dart';
// import 'customer_appointment_table.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'package:dynamics_crm/config/global_constants.dart';

/// Create a [AndroidNotificationChannel] for heads up notifications
// AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class Launcher extends StatefulWidget {
  Launcher({super.key,  required this.pageIndex });
  int pageIndex;

  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  late String _token;
  int _selectedIndex = 0;
  int initialIndex = MY_COMPANY.displayName != 'IDEXX' ? 2 : 1;

  late PageController _pageController;
  final List<Widget> _pageWidget = MY_COMPANY.displayName != 'IDEXX' ? <Widget>[
    const Home(),
    const Report(),
    const Profile(),
  ]
      : <Widget>[
    const Home(),
    const Profile(),
  ];

  final List<BottomNavigationBarItem> _menuBar = MY_COMPANY.name != 'IDEXX' ? <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Main',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart),
      label: 'Report',
    ),
    // const BottomNavigationBarItem(
    //   icon: Icon(Icons.info_outline_rounded),
    //   label: 'News',
    // ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_rounded),
      label: 'Profile',
    )
  ]
      : <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Main',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_rounded),
      label: 'Profile',
    ),
  ];

  // Crude counter to make messages unique
  int _messageCount = 0;

  /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
  String constructFCMPayload(String token) {
    _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#$_messageCount) was created via FCM!',
      },
    });
  }

  Future<void> sendPushMessage() async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token),
      );

      print('FCM request for device sent!');
    } catch (ex) {
      log('$ex');
    }
  }

  getToken() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {

        if (kIsWeb) {
          FCM_TOKEN = await FirebaseMessaging.instance.getToken(
              vapidKey: 'BOEoOS23mXiXOq3I0rQCIdijkCdlms1Dk0_QWACpQiIR9XE-PLRx_HGz1TKyHNejKd031Elpb_BdLngqZY-JQ8o') ?? '';
        }
        else {
          FCM_TOKEN = await FirebaseMessaging.instance.getAPNSToken() ?? '';
        }

        print('FlutterFire Messaging : Got APNs token: $FCM_TOKEN');
      }
      else {
        if (kIsWeb) {
          FCM_TOKEN = await FirebaseMessaging.instance.getToken(
              vapidKey: 'BOEoOS23mXiXOq3I0rQCIdijkCdlms1Dk0_QWACpQiIR9XE-PLRx_HGz1TKyHNejKd031Elpb_BdLngqZY-JQ8o') ?? '';
        }
        else {
          FCM_TOKEN = await FirebaseMessaging.instance.getToken() ?? '';
        }

        // print(
        //   'FlutterFire Messaging : Getting an APNs token is only supported on iOS and macOS platforms.',
        // );
        print('FlutterFire Messaging : Got token: $FCM_TOKEN');
      }
    }
    catch(ex){
      log('getToken Error: $ex');
    }
  }

  Future<void> onActionSelected(String value) async {
    switch (value) {
      case 'subscribe':
        {
          log(
            'FlutterFire Messaging Example: Subscribing to topic "fcm_test".',
          );
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
          log(
            'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.',
          );
        }
        break;
      case 'unsubscribe':
        {
          log(
            'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".',
          );
          await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
          log(
            'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.',
          );
        }
        break;
      case 'get_apns_token':
        {
          await getToken();
        }
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: initialIndex);
    _selectedIndex = widget.pageIndex;

    getToken();

    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage? message) {
    //   if (message != null) {
    //     // Navigator.pushNamed(
    //     //   context,
    //     //   '/message',
    //     //   arguments: MessageArguments(message, true),
    //     // );
    //   }
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null && !kIsWeb) {
        // flutterLocalNotificationsPlugin.show(
        //   notification.hashCode,
        //   notification.title,
        //   notification.body,
        //   NotificationDetails(
        //     android: AndroidNotificationDetails(
        //       channel.id,
        //       channel.name,
        //       channelDescription: channel.description,
        //       // TODO add a proper drawable resource to android, for now using
        //       //      one that already exists in example app.
        //       icon: 'launch_background',
        //     ),
        //   ),
        // );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('${MY_COMPANY.displayName!} ${MY_COMPANY.displayName!.contains('TEST') ? ' (ทดสอบ)' : ''}', style: const TextStyle(fontSize: 15.0),),
        actions: <Widget>[
          // _showAlarm(),
        ],
      ),
      body: PageView(
        controller: _pageController,
        // physics: PageScrollPhysics(),
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: _pageWidget,
        // children: [
        //   DoubleBackToCloseApp(
        //     snackBar: const SnackBar(
        //       duration: Duration(milliseconds: 800),
        //         content: Text(
        //       'Tap back again to exit',
        //       textAlign: TextAlign.center,
        //     )),
        //     child: _pageWidget.elementAt(_selectedIndex)),
        // ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _menuBar,
        onTap: _onItemTapped,

        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        // currentIndex: _selectedIndex,
        // onTap: _onItemTapped,
      ),
    );
  }

  // Widget _showAlarm() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Stack(
  //       children: <Widget>[
  //         IconButton(icon: const Icon(Icons.notifications_outlined, size: 26),
  //             onPressed: () {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => CustomerAppointmentTable()));
  //             }),
  //
  //         (Provider.of<CountAlarm>(context).counter <= 0) //globals.countAlarm <= 0
  //             ?
  //         Container()
  //             :
  //         Positioned(
  //           right: 0,
  //           top: 0,
  //           child: Container(
  //             padding: const EdgeInsets.all(2),
  //             decoration: BoxDecoration(
  //               color: Colors.red,
  //               borderRadius: BorderRadius.circular(6),
  //             ),
  //             constraints: const BoxConstraints(
  //               minWidth: 15,
  //               minHeight: 15,
  //             ),
  //             child: Text(
  //               "${Provider.of<CountAlarm>(context).counter}",//"${Provider.of<CountAlarm>(context).counter}", //"${globals.countAlarm}", //globals.countAlarm > 10 ? "9+" : "${globals.countAlarm}",
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 13,
  //               ),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ),
  //         ///
  //
  //       ],
  //     ),
  //   );
  //   /// แจ้งเตือน
  // }
}
