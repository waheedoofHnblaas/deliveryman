import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/model/oop/Item.dart';

Widget CustomItemCard(
  context,
  List<Item> snapshot,
  int index,
  Widget chl,
  String? count,
) {
  int n = 0;
  if (count != null && count != '') {
    n = int.parse(count);
  } else {
    n = 0;
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListTile(
          tileColor: n >= 1 ? Colors.teal[100] : Colors.white,
          title: Text(
            snapshot[index].name!,
            style: TextStyle(fontSize: 21, color: Get.theme.primaryColor),
          ),
          subtitle: Text(
            snapshot[index].weight! + ' kg',
            style: TextStyle(fontSize: 11, color: Get.theme.primaryColor),
          ),
          leading: Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                n.toString(),
                style: TextStyle(fontSize: 18, color: Get.theme.backgroundColor),
              ),
            ),
            color: Get.theme.primaryColor,
          ),
          trailing: Text(
            snapshot[index].price! + ' \$',
            style: TextStyle(fontSize: 21,color: Get.theme.primaryColor),
          ),
        ),
      ),
      chl,
    ],
  );
}
