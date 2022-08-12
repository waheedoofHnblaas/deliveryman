import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:get/get.dart';
import 'package:google_map/main.dart';
import 'package:google_map/model/database/api.dart';
import 'package:google_map/model/database/google_map_api.dart';
import 'package:google_map/model/oop/Item.dart';
import 'package:google_map/model/oop/Order.dart';
import 'package:google_map/model/oop/custom.dart';
import 'package:google_map/model/oop/employee.dart';
import 'package:google_map/view/conmponent/CustomTextField.dart';
import 'package:google_map/view/screens/Data_screen.dart';
import 'package:google_map/view/screens/addItemSc.dart';
import 'package:google_map/view/screens/authSc/Register_screen.dart';
import 'package:google_map/view/screens/dashSc/MainDash.dart';

class CustomAwesomeDrawer extends StatefulWidget {
  CustomAwesomeDrawer(this.context, this.myLocation, {Key? key})
      : super(key: key);

  late BuildContext context;
  late Position myLocation;

  @override
  State<CustomAwesomeDrawer> createState() => _CustomAwesomeDrawerState();
}

class _CustomAwesomeDrawerState extends State<CustomAwesomeDrawer> {
  final Api API = Api();

  bool orderList = true, itemList = false, empsList = false;
  String searsh = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              preferences.getString('id')=='0'?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          orderList = true;
                          itemList = false;
                          empsList = false;
                        });
                      },
                      child: Text(
                        'orders',
                        style: TextStyle(
                          color: Get.theme.backgroundColor,
                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          orderList = false;
                          itemList = true;
                          empsList = false;
                        });
                      },
                      child: Text(
                        'items',
                        style: TextStyle(color: Get.theme.backgroundColor),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          orderList = false;
                          itemList = false;
                          empsList = true;
                        });
                      },
                      child: Text(
                        'emps',
                        style: TextStyle(color: Get.theme.backgroundColor),
                      )),
                ],
              ):Text('orders',style: TextStyle(color: Get.theme.backgroundColor),),
              // CustomeTextFeild(
              //   (val) {
              //     setState(() {
              //       searsh = val.toString();
              //     });
              //   },
              //   'search',
              //   '',
              //   context,
              //   type: TextInputAction.none,
              //   auto: false,
              //   isNumber: TextInputType.number,
              // ),
              FloatingActionButton(
                  elevation: 0,
                  backgroundColor: Get.theme.primaryColor,
                  foregroundColor: Get.theme.backgroundColor,
                  child: IconButton(
                    tooltip: 'add item',
                    onPressed: () {
                      itemList
                          ? Get.to(
                              () => AddItemScreen(
                                  name: '',
                                  price: '',
                                  info: '',
                                  quant: '',
                                  type: '',
                                  weight: ''),
                            )
                          : empsList?Get.to(
                            () => Register(true),
                      ):null;
                    },
                    icon: Icon(
                      CupertinoIcons.add_circled,
                      semanticLabel: 'add item',
                      color: Get.theme.backgroundColor,
                    ),
                  ),
                  onPressed: () {}),

              orderList
                  ? listOrder()
                  : itemList
                      ? listItems()
                      : listEmps()
            ],
          ),
        ),
      ),
    );
  }

  Widget listOrder() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: FutureBuilder<List<Order>?>(
          future: API.getMainOrders(myLocation, context),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.connectionState == ConnectionState.done) {
              List<Order> _order = [];
              if (done) {
                for (Order order in snapshot.data!) {
                  if (order.isRecieved == true) {
                    _order.add(order);
                  }
                }
              } else if (wait) {
                for (Order order in snapshot.data!) {
                  if (order.isWaiting == true) {
                    _order.add(order);
                  }
                }
              } else if (withD) {
                for (Order order in snapshot.data!) {
                  if (order.isWaiting == false &&
                      order.isRecieved == false) {
                    _order.add(order);
                  }
                }
              } else {
                for (Order order in snapshot.data!) {
                  _order.add(order);
                }
              }
              return ListView.builder(
                itemCount: _order.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      component(_order[index]),
                      index==_order.length-1?
                          Container(height: 220,):Container()
                    ],
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget listEmps() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: FutureBuilder<List<Employee>?>(
          future: Api.getEmps(myLocation, context),
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(snapshot.data![index].name!),
                        leading: Text(snapshot.data![index].id!),
                        subtitle: Text(snapshot.data![index].password!),
                        trailing: Text(snapshot.data![index].phone!),
                        tileColor: Get.theme.backgroundColor,
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget listItems() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: FutureBuilder<List<Item>?>(
          future: API.getorderItems('all'),
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(
                        AddItemScreen(
                          name: snapshot.data![index].name!.toString(),
                          price: snapshot.data![index].price!.toString(),
                          info: snapshot.data![index].info!.toString(),
                          quant: snapshot.data![index].quant!.toString(),
                          type: 'type',
                          weight: snapshot.data![index].weight!.toString(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(snapshot.data![index].name!),
                        leading: Text(snapshot.data![index].quant!),
                        subtitle: Text(snapshot.data![index].info!),
                        trailing: Text(snapshot.data![index].price!+' s.p'),
                        tileColor: Get.theme.backgroundColor,
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget component(Order order) {
    var dest =  API.getDestanceBetween(position1: order.marker!.position,position2: myLocation);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Get.to(
              DataScreen(order),
            );
          },
          child: Card(
            color: !order.isWaiting! && !order.isRecieved!
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
                              future: API.getCustomNameById(order.ownerId!),
                              builder: (context, customersnap) {
                                if (!customersnap.hasData ||
                                    customersnap.hasError) {
                                  return const Text('loading...');
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
                            (!order.isWaiting! && order.isRecieved!) ||
                                    (!order.isWaiting! && !order.isRecieved!)
                                ? FutureBuilder<Employee>(
                                    future: API.getEmpNameById(
                                      order.deliveryId!,
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
                                : Container(
                                    child: const Text(
                                      '  new',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.createTime!),
                            Text(order.getDelTime!),
                            Text(order.doneCustTime!),
                            Card(
                              child: Text('id :' + order.orderId!),
                            ),
                            order.isRecieved!
                                ? const Icon(
                                    Icons.done_all,
                                    color: Colors.white,
                                  )
                                : !order.isRecieved! && !order.isWaiting!
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
                  !order.isWaiting! && !order.isRecieved!
                      ? Image.asset(
                          'lib/view/images/activeIcon.png',
                          height: 50,
                        )
                      : order.isWaiting! && !order.isRecieved!
                          ? Image.asset(
                              'lib/view/images/waitIcon.png',
                              height: 50,
                            )
                          : Image.asset(
                              'lib/view/images/doneIcon.png',
                              height: 50,
                            ),
                  Text('${dest.ceil().toString()}'+' meter'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
