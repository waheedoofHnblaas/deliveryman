import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/view/screens/authSc/Login_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
class PersonalScreen extends StatefulWidget {
  const PersonalScreen({Key? key}) : super(key: key);

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

bool isEmp = false, isCustom = false;

class _PersonalScreenState extends State<PersonalScreen> {





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Get.off(PersonalScreen());
              },
              icon: Icon(Icons.refresh))
        ],
        title: const Text('personality'),
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              bottom: 55,
              left: 0,
              right: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Get.theme.backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(33)),
                  ),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          child: Hero(
                            tag: 'icon',
                            child: Image.asset(
                              "lib/view/images/deliveryGif.gif",
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.4,
                        ),
                        const SizedBox(height: 55),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'are you ?',
                            style: TextStyle(color: Get.theme.primaryColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: OutlineButton(

                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(33)),
                                  ),

                                  onPressed: () {
                                    setState(() {
                                      isCustom = !isCustom;
                                      isEmp = false;
                                    });
                                  },
                                  child: Text(
                                    'Customer',
                                    style:
                                        TextStyle(color: Get.theme.primaryColor),
                                  ),
                                  borderSide: BorderSide(
                                    color: isCustom
                                        ? Get.theme.primaryColor
                                        : Get.theme.backgroundColor,
                                  ),

                                ),
                              ),
                              SizedBox(width: 8,),
                              Expanded(
                                child: OutlineButton(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(33)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isEmp = !isEmp;
                                      isCustom = false;
                                    });
                                  },
                                  child: Text(
                                    'Employee',
                                    style:
                                        TextStyle(color: Get.theme.primaryColor),
                                  ),
                                  borderSide: BorderSide(
                                    color: isEmp
                                        ? Get.theme.primaryColor
                                        : Get.theme.backgroundColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: InkWell(
                onTap: () {
                  if (!isEmp && !isCustom) {
                    Get.to(Login(false));
                  } else {
                    if (isEmp) {
                      Get.to(Login(isEmp));
                    } else {
                      Get.to(Login(isEmp));
                    }
                  }
                },
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'confirm',
                        style: TextStyle(color: Get.theme.backgroundColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
