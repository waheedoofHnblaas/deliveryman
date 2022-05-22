import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
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

class _EmpDashboardState extends State<MainDashboard> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width / 3,
      drawer: CustomAwesomeDrawer(context, myLocation),
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
              icon: const Icon(CupertinoIcons
                  .rectangle_arrow_up_right_arrow_down_left_slash)),
        ],
        title: Text('Orders EMP: ${preferences.getString('name')}'),
      ),
      body: Center(
        child: ttt
            ? FutureBuilder<List<Order>>(
                future: API.getMainOrders(myLocation, context),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      !snapshot.hasError &&
                      snapshot.connectionState == ConnectionState.done) {
                    List<Marker> marks = [];
                    for (Order order in snapshot.data!) {
                      marks.add(order.marker!);
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
            : CircularProgressIndicator(),
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
