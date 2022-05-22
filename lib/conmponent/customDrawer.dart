import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:get/get.dart';
import 'package:google_map/conmponent/CustomCirProgress.dart';
import 'package:google_map/oop/Item.dart';
import 'package:google_map/oop/Order.dart';
import 'package:google_map/database/api_links.dart';
import 'package:google_map/database/google_map_api.dart';
import 'package:google_map/main.dart';
import 'package:google_map/oop/custom.dart';
import 'package:google_map/oop/employee.dart';
import 'package:google_map/screens/Data_screen.dart';
import 'package:google_map/screens/dashSc/MainDash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

AwesomeDrawerBar CustomAwesomeDrawer(context, myLocation) {
  Api API = Api();

  return AwesomeDrawerBar(
    isRTL: true,
    slideHeight: MediaQuery.of(context).size.height - 20,
    mainScreen: Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 25,
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            CupertinoIcons.back,
          ),
        ),
        title: const Text('all orders'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<Order>>(
          future: API.getMainOrders(myLocation, context),
          builder: (context, ordersnap) {
            if (ordersnap.hasData && !ordersnap.hasError) {
              return ListView.builder(
                itemCount: ordersnap.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Get.to(
                          DataScreen(
                            CameraPosition(
                              target: LatLng(
                                ordersnap
                                    .data![index].marker!.position.latitude,
                                ordersnap
                                    .data![index].marker!.position.longitude,
                              ),
                              zoom: 14,
                            ),
                            ordersnap.data![index].marker!,
                          ),
                        );
                      },
                      child: Card(
                        color: Get.theme.backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder<Customer>(
                                          future: API.getCustomNameById(
                                              ordersnap.data![index].ownerId!),
                                          builder: (context, customersnap) {
                                            if (customersnap.hasData &&
                                                !customersnap.hasError) {
                                              return Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'Customer :${customersnap.data!.name!}'),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                        FutureBuilder<Employee>(
                                          future: API.getEmpNameById(ordersnap
                                              .data![index].deliveryId!),
                                          builder: (context, employeesnap) {
                                            if (employeesnap.hasData &&
                                                !employeesnap.hasError) {
                                              return Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'Employee :${employeesnap.data!.name!}'),
                                                ),
                                              );
                                            } else
                                              return Container();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            ordersnap.data![index].createTime!),
                                        Text(
                                            ordersnap.data![index].getDelTime!),
                                        Text(ordersnap
                                            .data![index].doneCustTime!),
                                        ordersnap.data![index].isRecieved!
                                            ? const Icon(
                                                Icons.done_all,
                                                color: Colors.white,
                                              )
                                            : !ordersnap.data![index]
                                                        .isRecieved! &&
                                                    !ordersnap
                                                        .data![index].isWaiting!
                                                ? const Icon(
                                                    Icons.done_all,
                                                    color: Colors.grey,
                                                  )
                                                : const Icon(
                                                    Icons.done,
                                                    color: Colors.grey,
                                                  )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              FutureBuilder<List<Item>>(
                                future: API.getorderItems(
                                    ordersnap.data![index].orderId!),
                                builder: (context, itemssnap) {
                                  if (itemssnap.hasData &&
                                      !itemssnap.hasError) {
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: itemssnap.data!.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            color: Colors.white54,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '${itemssnap.data![index].name!}',
                                                  ),
                                                  Text(
                                                    '${itemssnap.data![index].count!}',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else
                                    return Container();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
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
