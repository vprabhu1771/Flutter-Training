`HelloWorldScreen.dart`
```dart
import 'package:flutter/material.dart';

class HelloWorldScreen extends StatelessWidget {
  const HelloWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello World'),
      ),
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}
```

`main.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_hello_world_desktop/screens/HelloWorldScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HelloWorldScreen()
      },
    );
  }
}
```