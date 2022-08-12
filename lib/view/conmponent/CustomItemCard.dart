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
      Container(
  color: Get.theme.backgroundColor,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ListTile(
                    tileColor: n >= 1 ? Colors.teal[100] : Colors.white,
                    title: Text(
                      snapshot[index].name!,
                      style: TextStyle(fontSize: 26, color: Get.theme.primaryColor),
                    ),
                    subtitle: Text(
                      snapshot[index].weight! + ' kg',
                      style: TextStyle(fontSize: 11, color: Get.theme.primaryColor),
                    ),


                    trailing: Text(
                      snapshot[index].price! + ' sp',
                      style: TextStyle(fontSize: 16,color: Get.theme.primaryColor),
                    ),
                  ),
                ),

              ],
            ),

            Row(
              children: [
                SizedBox(
                  width: Get.width*0.5,
                  child: Slider(
                      autofocus: true,
                      activeColor: Get.theme.primaryColor,
                      onChangeEnd: (i) async {

                      },
                      value: double.parse(n.toString()),
                      label: 'count',
                      divisions: 1000,
                      max: double.parse(
                          snapshot[index].quant??'0'),
                      min: 0,
                      onChanged: (i) {

                      }),
                ),
                Text(
                  '${n.toString()}/${snapshot[index].quant}',
                  style: TextStyle(fontSize: 18, color: Get.theme.primaryColor),
                )
              ],
            ),
            Divider(height: 1,color: Get.theme.primaryColor,)
          ],
        ),
      ),
      chl,
    ],
  );
}
