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

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
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

class _DashboardState extends State<Dashboard> {
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
        return const Login();
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
                      child: FutureBuilder<List<Order>>(
                          initialData: const [],
                          future: Api.getOrders(myLocation),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                !snapshot.hasError &&
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              Set<Marker> markers = {};

                              //  preparing all markers from orders
                              for (Order order in snapshot.data!) {
                                markers.add(
                                  Marker(
                                      markerId:
                                          MarkerId(order.marker.markerId.value),
                                      position: order.marker.position,
                                      infoWindow: order.marker.infoWindow,
                                      icon: order.marker.icon,
                                      onTap: () {
                                        _googleMapController!.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target: LatLng(
                                                  order
                                                      .marker.position.latitude,
                                                  order.marker.position
                                                      .longitude,
                                                ),
                                                zoom: 12),
                                          ),
                                        );

                                        showBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            elevation: 10,
                                            context: context,
                                            builder: (context) {
                                              return SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text('Order data'),
                                                    Text(
                                                      '${Api.getDestanceBetween(
                                                        myLocation.latitude,
                                                        myLocation.longitude,
                                                        order.marker.position
                                                            .latitude,
                                                        order.marker.position
                                                            .longitude,
                                                      ).ceil()} meters',
                                                    ),
                                                    Text(
                                                        '${int.parse(order.orderTime.day.toString()) - int.parse(DateTime.now().day.toString())} day'),
                                                    Text(
                                                      order.items,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                Text('cancel')),
                                                        Column(
                                                          children: [
                                                            OutlineButton(
                                                                onPressed: () {
                                                                  order.isWaitting =
                                                                      false;
                                                                  order.deliveryUserNum = Api
                                                                      .usersList[
                                                                          4]
                                                                      .userNumber;

                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    'I will arrive it')),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            });
                                      }),
                                ); //all markers
                              }

                              for (Order order in snapshot.data!) {
                                if (order.received) {
                                  Marker removedMarker = order.marker;
                                  markers.remove(order.marker);
                                  markers.add(
                                    Marker(
                                      infoWindow: InfoWindow(
                                        title:
                                            '${Api.getDestanceMyLocationToOrder(myLocation, order)} from delivery : ${Api.getMyUserByNumber(order.deliveryUserNum).userName}',
                                        snippet: '${order.items}',
                                      ),
                                      markerId: MarkerId(
                                          removedMarker.markerId.value),
                                      position: removedMarker.position,
                                      rotation: 90,
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueRose,
                                      ),
                                    ),
                                  );
                                } else if (!order.isWaitting) {
                                  Marker removedMarker = order.marker;
                                  markers.remove(order.marker);
                                  markers.add(
                                    Marker(
                                      infoWindow: InfoWindow(
                                        title:
                                        '${Api.getDestanceMyLocationToOrder(myLocation, order).ceil()}m from delivery : ${Api.getMyUserByNumber(order.deliveryUserNum).userName}',
                                        snippet: '${order.items}',
                                      ),
                                      markerId: MarkerId(
                                          removedMarker.markerId.value),
                                      position: removedMarker.position,
                                      rotation: 180,
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueGreen,
                                      ),
                                    ),
                                  );
                                }
                              }

                              return GoogleMap(
                                onMapCreated: (GoogleMapController controller) {
                                  _googleMapController = controller;
                                },
                                // onTap: (latlog) {
                                //   setState(() {
                                //     choose = false;
                                //   });
                                // },
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                markers: choose
                                    ? Set<Marker>.of(chooseMarker)
                                    : markers,
                                mapType: MapType.normal,
                                initialCameraPosition: choose
                                    ? CameraPosition(
                                        target: LatLng(
                                          chooseMarker[0].position.latitude,
                                          chooseMarker[0].position.longitude,
                                        ),
                                        zoom: 13,
                                      )
                                    : const CameraPosition(
                                        target: LatLng(36.2, 37.15),
                                        zoom: 10,
                                      ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }),
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
                                            future: Api.getOrders(myLocation),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  !snapshot.hasError &&
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                return SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: List.generate(
                                                          snapshot.data!.length,
                                                          (index) {
                                                        return Column(
                                                          children: [
                                                            Text(
                                                              snapshot
                                                                  .data![index]
                                                                  .orderTime
                                                                  .toString(),
                                                            ),
                                                            CardOrder_component(
                                                              'deliv',
                                                              () {
                                                                if (chooseMarker[
                                                                            0]
                                                                        .markerId
                                                                        .value !=
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .marker
                                                                        .markerId
                                                                        .value) {
                                                                  choose = true;
                                                                } else {
                                                                  choose =
                                                                      !choose;
                                                                }

                                                                chooseMarker[
                                                                        0] =
                                                                    (Marker(
                                                                        markerId:
                                                                            MarkerId(
                                                                          snapshot
                                                                              .data![index]
                                                                              .marker
                                                                              .markerId
                                                                              .value,
                                                                        ),
                                                                        position: snapshot
                                                                            .data![
                                                                                index]
                                                                            .marker
                                                                            .position,
                                                                        icon: snapshot.data![index].isWaitting
                                                                            ? BitmapDescriptor.defaultMarker
                                                                            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)));

                                                                if (choose) {
                                                                  _googleMapController!
                                                                      .animateCamera(
                                                                    CameraUpdate
                                                                        .newCameraPosition(
                                                                      CameraPosition(
                                                                          target:
                                                                              LatLng(
                                                                            chooseMarker[0].position.latitude,
                                                                            chooseMarker[0].position.longitude,
                                                                          ),
                                                                          zoom:
                                                                              12.2),
                                                                    ),
                                                                  );
                                                                } else {
                                                                  _googleMapController!
                                                                      .animateCamera(
                                                                    CameraUpdate
                                                                        .newCameraPosition(
                                                                      const CameraPosition(
                                                                        target: LatLng(
                                                                            36.2,
                                                                            37.15),
                                                                        zoom:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                                print(
                                                                    '=Navigator===${myLocation.latitude}==${myLocation.longitude}=====${snapshot.data![index].ownerUserNum}==========');
                                                                // Navigator.push(
                                                                //   context,
                                                                //   MaterialPageRoute(
                                                                //       builder: (context) {
                                                                //     return DataOrder_screen(
                                                                //       order: snapshot.data![index],
                                                                //       kGooglePlex: CameraPosition(
                                                                //         target: LatLng(36.2, 37.15),
                                                                //         zoom: 12,
                                                                //       ),
                                                                //     );
                                                                //   }),
                                                                // );
                                                              },
                                                              () {
                                                                Api.orders.remove(
                                                                    snapshot.data![
                                                                        index]);
                                                                setState(() {});
                                                              },
                                                              () {
                                                                snapshot
                                                                        .data![
                                                                            index]
                                                                        .isWaitting =
                                                                    false;
                                                                snapshot
                                                                        .data![
                                                                            index]
                                                                        .deliveryUserNum =
                                                                    Api
                                                                        .usersList[
                                                                            4]
                                                                        .userNumber;

                                                                setState(() {});
                                                              },
                                                              // '${snapshot.data![index].data}',
                                                              '${((Api.getDestanceBetween(
                                                                myLocation
                                                                    .latitude,
                                                                myLocation
                                                                    .longitude,
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .marker
                                                                    .position
                                                                    .latitude,
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .marker
                                                                    .position
                                                                    .longitude,
                                                              )).round())}',

                                                              snapshot
                                                                  .data![index],
                                                              context,
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                    ),
                                                  ),
                                                );
                                              } else {
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
