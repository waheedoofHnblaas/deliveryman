// TODO Implement this library.import 'dart:ui';
import 'package:flutter/material.dart';

Widget CustomeTextFeild(
  func,
  lab,
  String content,
  context, {
    auto = true,
      type = TextInputAction.next,
  isPassword = false,
  TextInputType isNumber = TextInputType.name,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
    child: Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
        height: 60,
        width: MediaQuery.of(context).size.width - 10,
        child: TextFormField(

            textInputAction: type,
            initialValue: content,
            keyboardType: isNumber,
            style: TextStyle(fontSize: 16),
            autofocus: auto,
            textAlign: TextAlign.center,
            cursorHeight: 25,
            obscureText: isPassword,
            decoration: InputDecoration(
              label: Text(lab),
              border: OutlineInputBorder(
                gapPadding: 5,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onChanged: (val) {
              func(val);
            }),
      ),
    ),
  );
}
