import 'package:google_map/Order.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Employee {
  late String employeeName;
  late String employeeNumber;
  late Marker employeeMarker;
  late List<Order> employeeOrders;


  Employee({
    required this.employeeName,
    required this.employeeMarker,
    required this.employeeNumber,
    required this.employeeOrders,
  });

}