import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_map/main.dart';
import 'package:google_map/model/database/api.dart';
import 'package:google_map/model/database/api_links.dart';
import 'package:google_map/model/database/google_map_api.dart';
import 'package:google_map/view/conmponent/CustomButton.dart';
import 'package:google_map/view/conmponent/CustomCirProgress.dart';
import 'package:google_map/view/conmponent/CustomTextField.dart';
import 'package:google_map/view/conmponent/customAwesome.dart';
import 'package:google_map/view/screens/dashSc/MainDash.dart';

class AddItemScreen extends StatefulWidget {
  AddItemScreen({
    Key? key,
    required this.name,
    required this.price,
    required this.info,
    required this.quant,
    required this.type,
    required this.weight,
  }) : super(key: key);

  String name = '', price = '', type = '', weight = '', info = '', quant = '';

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final PhpApi _phpapi = PhpApi();
  final Api _api = Api();

  addItem() async {
    CustomeCircularProgress(context);
    try {
      var response = await _phpapi.postRequest(
        addItemLink,
        {
          'name': widget.name,
          'price': widget.price,
          'type': widget.type,
          'weight': widget.weight,
          'info': widget.info,
          'quant': widget.quant,
        },
      );

      Get.back();
      if (response['status'] == 'item is here') {
        CustomAwesomeDialog(context: context, content: 'item is her');
      } else if (response['status'] == 'success') {
        Get.offAll(MainDashboard(
            preferences.getString('name')!,
            preferences.getString('password')!,
            preferences.getString('phone')!));
      } else {
        CustomAwesomeDialog(
            context: context, content: 'network connection less');
      }
    } catch (e) {
      CustomAwesomeDialog(context: context, content: 'network error');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        title: Text('add item'),
        leading: IconButton(
          iconSize: 25,
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            CupertinoIcons.back,
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Get.theme.backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(33)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: (MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).viewInsets.bottom) *
                              .2,
                          child: Hero(
                              tag: 'icon',
                              child: Image.asset(
                                  'lib/view/images/deliveryGif.gif')),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomeTextFeild((v) {
                          setState(() {
                            widget.name = v;
                          });
                        }, 'item name', widget.name, context,
                            readOnly: widget.quant != '' ? true : false,
                            auto: widget.quant != '' ? false : true),
                        widget.quant != ''
                            ? const Text(
                                'edit',
                                style: TextStyle(color: Colors.red),
                              )
                            : Container(),
                        CustomeTextFeild(
                          (v) {
                            setState(() {
                              widget.price = v;
                            });
                          },
                          'item price',
                          widget.price,
                          context,
                          isNumber: TextInputType.number,auto: true
                        ),
                        widget.quant != ''
                            ? const Text(
                          'edit',
                          style: TextStyle(color: Colors.red),
                        )
                            : Container(),
                        CustomeTextFeild(
                              (v) {
                            setState(() {
                              widget.quant = v;
                            });
                          },
                          'item size ${widget.quant} +',
                          '0',
                          context,
                          isNumber: TextInputType.number,
                        ),
                        SizedBox(
                          height: 44,
                          child: FutureBuilder<List<String>?>(
                            future: _api.getAllTypes(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    if (snapshot.hasData &&
                                        !snapshot.hasError &&
                                        snapshot.data!.isNotEmpty) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            widget.type = snapshot.data![index]
                                                .toString();
                                          });
                                        },
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snapshot.data![index],
                                              style: TextStyle(
                                                  color:
                                                      Get.theme.backgroundColor,
                                                  fontSize: 11),
                                            ),
                                          ),
                                          color: Get.theme.primaryColor,
                                        ),
                                      );
                                    } else {
                                      return const SizedBox(
                                        height: 20,
                                        child: LinearProgressIndicator(),
                                      );
                                    }
                                  },
                                );
                              } else {
                                return LinearProgressIndicator(
                                  color: Get.theme.primaryColor,
                                );
                              }
                            },
                          ),
                        ),
                        CustomeTextFeild(
                          (v) {
                            setState(() {
                              widget.type = v;
                            });
                          },
                          'item type',
                          widget.type.toString(),
                          context,
                          readOnly: widget.quant != '' ? true : false,
                        ),
                        CustomeTextFeild(
                          (v) {
                            setState(() {
                              widget.info = v;
                            });
                          },
                          'item information',
                          widget.info,
                          context,
                          readOnly: widget.quant != '' ? true : false,
                        ),
                        CustomeTextFeild((v) {
                          setState(() {
                            widget.weight = v;
                          });
                        }, 'item weight', widget.weight, context,
                            readOnly: widget.quant != '' ? true : false,
                            isNumber: TextInputType.number),
                      ],
                    ),
                  ),
                ),
                CustomeButton(
                  () async {
                    await addItem();
                  },
                  'add Item',
                  context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
