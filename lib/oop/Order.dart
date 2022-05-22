import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/conmponent/customAwesome.dart';
import 'package:google_map/database/api.dart';
import 'package:google_map/database/api_links.dart';
import 'package:google_map/database/google_map_api.dart';
import 'package:google_map/main.dart';
import 'package:google_map/oop/employee.dart';
import 'package:google_map/screens/dashSc/CustomDashboard_screen.dart';
import 'package:google_map/screens/dashSc/MainDash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Order {
  Api API = Api();
  String? orderId;
  String? ownerId;
  String? deliveryId;
  bool? isWaiting;
  bool? isRecieved;
  Marker? marker;
  String? createTime;
  String? getDelTime;
  String? doneCustTime;
  String? totalPrice;

  Order(
      {this.orderId,
      this.ownerId,
      this.deliveryId,
      this.isWaiting,
      this.isRecieved,
      this.marker,
      this.createTime,
      this.getDelTime,
      this.doneCustTime,
      this.totalPrice});

  Order.fromJson(
    Map<String, dynamic> json,
    context,
    String itemsName,
    isEmp,
    BitmapDescriptor waitIcon,
    BitmapDescriptor activeIcon,
    BitmapDescriptor doneIcon,
  ) {
    orderId = json['order_id'];
    ownerId = json['owner_id'];
    deliveryId = json['delivery_id'];
    isWaiting = json['isWaiting'] == '0' ? false : true;

    isRecieved = json['isRecieved'] == '0' ? false : true;
    marker = Marker(
      // rotation: json['isWaiting'] == '1'
      //     ? 0
      //     : json['isRecieved'] == '1'
      //         ? 180
      //         : 90,
      infoWindow: InfoWindow(
          onTap: () async {
            var delivery = await API.getEmpNameById(
              json['delivery_id'],
            );
            if (isEmp) {
              if (json['isWaiting'] == '1' && json['isRecieved'] == '0') {
                CustomAwesomeDialog(
                    context: context,
                    content: 'I will Arrive',
                    onOkTap: () async {
                      API
                          .updateGettingOrder(json['order_id'],
                              preferences.getString('id')!, getNowTime())
                          .then((value) async {
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
                    });
              } else if (json['isWaiting'] == '0' &&
                  json['isRecieved'] == '0') {
                CustomAwesomeDialog(
                  context: context,
                  content: json['delivery_id'] != preferences.getString('id')
                      ? 'with delivery man :${delivery.name}'
                      : 'with you',
                );
              } else {
                CustomAwesomeDialog(
                    context: context,
                    content: 'your order has done by : ${delivery.name!}');
              }
            } else {
              if (json['isWaiting'] == '1' && json['isRecieved'] == '0') {
                AwesomeDialog(
                    context: context,
                    btnCancelText: 'delete',
                    btnCancelOnPress: () async {
                      CustomeCircularProgress(context);

                      await API
                          .deleteOrder(json['order_id'].toString())
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
              } else if (json['isWaiting'] == '0' &&
                  json['isRecieved'] == '0') {
                AwesomeDialog(
                    context: context,
                    btnOkText: 'i get it',
                    btnOkOnPress: () async {
                      await API
                          .updateDoneOrder(
                        json['order_id'].toString(),
                        getNowTime(),
                      )
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
                      child: Text('your order has done by : ${delivery.name!}'
                          ''),
                    )).show();
              }
            }
          },
          snippet: itemsName + '  id :' + json['order_id'].toString(),
          title: '${json['createTime']}'),

      icon: json['isRecieved'] == '1'
          ? doneIcon
          : json['isWaiting'] == '1'
              ? waitIcon
              : activeIcon,
      markerId: MarkerId(json['order_id']),
      position: LatLng(
        double.parse(json['lat']),
        double.parse(
          json['long'],
        ),
      ),
    );
    createTime = json['createTime'].toString();
    getDelTime = json['getDelTime'] == '0' ? '' : json['getDelTime'];
    doneCustTime = json['doneCustTime'] == '0' ? '' : json['doneCustTime'];
    totalPrice = json['totalPrice'];
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['order_id'] = this.orderId;
//   data['owner_id'] = this.ownerId;
//   data['delivery_id'] = this.deliveryId;
//   data['isWaiting'] = this.isWaiting;
//   data['isRecieved'] = this.isRecieved;
//   data['lat'] = this.lat;
//   data['long'] = this.long;
//   data['createTime'] = this.createTime;
//   data['getDelTime'] = this.getDelTime;
//   data['doneCustTime'] = this.doneCustTime;
//   data['totalPrice'] = this.totalPrice;
//   return data;
// }
}

String getNowTime() {
  return '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}'
      '  ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
}
