import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/conmponent/CustomItemCard.dart';
import 'package:google_map/conmponent/customAwesome.dart';
import 'package:google_map/oop/Item.dart';
import 'package:google_map/oop/Order.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/conmponent/CustomTextField.dart';
import 'package:google_map/oop/custom.dart';
import 'package:google_map/database/api.dart';
import 'package:google_map/database/api_links.dart';
import 'package:google_map/database/google_map_api.dart';
import 'package:google_map/main.dart';
import 'package:google_map/screens/dashSc/CustomDashboard_screen.dart';
import 'package:google_map/screens/authSc/Login_screen.dart';
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
  Api API = Api();

  List<Item> _listitems = [];

  addOrder() async {
    CustomeCircularProgress(context);

    try {
      var response = await _api.postRequest(
        addorederLink,
        {
          'owner_id': preferences.get('id').toString(),
          'delivery_id': '0',
          'isWaiting': '1',
          'isRecieved': '0',
          'getDelTime': '0',
          'doneCustTime': '0',
          'totalPrice': '0',
          'lat': lat,
          'long': long,
          'createTime':
              '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}'
                  '  ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
        },
      );

      print('add failed ${response['orderId']}');
      if (response['status'] == 'success') {
        _listitems.forEach((element) async {
          await addOrderItem(
            lastOrderId: response['orderId'],
            itemCount: element.count.toString(),
            itemId: element.itemId.toString(),
          );
        });
      } else {
        print('add failed ${response['status']}');
      }
    } catch (e) {
      print(e);
    }
  }

  addOrderItem(
      {required String lastOrderId,
      required String itemId,
      required String itemCount}) async {
    try {
      var response = await _api.postRequest(
        addItemsOrderLink,
        {
          'order_id': lastOrderId,
          'item_id': itemId,
          'countItem': itemCount,
        },
      );

      print('add failed ${response['orderId']}');
      Navigator.pop(context);
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

  // getPlaces(latitude, longitude) async {
  //   List<Placemark> places =
  //       await placemarkFromCoordinates(latitude, longitude);
  //   print(places[0].country);
  //   print(places[0].administrativeArea);
  //   print(places[0].locality);
  //   print(places[0].subAdministrativeArea);
  //   print('lat :$lat   long: $long');
  // }

  // String grtItemById(String id) {
  //   String item = '';
  //   widget.getorderItems.forEach((element) {
  //     if (element.itemId! == id) {
  //       item = element.name!;
  //     }
  //   });
  //   return item;
  // }

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
                    mapToolbarEnabled: true,
                    onMapCreated: (val) {
                      print(val);
                    },
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
                        CustomAwesomeDialog(
                            context: context, content: 'out of our map');
                      }
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: lat != ''
                        ? {
                            Marker(
                                infoWindow: InfoWindow(
                                    title: 'your new order location'),
                                visible: true,
                                markerId: MarkerId(id),
                                position: LatLng(
                                    double.parse(lat), double.parse(long)))
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
                          child: Text('dkdk'),
                        ),
                        color: Colors.amber,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('dkdk'),
                        ),
                        color: Colors.amber,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('dkdk'),
                        ),
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 5,
              height: 300,
              child: FutureBuilder<List<Item>>(
                  initialData: widget.getorderItems,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        !snapshot.hasError &&
                        ConnectionState.waiting != snapshot.connectionState) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: ((context, index) {
                            return InkWell(
                              onTap: () async {
                                AwesomeDialog(
                                        context: context,
                                        body: Column(
                                          children: [
                                            Text(
                                              'count of :${snapshot.data![index].name}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children:
                                                      List.generate(10, (i) {
                                                    return InkWell(
                                                      onTap: () {
                                                        if (i > 0) {
                                                          _listitems.remove(
                                                              snapshot.data![
                                                                  index]);
                                                          snapshot.data![index]
                                                                  .count =
                                                              (i).toString();
                                                          _listitems.add(
                                                              snapshot.data![
                                                                  index]);
                                                        } else {
                                                          snapshot.data![index]
                                                              .count = '';
                                                          _listitems.remove(
                                                              snapshot.data![
                                                                  index]);
                                                        }

                                                        setState(() {});
                                                        print(
                                                            _listitems.length);
                                                        _listitems
                                                            .forEach((element) {
                                                          print(element.name! +
                                                              ' :====== ' +
                                                              element.count!);
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Card(
                                                        color: Colors.green,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: Text(
                                                            i >= 0
                                                                ? '${i}'
                                                                : 'X',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        dialogType: DialogType.NO_HEADER)
                                    .show();
                              },
                              child: CustomItemCard(context, snapshot, index,
                                  Container(), snapshot.data![index].count),
                            );
                          }));
                    } else {
                      return LinearProgressIndicator();
                    }
                  }),
            ),
            // !(itemId[0] == '' || itemId[1] == '' || itemId[2] == '')
            //     ?
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: OutlineButton(
                color: Colors.green,
                onPressed: () async {
                  if ((36.2395093776424 > double.parse(lat) &&
                          double.parse(lat) > 36.16330528868279) &&
                      (37.08518844097853 < double.parse(long) &&
                          double.parse(long) < 37.20690105110407)) {
                    if (_listitems.length == 0) {
                      CustomAwesomeDialog(
                          context: context, content: 'no item selected');
                    } else {
                      await addOrder();
                    }
                  } else {
                    CustomAwesomeDialog(
                        context: context, content: 'out of our map');
                  }
                },
                child: const Text('sure'),
              ),
            )
            // : Text(
            //     'choose three items',
            //     style: TextStyle(color: Colors.red),
            //   ),
          ],
        ),
      ),
    );
  }
}
