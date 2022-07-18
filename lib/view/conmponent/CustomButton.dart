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
        child: OutlineButton(
          borderSide: BorderSide(color: Get.theme.backgroundColor
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: func,
          child: Text(content,style: TextStyle(color: Get.theme.backgroundColor),),
        ),
      ),
    ),
  );
}
