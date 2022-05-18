import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_map/conmponent/CustomButton.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/conmponent/CustomTextField.dart';
import 'package:google_map/database/api.dart';
import 'package:google_map/main.dart';
import 'package:google_map/screens/CustomDashboard_screen.dart';
import 'package:google_map/screens/Login_screen.dart';
import 'package:google_map/database/api_links.dart';
import 'package:google_map/screens/MainDash.dart';

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

      if (response['status'] == 'user is here') {
        AwesomeDialog(context: context, title: 'user is exist').show();
      } else if (response['status'] == 'success') {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return CustomDashboard(name, password, phone);
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
      appBar: AppBar(
        title: Text('register'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                CustomeButton(
                  () async {
                    if (name == '' || password == '' || phone == '') {
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              title: 'empty field')
                          .show();
                    } else {
                      CustomeCircularProgress(context);
                      await regist();
                    }
                  },
                  'register',
                  context,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return Login(false);
                      }), (route) => false);
                    },
                    child: const Text('you have acount ?'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
