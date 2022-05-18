import 'dart:async';
import 'dart:ffi';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/Item.dart';
import 'package:google_map/Order.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/google_map_api.dart';
import 'package:google_map/main.dart';
import 'package:google_map/screens/Login_screen.dart';
import 'package:google_map/screens/Register_screen.dart';
import 'package:google_map/screens/addScreen.dart';
import 'package:google_map/screens/person_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../google_map_api.dart';

class CustomDashboard extends StatefulWidget {
  CustomDashboard(String this.name, String this.password, String this.phone);

  late String name, phone, password;

  @override
  State<CustomDashboard> createState() => _DashboardState();
}

bool ttt = false;
Position myLocation = Position(
    longitude: 37.166668,
    latitude: 36.216667,
    timestamp: DateTime.now(),
    accuracy: 1,
    altitude: 1,
    heading: 1,
    speed: 1,
    speedAccuracy: 1);

class _DashboardState extends State<CustomDashboard> {
  Api API = Api();

  Future<void> getPos() async {
    try {
      LocationPermission per = await Geolocator.checkPermission();
      if (per == LocationPermission.denied) {
        per = await Geolocator.requestPermission();
        if (per != LocationPermission.always) {}
      }
      myLocation = await API.getMyLocation();
      setState(() {
        ttt = true;
      });
    } catch (e) {
      print('==============$e=================');
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Login(false);
      }), (route) => false);
    }
    await API.getMyOrders(myLocation, context);
  }



  @override
  void initState() {
    // TODO: implement initState

    getPos();
  }

  GoogleMapController? _googleMapController;

  List<Order> orders = [];
  bool haveOrder = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text('${preferences.getString('name')} orders map'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return CustomDashboard(
                      widget.name, widget.password, widget.phone);
                }), (route) => false);
              },
              icon: Icon(CupertinoIcons.refresh)),
          IconButton(
              onPressed: () {
                preferences.clear();
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return PersonalScreen();
                }), (route) => false);
              },
              icon: Icon(CupertinoIcons
                  .rectangle_arrow_up_right_arrow_down_left_slash)),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            API.apiOrders.forEach(
              (element) {
                if (element.ownerUserNum == preferences.getString('id')) {
                  print(element.ownerUserNum);
                  if (element.isWaitting) {
                    print(element.received);
                    print('============================');
                    setState(() {
                      haveOrder = true;
                    });
                  }
                }
              },
            );
            if (!haveOrder) {
              List<Item> list = await API.getorderItems('all');
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddScreen(
                    LatLng(myLocation.latitude, myLocation.longitude), list);
              }));
            } else {
              AwesomeDialog(
                      context: context, body: Text('you have order active'))
                  .show();
            }
          },
          child: const Icon(
            Icons.add,
            color: Colors.black,
          )),
      backgroundColor: Colors.white,
      body: Center(
        child: ttt
            ? FutureBuilder<List<Order>>(
                future: API.getMyOrders(myLocation, context),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      !snapshot.hasError &&
                      snapshot.connectionState == ConnectionState.done) {
                    List<Marker> marks = [];
                    for (Order order in snapshot.data!) {
                      if (order.ownerUserNum ==
                          preferences.get('id').toString())
                        marks.add(order.marker);
                    }

                    return Stack(
                      children: [
                        GoogleMap(
                          markers: Set.of(marks),
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                myLocation.latitude, myLocation.longitude),
                            zoom: 11.5,
                          ),
                        ),

                      ],
                    );
                  } else {
                    return CustomeCircularProgress(context);
                  }
                },
              )
            : CustomeCircularProgress(context),
      ),
    );
  }
}
