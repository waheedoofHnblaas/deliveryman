
import 'package:get/get.dart';
import 'package:google_map/database/google_map_api.dart';
import 'package:google_map/main.dart';
import 'package:google_map/screens/dashSc/CustomDashboard_screen.dart';
import 'package:google_map/screens/dashSc/MainDash.dart';
import 'package:google_map/view/conmponent/CustomCirProgress.dart';
import 'package:google_map/view/conmponent/customAwesome.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Order {
  Api API = Api();
  String? orderId;
  String? ownerId;
  String? deliveryId;
  String? deliveryLat;
  String? deliveryLong;
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
      this.deliveryLat,
      this.deliveryLong,
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
    deliveryLong = json['deliveryLong']==''?'1.1':json['deliveryLong'];
    deliveryLat = json['deliveryLat']==''?'1.1':json['deliveryLat'];
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
            var owner = await API.getCustomNameById(
              json['owner_id'],
            );
            if (isEmp) {
              if (json['isWaiting'] == '1' && json['isRecieved'] == '0') {
                CustomAwesomeDialog(
                  context: context,
                  content: 'I will Arrive to ${owner.name}',
                  onOkTap: () async {
                    API
                        .updateGettingOrder(
                      json['order_id']!,
                      myLocation.latitude.toString(),
                      myLocation.longitude.toString(),
                      preferences.getString('id')!,
                      API.getNowTime(),
                    )
                        .then((value) async {
                      value == 'success'
                          ? Get.offAll(
                              MainDashboard(
                                  preferences.getString('name')!,
                                  preferences.getString('password')!,
                                  preferences.getString('phone')!),
                            )
                          : null;
                    });
                  },
                  onCancelTap: () {},
                );
              } else if (json['isWaiting'] == '0' &&
                  json['isRecieved'] == '0') {
                var owner = await API.getCustomNameById(
                  json['owner_id'],
                );
                CustomAwesomeDialog(
                  context: context,
                  content: json['delivery_id'] != preferences.getString('id')
                      ? 'with delivery man :${delivery.name}'
                      : 'with you to ${owner.name}',
                  onCancelTap: () {},
                );
              } else {
                CustomAwesomeDialog(
                  context: context,
                  content: 'your order has done by : ${delivery.name!} to ${owner.name}',
                  onCancelTap: () {},
                );
              }
            } else {
              if (json['isWaiting'] == '1' && json['isRecieved'] == '0') {
                CustomAwesomeDialog(
                  context: context,
                  content: 'delete order ?',
                  onOkTap: () async {
                    CustomeCircularProgress(context);

                    await API
                        .deleteOrder(json['order_id'].toString())
                        .then((value) {
                      value == 'success'
                          ? Get.offAll(
                              CustomDashboard(
                                  preferences.getString('name')!,
                                  preferences.getString('password')!,
                                  preferences.getString('phone')!),
                            )
                          : null;
                    });
                  },
                );
              } else if (json['isWaiting'] == '0' &&
                  json['isRecieved'] == '0') {
                CustomAwesomeDialog(
                  context: context,
                  content: 'your order with ${delivery.name} do you  get it ?',
                  onOkTap: () async {
                    await API
                        .updateDoneOrder(
                      json['order_id'].toString(),
                      API.getNowTime(),
                    )
                        .then((value) {
                      value == 'success'
                          ? Get.offAll(
                              CustomDashboard(
                                  preferences.getString('name')!,
                                  preferences.getString('password')!,
                                  preferences.getString('phone')!),
                            )
                          : null;
                    });
                  },
                  onCancelTap: () {},
                );
              } else if (json['isWaiting'] == '0' &&
                  json['isRecieved'] == '1') {
                CustomAwesomeDialog(
                  context: context,
                  content: 'your order has done by : ${delivery.name!}',
                  onCancelTap: () {},
                );
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

  Map<String, dynamic> toJson(lat, long) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner_id'] = preferences.get('id').toString();
    data['delivery_id'] = '0';
    data['deliveryLat'] = '0';
    data['deliveryLong'] = '0';
    data['isWaiting'] = '1';
    data['isRecieved'] = '0';
    data['getDelTime'] = '0';
    data['doneCustTime'] = '0';
    data['totalPrice'] = '0';
    data['lat'] = lat;
    data['long'] = long;
    data['createTime'] = API.getNowTime();
    return data;
  }
}
