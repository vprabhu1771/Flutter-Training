// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:live_order_tracking/model/order.dart';
// import 'package:get/get.dart';
//
// import 'live_tracking_controller.dart';
//
//
// class LiveTrackingPage extends StatefulWidget {
//   const LiveTrackingPage({super.key});
//
//   @override
//   State<LiveTrackingPage> createState() => _LiveTrackingPageState();
// }
//
// class _LiveTrackingPageState extends State<LiveTrackingPage> {
//
//   late MyOrder order; // Use 'late' since it will be initialized in initState
//
//   @override
//   void initState() {
//     super.initState();
//     // Access arguments inside initState
//     final args = Get.arguments as Map<String, dynamic>;
//     order = args['order'] as MyOrder;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return GetBuilder<LiveTrackingController>(
//       init: LiveTrackingController(),
//       builder: (controller) {
//         controller.myOrder = order;
//         controller.updateDestinationLocation(order.latitude, order.longitude);
//         controller.startTracking(order.id);
//         return Scaffold(
//           appBar: AppBar(
//             title: Text("Order Tracking"),
//           ),
//           body: Stack(
//             children: [
//               GoogleMap(
//                 mapType: MapType.normal,
//                 initialCameraPosition: CameraPosition(
//                     target: LatLng(0, 0),
//                     zoom: 14
//                 ),
//                 onMapCreated: (GoogleMapController mapController) {
//                   controller.mapController = mapController;
//                 },
//                 markers: {
//                   Marker(
//                     markerId: MarkerId('destination'),
//                     position: controller.destination,
//                     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//                     infoWindow: InfoWindow(
//                       title: 'Destination',
//                       snippet: 'Lat: ${controller.destination.latitude}, Lng: ${controller.destination.longitude}'
//                     )
//                   ),
//                   Marker(
//                       markerId: MarkerId('deliveryBoy'),
//                       position: controller.deliveryBoyLocation,
//                       // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//                       icon: controller.markerIcon,
//                       infoWindow: InfoWindow(
//                           title: 'Delivery Boy',
//                           snippet: 'Lat: ${controller.deliveryBoyLocation.latitude}, Lng: ${controller.deliveryBoyLocation.longitude}'
//                       )
//                   )
//                 },
//               ),
//               Positioned(
//                   top: 16.0,
//                   left: 0,
//                   right: 0,
//                   child: Center(
//                     child: Container(
//                       padding: EdgeInsets.all(8.0),
//                       decoration: BoxDecoration(
//                         color: Colors.yellow,
//                         borderRadius: BorderRadius.circular(8.0)
//                       ),
//                       child: Text(
//                         // "Remaining Distance: 2 Kilometers",
//                         "Remaining Distance: ${controller.remainingDistance.toStringAsFixed(2)} Kilometers",
//                         style: TextStyle(fontSize: 16.0),
//                       ),
//                     ),
//                   )
//               )
//             ],
//           ),
//         );
//       });
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_order_tracking/model/order.dart';
import 'package:get/get.dart';
import 'live_tracking_controller.dart';

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({super.key});

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  late MyOrder order;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    try {
      final args = Get.arguments as Map<String, dynamic>;
      order = args['order'] as MyOrder;
    } catch (e) {
      print('Error initializing order: $e');
      // Handle error - maybe show a snackbar or navigate back
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveTrackingController>(
      init: LiveTrackingController(),
      builder: (controller) {
        controller.myOrder = order;
        controller.updateDestinationLocation(order.latitude, order.longitude);
        controller.startTracking(order.id);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Order Tracking"),
          ),
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(order.latitude ?? 0, order.longitude ?? 0),
                  zoom: 14,
                ),
                onMapCreated: (GoogleMapController mapController) {
                  controller.mapController = mapController;
                  setState(() {
                    _isMapReady = true;
                  });
                },
                markers: {
                  if (controller.destination != const LatLng(0, 0))
                    Marker(
                      markerId: const MarkerId('destination'),
                      position: controller.destination,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                      infoWindow: InfoWindow(
                        title: 'Destination',
                        snippet:
                        'Lat: ${controller.destination.latitude}, Lng: ${controller.destination.longitude}',
                      ),
                    ),
                  if (controller.deliveryBoyLocation != const LatLng(0, 0))
                    Marker(
                      markerId: const MarkerId('deliveryBoy'),
                      position: controller.deliveryBoyLocation,
                      // icon: controller.markerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                      infoWindow: InfoWindow(
                        title: 'Delivery Boy',
                        snippet:
                        'Lat: ${controller.deliveryBoyLocation.latitude}, Lng: ${controller.deliveryBoyLocation.longitude}',
                      ),
                    ),
                },
                // Add these for better UX
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
              ),
              Positioned(
                top: 16.0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Remaining Distance: ${controller.remainingDistance.toStringAsFixed(2)} Kilometers",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ),
              // Show loading indicator if map isn't ready
              if (!_isMapReady)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }
}