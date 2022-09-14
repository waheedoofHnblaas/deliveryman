import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget CustomeButton(func, String content, context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
    child: Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 100,
        child: OutlinedButton(

          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(33.0),
            ),
            side: BorderSide(color: Get.theme.backgroundColor
            ),
          ),

          onPressed: func,
          child: Text(content,style: TextStyle(color: Get.theme.backgroundColor),),
        ),
      ),
    ),
  );
}
