import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/dashSc/MainDash.dart';



Widget SortBtn(String text,Color Textcolor,Color BtnColor, Null Function() param3){
  return Padding(
padding:  EdgeInsets.all(8.0),
child: RotatedBox(
quarterTurns: 1,
child: RaisedButton(
onPressed: param3,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(30.0),
),
child: Text(
  text,
style: TextStyle(
color: Textcolor
),
),
color: BtnColor
),
),
);
}