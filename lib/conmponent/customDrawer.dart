import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:google_map/oop/Order.dart';
import 'package:google_map/database/api_links.dart';
import 'package:google_map/database/google_map_api.dart';
import 'package:google_map/main.dart';
import 'package:google_map/oop/employee.dart';
import 'package:google_map/screens/Data_screen.dart';
import 'package:google_map/screens/dashSc/MainDash.dart';

import '../screens/dashSc/CustomDashboard_screen.dart';

AwesomeDrawerBar CustAwesoneDrawer(context, myLocation) {
  Api API = Api();
  return AwesomeDrawerBar(
    isRTL: true,
    slideHeight: MediaQuery.of(context).size.height - 20,
    mainScreen: Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder<List<Order>>(
            future: API.getMainOrders(myLocation, context),
            builder: (context, snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: FutureBuilder<Employee>(
                          future: API.getUserNameById(
                            snapshot.data![index].ownerUserNum.toString(),
                            getCustloyeeByIdLink,
                          ),
                          builder: (context, snapshot2) {
                            if (snapshot.hasData && !snapshot.hasError) {
                              return ListTile(
                                leading: snapshot.data![index].received
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : Icon(
                                        Icons.highlight_remove_outlined,
                                        color: Colors.red,
                                      ),
                                title: Text(snapshot2.data!.name!),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(snapshot2.data!.phone!),
                                      Icon(
                                        Icons.phone,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                    );
                  },
                  itemCount: API.apiOrders.length,
                );
              } else if (snapshot.data == []) {
                return Text('no orders yet ...');
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    ),
    menuScreen: MainDashboard(
      preferences.getString('name')!,
      preferences.getString('password')!,
      preferences.getString('phone')!,
    ),
    type: StyleState.rotate3dOut,
    borderRadius: 24.0,
    showShadow: true,
    angle: -12.0,
    backgroundColor: Colors.blue,
    openCurve: Curves.fastOutSlowIn,
    closeCurve: Curves.bounceIn,
  );
}
