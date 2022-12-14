import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_map/model/oop/Order.dart';
import 'package:google_map/main.dart';
import 'package:google_map/view/conmponent/customAwesome.dart';
import 'package:google_map/view/conmponent/customDrawer.dart';
import 'package:google_map/view/conmponent/sortBtn.dart';
import 'package:google_map/view/screens/addItemSc.dart';
import 'package:google_map/view/screens/authSc/Login_screen.dart';
import 'package:google_map/view/screens/dashSc/CustomDashboard_screen.dart';
import 'package:google_map/view/screens/person_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  DateTime currentBackPressTime = DateTime(2000, 1, 1, 1, 1, 44);

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    print(now.difference(currentBackPressTime));
    print(currentBackPressTime.year);
    print('=================');
    if (currentBackPressTime.year == 2000 ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'exit ?');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> wid = [
      Stack(
        children: [
          ttt
              ? Container(
                  height: Get.height * 0.9,
                  child: FutureBuilder<List<Order>?>(
                    future: API.getMainOrders(
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
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        ],
      ),
      Container(
        height: Get.height * 0.9,
        child: CustomAwesomeDrawer(
          context,
          myLocation,
        ),
      )
    ];

    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: WillPopScope(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SafeArea(
                child: Container(
                  color: Get.theme.primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SortBtn(
                        'ALL',
                        !all
                            ? Get.theme.backgroundColor
                            : Get.theme.primaryColor,
                        all
                            ? Get.theme.backgroundColor
                            : Get.theme.primaryColor,
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
                        !wait
                            ? Get.theme.backgroundColor
                            : Get.theme.primaryColor,
                        wait
                            ? Get.theme.backgroundColor
                            : Get.theme.primaryColor,
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
                        !done
                            ? Get.theme.backgroundColor
                            : Get.theme.primaryColor,
                        done
                            ? Get.theme.backgroundColor
                            : Get.theme.primaryColor,
                        () {
                          setState(() {
                            all = false;
                            wait = false;
                            done = true;
                            withD = false;
                          });
                        },
                      ),
                      Stack(
                        children: [
                          SortBtn(
                            'delivery',
                            !withD
                                ? Get.theme.backgroundColor
                                : Get.theme.primaryColor,
                            withD
                                ? Get.theme.backgroundColor
                                : Get.theme.primaryColor,
                            () {
                              setState(() {
                                all = false;
                                wait = false;
                                done = false;
                                withD = true;
                              });
                            },
                          ),
                          Positioned(
                            bottom: -2,
                            right: 8,
                            left: 8,
                            child: Container(
                                child: LinearProgressIndicator(
                                    backgroundColor: !withD
                                        ? Get.theme.primaryColor
                                        : Get.theme.backgroundColor,
                                    color: Colors.lightGreenAccent),
                                color: !withD
                                    ? Get.theme.primaryColor
                                    : Get.theme.backgroundColor,
                                margin: EdgeInsets.all(10)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    wid[0],
                    showList ? wid[1] : Container(),
                  ],
                ),
              ),
              Card(
                color: Get.theme.primaryColor.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                                fontSize: 12, color: Get.theme.backgroundColor),
                          ),
                          Text(
                            widget.phone,
                            style: TextStyle(
                                fontSize: 12, color: Get.theme.backgroundColor),
                          ),
                        ],
                      ),
                    ),
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
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(22)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.list,
                            color: !showList
                                ? Get.theme.primaryColor
                                : Get.theme.backgroundColor,
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
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(22)),
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
                    const SizedBox(
                      width: 44,
                    ),
                    IconButton(
                        onPressed: () {
                          CustomAwesomeDialog(
                              context: context,
                              content: 'do you want logout',
                              onOkTap: () {
                                preferences.clear();
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const PersonalScreen();
                                }), (route) => false);
                              });
                        },
                        icon: Icon(
                          CupertinoIcons
                              .rectangle_arrow_up_right_arrow_down_left_slash,
                          color: Get.theme.backgroundColor,
                        )),
                    const SizedBox(width: 22),
                    IconButton(
                        onPressed: () {
                          Get.offAll(MainDashboard(
                              widget.name, widget.password, widget.phone));
                        },
                        icon: Icon(
                          CupertinoIcons.refresh,
                          color: Get.theme.backgroundColor,
                        )),
                    const SizedBox(width: 22),
                    // IconButton(
                    //     onPressed: () async{
                    //     API.BFS(context);
                    //     setState(() {
                    //
                    //     });
                    //     },
                    //     icon: Icon(
                    //       CupertinoIcons.number,
                    //       color: Get.theme.backgroundColor,
                    //     )),
                  ],
                ),
              )
            ],
          )),
          onWillPop: onWillPop),
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
