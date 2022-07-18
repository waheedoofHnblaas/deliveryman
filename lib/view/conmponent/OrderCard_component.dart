// // TODO Implement this library.import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_map/oop/Order.dart';
// import 'package:google_map/database/google_map_api.dart';
//
// Widget CardOrder_component(
//   type,
//   ontap,
//   onremove,
//   onreceve,
//   String destanse,
//   Order order,
//   context,
// ) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5),
//     child: Padding(
//       padding: const EdgeInsets.only(top: 5),
//       child: InkWell(
//         // onTap: ontap,
//         child: Container(
//           decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.all(Radius.circular(20))),
//           width: MediaQuery.of(context).size.width / 1.5,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 elevation: 5,
//                 child: ListTile(
//                   title: Text('$destanse meter'),
//                   subtitle: Text('username'),
//                   leading: order.isWaitting
//                       ? const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Icon(
//                             Icons.wifi_tethering,
//                             color: Colors.green,
//                           ),
//                         )
//                       : const Icon(
//                           Icons.check,
//                           color: Colors.red,
//                         ),
//                 ),
//               ),
//               Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 elevation: 5,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // type == 'custom'
//                     //     ? Column(
//                     //         children: [
//                     //           order.isWaitting
//                     //               ? SizedBox(
//                     //                   width:
//                     //                       MediaQuery.of(context).size.width / 4,
//                     //                   child: OutlineButton(
//                     //                       onPressed: onremove,
//                     //                       child:
//                     //                           const Icon(Icons.delete_forever)),
//                     //                 )
//                     //               : Container(),
//                     //           order.received
//                     //               ? Container()
//                     //               : !order.isWaitting
//                     //                   ? SizedBox(
//                     //                       width: MediaQuery.of(context)
//                     //                               .size
//                     //                               .width /
//                     //                           4,
//                     //                       child: OutlineButton(
//                     //                           onPressed: onreceve,
//                     //                           child: const Icon(
//                     //                               Icons.get_app_outlined)),
//                     //                     )
//                     //                   : Container(),
//                     //         ],
//                     //       )
//                     //     : Column(
//                     //         children: [
//                     //           !order.received
//                     //               ? order.isWaitting
//                     //                   ? SizedBox(
//                     //                       width: MediaQuery.of(context)
//                     //                               .size
//                     //                               .width /
//                     //                           4,
//                     //                       child: OutlineButton(
//                     //                           onPressed: onreceve,
//                     //                           child: const Icon(
//                     //                               Icons.get_app_outlined)),
//                     //                     )
//                     //                   : Container()
//                     //               : Container()
//                     //         ],
//                     //       ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width / 3,
//                       child: ListTile(
//                         title: SizedBox(
//                           height: MediaQuery.of(context).size.height / 10,
//                           child: ListView(
//                             scrollDirection: Axis.vertical,
//                             children:
//                                 List.generate(order.items.length, (index) {
//                               return Card(
//                                 color: Colors.green[100],
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(1.0),
//                                     child: Text(
//                                 '${order.items[index]}',
//                                 textAlign: TextAlign.center,
//                               ),
//                                   ));
//                             }),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
