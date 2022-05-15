import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/Order.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/conmponent/OrderCard_component.dart';
import 'package:google_map/google_map_api.dart';
import 'package:google_map/screens/CustomDashboard_screen.dart';
import 'package:google_map/screens/Login_screen.dart';
import 'package:google_map/screens/addScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EmpDashboard extends StatefulWidget {
  const EmpDashboard({Key? key}) : super(key: key);

  @override
  State<EmpDashboard> createState() => _EmpDashboardState();
}

bool choose = false;
List<Marker> chooseMarker = [Marker(markerId: MarkerId(''))];

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

class _EmpDashboardState extends State<EmpDashboard> {
  Future<void> getPos() async {
    try {
      LocationPermission per = await Geolocator.checkPermission();
      if (per == LocationPermission.denied) {
        per = await Geolocator.requestPermission();
        if (per != LocationPermission.always) {}
      }
      myLocation = await Api.getMyLocation();
      setState(() {
        ttt = true;
      });
      // getPlaces(myLocation.latitude, myLocation.longitude);
    } catch (e) {
      print('==============$e=================');
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Login(true);
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
    // TODO: implement initState

    getPos();
  }

  GoogleMapController? _googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width / 3,
      // drawer: Drawer(
      //   child: SafeArea(
      //     child: ,
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return CustomDashboard();
                  }), (route) => false);
                },
                icon: Icon(
                  Icons.next_plan_outlined,
                )),
          ),
        ],
        title: Text('Orders'),
      ),
      body: Center(
        child: ttt
            ? Stack(
                children: [
                  SafeArea(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 11,
                      child: Text('')
                    ),
                  ),
                  Positioned(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Text('list'),
                                      Icon(Icons.list),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(22),
                                          topRight: Radius.circular(22)),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3,
                                        child: FutureBuilder<List<Order>>(
                                            initialData: const [],
                                            future: Api.getMainOrder(myLocation),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  !snapshot.hasError &&
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                return Text('');
                                              }else {
                                                return const CircularProgressIndicator();
                                              }
                                            }),
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    bottom: 5,
                    left: 5,
                    right: 150,
                  ),
                ],
              )
            : CustomeCircularProgress(context),
      ),
    );
  }
}
