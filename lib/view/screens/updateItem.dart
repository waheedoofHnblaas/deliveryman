import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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

class UpdateItemScreen extends StatefulWidget {
  UpdateItemScreen({
    required this.name,
    required this.price,
    required this.info,
    required this.quant,
    required this.type,
    required this.weight,
  }) ;

  String name = '', price = '', type = '', weight = '', info = '', quant = '';

  @override
  State<UpdateItemScreen> createState() => _UpdateItemScreenState();
}

class _UpdateItemScreenState extends State<UpdateItemScreen> {
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
          'quant': widget.quant==''?'0':widget.quant,
        },
      );

      Get.back();
      if (response['status'] == 'item is here') {
        CustomAwesomeDialog(context: context, content: 'item is her');
      } else if (response['status'] == 'success') {
        Get.back();
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
  void initState() {
    // TODO: implement initState
    Q = widget.quant;
    setState(() {
      widget.quant='';
    });
  }
  var Q = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        title: const Text('update item'),
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
                      Text(widget.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 21),),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomeTextFeild(
                              (v) {
                            setState(() {
                              widget.quant = v;
                            });
                          },
                          'item quant = $Q + ${widget.quant}',
                          widget.quant,
                          context,
                          isNumber: TextInputType.number,auto: true
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
    );
  }
}
