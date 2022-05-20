import 'dart:convert';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/conmponent/customAwesome.dart';
import 'package:google_map/oop/Item.dart';
import 'package:google_map/oop/Order.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/oop/custom.dart';
import 'package:google_map/database/api.dart';
import 'package:google_map/database/api_links.dart';
import 'package:google_map/oop/employee.dart';
import 'package:google_map/main.dart';
import 'package:google_map/screens/dashSc/CustomDashboard_screen.dart';
import 'package:google_map/screens/Data_screen.dart';
import 'package:google_map/screens/dashSc/MainDash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<Position> getMyLocation() async {
    Position cl = await Geolocator.getCurrentPosition().then((value) => value);
    print('++++++++++++++++++++++$cl+++++++++++++++++++++++++++');
    return cl;
  }

  // static Future<Order> fetchOrder(int i) async {
  //   final response = await http.get(Uri.parse(
  //       'https://defianttreatment.backendless.app/api/data/Order?loadRelations=owner'));
  //
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     // print('===============fetchOrder======================');
  //     // print(jsonDecode(response.body));
  //
  //     return Order.fromJson(jsonDecode(response.body), i);
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load orders');
  //   }
  // }

  double getDestanceBetween(
      startLatitude, startLongitude, endLatitude, endLongitude) {
    double cl = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    return cl;
  }

  double getDestanceMyLocationToOrder(Position mylocation, Order order) {
    double cl = Geolocator.distanceBetween(
        mylocation.latitude,
        mylocation.longitude,
        order.marker.position.latitude,
        order.marker.position.longitude);
    return cl;
  }

  // static Future<List<Order>> getOrders(Position mylocation) async {
  //   orders.sort(
  //     (a, b) {
  //       return Api.getDestanceBetween(mylocation.latitude, mylocation.longitude,
  //               a.marker.position.latitude, a.marker.position.longitude)
  //           .compareTo(Api.getDestanceBetween(
  //               mylocation.latitude,
  //               mylocation.longitude,
  //               b.marker.position.latitude,
  //               b.marker.position.longitude));
  //     },
  //   );
  //   return orders;
  // }

  List<Order> apiOrders = [];

  Future<List<Order>> getMainOrders(Position mylocation, context) async {
    try {
      var response = await http.get(Uri.parse(getordersLink));
      print(jsonDecode(response.body));
      final data = jsonDecode(response.body);
      for (Map order in data) {
        // String items = '';
        // await getorderItems(order['order_id']).then((value) {
        //   value.forEach((element) {
        //     items = items +'-'+element.;
        //   });
        // });

        int destance = Geolocator.distanceBetween(
                mylocation.latitude,
                mylocation.longitude,
                double.parse(order['lat']),
                double.parse(order['long']))
            .ceil();
        String itemsName = '';
        List<Item> items = await getorderItems(order['order_id']);
        items.forEach((element) {
          itemsName = '${element.name!}:${element.count}' + '-' + itemsName;
        });

        if (order['delivery_id'] == preferences.getString('id')! ||
            order['isWaiting'] == '1' ||
            preferences.getString('id') == '0') {
          print('+++++++++++++++++++++++++++++++++++++++++++++++');
          print(order['getDelTime']);
          apiOrders.add(
            Order(
              deliveryUserNum: order['delivery_id'],
              id: order['order_id'],
              doneCustTime: order['doneCustTime'],
              getDelTime: order['getDelTime'],
              totalPrice: order['totalPrice'],
              orderTime: order['createTime'].toString(),
              isWaitting: order['isWaiting'] == '0' ? false : true,
              items: items,
              received: order['isRecieved'] == '0' ? false : true,
              ownerUserNum: order['owner_id'],
              marker: Marker(
                rotation: order['isWaiting'] == '1'
                    ? 0
                    : order['isRecieved'] == '1'
                        ? 180
                        : 90,
                infoWindow: InfoWindow(
                  onTap: () async {
                    var delivery = await getUserNameById(
                        order['delivery_id'], getEmployeeByIdLink);
                    if (order['isWaiting'] == '1' &&
                        order['isRecieved'] == '0') {
                      AwesomeDialog(
                          context: context,
                          btnOkText: 'i well arrive it',
                          btnOkOnPress: () async {
                            await updateGettingOrder(
                              order['order_id'].toString(),
                              preferences.getString('id')!,
                              '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}'
                              '  ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                            ).then((value) {
                              value == 'success'
                                  ? Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (conetxt) {
                                      return MainDashboard(
                                          preferences.getString('name')!,
                                          preferences.getString('password')!,
                                          preferences.getString('phone')!);
                                    }), (route) => false)
                                  : null;
                            });
                          }).show();
                    } else if (order['isWaiting'] == '0' &&
                        order['isRecieved'] == '0') {
                      AwesomeDialog(
                          context: context,
                          body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'this order with dilevery : ${delivery.name!}'),
                          )).show();
                    } else {
                      AwesomeDialog(
                          context: context,
                          body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'this order has done by : ${delivery.name!}'),
                          )).show();
                    }
                  },
                  snippet: itemsName + '  ' + destance.toString() + 'm' + '  ' + '  id :' + order['order_id'].toString(),
                  title: order['createTime'],
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  order['isWaiting'] == '1'
                      ? BitmapDescriptor.hueGreen
                      : order['isRecieved'] == '1'
                          ? BitmapDescriptor.hueAzure
                          : BitmapDescriptor.hueRed,
                ),
                markerId: MarkerId(order['order_id']),
                position: LatLng(
                  double.parse(order['lat']),
                  double.parse(
                    order['long'],
                  ),
                ),
              ),
            ),
          );
        }
      }
      return apiOrders;
    } catch (e) {
      print('catch getMainOrder error $e}');
      return [];
    }
  }

  Future<Employee> getUserNameById(String Id, String link) async {
    try {
      final PhpApi _api = PhpApi();
      var res = await _api.postRequest(link, {'id': Id});

      // List<dynamic> data = jsonDecode(res);

      return Employee.fromJson(res);
    } catch (e) {
      print('catch getItems error $e}');
      return jsonDecode(e.toString());
    }
  }

  Future<List<Order>> getMyOrders(Position mylocation, context) async {
    try {
      var response = await http.get(Uri.parse(getordersLink));
      print(jsonDecode(response.body));
      final data = jsonDecode(response.body);
      for (Map order in data) {
        // String items = '';
        // await getorderItems(order['order_id']).then((value) {
        //   value.forEach((element) {
        //     items = items +'-'+element.;
        //   });
        // });

        String itemsName = '';
        List<Item> items = await getorderItems(order['order_id']);
        items.forEach((element) {
          itemsName =  '${element.name!}:${element.count}'+ '-' +itemsName;
        });

        apiOrders.add(
          Order(
            getDelTime: order['getDelTime'],
            id: order['order_id'],
            doneCustTime: order['doneCustTime'],
            totalPrice: order['totalPrice'],
            deliveryUserNum: order['delivery_id'],
            orderTime: order['createTime'].toString(),
            isWaitting: order['isWaiting'] == '0' ? false : true,
            items: items,
            received: order['isRecieved'] == '0' ? false : true,
            ownerUserNum: order['owner_id'],
            marker: Marker(
              rotation: order['isWaiting'] == '1'
                  ? 0
                  : order['isRecieved'] == '1'
                      ? 180
                      : 90,
              infoWindow: InfoWindow(
                  onTap: () async {
                    var delivery = await getUserNameById(
                        order['delivery_id'], getEmployeeByIdLink);

                    if (order['isWaiting'] == '1' &&
                        order['isRecieved'] == '0') {
                      AwesomeDialog(
                          context: context,
                          btnCancelText: 'delete',
                          btnCancelOnPress: () async {
                            CustomeCircularProgress(context);

                            await deleteOrder(order['order_id'].toString())
                                .then((value) {
                              value == 'success'
                                  ? Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (conetxt) {
                                      return CustomDashboard(
                                          preferences.getString('name')!,
                                          preferences.getString('password')!,
                                          preferences.getString('phone')!);
                                    }), (route) => false)
                                  : null;
                            });
                          }).show();
                    } else if (order['isWaiting'] == '0' &&
                        order['isRecieved'] == '0') {
                      AwesomeDialog(
                          context: context,
                          btnOkText: 'i get it',
                          btnOkOnPress: () async {
                            await updateDoneOrder(
                              order['order_id'].toString(),
                              '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}'
                              '  ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                            ).then((value) {
                              value == 'success'
                                  ? Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (conetxt) {
                                      return CustomDashboard(
                                          preferences.getString('name')!,
                                          preferences.getString('password')!,
                                          preferences.getString('phone')!);
                                    }), (route) => false)
                                  : null;
                            });
                          },
                          body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'your order on road with : ${delivery.name!}... you get it ?',
                              textAlign: TextAlign.center,
                            ),
                          )).show();
                    } else {
                      AwesomeDialog(
                          context: context,
                          body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'your order has done by : ${delivery.name!}'
                                ''),
                          )).show();
                    }
                  },
                  snippet: itemsName + '  id :' + order['order_id'].toString(),
                  title: '${order['createTime']}'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                order['isWaiting'] == '1'
                    ? BitmapDescriptor.hueGreen
                    : order['isRecieved'] == '1'
                        ? BitmapDescriptor.hueAzure
                        : BitmapDescriptor.hueRed,
              ),
              markerId: MarkerId(order['order_id']),
              position: LatLng(
                double.parse(order['lat']),
                double.parse(
                  order['long'],
                ),
              ),
            ),
          ),
        );
      }
      return apiOrders;
    } catch (e) {
      print('catch getMainOrder error $e}');
      CustomAwesomeDialog(
          context: context,
          content: 'no internet',
          onOkTap: () {
            updateCustomScreen(context);
          });
      return [];
    }
  }

  Future<String> deleteOrder(String id) async {
    try {
      PhpApi _api = PhpApi();
      var response = await _api.postRequest(
        deleteorederLink,
        {'id': id},
      );
      if (response['status'] == 'success') {
        return 'success';
      } else {
        print('add failed ${response['status']} $id');
        return 'failed';
      }
    } catch (e) {
      print(e);
      return 'failed';
    }
  }

  Future<String> updateGettingOrder(
      String orderId, String deliveryId, String getDelTime) async {
    try {
      PhpApi _api = PhpApi();
      var response = await _api.postRequest(
        getorderUpdateLink,
        {
          'order_id': orderId,
          'delivery_id': deliveryId,
          'getDelTime': getDelTime,
        },
      );
      if (response['status'] == 'success') {
        return 'success';
      } else {
        print('add failed ${response['status']}');
        return 'failed';
      }
    } catch (e) {
      print(e);
      return 'failed';
    }
  }

  Future<String> updateDoneOrder(String id, String doneCustTime) async {
    try {
      PhpApi _api = PhpApi();
      var response = await _api.postRequest(
        doneorderUpdateLink,
        {'id': id, 'doneCustTime': doneCustTime},
      );
      if (response['status'] == 'success') {
        return 'success';
      } else {
        print('add failed ${response['status']}');
        return 'failed';
      }
    } catch (e) {
      print(e);
      return 'failed';
    }
  }

  Future<List<Item>> getorderItems(String orderID) async {
    List<Item> apitems = [];
    try {
      final PhpApi _api = PhpApi();
      var res = await _api.postRequest(getorederItemsLink, {'id': orderID});

      if (orderID == 'all') {
        res = await _api.postRequest(getitemsLink, {'id': orderID});
      }

      // List<dynamic> data = jsonDecode(res);

      for (Map<String, dynamic> item in res) {
        apitems.add(
          Item.fromJson(item),
        );
      }

      return apitems;
    } catch (e) {
      print('catch getItems error $e}');
      return jsonDecode(e.toString());
    }
  }

  updateCustomScreen(context) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return CustomDashboard(preferences.getString('name')!,
          preferences.getString('password')!, preferences.getString('phone')!);
    }), (route) => false);
  }
}
