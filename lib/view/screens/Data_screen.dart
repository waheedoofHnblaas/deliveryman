import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_map/model/oop/Item.dart';
import 'package:google_map/model/oop/Order.dart';
import 'package:google_map/view/screens/dashSc/CustomDashboard_screen.dart';
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
            SafeArea(

              child: GoogleMap(mapToolbarEnabled: true,
                trafficEnabled: true,
                myLocationButtonEnabled: true,
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
            Positioned(
              bottom: 60,
              left: 30,
              right: 60,
              child: FutureBuilder<List<Item>?>(
                future: API.getorderItems(widget._order.orderId!),
                builder: (BuildContext context, itemssnap) {
                  if (itemssnap.hasData && !itemssnap.hasError) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                List.generate(itemssnap.data!.length, (index) {
                              return Card(
                                color: Get.theme.primaryColor.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        itemssnap.data![index].name!,
                                        style: TextStyle(
                                            color: Get.theme.backgroundColor),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        itemssnap.data![index].count!,
                                        style: TextStyle(
                                            color: Get.theme.backgroundColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          )),
                    );
                  } else
                    return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
