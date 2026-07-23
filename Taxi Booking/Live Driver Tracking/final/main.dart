import 'package:customer_app/HomeScreen.dart';
import 'package:customer_app/customer_map2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'customer_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: CustomerMap(),
      // home: CustomerMap2(),
      home: HomeScreen(),
    ),
  );
}