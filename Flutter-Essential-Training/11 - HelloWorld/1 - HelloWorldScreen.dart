import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class HelloWorldScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text('Hello World'),
        backgroundColor: Colors.pinkAccent,
      ),
      
      body: const Center(
        child: Text(
          'Hello World!',
          style: TextStyle(fontSize: 24),
        ),
      ),

    );

  }
  
}