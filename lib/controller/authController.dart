import 'package:get/get.dart';

class AuthController extends GetxController{
  String password = '';
  String name = '';
  String phone = '';
  bool isEmp = false;


  auth(String name,String password,String phone,bool isEmp) {
    this.name = name;
    this.phone = phone;
    this.password = password;
    this.isEmp = isEmp;
    update();
  }
}