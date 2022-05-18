import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/Item.dart';
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
  AddScreen(this.latLng, this.getorderItems);

  late LatLng latLng;
  late List<Item> getorderItems;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String lat = '', long = '', id = '';
  final PhpApi _api = PhpApi();

  List<String> itemId = ['', '', ''];
  double countitem1 = 1, countitem3 = 1, countitem2 = 1;
  Api API = Api();

  addOrder() async {
    Position myLocation = await API.getMyLocation();

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
          'item_id': itemId[0],
          'item_id2': itemId[1],
          'item_id3': itemId[2],
          'countItem': countitem1.toString(),
          'countItem2': countitem2.toString(),
          'countItem3': countitem3.toString(),
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

  @override
  void initState() {
    setState(() {
      lat = widget.latLng.latitude.toString();
      long = widget.latLng.longitude.toString();
    });
  }

  getPlaces(latitude, longitude) async {
    List<Placemark> places =
        await placemarkFromCoordinates(latitude, longitude);
    print(places[0].country);
    print(places[0].administrativeArea);
    print(places[0].locality);
    print(places[0].subAdministrativeArea);
    print('lat :$lat   long: $long');
  }

  String grtItemById(String id) {
    String item = '';
    widget.getorderItems.forEach((element) {
      if (element.id.toString() == id) {
        item = element.name;
      }
    });
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add order'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

        Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.8,
              child: GoogleMap(
                onTap: (latlong) async {
                  // 36.2395093776424>lat>36.16330528868279

                  // 37.08518844097853<long<37.20690105110407
                  if ((36.2395093776424 > latlong.latitude &&
                          latlong.latitude > 36.16330528868279) &&
                      (37.08518844097853 < latlong.longitude &&
                          latlong.longitude < 37.20690105110407)) {
                    setState(() {
                      lat = latlong.latitude.toString();
                      long = latlong.longitude.toString();
                    });
                  } else {
                    AwesomeDialog(
                        context: context,
                        body: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('out of our map'),
                        )).show();
                  }

                  getPlaces(latlong.latitude, latlong.longitude);
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
            Positioned(
              top: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(grtItemById(itemId[0])),
                    ),
                    color: Colors.amber,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(grtItemById(itemId[1])),
                    ),
                    color: Colors.amber,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(grtItemById(itemId[2])),
                    ),
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
          ],
        ),
        // ListTile(
        //   title: Center(child: Text('department')),
        //   subtitle: Center(
        //     child: DropdownButton(
        //       isExpanded: true,
        //       value: itemId[0],
        //       items: itemId.map((String items) {
        //         return DropdownMenuItem(
        //           value: items,
        //           child: Text(items),
        //         );
        //       }).toList(),
        //       onChanged: (val) {
        //         setState(() {
        //           itemId[0] = val.toString();
        //         });
        //       },
        //     ),
        //   ),
        // ),

        SizedBox(
          width: MediaQuery.of(context).size.width - 5,
          height: 300,
          child: FutureBuilder<List<Item>>(
              initialData: widget.getorderItems,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    ConnectionState.waiting != snapshot.connectionState) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 280,
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: ((context, index) {
                              return InkWell(
                                onTap: () async {
                                  await AwesomeDialog(
                                      context: context,
                                      btnOkText: 'add',
                                      dialogType: DialogType.NO_HEADER,
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {
                                        setState(() {});
                                      },
                                      body: Padding(
                                        padding:
                                            const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceAround,
                                          children: [
                                            Text(snapshot
                                                .data![index].name),
                                            Text('info :' +
                                                snapshot
                                                    .data![index].info),
                                            Text('price :' +
                                                snapshot
                                                    .data![index].price
                                                    .toString()),
                                            Text('weight :' +
                                                snapshot
                                                    .data![index].weight
                                                    .toString()),
                                          ],
                                        ),
                                      )).show();
                                },
                                child: Card(
                                  color: itemId.contains(snapshot
                                          .data![index].id
                                          .toString())
                                      ? Colors.lightGreenAccent
                                      : Colors.white70,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (itemId[0] == '') {
                                                itemId[0] = snapshot
                                                    .data![index].id
                                                    .toString();
                                              } else if (itemId[1] ==
                                                  '') {
                                                itemId[1] = snapshot
                                                    .data![index].id
                                                    .toString();
                                              } else if (itemId[2] ==
                                                  '') {
                                                itemId[2] = snapshot
                                                    .data![index].id
                                                    .toString();
                                              } else {}
                                              print(
                                                  '${itemId[0]} ${itemId[1]} ${itemId[2]}');
                                            });
                                          },
                                          icon: Icon(CupertinoIcons.add),
                                          color: Theme.of(context)
                                              .primaryColor,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              200,
                                          child: ListTile(
                                            title: Text(
                                              '${snapshot.data![index].name}   ${snapshot.data![index].id}',
                                            ),
                                            subtitle: Text(
                                              ' price:' +
                                                  snapshot
                                                      .data![index].price
                                                      .toString() +
                                                  '   weight:' +
                                                  snapshot
                                                      .data![index].weight
                                                      .toString(),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              setState(() {
                                                if (itemId[0] ==
                                                    snapshot
                                                        .data![index].id
                                                        .toString()) {
                                                  itemId[0] = '';
                                                } else if (itemId[1] ==
                                                    snapshot
                                                        .data![index].id
                                                        .toString()) {
                                                  itemId[1] = '';
                                                } else if (itemId[2] ==
                                                    snapshot
                                                        .data![index].id
                                                        .toString()) {
                                                  itemId[2] = '';
                                                } else {}
                                                print(
                                                    '${itemId[0]} ${itemId[1]} ${itemId[2]}');
                                              });
                                            });
                                          },
                                          icon:
                                              Icon(CupertinoIcons.minus),
                                          color: Theme.of(context)
                                              .primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })),
                      ),
                    ],
                  );
                } else {
                  return LinearProgressIndicator();
                }
              }),
        ),
        !(itemId[0] == '' || itemId[1] == '' || itemId[2] == '')
            ? SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: OutlineButton(
                  color: Colors.green,
                  onPressed: () async {
                    CustomeCircularProgress(context);

                    await addOrder();
                  },
                  child: const Text('sure'),
                ),
              )
            : Text(
                'choose three items',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
