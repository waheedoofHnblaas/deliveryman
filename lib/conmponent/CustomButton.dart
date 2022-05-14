import 'package:flutter/material.dart';

Widget CustomeButton(func, String content, context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
    child: Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        color: Colors.white10,
        height: 50,
        width: MediaQuery.of(context).size.width - 100,
        child: ElevatedButton(
          onPressed: func,
          child: Text(content),
        ),
      ),
    ),
  );
}
