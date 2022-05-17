import 'package:flutter/material.dart';
import 'package:google_map/screens/CustomDashboard_screen.dart';
import 'package:google_map/screens/MainDash.dart';
import 'package:google_map/screens/person_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();
  // await Api.getOrders(await Api.getMyLocation());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: preferences.get('id') == null
          ? PersonalScreen()
          : preferences.getBool('isEmp')!
              ? MainDashboard(
                  preferences.get('name').toString(),
                  preferences.get('password').toString(),
                  preferences.get('phone').toString())
              : CustomDashboard(
                  preferences.get('name').toString(),
                  preferences.get('password').toString(),
                  preferences.get('phone').toString(),
                )
    );
  }
}
