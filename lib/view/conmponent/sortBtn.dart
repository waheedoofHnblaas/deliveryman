import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/dashSc/MainDash.dart';

Widget SortBtn(
    String text, Color TextColor, Color BtnColor, Null Function() param3) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Stack(
      children: [
        RotatedBox(
          quarterTurns: 1,
          child: RaisedButton(
              onPressed: param3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                text,
                style: TextStyle(color: TextColor),
              ),
              color: BtnColor),
        ),
        text == 'with delivery'
            ? Positioned(
                bottom: 10,right: 10,
                left: 10,
                child: Center(
                  child: Container(
                    child: LinearProgressIndicator(color: Colors.greenAccent,backgroundColor: BtnColor),

                  ),
                ))
            : Container()
      ],
    ),
  );
}
