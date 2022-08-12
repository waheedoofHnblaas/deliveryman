import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_map/model/database/api.dart';
import 'package:google_map/model/database/api_links.dart';
import 'package:google_map/model/oop/Item.dart';
import 'package:google_map/model/oop/Order.dart';
import 'package:google_map/main.dart';
import 'package:google_map/view/conmponent/CustomCirProgress.dart';
import 'package:google_map/view/conmponent/customAwesome.dart';
import 'package:google_map/view/screens/addScreen.dart';
import 'package:google_map/view/screens/authSc/Login_screen.dart';
import 'package:google_map/view/screens/dashSc/MainDash.dart';
import 'package:google_map/view/screens/person_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../model/database/google_map_api.dart';

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
Api API = Api();

class _DashboardState extends State<CustomDashboard> {
  Api API = Api();
  bool all = true, wait = false, done = false, withD = false;
  final PhpApi _phpapi = PhpApi();

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
  }

  // addItem(String itemName,String itemQuant,) async {
  //   CustomeCircularProgress(context);
  //   try {
  //     var response = await _phpapi.postRequest(
  //       addItemLink,
  //       {
  //         'name': itemName,
  //         'quant': itemQuant,
  //         // 'price': widget.price,
  //         // 'type': widget.type,
  //         // 'weight': widget.weight,
  //         // 'info': widget.info,
  //       },
  //     );
  //
  //     Get.back();
  //     if (response['status'] == 'item is here') {
  //       CustomAwesomeDialog(context: context, content: 'item is her');
  //     } else if (response['status'] == 'success') {
  //       CustomAwesomeDialog(context: context,title: '', content: 'your order has deleted');
  //     } else {
  //       CustomAwesomeDialog(
  //           context: context, content: 'network connection less');
  //     }
  //   } catch (e) {
  //     CustomAwesomeDialog(context: context, content: 'network error');
  //     print(e);
  //   }
  // }
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
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                elevation: 0,
                onPressed: () {
                  setState(() {
                    all = true;
                    wait = false;
                    done = false;
                    withD = false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: Text(
                  'ALL',
                  style: TextStyle(
                      color: !all
                          ? Get.theme.backgroundColor
                          : Get.theme.primaryColor,
                      fontSize: 12),
                ),
                color: all ? Get.theme.backgroundColor : Get.theme.primaryColor,
              ),
              RaisedButton(
                elevation: 0,
                onPressed: () {
                  setState(() {
                    all = false;
                    wait = false;
                    done = true;
                    withD = false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: Text(
                  'DONE',
                  style: TextStyle(
                    color: !done
                        ? Get.theme.backgroundColor
                        : Get.theme.primaryColor,
                    fontSize: 12,
                  ),
                ),
                color:
                    done ? Get.theme.backgroundColor : Get.theme.primaryColor,
              ),
              RaisedButton(
                elevation: 0,
                onPressed: () {
                  setState(() {
                    all = false;
                    wait = true;
                    done = false;
                    withD = false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: Text(
                  'WAIT',
                  style: TextStyle(
                    color: !wait
                        ? Get.theme.backgroundColor
                        : Get.theme.primaryColor,
                    fontSize: 12,
                  ),
                ),
                color:
                    wait ? Get.theme.backgroundColor : Get.theme.primaryColor,
              ),
              Expanded(
                child: Stack(
                  children: [
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          all = false;
                          wait = false;
                          done = false;
                          withD = true;
                        });
                      },
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      child: Text(
                        'with delivery',
                        style: TextStyle(
                          color: !withD
                              ? Get.theme.backgroundColor
                              : Get.theme.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                      color: withD
                          ? Get.theme.backgroundColor
                          : Get.theme.primaryColor,
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
              ),
            ],
          )),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: Get.theme.backgroundColor,
                width: 1,
                style: BorderStyle.solid)),
        child: FloatingActionButton(
          backgroundColor: Get.theme.primaryColor,
          foregroundColor: Get.theme.backgroundColor,
          onPressed: () async {
            CustomeCircularProgress(context);
            try {
              List<Order> _apiOrders = await Api.getMyOrders(
                  myLocation, context, preferences.getString('id')!);
              _apiOrders.forEach(
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
                list = await API.getorderItems('all');
                Get.back();
                Get.to(
                  AddScreen(
                    LatLng(myLocationCust.latitude, myLocationCust.longitude),
                    list,
                  ),
                );
              } else {
                Navigator.pop(context);
                CustomAwesomeDialog(
                    context: context,
                    content: 'you have active order',title: 'delete',
                    onOkTap: () async {

                      await API
                          .deleteOrder(_order.orderId.toString())
                          .then((value) async {
                        list = await API.getorderItems('all');

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
                                setState(() {

                                });
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
                    },
                );
              }
            } catch (e) {
              Get.back();
              CustomAwesomeDialog(context: context, content: '$e');
            }
          },
          child: Icon(Icons.add, color: Get.theme.backgroundColor, size: 33),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Container(
              height: Get.height * 0.85,
              child: ttt
                  ? FutureBuilder<List<Order>>(
                      future: Api.getMyOrders(myLocationCust, context,
                          preferences.getString('id')!),
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
                            zoomControlsEnabled: false,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            markers: Set.of(marks),
                            initialCameraPosition: CameraPosition(
                              target: LatLng(myLocationCust.latitude,
                                  myLocationCust.longitude),
                              zoom: 11.5,
                            ),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    )
                  : Center(child: const CircularProgressIndicator()),
            ),
            Expanded(
              child: Container(
                color: Get.theme.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(
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
                              color: Get.theme.backgroundColor, fontSize: 12),
                        ),
                        Text(
                          widget.phone,
                          style: TextStyle(
                              color: Get.theme.backgroundColor, fontSize: 12),
                        ),
                      ],
                    )),
                    const SizedBox(
                      width: 55,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: Icon(
                          CupertinoIcons.refresh,
                          color: Get.theme.backgroundColor,
                        )),
                    IconButton(
                        onPressed: () {
                          CustomAwesomeDialog(
                              context: context,
                              content: 'do you want logout',
                              onOkTap: () {
                                preferences.clear();
                                Get.offAll(const PersonalScreen());
                              });
                        },
                        icon: Icon(
                          CupertinoIcons
                              .rectangle_arrow_up_right_arrow_down_left_slash,
                          color: Get.theme.backgroundColor,
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
