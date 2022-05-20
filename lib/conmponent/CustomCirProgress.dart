// TODO Implement this library.import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';

Future CustomeCircularProgress(context) {
  return AwesomeDialog(
          width: MediaQuery.of(context).size.width / 2,
          context: context,
          dialogType: DialogType.NO_HEADER,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          animType: AnimType.SCALE)
      .show();
}
