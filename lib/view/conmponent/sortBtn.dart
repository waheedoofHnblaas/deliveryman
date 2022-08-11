import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/dashSc/MainDash.dart';

Widget SortBtn(
    String text, Color TextColor, Color BtnColor, Null Function() param3) {
  return RaisedButton(
    elevation: 0,
    onPressed: param3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22.0),
    ),
    child: Text(
      text,
      style: TextStyle(color: TextColor, fontSize: 12),
    ),
    color: BtnColor,
  );
}
