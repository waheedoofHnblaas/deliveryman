import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:get/get.dart';
import 'package:google_map/model/database/api.dart';
import 'package:google_map/model/database/google_map_api.dart';
import 'package:google_map/model/oop/Item.dart';
import 'package:google_map/model/oop/Order.dart';
import 'package:google_map/model/oop/custom.dart';
import 'package:google_map/model/oop/employee.dart';
import 'package:google_map/view/conmponent/CustomTextField.dart';
import 'package:google_map/view/screens/Data_screen.dart';
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
  @override
  void initState() {
    // TODO: implement initState

    _api.deleteOrdersList();
    print('===========================');
  }

  final Api _api = Api();

  String searsh = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomeTextFeild(
                (val) {
                  setState(() {
                    searsh = val.toString();
                  });
                },
                'search',
                '',
                context,
                type: TextInputAction.none,
                auto: false,
                isNumber: TextInputType.number,
              ),
              listItems()
            ],
          ),
        ),
      ),
    ));
  }

  Widget listOrder() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: FutureBuilder<List<Order>?>(
          future: Api.getMainOrders(myLocation, context),
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              print(snapshot.data!.length);
              print('========================snapshot=============');
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  if (snapshot.data![index].orderId == searsh ||
                      searsh.isEmpty) {
                    return component(snapshot.data![index]);
                  } else {
                    return Container();
                  }
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
        height: MediaQuery.of(context).size.height * 0.8,
        child: FutureBuilder<List<Employee>?>(
          future: Api.getEmps(myLocation, context),
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              print(snapshot.data!.length);
              print('========================snapshot=============');
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  print(snapshot.data![index].phone);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(snapshot.data![index].name!),
                      leading: Text(snapshot.data![index].id!),
                      subtitle: Text(snapshot.data![index].password!),
                      trailing: Text(snapshot.data![index].phone!),
                      tileColor: Get.theme.backgroundColor,
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
        height: MediaQuery.of(context).size.height * 0.8,
        child: FutureBuilder<List<Item>?>(
          future: Api.getorderItems('all'),
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              print(snapshot.data!.length);
              print('========================snapshot=============');
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  print(snapshot.data![index].name);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(snapshot.data![index].name!),
                      leading: Text(snapshot.data![index].itemId!),
                      subtitle: Text(snapshot.data![index].info!),
                      trailing: Text(snapshot.data![index].price!),
                      tileColor: Get.theme.backgroundColor,
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

  Widget component(order) {
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
                  FutureBuilder<List<Item>>(
                    future: Api.getorderItems(order.orderId!),
                    builder: (context, itemssnap) {
                      if (itemssnap.hasData && !itemssnap.hasError) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ListView.builder(
                            shrinkWrap: true,
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
