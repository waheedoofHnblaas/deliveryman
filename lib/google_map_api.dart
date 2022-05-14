import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/Order.dart';
import 'package:google_map/custom.dart';
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

  static double getDestanceBetween(
      startLatitude, startLongitude, endLatitude, endLongitude) {
    double cl = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    return cl;
  }
  static double getDestanceMyLocationToOrder(
      Position mylocation, Order order) {
    double cl = Geolocator.distanceBetween(
      mylocation.latitude  , mylocation.longitude, order.marker.position.latitude, order.marker.position.longitude);
    return cl;
  }




  static List usersList = [
    Customer(password: '111111', userName: 'ali', userNumber: '03905894885'),
    Employee(password: '111111', userName: 'waheed', userNumber: '039080095985'),
  ];

  static List<Order> orders = [
    // Order(
    //   orderTime: DateTime(2022,2,12,12,12,43),
    //   dilevryName: 'waheed',
    //   marker:  Marker(
    //     markerId: MarkerId('1'),
    //     infoWindow: InfoWindow(title: 'order 1'),
    //     position: LatLng(36.24, 37.16),
    //   ),
    //   owner: 'waheed',
    //   items: ['item1', 'item2', 'item3', 'item3'],
    //   iswaitting: true,
    //   received: false,
    // ),
    Order(
      deliveryUserNum: '03905894895985',
      received: false,
      items: 'oepoepo-okcewc',
      marker: Marker(
        markerId: MarkerId('099089'),
        infoWindow: InfoWindow(title: 'order 3'),
        position: LatLng(36.23, 37.14),
      ),
      isWaitting: false,
      orderTime: DateTime(2022, 2, 12, 22, 12, 43),
      ownerUserNum: Api.usersList[0].userNumber,
    ),
    // Order(
    //   orderTime: DateTime(2022, 2, 12, 22, 12, 43),
    //   deliveryUser:
    //       User(userName: 'deleelde', userNumber: '2342432', isEmp: true),
    //   marker: const Marker(
    //     markerId: MarkerId('897790'),
    //     infoWindow: InfoWindow(title: 'order 3'),
    //     position: LatLng(36.23, 37.14),
    //   ),
    //   ownerUser: User(userName: 'ali', userNumber: '2342432', isEmp: false),
    //   items: 'item3-item3-item3',
    //   isWaitting: true,
    //   received: false,
    // ),
    // Order(
    //   orderTime: DateTime(2022,2,12,2,12,43),
    //
    //   dilevryName: 'waheedo',
    //   marker: const Marker(
    //       markerId: MarkerId('4'),
    //       infoWindow: InfoWindow(title: 'order 4'),
    //       position: LatLng(36.22, 37.15)),
    //   owner: 'waheed',
    //   items: ['item1', 'item2', 'item3'],
    //   iswaitting: true,
    //   received: false,
    // ),
  ];

  static Customer getMyUserByNumber(String num){
    Customer user =   Customer(password: '', userName: '', userNumber: '');
    Api.usersList.forEach((element) {
      if(element.userNumber==num) {
        user = element;
      }
    });

    return user;

  }

  static Future<List<Order>> getOrders(Position mylocation) async {
    orders.sort(
      (a, b) {
        return Api.getDestanceBetween(mylocation.latitude, mylocation.longitude,
                a.marker.position.latitude, a.marker.position.longitude)
            .compareTo(Api.getDestanceBetween(
                mylocation.latitude,
                mylocation.longitude,
                b.marker.position.latitude,
                b.marker.position.longitude));
      },
    );
    return orders;
  }

  static Future<List<Order>> getCustomOrders(
      Position mylocation, Customer owner) async {
    List<Order> customorders = [];
    for (Order element in orders) {
      if (element.ownerUserNum == owner.userNumber) {
        customorders.add(element);
      }
    }

    return customorders;
  }
}
