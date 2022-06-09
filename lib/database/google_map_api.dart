import 'dart:convert';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
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

  static double getDestanceBetween(
      startLatitude, startLongitude, endLatitude, endLongitude) {
    double cl = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    return cl;
  }

  static double getDestanceMyLocationToOrder(Position mylocation, Order order) {
    double cl = Geolocator.distanceBetween(
        mylocation.latitude,
        mylocation.longitude,
        order.marker!.position.latitude,
        order.marker!.position.longitude);
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


  static Future<List<Order>?> getMainOrders(Position mylocation, context, search ) async {
    try {
      apiOrders.clear();
      var response = await http.get(Uri.parse(getordersLink));
      print(jsonDecode(response.body));
      final data = jsonDecode(response.body);
      for (Map<String, dynamic> order in data) {

        String itemsName = '';
        List<Item> items = await getorderItems(order['order_id']);
        for (var element in items) {
          itemsName = '${element.name!}:${element.count} -' + itemsName;
        }

        if (order['delivery_id'] == preferences.getString('id')! ||
            order['isWaiting'] == '1' ||
            preferences.getString('id') == '0') {
          print('+++++++++++++++++++++++++++++++++++++++++++++++');
          print(order['getDelTime']);
          BitmapDescriptor waitIcon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(),
            "lib/images/waitIcon.png",
          );
          BitmapDescriptor doneIcon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(),
            "lib/images/doneIcon.png",
          );
          BitmapDescriptor activeIcon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(),
            "lib/images/activeIcon.png",
          );
          apiOrders.add(
            Order.fromJson(order, context, itemsName, true, waitIcon,
                activeIcon, doneIcon),
          );
        }
      }
      return apiOrders;
    } catch (e) {
      print('catch getMainOrder error $e}');
      return [];
    }
  }

  static  Future<Employee> getEmpNameById(
    String Id,
  ) async {
    try {
      final PhpApi _api = PhpApi();
      var res = await _api.postRequest(getEmployeeByIdLink, {'id': Id});

      // List<dynamic> data = jsonDecode(res);

      return Employee.fromJson(res);
    } catch (e) {
      print('catch getItems error $e}');
      return jsonDecode(e.toString());
    }
  }
  String getNowTime() {
    return '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}'
        '  ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
  }
  static  Future<Customer> getCustomNameById(
    String Id,
  ) async {
    if(Id!=''){
      try {
        final PhpApi _api = PhpApi();
        var res = await _api.postRequest(getCustloyeeByIdLink, {'id': Id});

        // List<dynamic> data = jsonDecode(res);

        return Customer.fromJson(res);
      } catch (e) {
        print('catch getItems error $e}');
        return jsonDecode(e.toString());
      }
    }else{
     return Customer();
    }

  }

  static  Future<List<Order>> getMyOrders(Position mylocation, context) async {
    try {
      var response = await http.get(Uri.parse(getordersLink));
      print(jsonDecode(response.body));
      final data = jsonDecode(response.body);
      for (Map<String, dynamic> order in data) {
        String itemsName = '';
        List<Item> items = await getorderItems(order['order_id']);
        for (var element in items) {
          itemsName = '${element.name!}:${element.count}' + '-' + itemsName;
        }
        BitmapDescriptor waitIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(
            size: Size.fromHeight(30),
          ),
          "lib/images/waitIcon.png",
        );
        BitmapDescriptor doneIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size.fromHeight(10)),
          "lib/images/doneIcon.png",
        );
        BitmapDescriptor activeIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(),
          "lib/images/activeIcon.png",
        );
        apiOrders.add(
          Order.fromJson(
              order, context, itemsName, false, waitIcon, activeIcon, doneIcon),
        );
      }
      return apiOrders;
    } catch (e) {
      print('catch getMainOrder error $e}');
      CustomAwesomeDialog(
          context: context,
          content: 'no internet',
          onOkTap: () {
            updateCustomScreen();
          });
      return [];
    }
  }

  static  Future<String> deleteOrder(String id) async {
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

  static  Future<String> updateGettingOrder(
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

  static  Future<String> updateDoneOrder(String id, String doneCustTime) async {
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

  static  Future<List<Item>> getorderItems(String orderID) async {
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

  static  updateCustomScreen() {
    Get.off(CustomDashboard(preferences.getString('name')!,
        preferences.getString('password')!, preferences.getString('phone')!));
  }
}
