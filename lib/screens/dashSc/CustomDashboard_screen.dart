import 'dart:async';
import 'dart:ffi';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_map/conmponent/customAwesome.dart';
import 'package:google_map/oop/Item.dart';
import 'package:google_map/oop/Order.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/database/google_map_api.dart';
import 'package:google_map/main.dart';
import 'package:google_map/screens/authSc/Login_screen.dart';
import 'package:google_map/screens/authSc/Register_screen.dart';
import 'package:google_map/screens/addScreen.dart';
import 'package:google_map/screens/person_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../database/google_map_api.dart';

class CustomDashboard extends StatefulWidget {
  CustomDashboard(String this.name, String this.password, String this.phone);

  late String name, phone, password;

  @override
  State<CustomDashboard> createState() => _DashboardState();
}

bool ttt = false;
Position myLocationCust = Position(
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
      myLocationCust = await API.getMyLocation();
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
    await Api.getMyOrders(myLocationCust, context);
  }

  @override
  void initState() {
    getPos();
  }

  GoogleMapController? _googleMapController;

  List<Order> orders = [];
  bool haveOrder = false;
  late Order _order;
  late List<Item> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        elevation: 0,
        title: Text('${preferences.getString('name')} orders map'),
        actions: [
          IconButton(
              onPressed: () {
                Get.offAll(
                  CustomDashboard(widget.name, widget.password, widget.phone),
                );
              },
              icon: Icon(CupertinoIcons.refresh)),
          IconButton(
              onPressed: () {
                preferences.clear();
                Get.offAll(PersonalScreen());
              },
              icon: const Icon(CupertinoIcons
                  .rectangle_arrow_up_right_arrow_down_left_slash)),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Get.theme.primaryColor,
          foregroundColor: Get.theme.backgroundColor,
          onPressed: () async {
            CustomeCircularProgress(context);
            try {
              Api.apiOrders.forEach(
                (element) {
                  if (element.ownerId == preferences.getString('id')) {
                    print(element.ownerId);
                    if (element.isWaiting!) {
                      print(element.isRecieved);
                      print('============================');
                      setState(() {
                        haveOrder = true;
                        _order = element;
                      });
                    }
                  }
                },
              );
              if (!haveOrder) {
                list = await Api.getorderItems('all');
                Get.back();
                Get.to(
                  AddScreen(
                    LatLng(myLocationCust.latitude, myLocationCust.longitude),
                    list,
                  ),
                );
              } else {
                Navigator.pop(context);

                AwesomeDialog(
                    context: context,
                    btnOkText: 'open',
                    btnOkOnPress: () {},
                    btnCancelText: 'delete',
                    body: Text('you have order active'),
                    btnCancelOnPress: () async {
                      CustomeCircularProgress(context);

                      await Api.deleteOrder(_order.orderId.toString())
                          .then((value) async {
                        list = await Api.getorderItems('all');

                        if (value == 'success') {
                          Get.to(
                            AddScreen(
                                LatLng(myLocationCust.latitude,
                                    myLocationCust.longitude),
                                list),
                          );
                        } else {
                          Get.back();
                          CustomAwesomeDialog(
                              context: context,
                              content: 'error with connection',
                              onOkTap: () {
                                Get.offAll(
                                  CustomDashboard(
                                    widget.name,
                                    widget.password,
                                    widget.phone,
                                  ),
                                );
                              });
                        }
                      });
                    }).show();
              }
            } catch (e) {
              Get.back();
              CustomAwesomeDialog(context: context, content: '$e');
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
                future: Api.getMyOrders(myLocationCust, context),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      !snapshot.hasError &&
                      snapshot.connectionState == ConnectionState.done) {
                    List<Marker> marks = [];
                    for (Order order in snapshot.data!) {
                      if (order.ownerId == preferences.get('id').toString())
                        marks.add(order.marker!);
                    }

                    return Stack(
                      children: [
                        GoogleMap(
                          markers: Set.of(marks),
                          initialCameraPosition: CameraPosition(
                            target: LatLng(myLocationCust.latitude,
                                myLocationCust.longitude),
                            zoom: 11.5,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
