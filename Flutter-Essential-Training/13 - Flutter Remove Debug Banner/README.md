# 13 - Flutter Remove Debug Banner

1. Flutter Remove Debug Banner
https://stackoverflow.com/questions/48893935/how-can-i-remove-the-debug-banner-in-flutter


```
MaterialApp(
  debugShowCheckedModeBanner: false
)
```

```
CupertinoApp(
  debugShowCheckedModeBanner: false
)
```

2. main.dart
```
import 'package:flutter/material.dart';
import 'package:untitled/screens/HelloWorldScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {        
        '/': (context) => HelloWorldScreen(),
      },
    );
  }
}
```