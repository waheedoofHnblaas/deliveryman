import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';

CustomAwesomeDialog(
    {title, required context, required content, type, onOkTap, onCancelTap}) {
  AwesomeDialog(
    dialogBackgroundColor: Get.theme.primaryColor,
    context: context,
    title: title,
    body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Text(
          content,
          style: TextStyle(fontSize: 21, color: Get.theme.backgroundColor),
          textAlign: TextAlign.center,
        ),
      ),
    ),
    btnOkText: title,
    btnOkOnPress: onOkTap,
    btnCancelOnPress: onCancelTap,
  ).show();
}
