import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DataScreen extends StatefulWidget {
  DataScreen(this.latlong, this.marker);

  late CameraPosition latlong;
  late Marker marker;

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
              initialCameraPosition: widget.latlong,
              markers: {widget.marker},
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
