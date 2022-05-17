import 'package:google_map/Item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Order {
  late String deliveryUserNum;
  late bool isWaitting;
  late bool received;
  late String orderTime;
  late Marker marker;
  late String ownerUserNum;

  late List<Item> items;

  Order({
    deliveryUserNum,
    marker,
    received,
    orderTime,
    ownerUserNum,
    items,
    isWaitting,
  }) {
    this.deliveryUserNum=deliveryUserNum;
    this.marker = marker;
    this.isWaitting = isWaitting;
    this.received = received;
    this.orderTime = orderTime;
    this.ownerUserNum = ownerUserNum;
    this.items = items;
  }

//
// factory Order.fromJson(List<dynamic> json, i) {
//   return Order(
//     deliveryUser: json[i]['iswaitting'] == false ? json[i]['delivery'] : null,
//     isWaitting: json[i]['iswaitting'],
//     received: json[i]['received'],
//     orderTime: json[i]['created'],
//     marker: json[i]['marker'],
//     ownerUser: json[i]['owner'],
//     items: json[i]['items'],
//   );
// }
}
