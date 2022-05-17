import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map/conmponent/CustomButton.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/conmponent/CustomTextField.dart';
import 'package:google_map/database/api.dart';
import 'package:google_map/database/api_links.dart';
import 'package:google_map/main.dart';
import 'package:google_map/screens/CustomDashboard_screen.dart';
import 'package:google_map/screens/MainDash.dart';
import 'package:google_map/screens/Register_screen.dart';

class Login extends StatefulWidget {
  Login(this.isEmp);

  late bool isEmp;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String name = '', num = '', password = '';
  final PhpApi _api = PhpApi();

  login() async {
    try {
      var response = await _api.postRequest(
        widget.isEmp ? loginLinkEmp : loginLinkCustom,
        {
          'name': name,
          'password': password,
        },
      );

      if (response['status'] == 'success') {

        print('++++++++++++++++++++++++++++++++++++++ ${response['data']['id']}');
        preferences.setBool('isEmp', widget.isEmp);
        preferences.setString('id', response['data']['id'].toString());
        preferences.setString('name', response['data']['name'].toString());
        preferences.setString(
            'password', response['data']['password'].toString());
        preferences.setString('phone', response['data']['phone'].toString());
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return   widget.isEmp ? MainDashboard(
            preferences.get('name').toString(),
            preferences.get('password').toString(),
            preferences.get('phone').toString(),
          ):CustomDashboard(
            preferences.get('name').toString(),
            preferences.get('password').toString(),
            preferences.get('phone').toString(),
          );
        }), (route) => false);
      } else {

        print('register failed ${response['status']}');
      }
    } catch (e) {
      print(e);
    }
  }

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
              CustomeTextFeild((val) {
                setState(() {
                  name = val;
                });
              }, 'your personal name', '', context),
              CustomeTextFeild((val) {
                setState(() {
                  password = val;
                });
              }, 'your password', '', context),
              CustomeButton(() async {
                if (name != '' && password != '') {
                  CustomeCircularProgress(context);
                  await login();

                } else {}
              }, 'login', context),
              widget.isEmp
                  ? Container()
                  : TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return Register(widget.isEmp);
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
