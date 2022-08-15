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
import 'package:google_map/view/screens/dashSc/MainDash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  double getDestanceBetween({position1, position2}) {
    LatLng position11 = LatLng(position1.latitude, position1.longitude);
    LatLng position22 = LatLng(position2.latitude, position2.longitude);

    double cl = Geolocator.distanceBetween(position11.latitude,
        position11.longitude, position22.latitude, position22.longitude);
    return cl;
  }

  int getDestanceMyLocationToOrder(Position mylocation, LatLng latLng) {
    LatLng position = LatLng(latLng.latitude, latLng.longitude);
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

  static List<Item> _apiItems = [];
  static List<int> OrderIds = [];

  Future<List<Order>?> getMainOrders(Position mylocation, context) async {
    List<Order> apiOrders = [];

    try {
      apiOrders = [];
      apiOrders.clear();

      PhpApi _phpApi = PhpApi();
      final data = await _phpApi.getRequest(getordersLink);

      for (Map<String, dynamic> data2 in data) {
        print('------------------');
        print(data2);
      }
      print('++++++++++++++++++++getMainOrders++++++++++++++++++++++++');
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
          apiOrders.add(
            Order.fromJson(
                order,
                context,
                itemsName,
                true,
                waitIcon,
                activeIcon,
                doneIcon),
          );
        }
      }
      apiOrders.forEach((element) {
        apiOrders.sort((a, b) {
          return  API
              .getDestanceBetween(
              position1: myLocation,
              position2: a.marker!.position)
              .compareTo(API.getDestanceBetween(
              position1: myLocation,
              position2: b.marker!.position));
        },);
      });
      return apiOrders;
    } catch (e) {
      CustomAwesomeDialog(
          context: context,
          content: 'no internet or server error',
          onOkTap: () {

            Get.off(MainDashboard(preferences.getString('name')!,
                preferences.getString('password')!, preferences.getString('phone')!));
          });
      return [];
    }
  }

  static Future<List<Employee>?> getEmps(Position mylocation, context) async {
    List<Employee> emps = [];
    try {
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
            Get.off(MainDashboard(preferences.getString('name')!,
                preferences.getString('password')!, preferences.getString('phone')!));
          });
      return [];
    }
  }

  static Future<List<Order>> getMyOrders(Position mylocation, context,
      String ownerId) async {
    List<Order> apiOrders = [];

    try {
      apiOrders.clear();
      // var respons = await http.get(Uri.parse(getordersLink));
      final PhpApi _api = PhpApi();

      final data =
      await _api.postRequest(getordersByOwnerIdLink, {'id': ownerId});

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
        apiOrders.add(
          Order.fromJson(
              order,
              context,
              itemsName,
              false,
              waitIcon,
              activeIcon,
              doneIcon),
        );
      }
      return apiOrders;
    } catch (e) {
      CustomAwesomeDialog(
          context: context,
          content: 'no internet or server error',
          onOkTap: () {
            Get.off(CustomDashboard(preferences.getString('name')!,
                preferences.getString('password')!, preferences.getString('phone')!));
          });
      return [];
    }
  }

  Future<Employee> getEmpNameById(String Id,) async {
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
    return '${DateTime
        .now()
        .year}/${DateTime
        .now()
        .month}/${DateTime
        .now()
        .day}'
        '  ${DateTime
        .now()
        .hour}:${DateTime
        .now()
        .minute}:${DateTime
        .now()
        .second}';
  }

  Future<Customer> getCustomNameById(String Id,) async {
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

 Order getCloserOrder(Order order, List<Order> orders) {
    Order _order = order;
    orders.remove(order);
    double dest = getDestanceBetween(
        position1: order.marker!.position,
        position2: orders[1].marker!.position);
    orders.forEach((element) {
      if (dest > getDestanceBetween(position1: order.marker!.position,
          position2: element.marker!.position)){
        dest = getDestanceBetween(position1: order.marker!.position,
            position2: element.marker!.position);
        _order = element;
      };
    });
    return _order;
  }
  //
  // Future<List<Order>?> BFS(context) async {
  //   Api API = Api();
  //   List<Order> _orders = (await API.getMainOrders(myLocation, context))!;
  //   List<Order> _waitOrders = [];
  //
  //   int i = 0;
  //   Order shortOrder = _orders[0];
  //   var shortDest = getDestanceBetween(
  //       position2: _orders[1].marker!.position,
  //       position1: shortOrder.marker!.position);
  //   _orders.forEach((element) {
  //     if (element.isWaiting!) _waitOrders.add(element);
  //   });
  //
  //   _waitOrders.forEach((element) {
  //
  //     print(element.orderId);
  //     print(getCloserOrder(element, _waitOrders).orderId);
  //     print('element.orderId==============================');
  //   });
  //
  //   _waitOrders.forEach((element) {
  //   });
  //   return _waitOrders;
  // }

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

  Future<String> updateGettingOrder(String orderId,
      deliveryLat,
      deliveryLong,
      String deliveryId,
      String getDelTime,) async {
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

  Future<String> updateDoneOrder(String id, String doneCustTime,
      String deliveryId, String rate) async {
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

      _apiItems = [];
      var res = [];
      if (orderID == 'all') {
        res = await _api.postRequest(getitemsLink, {'id': orderID});
      } else {
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

  Future<List<Map<String,String>>?> getAllTypes() async {
    try {
    List<Map<String,String>>? types = [];
      final PhpApi _api = PhpApi();

      var res = [];

      res = await _api.postRequest(getAllTypesLink, {});

      // List<dynamic> data = jsonDecode(res);

      for (Map<String, dynamic> type in res) {
    
        types.add({type['typeId']:type['typeName']});
      }
    print(res);

      return types;
    } catch (e) {
      return jsonDecode(e.toString());
    }
  }


}
