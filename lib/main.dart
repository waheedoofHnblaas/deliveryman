import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_map/view/screens/dashSc/CustomDashboard_screen.dart';
import 'package:google_map/view/screens/dashSc/MainDash.dart';
import 'package:google_map/view/screens/person_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;

Future<void> initPlaState() async {
  try {
    OneSignal.shared.setAppId('c7e9c9d9-80f8-4d6c-8955-f648312bb26f');
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {
    });
  } catch (e) {
    print(e);
  }
}


Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,),
  );
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();
  // await Api.getOrders(await Api.getMyLocation());
  await initPlaState();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'RobotoMono',
        primaryColor: const Color(0xFF006497),
        backgroundColor: const Color(0xffffffff),
        // backgroundColor: Color(0xFF90D9F8),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
          backgroundColor: Color(0xFF006497),
          toolbarHeight: 40,
          centerTitle: true,
        ),
      ),
      home: preferences.get('id') == null
          ? const PersonalScreen()
          : preferences.getBool('isEmp')!
          ? MainDashboard(
        preferences.get('name').toString(),
        preferences.get('password').toString(),
        preferences.get('phone').toString(),
      )
          : CustomDashboard(
        preferences.get('name').toString(),
        preferences.get('password').toString(),
        preferences.get('phone').toString(),
      ),
    ),
  );
}
