import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/model/database/api.dart';
import 'package:google_map/model/database/google_map_api.dart';
import 'package:google_map/model/oop/Item.dart';
import 'package:google_map/model/oop/Order.dart';
import 'package:google_map/main.dart';
import 'package:google_map/view/conmponent/CustomCirProgress.dart';
import 'package:google_map/view/conmponent/CustomItemCard.dart';
import 'package:google_map/view/conmponent/customAwesome.dart';
import 'package:google_map/view/screens/dashSc/CustomDashboard_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../model/database/api_links.dart';

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

  bool total = true;
  final Order _order = Order();
  final List<Item> _listitems = [];

  addItem(name, price, count) async {
    CustomeCircularProgress(context);
    try {
      var response = await _api.postRequest(
        addItemLink,
        {
          'name': name,
          'price': price,
          'quant': '-${count}',
          'type': 'widget.type',
          'weight': 'widget.weight',
          'info': 'widget.info',
        },
      );

      Get.back();
      if (response['status'] == 'item is here') {
        CustomAwesomeDialog(context: context, content: 'item is her');
      } else if (response['status'] == 'success') {
        Get.offAll(CustomDashboard(
            preferences.getString('name')!,
            preferences.getString('password')!,
            preferences.getString('phone')!));
      } else {
        CustomAwesomeDialog(
            context: context, content: 'network connection less');
      }
    } catch (e) {
      CustomAwesomeDialog(context: context, content: 'network error');
      print(e);
    }
  }

  addOrder() async {
    CustomeCircularProgress(context);

    try {
      var response = await _api.postRequest(
        addorederLink,
        _order.toJson(lat, long),
      );

      print('add failed ${response['orderId']}');
      if (response['status'] == 'success') {
        _listitems.forEach((element) async {
          await addOrderItem(
            lastOrderId: response['orderId'],
            itemCount: element.count.toString(),
            itemId: element.itemId.toString(),
          );

          print(element.name);
          print('============element.name============');
          await addItem(element.name, element.price, element.count);
        });
      } else {
        print('add failed ${response['status']}');
      }
    } catch (e) {
      print(e);
      print('============addOrder============');
    }
  }

  addOrderItem({
    required String lastOrderId,
    required String itemId,
    required String itemCount,
  }) async {
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
      Get.back();
      if (response['status'] == 'success') {
        Get.offAll(()=> CustomDashboard(
          preferences.get('name').toString(),
          preferences.get('password').toString(),
          preferences.get('phone').toString(),
        ));
      } else {
        print('add failed ${response['status']}');
      }
    } catch (e) {
      print(e);
      print('============addOrderItem====$lastOrderId========');
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
      body: total
          ? Stack(
              alignment: Alignment.center,
              children: [
                SafeArea(
                  child: GoogleMap(
                    mapToolbarEnabled: true,
                    onMapCreated: (val) {
                      print(val);
                    },
                    onTap: (latlong) async {
                      if ((36.2395093776424 > latlong.latitude &&
                              latlong.latitude > 36.16330528868279) &&
                          (37.08518844097853 < latlong.longitude &&
                              latlong.longitude < 37.20690105110407)) {
                        setState(() {
                          lat = latlong.latitude.toString();
                          long = latlong.longitude.toString();
                        });
                        CustomAwesomeDialog(
                            context: context,
                            content: 'set here and choose items !',
                            onOkTap: () {
                              setState(() {
                                total = false;
                              });
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
                                infoWindow: const InfoWindow(
                                    title: 'your new order location'),
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
                  bottom: 10,
                  child: FloatingActionButton(
                      child: Text(
                        'here ?',
                        style: TextStyle(color: Get.theme.backgroundColor),
                      ),
                      backgroundColor: Get.theme.primaryColor,
                      foregroundColor: Get.theme.backgroundColor,
                      onPressed: () {
                        setState(() {
                          total = !total;
                        });
                      }),
                ),
              ],
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: CircleAvatar(
                        child: Icon(Icons.arrow_back_ios_new,
                            color: Get.theme.backgroundColor),
                        backgroundColor: Get.theme.primaryColor,
                      )),
                  backgroundColor: Get.theme.primaryColor,
                  foregroundColor: Get.theme.backgroundColor,
                  expandedHeight: MediaQuery.of(context).size.height * 0.8,
                  pinned: true,
                  snap: false,
                  floating: true,
                  collapsedHeight: 100,
                  title: Card(
                    elevation: 0,
                    color: Get.theme.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80.0, vertical: 8),
                      child: Text(
                        'add',
                        style: TextStyle(
                            color: Get.theme.backgroundColor, fontSize: 18),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.all(30),
                      centerTitle: true,
                      background: GoogleMap(
                        mapToolbarEnabled: true,
                        onMapCreated: (val) {
                          print(val);
                        },
                        onTap: (latlong) async {
                          if ((36.2395093776424 > latlong.latitude &&
                                  latlong.latitude > 36.16330528868279) &&
                              (37.08518844097853 < latlong.longitude &&
                                  latlong.longitude < 37.20690105110407)) {
                            setState(() {
                              lat = latlong.latitude.toString();
                              long = latlong.longitude.toString();
                            });
                            CustomAwesomeDialog(
                                context: context,
                                content: 'choose items !',
                                onOkTap: () {
                                  setState(() {
                                    total = false;
                                  });
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
                                    infoWindow: const InfoWindow(
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
                      )),
                ),

                total
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Container(
                              height: Get.size.height / 4,
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  'choose location first ...',
                                  style: TextStyle(
                                      color: Get.theme.backgroundColor,
                                      fontSize: 21),
                                ),
                              )),
                              color: Get.theme.primaryColor,
                            );
                          },
                          childCount: 1,
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                int count = int.parse(widget
                                                            .getorderItems[
                                                                index]
                                                            .count ==
                                                        null
                                                    ? '0'
                                                    : widget
                                                        .getorderItems[index]
                                                        .count!);
                                                int quant = int.parse(widget
                                                            .getorderItems[
                                                                index]
                                                            .quant ==
                                                        null
                                                    ? '0'
                                                    : widget
                                                        .getorderItems[index]
                                                        .quant!);
                                                if (count <quant) {
                                                  setState(() {
                                                    _listitems.remove(
                                                        widget.getorderItems[
                                                            index]);
                                                    count++;
                                                    widget
                                                        .getorderItems[index]
                                                        .count = (count).toString();
                                                    _listitems.add(
                                                        widget.getorderItems[
                                                            index]);
                                                  });
                                                }
                                                print(count);
                                                print(
                                                    '=================count===============');
                                              },
                                              icon: Icon(
                                                  Icons.add_circle_outline,
                                                  color: Get
                                                      .theme.primaryColor)),
                                          IconButton(
                                              onPressed: () {
                                                int count = int.parse(widget
                                                  .getorderItems[
                                              index]
                                                  .count ==
                                                  null
                                                  ? '0'
                                                  : widget
                                                  .getorderItems[index]
                                                  .count!);
                                              int quant = int.parse(widget
                                                  .getorderItems[
                                              index]
                                                  .quant ==
                                                  null
                                                  ? '0'
                                                  : widget
                                                  .getorderItems[index]
                                                  .quant!);
                                              if (1 <=count) {
                                                setState(() {
                                                  _listitems.remove(
                                                      widget.getorderItems[
                                                      index]);
                                                  count--;
                                                  widget
                                                      .getorderItems[index]
                                                      .count = (count).toString();
                                                  _listitems.add(
                                                      widget.getorderItems[
                                                      index]);
                                                });
                                              }else {
                                                widget.getorderItems[index].count = null;
                                                _listitems.remove(widget.getorderItems[index]);
                                              }
                                              print(count);
                                              print(
                                                  '=================count===============');
                                              },
                                              icon: Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.red
                                                      .withOpacity(0.8))),
                                        ],
                                      ),
                                    ),
                                    CustomItemCard(
                                      context,
                                      widget.getorderItems,
                                      index,
                                      Container(),
                                      widget.getorderItems[index].count,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                          childCount: widget.getorderItems.length,
                        ),
                      ),


              ],
            ),
      floatingActionButton: total
          ? Container()
          : FloatingActionButton(
              backgroundColor: Get.theme.primaryColor,
              child: Text(
                'sure',
                style: TextStyle(color: Get.theme.backgroundColor),
              ),
              onPressed: () async {
                if (((36.2395093776424 > double.parse(lat) &&
                        double.parse(lat) > 36.16330528868279) &&
                    (37.08518844097853 < double.parse(long) &&
                        double.parse(long) < 37.20690105110407))) {
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
              }),
    );
  }
}
