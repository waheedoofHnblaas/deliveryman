import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';

CustomAwesomeDialog(
    {title, required context, required content, type, onOkTap, onCancelTap}) {
  AwesomeDialog(
    dialogBackgroundColor: Get.theme.primaryColor,
    context: context,
    title: title,
    titleTextStyle: TextStyle(color: Get.theme.primaryColor),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Get.theme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Text(
              content,
              style: TextStyle(fontSize: 21, color: Get.theme.backgroundColor),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    ),
    btnOkText: title,
    buttonsTextStyle: TextStyle(color: Get.theme.primaryColor),
    btnOkOnPress: onOkTap,
    btnCancelText: 'make call',
    btnCancelIcon: Icons.phone,
    btnCancelColor: Get.theme.backgroundColor,
    animType: AnimType.SCALE,
    btnCancelOnPress: onCancelTap,
  ).show();
}
