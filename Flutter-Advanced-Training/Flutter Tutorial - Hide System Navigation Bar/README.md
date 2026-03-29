To hide the system navigation bar in Flutter, you can use the `SystemChrome` class from the `flutter/services.dart` package. Here's a simple guide to hide the system navigation bar for your Flutter app:

### Steps:

1. **Import Required Package:**
   Import the `flutter/services.dart` package in your Dart file.

   ```dart
   import 'package:flutter/services.dart';
   ```

2. **Use `SystemChrome` to Hide the Navigation Bar:**
   In the widget's `initState()` method, call `SystemChrome.setEnabledSystemUIMode()` to hide the system navigation bar.

   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter/services.dart';

   void main() {
     runApp(MyApp());
   }

   class MyApp extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return MaterialApp(
         home: HomeScreen(),
       );
     }
   }

   class HomeScreen extends StatefulWidget {
     @override
     _HomeScreenState createState() => _HomeScreenState();
   }

   class _HomeScreenState extends State<HomeScreen> {
     @override
     void initState() {
       super.initState();
       // Hides the status bar and system navigation bar
       SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
     }

     @override
     void dispose() {
       // Restore the system UI when exiting the screen
       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
       super.dispose();
     }

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(title: Text('Hide System Navigation Bar')),
         body: Center(child: Text('System Navigation Bar is hidden')),
       );
     }
   }
   ```

### Explanation:
- **`SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)`**: This hides the status bar and the system navigation bar. The user can still interact with the app and swipe from the edges to bring them back.
- **`SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual)`**: This restores the system UI if you navigate away from the screen or at any point you want to show the system UI again.
  
You can also use other options such as `SystemUiMode.leanBack` and `SystemUiMode.edgeToEdge` based on your specific use case.

Let me know if you'd like more details or a specific customization!