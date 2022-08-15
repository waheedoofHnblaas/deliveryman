import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/model/database/api.dart';
import 'package:google_map/view/conmponent/CustomButton.dart';
import 'package:google_map/view/conmponent/CustomCirProgress.dart';
import 'package:google_map/view/conmponent/CustomTextField.dart';
import 'package:google_map/view/conmponent/customAwesome.dart';
import 'package:google_map/view/screens/authSc/Login_screen.dart';
import '../../../model/database/api_links.dart';

class Register extends StatefulWidget {
  Register(this.isEmp, {Key? key}) : super(key: key);

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
      var response =
      widget.isEmp ? await _api.postRequest(
        registerLinkEmp ,
        {
          'name': name,
          'password': password,
          'phone': phone,
          'rate': '0',
          'createTime':
          '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
        },
      ):await _api.postRequest(
          registerLinkCustom,
          {
            'name': name,
            'password': password,
            'phone': phone,
            'createTime':
            '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
          }
      );

      Get.back();
      if (response['status'] == 'user is here') {
        CustomAwesomeDialog(context: context, content: 'user is exist');
      } else if (response['status'] == 'success') {
        widget.isEmp ? Get.back() : Get.offAll(Login(false));
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
        title: const Text('regist employee'),
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
                          height: (MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).viewInsets.bottom) *
                              .2,
                          child: Hero(
                              tag: 'icon',
                              child: Image.asset(
                                  'lib/view/images/deliveryGif.gif')),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomeTextFeild((v) {
                          setState(() {
                            name = v;
                          });
                        }, 'your name', '', context),
                        CustomeTextFeild((v) {
                          setState(() {
                            phone = v;
                          });
                        }, 'your phone', '', context,
                            isNumber: TextInputType.number),
                        CustomeTextFeild((v) {
                          setState(() {
                            password = v;
                          });
                        }, 'your password', '', context, isPassword: true),
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
               widget.isEmp?Container(): TextButton(
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
