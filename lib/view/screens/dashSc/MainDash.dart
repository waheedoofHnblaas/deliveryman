import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_map/model/oop/Order.dart';
import 'package:google_map/main.dart';
import 'package:google_map/view/conmponent/customDrawer.dart';
import 'package:google_map/view/conmponent/sortBtn.dart';
import 'package:google_map/view/screens/authSc/Login_screen.dart';
import 'package:google_map/view/screens/person_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../model/database/google_map_api.dart';

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
bool showList = false;

Api API = Api();

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
    super.initState();
    getPos();

  }



  @override
  Widget build(BuildContext context) {
    List<Widget> wid = [
      Stack(
        children: [
          ttt
              ? Center(
                  child: FutureBuilder<List<Order>?>(
                    future: Api.getMainOrders(
                      myLocation,
                      context,
                    ),
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
                            target: LatLng(
                                myLocation.latitude, myLocation.longitude),
                            zoom: 12,
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                )
              : Center(child: CircularProgressIndicator()),
          Positioned(
            top: 55,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SortBtn(
                  'ALL',
                  !all? Get.theme.backgroundColor : Get.theme.primaryColor,
                  all? Get.theme.backgroundColor : Get.theme.primaryColor,
                  () {
                    setState(() {
                      all = true;
                      wait = false;
                      done = false;
                      withD = false;
                    });
                  },
                ),
                SortBtn(
                  'NEW',
                  !wait ? Get.theme.backgroundColor : Get.theme.primaryColor,
                  wait ? Get.theme.backgroundColor : Get.theme.primaryColor,
                  () {
                    setState(() {
                      all = false;
                      wait = true;
                      done = false;
                      withD = false;
                    });
                  },
                ),
                SortBtn(
                  'DONE',
                  !done ? Get.theme.backgroundColor : Get.theme.primaryColor,
                  done ? Get.theme.backgroundColor : Get.theme.primaryColor,
                  () {
                    setState(() {
                      all = false;
                      wait = false;
                      done = true;
                      withD = false;
                    });
                  },
                ),
                SortBtn(
                  'with delivery',
                  !withD ? Get.theme.backgroundColor : Get.theme.primaryColor,
                  withD ? Get.theme.backgroundColor : Get.theme.primaryColor,
                  () {
                    setState(() {
                      all = false;
                      wait = false;
                      done = false;
                      withD = true;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),


      CustomAwesomeDrawer(
        context,
        myLocation,
      )
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width / 3,
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
          leading: Text('delivery :',style: Get.textTheme.subtitle1,),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            wid[0],
            showList ? wid[1] : Container(),
            Positioned(
              left: MediaQuery.of(context).size.width / 3,
              right: MediaQuery.of(context).size.width / 3,
              bottom: 30,
              height: 60,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      showList = true;
                    });
                  },
                  child: Card(
                    color: showList
                        ? Get.theme.primaryColor
                        : Get.theme.backgroundColor,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(22)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Text(
                        'List',
                        style: TextStyle(
                          color: !showList
                              ? Get.theme.primaryColor
                              : Get.theme.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      showList = false;
                    });
                  },
                  child: Card(
                    color: !showList
                        ? Get.theme.primaryColor
                        : Get.theme.backgroundColor,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(22)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Text(
                        'Map',
                        style: TextStyle(
                          color: showList
                              ? Get.theme.primaryColor
                              : Get.theme.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
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
