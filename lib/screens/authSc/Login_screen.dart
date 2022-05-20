import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map/conmponent/CustomButton.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/conmponent/CustomTextField.dart';
import 'package:google_map/database/api.dart';
import 'package:google_map/database/api_links.dart';
import 'package:google_map/main.dart';
import 'package:google_map/screens/dashSc/CustomDashboard_screen.dart';
import 'package:google_map/screens/dashSc/MainDash.dart';
import 'package:google_map/screens/authSc/Register_screen.dart';

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
    CustomeCircularProgress(context);
    try {
      var response = await _api.postRequest(
        widget.isEmp ? loginLinkEmp : loginLinkCustom,
        {
          'name': name,
          'password': password,
        },
      );

      Navigator.pop(context);
      if (response['status'] == 'success') {
        print(
            '++++++++++++++++++++++++++++++++++++++ ${response['data']['id']}');
        preferences.setBool('isEmp', widget.isEmp);
        preferences.setString('id', response['data']['id'].toString());
        preferences.setString('name', response['data']['name'].toString());
        preferences.setString(
            'password', response['data']['password'].toString());
        preferences.setString('phone', response['data']['phone'].toString());
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return widget.isEmp
              ? MainDashboard(
                  preferences.get('name').toString(),
                  preferences.get('password').toString(),
                  preferences.get('phone').toString(),
                )
              : CustomDashboard(
                  preferences.get('name').toString(),
                  preferences.get('password').toString(),
                  preferences.get('phone').toString(),
                );
        }), (route) => false);
      } else if (response['status'] == 'password') {
        print('register failed ${response['status']}');
        AwesomeDialog(context: context, title: 'password is not correct')
            .show();
      } else if(response['status']=='faild'){
        print('register failed ${response['faild']}');
        AwesomeDialog(
                context: context,
                title: 'you do not have account with this name')
            .show();
      }else{
        print('register failed ${response['status']}');
        AwesomeDialog(
            context: context,
            title: 'network error')
            .show();
      }
    } catch (e) {
      AwesomeDialog(
          context: context,
          title: 'network error')
          .show();
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.location,
                color: Colors.blue,
                size: 200,

              ),
              SizedBox(
                height: 20,
              ),
              CustomeTextFeild((val) {
                setState(() {
                  name = val;
                });
              }, 'your personal name', '', context),
              CustomeTextFeild(
                (val) {
                  setState(() {
                    password = val;
                  });
                },
                'your password',
                '',
                context,
                isPassword: true,
              ),
              CustomeButton(() async {
                if (name != '' && password != '') {
                  await login();
                } else {
                  AwesomeDialog(context: context, title: 'empty field').show();
                }
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
