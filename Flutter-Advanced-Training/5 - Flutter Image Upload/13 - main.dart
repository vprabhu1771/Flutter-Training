import 'package:flutter/material.dart';

// Make sure to import your HomeScreen file
import 'package:untitled/screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(title: 'Home'), // Set your HomeScreen as the home property
    );
  }
}
