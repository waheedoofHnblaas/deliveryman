import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_map/conmponent/CustomButton.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/conmponent/CustomTextField.dart';
import 'package:google_map/database/api.dart';
import 'package:google_map/screens/EmpDashboard.dart';
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
  String name = '', num = '', password = '';
  final Api _api = Api();

  regist() async {
    try {
      var response = await _api.postRequest(
        widget.isEmp ? registerLinkEmp : registerLinkCustom,
        {
          'name': name,
          'password': password,
          'phone': num,
        },
      );

      Navigator.pop(context);
      if (response['status'] == 'success') {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return Login(widget.isEmp);
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'register',
                  style: TextStyle(fontSize: 41, color: Colors.blue),
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
                    num = v;
                  });
                }, 'your phone number', '', context,
                    isNumber: TextInputType.number),
                CustomeTextFeild((v) {
                  setState(() {
                    password = v;
                  });
                }, 'your phone password', '', context),
                CustomeButton(
                  () async {
                    if (name == '' || password == '' || num == '') {
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              title: 'it is null')
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
                        return Login(widget.isEmp);
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
