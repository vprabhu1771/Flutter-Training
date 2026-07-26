// import 'package:flutter/material.dart';
// import 'package:live_order_tracking/screens/delivery_boy_app/delivery_boy_controller.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:get/get.dart';
//
// class DeliveryBoyPage extends StatefulWidget {
//   const DeliveryBoyPage({super.key});
//
//   @override
//   State<DeliveryBoyPage> createState() => _DeliveryBoyPageState();
// }
//
// class _DeliveryBoyPageState extends State<DeliveryBoyPage> {
//
//   @override
//   Widget build(BuildContext context) {
//
//     return GetBuilder<DeliveryBoyController>(
//         init: DeliveryBoyController(),
//         builder: (controller) {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text("Delivery Boy App"),
//             ),
//             body: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: ListView(
//                 children: [
//                   Text(
//                     "Enter My Order ID:",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8,),
//                   TextField(
//                     controller: controller.orderIdController,
//                     decoration: InputDecoration(
//                       hintText: "My Order ID",
//                       border: OutlineInputBorder()
//                     ),
//                   ),
//                   SizedBox(height: 16,),
//                   Visibility(
//                       visible: true,
//                       child: ElevatedButton(
//                           onPressed: () {
//                             controller.getOrderById();
//                           },
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.red,foregroundColor: Colors.white),
//                           child: Text("Submit")
//                       )
//                   ),
//                   SizedBox(height: 16,),
//                   // Display delivery address and phone number if available
//                   Visibility(
//                       visible: controller.showDeliveryInfo,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Text(
//                             "Delivery Address: ${controller.deliveryAddress}",
//                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 8,),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Phone: ${1234567890}",
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               IconButton(
//                                   onPressed: () {
//                                     // Launch the phone dialer with the phone number
//                                     launch('tel:${controller.phoneNumber}');
//                                   },
//                                   icon: Icon(Icons.call)
//                               )
//                             ],
//                           ),
//                           SizedBox(height: 8,),
//                           Text(
//                             "Amount to Collect: \$ ${controller.amountToCollect}",
//                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 16,),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               ElevatedButton.icon(
//                                 onPressed: (){
//                                   launchUrl(Uri.parse("https://www.google.com/maps?q=${controller.customerLatitude},${controller.customerLongitude}"));
//                                 },
//                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
//                                 icon: Icon(Icons.location_on),
//                                 label: Text('Show Location'),
//                               ),
//                               ElevatedButton(
//                                   onPressed: () {
//                                     controller.startDelivery();
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.grey,
//                                     foregroundColor: Colors.white
//                                   ),
//                                   child: Text("Start Delivery")
//                               )
//                             ],
//                           )
//                         ],
//                       )
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }

import 'package:flutter/material.dart';
import 'package:live_order_tracking/screens/delivery_boy_app/delivery_boy_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class DeliveryBoyPage extends StatefulWidget {
  const DeliveryBoyPage({super.key});

  @override
  State<DeliveryBoyPage> createState() => _DeliveryBoyPageState();
}

class _DeliveryBoyPageState extends State<DeliveryBoyPage> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveryBoyController>(
        init: DeliveryBoyController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Delivery Boy App"),
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    "Enter My Order ID:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: controller.orderIdController,
                    decoration: InputDecoration(
                        hintText: "My Order ID",
                        border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: controller.isDeliveryStarted ? null : () {
                        controller.getOrderById();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white
                      ),
                      child: Text("Submit")
                  ),
                  SizedBox(height: 16),
                  // Display delivery address and phone number if available
                  Visibility(
                    visible: controller.showDeliveryInfo,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivery Details",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Address: ${controller.deliveryAddress}",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Phone: ${controller.phoneNumber}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      launch('tel:${controller.phoneNumber}');
                                    },
                                    icon: Icon(Icons.call, color: Colors.green),
                                  )
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Amount to Collect: \$ ${controller.amountToCollect}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: (){
                                launchUrl(Uri.parse(
                                    "https://www.google.com/maps?q=${controller.customerLatitude},${controller.customerLongitude}"
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white
                              ),
                              icon: Icon(Icons.location_on),
                              label: Text('Show Location'),
                            ),
                            ElevatedButton(
                                onPressed: controller.isDeliveryStarted
                                    ? null
                                    : () {
                                  controller.startDelivery();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: controller.isDeliveryStarted
                                        ? Colors.green
                                        : Colors.blue,
                                    foregroundColor: Colors.white
                                ),
                                child: Text(
                                    controller.isDeliveryStarted
                                        ? "Delivering..."
                                        : "Start Delivery"
                                )
                            ),
                            if (controller.isDeliveryStarted)
                              ElevatedButton(
                                  onPressed: () {
                                    controller.stopDelivery();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white
                                  ),
                                  child: Text("Stop")
                              ),
                          ],
                        ),
                        // Status indicator
                        if (controller.isDeliveryStarted)
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.green),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Live tracking active',
                                    style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: AnimatedContainer(
                                    duration: Duration(seconds: 1),
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.green,
                                      size: 8,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}