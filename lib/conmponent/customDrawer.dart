import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:get/get.dart';
import 'package:google_map/conmponent/CustomTextField.dart';
import 'package:google_map/oop/Item.dart';
import 'package:google_map/oop/Order.dart';
import 'package:google_map/database/google_map_api.dart';
import 'package:google_map/main.dart';
import 'package:google_map/oop/custom.dart';
import 'package:google_map/oop/employee.dart';
import 'package:google_map/screens/Data_screen.dart';
import 'package:google_map/screens/dashSc/MainDash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomAwesomeDrawer extends StatefulWidget {
  CustomAwesomeDrawer(this.context, this.myLocation, this._order);

  late BuildContext context;
  late Position myLocation;
  late List<Order> _order;

  @override
  State<CustomAwesomeDrawer> createState() => _CustomAwesomeDrawerState();
}

class _CustomAwesomeDrawerState extends State<CustomAwesomeDrawer> {
  String searsh = '';

  @override
  void initState() {
    // TODO: implement initState

    print(widget._order);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AwesomeDrawerBar(
      isRTL: true,
      slideHeight: MediaQuery.of(context).size.height - 20,
      mainScreen: Scaffold(
        backgroundColor: Get.theme.primaryColor,
        appBar: AppBar(
          actions: [],
          leading: IconButton(
            iconSize: 25,
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              CupertinoIcons.back,
            ),
          ),
          title: const Text(
            'Orders',
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomeTextFeild((val) {
                  setState(() {
                    searsh = val.toString();
                    print(val);
                  });
                }, 'search', '', context,
                    type: TextInputAction.none,
                    auto: false,
                    isNumber: TextInputType.number),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(widget._order.length, (i) {
                        print(i);
                        if (searsh.isEmpty) {
                          return component(i);
                        } else if (searsh.isNotEmpty) {
                          if (searsh != widget._order[i].orderId.toString()) {
                            return Container();
                          } else {
                            return component(i);
                          }
                        } else {
                          return Container();
                        }
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      menuScreen: MainDashboard(
        preferences.getString('name')!,
        preferences.getString('password')!,
        preferences.getString('phone')!,
      ),
      type: StyleState.popUp,
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,
      backgroundColor: Colors.blue,
      openCurve: Curves.easeInOutBack,
      closeCurve: Curves.bounceIn,
    ));
  }

  Widget component(i) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Get.to(
              DataScreen(widget._order[i]),
            );
          },
          child: Card(
            color: !widget._order[i].isWaiting! && !widget._order[i].isRecieved!
                ? Colors.lightGreenAccent
                : Get.theme.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<Customer>(
                              future: Api.getCustomNameById(
                                  widget._order[i].ownerId!),
                              builder: (context, customersnap) {
                                if (!customersnap.hasData ||
                                    customersnap.hasError) {
                                  return Container();
                                } else {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          'Customer :${customersnap.data!.name!}'),
                                    ),
                                  );
                                }
                              },
                            ),
                            !widget._order[i].isWaiting!
                                ? FutureBuilder<Employee>(
                                    future: Api.getEmpNameById(
                                      widget._order[i].deliveryId!,
                                    ),
                                    builder: (context, employeesnap) {
                                      if (!employeesnap.hasData ||
                                          employeesnap.hasError) {
                                        return Container();
                                      } else {
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                'Employee :${employeesnap.data!.name!}'),
                                          ),
                                        );
                                      }
                                    },
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget._order[i].createTime!),
                            Text(widget._order[i].getDelTime!),
                            Text(widget._order[i].doneCustTime!),
                            Card(
                              child: Text('id :' + widget._order[i].orderId!),
                            ),
                            widget._order[i].isRecieved!
                                ? const Icon(
                                    Icons.done_all,
                                    color: Colors.white,
                                  )
                                : !widget._order[i].isRecieved! &&
                                        !widget._order[i].isWaiting!
                                    ? const Icon(
                                        Icons.done_all,
                                        color: Colors.lightGreenAccent,
                                      )
                                    : const Icon(
                                        Icons.done,
                                        color: Colors.red,
                                      )
                          ],
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<List<Item>>(
                    future: Api.getorderItems(widget._order[i].orderId!),
                    builder: (context, itemssnap) {
                      if (itemssnap.hasData && !itemssnap.hasError) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: itemssnap.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white54,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        itemssnap.data![index].name!,
                                      ),
                                      Text(
                                        itemssnap.data![index].count!,
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
      ),
    );
  }
}
