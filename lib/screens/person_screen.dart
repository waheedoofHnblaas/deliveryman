import 'package:flutter/material.dart';
import 'package:google_map/screens/Login_screen.dart';
import 'package:google_map/screens/Register_screen.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({Key? key}) : super(key: key);

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

bool isEmp = false, isCustom = false;

class _PersonalScreenState extends State<PersonalScreen> {
  @override
  void initState() {
    // TODO: implement initState

    print('==========_PersonalScreenState=++==userName========');

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return PersonalScreen();
                }), (route) => false);
              },
              icon: Icon(Icons.refresh))
        ],
        title: const Text('personallity'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('are you ?'),
              ),
              OutlineButton(
                onPressed: () {
                  setState(() {
                    isCustom = !isCustom;
                    isEmp = false;
                  });
                },
                child: const Text('customer'),
                borderSide: BorderSide(
                  color: isCustom ? Colors.green : Colors.red,
                ),
              ),
              OutlineButton(
                onPressed: () {
                  setState(() {
                    isEmp = !isEmp;
                    isCustom = false;
                  });
                },
                child: const Text('Employee'),
                borderSide: BorderSide(
                  color: isEmp ? Colors.green : Colors.red,
                ),
              ),
              OutlineButton(
                onPressed: () {
                  if (!isEmp && !isCustom) {
                  } else {
                    if(isEmp){
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                            return Login(isEmp);
                          }), (route) => false);
                    }else{

                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                            return Register(isEmp);
                          }), (route) => false);
                    }
                  }
                },
                child: const Text('confirm'),
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
