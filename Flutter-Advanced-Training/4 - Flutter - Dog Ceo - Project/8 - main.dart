import 'package:flutter/material.dart';

// Make sure to import your HomeScreen file
import 'package:flutter_dog_ceo/screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog CEO App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(title: 'Dog Images'), // Set your HomeScreen as the home property
    );
  }
}
