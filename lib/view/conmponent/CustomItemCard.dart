import 'package:flutter/material.dart';
import 'package:google_map/oop/Item.dart';

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
  return Card(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              Card(
                color: n >= 1 ? Colors.teal[100] : Colors.white,
                child: ListTile(
                  title: Text(
                    snapshot[index].name!,
                    style: TextStyle(fontSize: 21),
                  ),
                  subtitle: Text(snapshot[index].price! + ' \$'),
                  leading:  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(n.toString()),
                    ),
                    color: Colors.teal[100],
                  ),
                  trailing: Text(snapshot[index].weight! + ' kg'),
                ),
              )
            ],
          ),
        ),
        chl,
      ],
    ),
  );
}
