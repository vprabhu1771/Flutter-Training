```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Good Morning'),
      ),
      body: Center(
        child: ElevatedButton(
            child: Text('About Us'),
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (context) => AboutDialog(
                    applicationIcon: FlutterLogo(),
                    applicationLegalese: 'Legalese',
                    applicationName: 'Flutter App',
                    applicationVersion: 'Version 1.0.0',
                    children: [
                      Text('abcd')
                    ],
                  )
              );
            }
        )
      )
    );
  }
}
```

```dart
import 'package:flutter/material.dart';
import 'package:untitled1/screens/HomeScreen.dart';

// Main entry point of the app
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
```

![Image](1.png)
![Image](2.png)