import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:live_order_tracking/screens/add_order/add_order_controller.dart';
import 'package:live_order_tracking/screens/order_list/order_list_page.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {

  @override
  Widget build(BuildContext context) {

    return GetBuilder<AddOrderController>(
      init: AddOrderController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Order Details"),
            actions: [
              IconButton(
                  onPressed: (){
                    Get.to(() => const OrderListPage());
                  },
                  icon: Icon(Icons.list)
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.map_outlined))
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextField(
                  // controller: TextEditingController(),
                  controller: controller.orderIdController,
                  decoration: InputDecoration(
                      labelText: 'Order ID'
                  ),
                ),
                SizedBox(height: 16.0,),
                TextField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                      labelText: 'Customer Name'
                  ),
                ),
                SizedBox(height: 16.0,),
                TextField(
                  controller: controller.phoneController,
                  decoration: InputDecoration(
                      labelText: 'Customer Phone'
                  ),
                ),
                SizedBox(height: 16.0,),
                TextField(
                  controller: controller.addressController,
                  decoration: InputDecoration(
                      labelText: 'Customer Address'
                  ),
                ),
                SizedBox(height: 16.0,),
                TextField(
                  controller: controller.amountController,
                  decoration: InputDecoration(
                      labelText: 'Bill Amount'
                  ),
                ),
                SizedBox(height: 16.0,),
                Container(
                  height: 380,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: 14),
                    onMapCreated: (GoogleMapController mapController) {
                      controller.mapController = mapController;
                    },
                    onTap: (latLong){
                      controller.selectedLocation = latLong;
                      controller.update();
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId('selectedLocation'),
                        position: controller.selectedLocation,
                        infoWindow: InfoWindow(
                          title: 'Selected Location',
                          snippet: 'Lat ${controller.selectedLocation!.latitude}, Lng: ${controller.selectedLocation!.longitude}'
                        )
                      )
                    },
                  ),
                ),
                SizedBox(height: 10.0,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    onPressed: () {
                      controller.addOrder(context);
                    },
                    child: Text("Submit Order")
                ),
              ],
            ),
          ),
        );
      });
  }
}
