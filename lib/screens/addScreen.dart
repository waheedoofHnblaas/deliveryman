import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/Order.dart';
import 'package:google_map/conmponent/CustomTextField.dart';
import 'package:google_map/custom.dart';
import 'package:google_map/google_map_api.dart';
import 'package:google_map/screens/CustomDashboard_screen.dart';
import 'package:google_map/screens/Dashboard_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddScreen extends StatefulWidget {
  AddScreen(this.latLng);

  late LatLng latLng;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

String lat = '', long = '', id = '';

class _AddScreenState extends State<AddScreen> {
  var items = [
    '',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10',
    'Item 11',
    'Item 12',
    'Item 13',
  ];

  var choose1 = 'Item 1';
  var choose2 = 'Item 2';
  var choose3 = 'Item 3';

  @override
  void initState() {
    id = Random().nextInt(999999).toString();
    setState(() {
      lat = widget.latLng.latitude.toString();
      long = widget.latLng.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: GoogleMap(
                  onTap: (latlong) {
                    setState(() {
                      lat = latlong.latitude.toString();
                      long = latlong.longitude.toString();
                    });
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: lat != ''
                      ? {
                          Marker(
                              infoWindow:
                                  InfoWindow(title: 'your new order location'),
                              visible: true,
                              markerId: MarkerId(id),
                              position:
                                  LatLng(double.parse(lat), double.parse(long)))
                        }
                      : {},
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: widget.latLng,
                    zoom: 12.5,
                  ),
                ),
              ),
              // ListTile(
              //   title: Center(child: Text('department')),
              //   subtitle: Center(
              //     child: DropdownButton(
              //       isExpanded: true,
              //       value: choose,
              //       items: items.map((String items) {
              //         return DropdownMenuItem(
              //           value: items,
              //           child: Text(items),
              //         );
              //       }).toList(),
              //       onChanged: (val) {
              //         setState(() {
              //           choose = val.toString();
              //         });
              //       },
              //     ),
              //   ),
              // ),
              ListTile(
                subtitle: Center(
                  child: DropdownButton(
                    isExpanded: true,
                    value: choose1,
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        alignment: Alignment.center,
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        choose1 = val.toString();
                      });
                    },
                  ),
                ),
              ),
              ListTile(
                subtitle: Center(
                  child: DropdownButton(

                    isExpanded: true,
                    value: choose2,
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        alignment: Alignment.center,
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        choose2 = val.toString();
                      });
                    },
                  ),
                ),
              ),
              ListTile(
                subtitle: Center(
                  child: DropdownButton(
                    isExpanded: true,
                    value: choose3,
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        alignment: Alignment.center,
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        choose3 = val.toString();
                      });
                    },
                  ),
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: OutlineButton(
                  color: Colors.green,
                  onPressed: () {
                    Api.orders.add(
                      Order(
                        deliveryUserNum: '',
                        received: false,
                        orderTime: DateTime.now(),
                        marker: Marker(
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed,
                          ),
                          markerId: MarkerId(id),
                          infoWindow:
                              InfoWindow(title: '$choose1 $choose2 $choose3'),
                          position: lat == ''
                              ? LatLng(
                                  widget.latLng.latitude,
                                  widget.latLng.longitude,
                                )
                              : LatLng(double.parse(lat), double.parse(long)),
                        ),
                        ownerUserNum: myUser.userNumber,
                        items: '$choose1-$choose3-$choose2',
                        isWaitting: true,
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: const Text('sure'),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
