import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/Order.dart';
import 'package:google_map/custom.dart';
import 'package:google_map/database/api_links.dart';
import 'package:google_map/employee.dart';
import 'package:google_map/screens/Data_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Api {
  static Future<Position> getMyLocation() async {
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

  static double getDestanceBetween(startLatitude, startLongitude, endLatitude,
      endLongitude) {
    double cl = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    return cl;
  }

  static double getDestanceMyLocationToOrder(Position mylocation, Order order) {
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

  static List<Order> apiOrders = [];

  static Future<List<Order>> getMainOrder(Position mylocation) async {
    try {
      var response = await http.get(Uri.parse(getordersLink));
      print(jsonDecode(response.body));
      final data = jsonDecode(response.body);
      for (Map order in data) {
        apiOrders.add(
          Order(
            deliveryUserNum: order['delivery_id'],
            orderTime: DateTime(2021),
            isWaitting: order['isWaiting'] == '0' ? false : true,
            items: 'skl',
            received: order['isRecieved'] == '0' ? false : true,
            ownerUserNum: order['owner_id'],
            marker: Marker(
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
      return jsonDecode(e.toString());
    }
  }
}