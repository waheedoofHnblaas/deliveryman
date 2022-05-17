import 'package:flutter/material.dart';
import 'package:google_map/Order.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class DataOrder_screen extends StatefulWidget {
  DataOrder_screen({Key? key,
    required this.order,
    required this.kGooglePlex,
  }) : super(key: key);

  late Order order;
  late CameraPosition kGooglePlex;
  @override
  State<DataOrder_screen> createState() => _DataOrder_screenState();
}

bool check = false;

class _DataOrder_screenState extends State<DataOrder_screen> {
  late Position _position;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order.ownerUserNum),
        centerTitle: true,
      ),
      body: Center(
        child:
        // widget.kGooglePlex == null
        //     ?  const CircularProgressIndicator()
        //     :
        Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        height: MediaQuery.of(context).size.height / 2,
                        child: GoogleMap(

                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          markers: {
                            Marker(

                              markerId: const MarkerId('817493216732583'),
                              infoWindow: InfoWindow(title: widget.order.marker.infoWindow.title),
                              position: LatLng(widget.order.marker.position.latitude, widget.order.marker.position.longitude),
                            )
                          },
                          mapType: MapType.normal,
                          initialCameraPosition: widget.kGooglePlex,

                        ),
                      ),
                      const Divider(
                        height: 20,
                        thickness: 2,
                        color: Colors.black,
                      ),
                      widget.order.isWaitting?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlineButton(
                              onPressed: () {
                                setState(() {
                                  check = !check;
                                  widget.order.isWaitting = false;
                                });
                                print('==================${widget.order.isWaitting}================');
                              },
                              child:  const Text(
                                'i well arrive it',
                                style: TextStyle(color: Colors.green),
                              )),
                          // OutlineButton(
                          //     onPressed: () {}, child: Text('check arrived')),
                          const  Text(
                            '1 km',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          OutlineButton.icon(
                              onPressed: () {},
                              icon: const  Icon(Icons.phone),
                              label:  const Text('call'))
                        ],
                      ): const Text('done'),
                      const  Divider(
                        height: 20,
                        thickness: 2,
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Card(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    children: List.generate(widget.order.items.length,
                                        (index) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(widget.order.items[index].name),
                                        )))),
                          ),
                          Column(
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children:  const [
                                      Text('owner data'),
                                      Text('owner email'),
                                      Text('owner number'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      check
                          ? OutlineButton.icon(
                              onPressed: () {
                                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                                //   return  const ();
                                // }), (route) => false).whenComplete(() {
                                //   widget.order.isWaitting = false;
                                // });
                              },
                              icon:  const Icon(Icons.done),
                              label:  const Text('done'))
                          : Container()
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
//AIzaSyBVGX7f7oLPlYgb_2me-qoHwDhhNoN3G9M
//36.9967503
//36.3797634
