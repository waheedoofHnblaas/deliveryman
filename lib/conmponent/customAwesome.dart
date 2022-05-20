import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

 CustomAwesomeDialog(
    {title, required context, required content, type, onOkTap, onCancelTap}) {
   AwesomeDialog(
    context: context,
    title: title,
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(content,style: TextStyle(fontSize: 21),),
    ),
    btnOkText: title,
    btnOkOnPress: onOkTap,
    btnCancelOnPress: onCancelTap,
  ).show();
}
