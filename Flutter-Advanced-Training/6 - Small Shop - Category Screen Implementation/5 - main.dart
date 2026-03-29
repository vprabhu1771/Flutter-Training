import 'package:flutter/material.dart';
import 'package:flutter_small_shop/screens/CategoryScreen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CategoryScreen(title: 'Category',),
    );
  }
}