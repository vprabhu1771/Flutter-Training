import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/order.dart';

class OrderListController extends GetxController {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  List<MyOrder> orders = [];

  @override
  void onInit() {
    orderCollection = firestore.collection('order');
    getAllOrder();
    super.onInit();
  }

  getAllOrder() async {
    print("Get All Order");
    try {
      QuerySnapshot querySnapshot = await orderCollection.get();
      print(orderCollection.get());
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        MyOrder order = MyOrder.fromJson(data);
        orders.add(order);
      }

      update(); // Notify GetX to update UI
    } catch (e) {
      rethrow;
    }
  }

}