import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_order_tracking/screens/add_order/add_order_page.dart';
import 'package:live_order_tracking/screens/delivery_boy_app/delivery_boy_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose App"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: () {
                  // Using GetX navigation with GetMaterialApp
                  Get.to(() => const AddOrderPage());
                },
                child: Text("Client App")
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: () {
                  // Get.snackbar(
                  //   'Info',
                  //   'Delivery Boy App coming soon!',
                  //   snackPosition: SnackPosition.BOTTOM,
                  //   backgroundColor: Colors.grey[800],
                  //   colorText: Colors.white,
                  // );

                  Get.to(() => const DeliveryBoyPage());
                },
                child: Text("Delivery Boy App")
            ),
          ],
        ),
      ),
    );
  }
}
