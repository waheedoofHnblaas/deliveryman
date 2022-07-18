import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_map/model/oop/Item.dart';
import 'package:google_map/model/oop/Order.dart';
import 'package:google_map/main.dart';
import 'package:google_map/view/conmponent/CustomCirProgress.dart';
import 'package:google_map/view/conmponent/customAwesome.dart';
import 'package:google_map/view/screens/addScreen.dart';
import 'package:google_map/view/screens/authSc/Login_screen.dart';
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
  bool all = false, wait = true, done = false, withD = false;
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
        title: ListTile(

          title: Text(
            '${widget.name}',
            style: TextStyle(color: Get.theme.backgroundColor),
          ),
          trailing: Text(
            '${widget.phone}',
            style: TextStyle(color: Get.theme.backgroundColor),
          ),
        ),
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

                      await API.deleteOrder(_order.orderId.toString())
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
          child:  Icon(
            Icons.add,
            color: Get.theme.backgroundColor
          )),
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: [
            ttt
                ? FutureBuilder<List<Order>>(
                    future: Api.getMyOrders(myLocationCust, context),
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

                        return Stack(
                          children: [
                            GoogleMap(myLocationEnabled: true,myLocationButtonEnabled: true,
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
                        shape:  RoundedRectangleBorder(
                          borderRadius:  BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          'ALL',
                          style: TextStyle(
                            color: !all
                                ? Get.theme.backgroundColor
                                : Get.theme.primaryColor,
                          ),
                        ),
                        color:
                        all ? Get.theme.backgroundColor : Get.theme.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
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
                        shape:  RoundedRectangleBorder(
                          borderRadius:  BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          'DONE',
                          style: TextStyle(
                            color: !done
                                ? Get.theme.backgroundColor
                                : Get.theme.primaryColor,
                          ),
                        ),
                        color:
                        done ? Get.theme.backgroundColor : Get.theme.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
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
                        shape:  RoundedRectangleBorder(
                          borderRadius:  BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          'WAIT',
                          style: TextStyle(
                            color: !wait
                                ? Get.theme.backgroundColor
                                : Get.theme.primaryColor,
                          ),
                        ),
                        color:
                        wait ? Get.theme.backgroundColor : Get.theme.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
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
                            shape:   RoundedRectangleBorder(
                              borderRadius:  BorderRadius.circular(30.0),
                            ),
                            child: Text(
                              'with delivery',
                              style: TextStyle(
                                color: !withD
                                    ? Get.theme.backgroundColor
                                    : Get.theme.primaryColor,
                              ),
                            ),
                            color:
                            withD ? Get.theme.backgroundColor : Get.theme.primaryColor,
                          ),
                        ),

                        Positioned(
                          bottom: -2 ,
                          right: 0,left: 0,
                          child: Container(child:LinearProgressIndicator(backgroundColor: !withD
                              ? Get.theme.primaryColor
                              : Get.theme.backgroundColor,color: Colors.lightGreenAccent),color: !withD
                              ? Get.theme.primaryColor
                              : Get.theme.backgroundColor,margin: EdgeInsets.all(11)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
