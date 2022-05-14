import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map/conmponent/CustomButton.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/conmponent/CustomTextField.dart';
import 'package:google_map/screens/Dashboard_screen.dart';
import 'package:google_map/screens/Register_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

bool _btn = true;

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'login',
                style: TextStyle(fontSize: 41, color: Colors.blue),
              ),
              SizedBox(
                height: 20,
              ),
              CustomeTextFeild(() {}, 'your personal name', '', context),
              CustomeTextFeild(() {}, 'your phone number', '', context),
              _btn
                  ? CustomeButton(() {
                      setState(() {
                        _btn = false;
                      });
                      Timer(Duration(seconds: 5), () {});
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return Dashboard();
                      }), (route) => false);
                    }, 'register', context)
                  : CustomeCircularProgress(context),
              TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return Register();
                    }), (route) => false);
                  },
                  child: Text('you have not acount ?'))
            ],
          ),
        ),
      ),
    );
  }
}
