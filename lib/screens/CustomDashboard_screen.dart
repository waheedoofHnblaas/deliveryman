import 'dart:async';
import 'dart:ffi';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/Order.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/conmponent/OrderCard_component.dart';
import 'package:google_map/custom.dart';
import 'package:google_map/google_map_api.dart';
import 'package:google_map/screens/EmpDashboard.dart';
import 'package:google_map/screens/Login_screen.dart';
import 'package:google_map/screens/addScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomDashboard extends StatefulWidget {
  const CustomDashboard({Key? key}) : super(key: key);

  @override
  State<CustomDashboard> createState() => _DashboardState();
}


bool choose = false;
bool sure = false;
List<Marker> chooseMarker = [Marker(markerId: MarkerId('896678697869788'))];

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
    } catch (e) {
      print('==============$e=================');
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Login(false);
      }), (route) => false);
    }
  }

  getPlaces(latitude, longitude) async {
    List<Placemark> places =
        await placemarkFromCoordinates(latitude, longitude);
    print(places[0].country);
    print(places[0].administrativeArea);
    print(places[0].locality);
    print(places[0].subAdministrativeArea);
  }

  @override
  void initState() {
    // TODO: implement initState

    getPos();
  }

  GoogleMapController? _googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('my orders map'),
        actions: [

        ],
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () {

          },
          child: const Icon(Icons.add,color: Colors.black,)),
      backgroundColor: Colors.white,
      body: Center(
        child: ttt
            ? SafeArea(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 11,

              ),
            )
            : CustomeCircularProgress(context),
      ),
    );
  }
}
