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
import 'package:google_map/main.dart';
import 'package:google_map/screens/dashSc/CustomDashboard_screen.dart';
import 'package:google_map/screens/authSc/Login_screen.dart';
import 'package:google_map/database/api_links.dart';
import 'package:google_map/screens/dashSc/MainDash.dart';

class Register extends StatefulWidget {
  Register(this.isEmp);

  late bool isEmp;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name = '', phone = '', password = '';
  final PhpApi _api = PhpApi();

  regist() async {
    CustomeCircularProgress(context);
    try {
      var response = await _api.postRequest(
        widget.isEmp ? registerLinkEmp : registerLinkCustom,
        {
          'name': name,
          'password': password,
          'phone': phone,
          'createTime':
              '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
        },
      );

      Get.back();
      if (response['status'] == 'user is here') {
        CustomAwesomeDialog(context: context, content: 'user is exist');
      } else if (response['status'] == 'success') {
        Get.offAll(CustomDashboard(name, password, phone));
      } else {
        CustomAwesomeDialog(
            context: context, content: 'network connection less');
      }
    } catch (e) {
      CustomAwesomeDialog(context: context, content: 'network error');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        title: Text('register'),
        leading: IconButton(
          iconSize: 25,
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            CupertinoIcons.back,
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Get.theme.backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(33)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          child: Hero(
                              tag: 'icon',
                              child: Image.asset('lib/images/delivery.png')),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomeTextFeild((v) {
                          setState(() {
                            name = v;
                          });
                        }, 'your personal name', '', context),
                        CustomeTextFeild((v) {
                          setState(() {
                            phone = v;
                          });
                        }, 'your phone number', '', context,
                            isNumber: TextInputType.number),
                        CustomeTextFeild((v) {
                          setState(() {
                            password = v;
                          });
                        }, 'your phone password', '', context, isPassword: true),
                      ],
                    ),
                  ),
                ),
                CustomeButton(
                  () async {
                    if (name == '' || password == '' || phone == '') {
                      CustomAwesomeDialog(
                          context: context, content: 'empty field');
                    } else if (password.length < 7) {
                      CustomAwesomeDialog(
                          context: context,
                          content: 'password shorter than 6 letters');
                    } else if (name.length < 7) {
                      CustomAwesomeDialog(
                          context: context,
                          content: 'name shorter than 6 letters');
                    } else {
                      await regist();
                    }
                  },
                  'register',
                  context,
                ),
                TextButton(
                  onPressed: () {
                    Get.off(Login(false));
                  },
                  child: Text(
                    'you have acount ?',
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
