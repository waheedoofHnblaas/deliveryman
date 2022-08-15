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
import 'package:google_map/view/screens/updateItem.dart';

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

  bool orderList = true, itemList = false, empsList = false, searchId = false;
  String searsh = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: Center(
        child: Stack(
          children: [

            Container(
              child: orderList
                  ? listOrder()
                  : itemList
                      ? listItems()
                      : listEmps(),
            ),
            Positioned(
              bottom: 30,
              child: Center(
                child: preferences.getString('id') == '0'
                    ? Card(
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(11),
                                right: Radius.circular(11))),
                        margin:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 0),
                        color: Get.theme.primaryColor.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    orderList = true;
                                    itemList = false;
                                    empsList = false;
                                    searchId = false;
                                    searsh = '';
                                  });
                                },
                                elevation: 0,
                                color: orderList
                                    ? Get.theme.backgroundColor
                                    : Get.theme.primaryColor,
                                child: Text(
                                  'orders',
                                  style: TextStyle(
                                    color: orderList
                                        ? Get.theme.primaryColor
                                        : Get.theme.backgroundColor,
                                  ),
                                ),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    orderList = false;
                                    itemList = true;
                                    empsList = false;
                                  });
                                },
                                elevation: 0,
                                color: itemList
                                    ? Get.theme.backgroundColor
                                    : Get.theme.primaryColor,
                                child: Text(
                                  'items',
                                  style: TextStyle(
                                    color: itemList
                                        ? Get.theme.primaryColor
                                        : Get.theme.backgroundColor,
                                  ),
                                ),
                              ),
                              RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      orderList = false;
                                      itemList = false;
                                      empsList = true;
                                    });
                                  },
                                  elevation: 0,
                                  color: empsList
                                      ? Get.theme.backgroundColor
                                      : Get.theme.primaryColor,
                                  child: Text(
                                    'emps',
                                    style: TextStyle(
                                      color: empsList
                                          ? Get.theme.primaryColor
                                          : Get.theme.backgroundColor,
                                    ),
                                  )),
                              !orderList
                                  ? SizedBox(
                                      height: Get.height * .08,
                                      child: FloatingActionButton(
                                          elevation: 0,
                                          backgroundColor: Get
                                              .theme.primaryColor
                                              .withOpacity(0.1),
                                          foregroundColor:
                                              Get.theme.backgroundColor,
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
                                                        weight: '',
                                                      ),
                                                    )?.whenComplete(() {
                                                      setState(() {});
                                                    })
                                                  : empsList
                                                      ? Get.to(
                                                          () => Register(true),
                                                        )!.whenComplete(() {
                                                          setState(() {

                                                          });
                                              })
                                                      : null;
                                            },
                                            icon: Icon(
                                              CupertinoIcons.add,
                                              semanticLabel: 'add item',
                                              color: Get.theme.backgroundColor,
                                            ),
                                          ),
                                          onPressed: () {}),
                                    )
                                  : SizedBox(
                                      height: Get.height * .08,
                                      child: FloatingActionButton(
                                          elevation: 0,
                                          backgroundColor: Get
                                              .theme.primaryColor
                                              .withOpacity(0.1),
                                          foregroundColor:
                                              Get.theme.backgroundColor,
                                          child: IconButton(
                                            tooltip: 'search order',
                                            onPressed: () {
                                              setState(() {
                                                searchId = !searchId;
                                                if (!searchId) {
                                                  searsh = '';
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              !searchId
                                                  ? CupertinoIcons.search
                                                  : Icons.keyboard_arrow_down,
                                              semanticLabel: 'search item',
                                              color: Get.theme.backgroundColor,
                                            ),
                                          ),
                                          onPressed: () {}),
                                    ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '',
                          style: TextStyle(
                              color: Get.theme.backgroundColor, fontSize: 21),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listOrder() {
    return SingleChildScrollView(
      child: Column(
        children: [
          searchId
              ? CustomeTextFeild((s) {
                  setState(() {
                    searsh = s;
                  });
                }, 'Order Id', '', context,
                  auto: true, isNumber: TextInputType.number)
              : Container(),
          SizedBox(
              height: Get.height * 0.8,
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
                    if (searsh.isNotEmpty) {
                      for (Order order in snapshot.data!) {
                        if (order.orderId != searsh) {
                          _order.remove(order);
                        }
                      }
                    }
                    if (_order.isEmpty) {
                      return const Center(
                        child: Card(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('empty'),
                        )),
                      );
                    } else {
                      return ListView.builder(itemExtent: 100,
                        itemCount: _order.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              component(_order[index]),
                              index == _order.length - 1
                                  ? Container(
                                      height: 220,
                                    )
                                  : Container()
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )),
        ],
      ),
    );
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
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Card(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('empty'),
                      )),
                    );
                  } else {
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
                  }
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
        height: Get.height * 0.9,
        child: FutureBuilder<List<Item>?>(
          future: API.getorderItems('all'),
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(
                            () => UpdateItemScreen(
                              name: snapshot.data![index].name.toString(),
                              price: snapshot.data![index].price.toString(),
                              info: snapshot.data![index].info.toString(),
                              quant: snapshot.data![index].quant.toString(),
                              type: 'type',
                              weight: snapshot.data![index].weight.toString(),
                            ),
                          )?.whenComplete(() {
                            return setState(() {});
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.black),
                            ),
                            title: Text(snapshot.data![index].name!),
                            leading: Text(snapshot.data![index].quant!),
                            subtitle: Text(snapshot.data![index].info!),
                            trailing:
                                Text(snapshot.data![index].price! + ' s.p'),
                            tileColor: Get.theme.backgroundColor,
                          ),
                        ),
                      ),
                      index == snapshot.data!.length - 1
                          ? SizedBox(
                              height: Get.height * 0.25,
                            )
                          : Container()
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

  Widget component(Order order) {
    var dest = API.getDestanceBetween(
        position1: order.marker!.position, position2: myLocation);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.28,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Get.to(
              DataScreen(order),
            );
          },
          child: ListTile(
              tileColor: !order.isWaiting! && !order.isRecieved!
                  ? Get.theme.backgroundColor.withGreen(200)
                  : !order.isWaiting! && order.isRecieved!
                      ? Get.theme.backgroundColor.withOpacity(0.3)
                      : Get.theme.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: Get.width * 0.5,
                            child: FutureBuilder<Customer>(
                              future: API.getCustomNameById(order.ownerId!),
                              builder: (context, customersnap) {
                                if (!customersnap.hasData ||
                                    customersnap.hasError) {
                                  return const Text('loading...');
                                } else {
                                  return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              'Customer :  ${customersnap.data!.name!}')));
                                }
                              },
                            ),
                          ),
                          (!order.isWaiting! && order.isRecieved!) ||
                                  (!order.isWaiting! && !order.isRecieved!)
                              ? SizedBox(
                                  width: Get.width * 0.5,
                                  child: FutureBuilder<Employee>(
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
                                                'Employee :  ${employeesnap.data!.name!}'),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                )
                              : Container(
                                  child: const Text(
                                    '  new',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: !order.isWaiting! && !order.isRecieved!
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
                          ),
                          Text('${dest.ceil().toString()}' + ' meter'),
                        ],
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('create:' + order.createTime!),
                            Text('get    : ' + order.getDelTime!),
                            Text('done  :' + order.doneCustTime!),
                          ],
                        ),
                      ),
                      Card(
                        child: Text('id :' + order.orderId!),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
