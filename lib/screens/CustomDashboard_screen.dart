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
import 'package:google_map/screens/Dashboard_screen.dart';
import 'package:google_map/screens/Login_screen.dart';
import 'package:google_map/screens/addScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomDashboard extends StatefulWidget {
  const CustomDashboard({Key? key}) : super(key: key);

  @override
  State<CustomDashboard> createState() => _DashboardState();
}

 Customer myUser = Api.usersList[0];
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
        return const Login();
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
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return Dashboard();
                }), (route) => false);
              },
              icon: Icon(Icons.next_plan))
        ],
      ),
      drawer: Drawer(

        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(30),
        ),
        child: SafeArea(

          child: SizedBox(
            child: FutureBuilder<List<Order>>(
                initialData: const [],
                future: Api.getCustomOrders(myLocation, myUser),
                builder: (context, snapshot) {
                  if (snapshot.hasData ||
                      !snapshot.hasError ||
                      snapshot.connectionState == ConnectionState.done) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: SingleChildScrollView(
                        child: Column(
                            children: List.generate(
                                snapshot.data!.length,
                                (index) => Column(children: [
                                      Text(
                                        Api.getMyUserByNumber(snapshot.data![index].deliveryUserNum).userName
                                            .toString(),
                                      ),
                                      CardOrder_component(
                                        'custom',
                                        () {
                                          setState(() {
                                            if (chooseMarker[0]
                                                    .markerId
                                                    .value !=
                                                snapshot.data![index].marker
                                                    .markerId.value) {
                                              choose = true;
                                            } else {
                                              choose = !choose;
                                            }

                                            chooseMarker[0] = (Marker(
                                              markerId: MarkerId(
                                                snapshot.data![index].marker
                                                    .markerId.value,
                                              ),
                                              position: snapshot
                                                  .data![index].marker.position,
                                              rotation: snapshot
                                                      .data![index].isWaitting
                                                  ? 180
                                                  : snapshot
                                                          .data![index].received
                                                      ? 90
                                                      : 0,
                                              icon: !snapshot
                                                      .data![index].isWaitting
                                                  ? BitmapDescriptor
                                                      .defaultMarker
                                                  : BitmapDescriptor
                                                      .defaultMarkerWithHue(
                                                      BitmapDescriptor.hueGreen,
                                                    ),
                                            ));
                                          });

                                          if (choose) {
                                            _googleMapController!.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: LatLng(
                                                      chooseMarker[0]
                                                          .position
                                                          .latitude,
                                                      chooseMarker[0]
                                                          .position
                                                          .longitude,
                                                    ),
                                                    zoom: 12.2),
                                              ),
                                            );
                                          } else {
                                            _googleMapController!.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                const CameraPosition(
                                                  target: LatLng(36.2, 37.15),
                                                  zoom: 10,
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
                                          Api.orders
                                              .remove(snapshot.data![index]);
                                          setState(() {});
                                        },
                                        () {
                                          snapshot.data![index].received = true;

                                          setState(() {});
                                        },
                                        // '${snapshot.data![index].data}',
                                        '${((Api.getDestanceBetween(
                                          myLocation.latitude,
                                          myLocation.longitude,
                                          snapshot.data![index].marker.position
                                              .latitude,
                                          snapshot.data![index].marker.position
                                              .longitude,
                                        )).round())}',
                                        snapshot.data![index],
                                        context,
                                      ),
                                    ]))),
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            for (Order element in Api.orders) {
              if (element.ownerUserNum == myUser.userNumber &&
                  element.isWaitting &&
                  !element.received) {
                setState(() {
                  sure = false;
                });

                AwesomeDialog(
                  btnCancel: OutlinedButton(
                      onPressed: () {
                        setState(() {});
                        _googleMapController!.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                  myLocation.latitude, myLocation.longitude),
                              zoom: 12.2,
                            ),
                          ),
                        );

                        Navigator.pop(context);
                        AwesomeDialog(
                            btnOk: Column(
                              children: [
                                OutlineButton(
                                    onPressed: () {
                                      element.received = true;

                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: const Text('I get it')),
                                OutlineButton(
                                    onPressed: () {
                                      Api.orders.remove(element);
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: const Text('delete it')),
                              ],
                            ),
                            animType: AnimType.TOPSLIDE,
                            context: context,
                            dialogType: DialogType.QUESTION,
                            title: 'Order Data',
                            body: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Text(
                                    '${Api.getDestanceBetween(myLocation.latitude, myLocation.longitude, element.marker.position.latitude, element.marker.position.longitude).ceil()} meters',
                                  ),
                                  Text(
                                      '${int.parse(element.orderTime.day.toString()) - int.parse(DateTime.now().day.toString())} day'),
                                  Text(
                                    element.items,
                                  ),
                                ],
                              ),
                            )).show();
                      },
                      child: Text('open it')),
                  btnOk: OutlinedButton(
                      onPressed: () {
                        Api.orders.remove(element);
                        setState(() {
                          sure = true;
                        });
                        Navigator.pop(context);
                      },
                      child: Text('delete it')),
                  context: context,
                  dialogType: DialogType.ERROR,
                  body: Text('you have another order on line'),
                  title: 'you have another',
                ).show();

                if (sure) break;
              } else {
                setState(() {
                  sure = true;
                });
              }
            }
            if (sure) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddScreen(
                    LatLng(myLocation.latitude, myLocation.longitude));
              })).whenComplete(() {
                setState(() {});

                _googleMapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: Api.orders.last.marker.position,
                      zoom: 12.5,
                    ),
                  ),
                );
              });
            }
          },
          child: const Icon(Icons.add,color: Colors.black,)),
      backgroundColor: Colors.white,
      body: Center(
        child: ttt
            ? SafeArea(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 11,
                child: FutureBuilder<List<Order>>(
                    initialData: const [],
                    future: Api.getCustomOrders(myLocation, myUser),
                    builder: (context, snapshot) {
                      print(snapshot);
                      if (snapshot.hasData ||
                          !snapshot.hasError ||
                          snapshot.connectionState ==
                              ConnectionState.done) {
                        Set<Marker> markers = {};

                        for (Order order in snapshot.data!) {
                          print(order.marker);
                        }

                        for (Order order in snapshot.data!) {
                          markers.add(
                            Marker(
                                markerId:
                                    MarkerId(order.marker.markerId.value),
                                position: order.marker.position,
                                infoWindow: order.marker.infoWindow,
                                icon: order.marker.icon,
                                onTap: () {
                                  setState(() {
                                    _googleMapController!.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target: LatLng(
                                              order.marker.position
                                                  .latitude,
                                              order.marker.position
                                                  .longitude,
                                            ),
                                            zoom: 12),
                                      ),
                                    );
                                  });
                                  AwesomeDialog(
                                      btnCancel: OutlineButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('cancel')),
                                      btnOk: Column(
                                        children: [
                                          order.isWaitting
                                              ? OutlineButton(
                                                  onPressed: () {
                                                    Api.orders
                                                        .remove(order);
                                                    setState(() {});
                                                    Navigator.pop(
                                                        context);
                                                  },
                                                  child: const Text(
                                                      'delete'))
                                              : OutlineButton(
                                                  onPressed: () {
                                                    order.received = true;

                                                    setState(() {});
                                                    Navigator.pop(
                                                        context);
                                                  },
                                                  child: const Text(
                                                      'I get it')),
                                        ],
                                      ),
                                      animType: AnimType.TOPSLIDE,
                                      context: context,
                                      dialogType: DialogType.QUESTION,
                                      title: 'Order Data',
                                      body: Padding(
                                        padding:
                                            const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${Api.getDestanceBetween(myLocation.latitude, myLocation.longitude, order.marker.position.latitude, order.marker.position.longitude).ceil()} meters',
                                            ),
                                            Text(
                                                '${int.parse(order.orderTime.day.toString()) - int.parse(DateTime.now().day.toString())} day'),
                                            Text(
                                              order.items,
                                            ),
                                          ],
                                        ),
                                      )).show();
                                }),
                          ); //all markers
                        }

                        for (Order order in snapshot.data!) {
                          if (order.received) {
                            String deliver = Api.getMyUserByNumber(order.deliveryUserNum).userName;
                            Marker removedMarker = order.marker;
                            markers.remove(
                              Marker(
                                markerId:
                                    MarkerId(order.marker.markerId.value),
                              ),
                            );
                            markers.add(
                              Marker(
                                infoWindow: InfoWindow(
                                    title: 'deliver : ${deliver}',
                                  snippet:
                                  '${order.items}',),
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
                            String delivery = Api.getMyUserByNumber(order.deliveryUserNum).userName;
                            Marker removedMarker = order.marker;
                            markers.remove(
                              Marker(
                                markerId:
                                    MarkerId(order.marker.markerId.value),
                              ),
                            );
                            markers.add(
                              Marker(
                                onTap: () {
                                  AwesomeDialog(
                                      btnCancel: OutlineButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('cancel')),
                                      btnOk: Column(
                                        children: [
                                          order.isWaitting
                                              ? OutlineButton(
                                                  onPressed: () {
                                                    Api.orders
                                                        .remove(order);
                                                    setState(() {});
                                                    Navigator.pop(
                                                        context);
                                                  },
                                                  child: const Text(
                                                      'delete'))
                                              : OutlineButton(
                                                  onPressed: () {
                                                    order.received = true;

                                                    setState(() {});
                                                    Navigator.pop(
                                                        context);
                                                  },
                                                  child: const Text(
                                                      'I get it')),
                                        ],
                                      ),
                                      animType: AnimType.TOPSLIDE,
                                      context: context,
                                      dialogType: DialogType.QUESTION,
                                      title: 'Order Data',
                                      body: Padding(
                                        padding:
                                            const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${Api.getDestanceBetween(myLocation.latitude, myLocation.longitude, order.marker.position.latitude, order.marker.position.longitude).ceil()} meters',
                                            ),
                                            Text(
                                                '${int.parse(order.orderTime.day.toString()) - int.parse(DateTime.now().day.toString())} day'),
                                            Text(
                                              order.items,
                                            ),
                                          ],
                                        ),
                                      )).show();
                                },
                                infoWindow: InfoWindow(
                                    title: 'deliver : ${delivery}',
                                  snippet:
                                  '${order.items}',),
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
                          onTap: (latlog) {
                            setState(() {
                              choose = false;
                            });
                          },
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
                                  zoom: 12.2,
                                )
                              : CameraPosition(
                                  target: LatLng(myLocation.latitude,
                                      myLocation.longitude),
                                  zoom: 10,
                                ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ),
            )
            : CustomeCircularProgress(context),
      ),
    );
  }
}
