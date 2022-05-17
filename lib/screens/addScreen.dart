import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/Order.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/conmponent/CustomTextField.dart';
import 'package:google_map/custom.dart';
import 'package:google_map/database/api.dart';
import 'package:google_map/database/api_links.dart';
import 'package:google_map/google_map_api.dart';
import 'package:google_map/main.dart';
import 'package:google_map/screens/CustomDashboard_screen.dart';
import 'package:google_map/screens/Login_screen.dart';
import 'package:google_map/screens/person_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddScreen extends StatefulWidget {
  AddScreen(this.latLng);

  late LatLng latLng;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String lat = '', long = '', id = '';
  final PhpApi _api = PhpApi();

  Api API = Api();

  addOrder() async {
    Position myLocation = await API.getMyLocation();
    try {
      API.apiOrders.forEach(
        (element) {
          if (element.ownerUserNum == preferences.getString('id')) {
            print(element.ownerUserNum);
            if (!element.received) {
              print(element.received);
              print('============================');

              throw '';
            }
          }
        },
      );


    } catch (e) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return CustomDashboard(
            preferences.getString('name')!,
            preferences.getString('password')!,
            preferences.getString('phone')!);
      }), (route) => false);
    }

    try {
      var response = await _api.postRequest(
        addorederLink,
        {
          'owner_id': preferences.get('id').toString(),
          'delivery_id': '0',
          'isWaiting': '1',
          'isRecieved': '0',
          'lat': lat,
          'long': long,
          'createTime':
              '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}'
                  '  ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
          'item_id': '3',
          'item_id2': '3',
          'item_id3': '3',
        },
      );
      if (response['status'] == 'success') {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return CustomDashboard(
              preferences.get('name').toString(),
              preferences.get('password').toString(),
              preferences.get('phone').toString(),
            );
          },
        ), (route) => false);
      } else {
        print('add failed ${response['status']}');
      }
    } catch (e) {
      print(e);
    }
  }

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
                  onPressed: () async {
                    CustomeCircularProgress(context);

                    await addOrder();
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
