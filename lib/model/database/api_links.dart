//192.168.43.206
//192.168.1.100
//192.168.43.206  192.168.43.206
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String server = 'https://phpddd.000webhostapp.com/phpcourse/';
const String registerLinkEmp = '${server}register_employees.php';
const String loginLinkEmp = '${server}login_employees.php';
const String registerLinkCustom = '${server}register_customer.php';
const String loginLinkCustom = '${server}login_customer.php';

const String addorederLink = '${server}addorder.php';
const String addItemLink = '${server}addItem.php';
const String getAllTypesLink = '${server}getOD/getItemType.php';
const String addItemsOrderLink = '${server}addItemsOrder.php';

const String deleteorederLink = '${server}deleteorder.php';
const String doneorderUpdateLink = '${server}doneorderupdate.php';

const String getordersLink = '${server}getorders.php';
const String getordersByOwnerIdLink = '${server}getOD/getordersByOwnerId.php';
const String getorderUpdateLink = '${server}getorderupdate.php';
const String getorederItemsLink = '${server}getorderitems.php';
const String getEmployeeByIdLink = '${server}getEmployeeById.php';
const String getEmpsLink = '${server}getEmps.php';
const String getCustloyeeByIdLink = '${server}getCustloyeeByIdLink.php';
const String getitemsLink = '${server}getitems.php';
const String getRateByIdLink = '${server}getRateById.php';

const CameraPosition cameraPosition = CameraPosition(
    target: LatLng(36.201909545860694, 37.13433723896742), zoom: 12);
