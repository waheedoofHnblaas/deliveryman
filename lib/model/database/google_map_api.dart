import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_map/model/database/api.dart';
import 'package:google_map/main.dart';
import 'package:google_map/model/oop/Item.dart';
import 'package:google_map/model/oop/Order.dart';
import 'package:google_map/model/oop/custom.dart';
import 'package:google_map/model/oop/employee.dart';
import 'package:google_map/view/conmponent/customAwesome.dart';
import 'package:google_map/view/screens/dashSc/CustomDashboard_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'api_links.dart';

class Api {
  Future<Position> getMyLocation() async {
    Position cl = await Geolocator.getCurrentPosition().then((value) => value);
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

  int getDestanceMyLocationToOrder(Position mylocation, LatLng position) {
    double cl = Geolocator.distanceBetween(mylocation.latitude,
        mylocation.longitude, position.latitude, position.longitude);
    return cl.ceil();
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
  static List<Item> _apiItems = [];
  static List<int> OrderIds = [];

   Future<List<Order>?> getMainOrders(
      Position mylocation, context) async {

    try {

      apiOrders = [];apiOrders.clear();
      PhpApi _phpApi = PhpApi();
      final data =await _phpApi.getRequest(getordersLink);

      for(Map<String, dynamic> data2 in data){

        print('------------------');
        print(data2);
      }
      print('++++++++++++++++++++++++++++++++++++++++++++');
      for (Map<String, dynamic> order in data) {
        String itemsName = '';
        List<Item> items = await API.getorderItems(order['order_id']);
        for (var element in items) {
          itemsName = '${element.name!}:${element.count} -' + itemsName;
        }

        if (order['delivery_id'] == preferences.getString('id')! ||
            order['isWaiting'] == '1' ||
            preferences.getString('id') == '0') {


          BitmapDescriptor waitIcon = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "lib/view/images/waitIcon.png",
          );
          BitmapDescriptor doneIcon = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "lib/view/images/doneIcon.png",
          );
          BitmapDescriptor activeIcon = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "lib/view/images/activeIcon.png",
          );
          API.apiOrders.add(
            Order.fromJson(order, context, itemsName, true, waitIcon,
                activeIcon, doneIcon),
          );
        }
      }
     return API.apiOrders;
    } catch (e) {
      CustomAwesomeDialog(
          context: context,
          content: 'no internet or server error',
          onOkTap: () {
            updateCustomScreen();
          });
      return [];
    }
  }


  static Future<List<Employee>?> getEmps(
      Position mylocation, context) async {
    List<Employee> emps = [];
    try {
      API.apiOrders.clear();

      var response = await http.get(Uri.parse(getEmpsLink));
      final data = jsonDecode(response.body);
      for (Map<String, dynamic> emp in data) {
        emps.add(Employee.fromJson(emp));
      }
      return emps;
    } catch (e) {
      CustomAwesomeDialog(
          context: context,
          content: 'no internet or server error',
          onOkTap: () {
            updateCustomScreen();
          });
      return [];
    }
  }

  static Future<List<Order>> getMyOrders(
      Position mylocation, context, String ownerId) async {
    try {
      API.apiOrders.clear();
      // var respons = await http.get(Uri.parse(getordersLink));
     final PhpApi _api = PhpApi();


      final data =  await _api.postRequest(getordersByOwnerIdLink, {'id': ownerId});

      for (Map<String, dynamic> order in data) {
        String itemsName = '';
        List<Item> items = await API.getorderItems(order['order_id']);
        for (var element in items) {
          itemsName = '${element.name!}:${element.count}' + '-' + itemsName;
        }
        BitmapDescriptor waitIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(
            size: Size.fromHeight(30),
          ),
          "lib/view/images/waitIcon.png",
        );
        BitmapDescriptor doneIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(),
          "lib/view/images/doneIcon.png",
        );
        BitmapDescriptor activeIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(),
          "lib/view/images/activeIcon.png",
        );
        API.apiOrders.add(
          Order.fromJson(order, context, itemsName, false, waitIcon,
              activeIcon, doneIcon),
        );
      }
      return API.apiOrders;
    } catch (e) {
      CustomAwesomeDialog(
          context: context,
          content: 'no internet or server error',
          onOkTap: () {
            updateCustomScreen();
          });
      return [];
    }
  }


  Future<Employee> getEmpNameById(
    String Id,
  ) async {
    try {
      final PhpApi _api = PhpApi();
      var res = await _api.postRequest(getEmployeeByIdLink, {'id': Id});

      // List<dynamic> data = jsonDecode(res);

      return Employee.fromJson(res);
    } catch (e) {
      return jsonDecode(e.toString());
    }
  }


  String getNowTime() {
    return '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}'
        '  ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
  }

  Future<Customer> getCustomNameById(
    String Id,
  ) async {
    if (Id != '') {
      try {
        final PhpApi _api = PhpApi();
        var res = await _api.postRequest(getCustloyeeByIdLink, {'id': Id});

        // List<dynamic> data = jsonDecode(res);

        return Customer.fromJson(res);
      } catch (e) {
        return jsonDecode(e.toString());
      }
    } else {
      return Customer();
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
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }

  Future<String> updateGettingOrder(
    String orderId,
    deliveryLat,
    deliveryLong,
    String deliveryId,
    String getDelTime,
  ) async {
    try {
      PhpApi _api = PhpApi();
      var response = await _api.postRequest(
        getorderUpdateLink,
        {
          'order_id': orderId,
          'delivery_id': deliveryId,
          'getDelTime': getDelTime,
          'deliveryLat': deliveryLat,
          'deliveryLong': deliveryLong,
        },
      );
      if (response['status'] == 'success') {
        return 'success';
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }

  Future<String> updateDoneOrder(
      String id, String doneCustTime, String deliveryId, String rate) async {
    try {
      PhpApi _api = PhpApi();
      var response = await _api.postRequest(
        doneorderUpdateLink,
        {
          'id': id,
          'doneCustTime': doneCustTime,
          'dId': deliveryId,
          'rate': rate,
        },
      );
      if (response['status'] == 'success') {
        return 'success';
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }

  Future<String> getRateById(String id) async {
    try {
      PhpApi _api = PhpApi();
      var response = await _api.postRequest(
        getRateByIdLink,
        {
          'id': id,
        },
      );
      if (response['status'] == 'success') {
        return 'success';
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }

   Future<List<Item>> getorderItems(String orderID) async {

    try {
      _apiItems.clear();
      final PhpApi _api = PhpApi();


      _apiItems=[];
      var res = [];
      if (orderID == 'all') {
        res = await _api.postRequest(getitemsLink, {'id': orderID});
      }else{
         res = await _api.postRequest(getorederItemsLink, {'id': orderID});
      }

      // List<dynamic> data = jsonDecode(res);

      for (Map<String, dynamic> item in res) {
        _apiItems.add(
          Item.fromJson(item),
        );
      }

      return _apiItems;
    } catch (e) {
      return jsonDecode(e.toString());
    }
  }
   Future<List<String>> getAllTypes() async {

    try {
      List<String> types = [];
      final PhpApi _api = PhpApi();


      var res = [];

      res = await _api.postRequest(getAllTypesLink,{});

      // List<dynamic> data = jsonDecode(res);

      for (Map<String, dynamic> type in res) {
        types.add(type['typeName']);
      }

      return types;
    } catch (e) {
      return jsonDecode(e.toString());
    }
  }

  static updateCustomScreen() {
    Get.off(CustomDashboard(preferences.getString('name')!,
        preferences.getString('password')!, preferences.getString('phone')!));
  }
}
