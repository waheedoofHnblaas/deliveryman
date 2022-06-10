import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_map/conmponent/CustomButton.dart';
import 'package:google_map/conmponent/customAwesome.dart';
import 'package:google_map/oop/Order.dart';
import 'package:google_map/conmponent/customDrawer.dart';
import 'package:google_map/database/google_map_api.dart';
import 'package:google_map/main.dart';
import 'package:google_map/screens/authSc/Login_screen.dart';
import 'package:google_map/screens/person_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Position myLocation = Position(
    longitude: 37.166668,
    latitude: 36.216667,
    timestamp: DateTime.now(),
    accuracy: 1,
    altitude: 1,
    heading: 1,
    speed: 1,
    speedAccuracy: 1);

class MainDashboard extends StatefulWidget {
  MainDashboard(
    String this.name,
    String this.password,
    String this.phone,
  );

  late String name, phone, password;

  @override
  State<MainDashboard> createState() => _EmpDashboardState();
}

bool choose = false;
List<Marker> chooseMarker = [const Marker(markerId: MarkerId(''))];
bool ttt = false;
bool all = true, wait = false, done = false, withD = false;

class _EmpDashboardState extends State<MainDashboard> {
  Future<void> getPos() async {
    Api API = Api();
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
      // getPlaces(myLocation.latitude, myLocation.longitude);
    } catch (e) {
      print('==============$e=================');
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Login(false);
      }), (route) => false);
    }
  }

  // getPlaces(latitude, longitude) async {
  //   List<Placemark> places =
  //       await placemarkFromCoordinates(latitude, longitude);
  //   print(places[0].country);
  //   print(places[0].administrativeArea);
  //   print(places[0].locality);
  //   print(places[0].subAdministrativeArea);
  // }

  @override
  void initState() {
    getPos();
    API.apiOrders.forEach((element) {
      print(element.createTime);
    });
  }

  Api API = Api();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width / 3,
      drawer: CustomAwesomeDrawer(context, myLocation, API.apiOrders),
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Get.offAll(
                    MainDashboard(widget.name, widget.password, widget.phone));
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
              icon: const Icon(
                CupertinoIcons.rectangle_arrow_up_right_arrow_down_left_slash,
              )),
        ],
        title: ListTile(
          title: Text(
            '${preferences.getString('name')}',
            style: TextStyle(color: Get.theme.backgroundColor),
          ),
          leading: Text('delivery man'),
        ),
      ),
      body: Center(
          child: Stack(
        children: [
          ttt
              ? FutureBuilder<List<Order>?>(
                  future: API.getMainOrders(myLocation, context, ''),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        !snapshot.hasError &&
                        snapshot.connectionState == ConnectionState.done) {
                      List<Marker> marks = [];
                      if (done) {
                        for (Order order in snapshot.data!) {
                          if (order.isRecieved == true) {
                            marks.add(order.marker!);
                          }
                        }
                      } else if (wait) {
                        for (Order order in snapshot.data!) {
                          if (order.isWaiting == true) {
                            marks.add(order.marker!);
                          }
                        }
                      } else if (withD) {
                        for (Order order in snapshot.data!) {
                          if (order.isWaiting == false &&
                              order.isRecieved == false) {
                            marks.add(order.marker!);
                          }
                        }
                      } else {
                        for (Order order in snapshot.data!) {
                          marks.add(order.marker!);
                        }
                      }

                      return GoogleMap(
                        mapType: MapType.terrain,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        markers: Set.of(marks),
                        initialCameraPosition: CameraPosition(
                          target:
                              LatLng(myLocation.latitude, myLocation.longitude),
                          zoom: 12,
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                )
              : Container(child: CircularProgressIndicator()),
          Positioned(
            top: 55,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          all = true;
                          wait = false;
                          done = false;
                          withD = false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'ALL',
                        style: TextStyle(
                          color: !all
                              ? Get.theme.backgroundColor
                              : Get.theme.primaryColor,
                        ),
                      ),
                      color: all
                          ? Get.theme.backgroundColor
                          : Get.theme.primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          all = false;
                          wait = false;
                          done = true;
                          withD = false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'DONE',
                        style: TextStyle(
                          color: !done
                              ? Get.theme.backgroundColor
                              : Get.theme.primaryColor,
                        ),
                      ),
                      color: done
                          ? Get.theme.backgroundColor
                          : Get.theme.primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          all = false;
                          wait = true;
                          done = false;
                          withD = false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'NEW',
                        style: TextStyle(
                          color: !wait
                              ? Get.theme.backgroundColor
                              : Get.theme.primaryColor,
                        ),
                      ),
                      color: wait
                          ? Get.theme.backgroundColor
                          : Get.theme.primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      RotatedBox(
                        quarterTurns: 1,
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              all = false;
                              wait = false;
                              done = false;
                              withD = true;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Text(
                            'with delivery',
                            style: TextStyle(
                              color: !withD
                                  ? Get.theme.backgroundColor
                                  : Get.theme.primaryColor,
                            ),
                          ),
                          color: withD
                              ? Get.theme.backgroundColor
                              : Get.theme.primaryColor,
                        ),
                      ),
                      Positioned(
                        bottom: -2,
                        right: 0,
                        left: 0,
                        child: Container(
                            child: LinearProgressIndicator(
                                backgroundColor: !withD
                                    ? Get.theme.primaryColor
                                    : Get.theme.backgroundColor,
                                color: Colors.lightGreenAccent),
                            color: !withD
                                ? Get.theme.primaryColor
                                : Get.theme.backgroundColor,
                            margin: EdgeInsets.all(11)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}

Completer<GoogleMapController> _controller = Completer();

Future<void> _goToTheLake(lat, long) async {
  final GoogleMapController controller = await _controller.future;
  controller.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(
      target: LatLng(lat, long),
      zoom: 13,
    ),
  ));
}
