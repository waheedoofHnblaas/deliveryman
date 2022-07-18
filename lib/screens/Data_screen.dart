import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/oop/Order.dart';
import 'package:google_map/screens/dashSc/CustomDashboard_screen.dart';
import 'package:google_map/screens/dashSc/MainDash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DataScreen extends StatefulWidget {
  DataScreen(this._order);

  late CameraPosition latlong;
  late Order _order;

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                zoom: 12,
                target: LatLng(
                  widget._order.marker!.position.latitude,
                  widget._order.marker!.position.longitude,
                ),
              ),
              markers: {
                widget._order.marker!,

                Marker(
                  markerId: const MarkerId('5436536'),
                  position: LatLng(
                    double.parse(widget._order.deliveryLat!),
                    double.parse(widget._order.deliveryLong!),
                  ),
                  infoWindow: const InfoWindow(title: 'your location order'),
                )
              },
              myLocationEnabled: true,
            ),
            Positioned(
              top: 30,
              left: 30,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: IconButton(
                    iconSize: 25,
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
