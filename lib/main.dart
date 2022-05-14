import 'package:flutter/material.dart';
import 'package:google_map/google_map_api.dart';
import 'package:google_map/screens/CustomDashboard_screen.dart';
import 'package:google_map/screens/Dashboard_screen.dart';
import 'package:google_map/screens/Data_screen.dart';
import 'package:google_map/screens/Register_screen.dart';
import 'package:google_map/screens/person_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Api.getOrders(await Api.getMyLocation());
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
      home: const Register(),
    );
  }
}
