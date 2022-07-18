// TODO Implement this library.import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:get/get.dart';

Future CustomeCircularProgress(context) {
  return Get.dialog(
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}
