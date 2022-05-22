import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/conmponent/CustomButton.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/conmponent/CustomTextField.dart';
import 'package:google_map/conmponent/color.dart';
import 'package:google_map/conmponent/customAwesome.dart';
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

      Get.back();
      if (response['status'] == 'success') {
        print(
            '++++++++++++++++++++++++++++++++++++++ ${response['data']['id']}');
        preferences.setBool('isEmp', widget.isEmp);
        preferences.setString('id', response['data']['id'].toString());
        preferences.setString('name', response['data']['name'].toString());
        preferences.setString(
            'password', response['data']['password'].toString());
        preferences.setString('phone', response['data']['phone'].toString());
        Get.offAll(
          widget.isEmp
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
        );
      } else if (response['status'] == 'password') {
        print('register failed ${response['status']}');
        CustomAwesomeDialog(
            context: context, content: 'password is not correct');
      } else if (response['status'] == 'faild') {
        print('register failed ${response['faild']}');
        CustomAwesomeDialog(
            context: context,
            content: 'you do not have account with this name');
      } else {
        CustomAwesomeDialog(context: context, content: 'network error');
        print('register failed ${response['status']}');
      }
    } catch (e) {
      CustomAwesomeDialog(context: context, content: 'network error $e');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 25,
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            CupertinoIcons.back,
          ),
        ),
        backgroundColor: Get.theme.primaryColor,
        title: Text('login'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Get.theme.backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(33)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: Image.asset('lib/images/delivery.png'),
                      ),
                      const SizedBox(
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
                    ],
                  ),
                ),
                CustomeButton(() async {
                  if (name != '' && password != '') {
                    await login();
                  } else {
                    AwesomeDialog(context: context, title: 'empty field')
                        .show();
                  }
                }, 'login', context),
                widget.isEmp
                    ? Container()
                    : TextButton(
                        onPressed: () {
                          Get.off(Register(widget.isEmp));
                        },
                        child: Text(
                          'you have not acount ?',
                          style: TextStyle(color: Get.theme.backgroundColor),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}