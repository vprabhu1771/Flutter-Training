To create a **custom splash screen** in Flutter, follow these steps:

---

## **Method 1: Using flutter_native_splash (Recommended)**
This method allows you to set up a native splash screen with a logo and background color.

### **1. Add dependency**
Run the following command:
```sh
flutter pub add flutter_native_splash
```

### **2. Configure splash screen in `pubspec.yaml`**
Add the following configuration:
```yaml
flutter_native_splash:
  color: "#ffffff"  # Background color (hex code)
  image: assets/splash_logo.png  # Your splash screen image
  android: true
  ios: true
  fullscreen: true
```

# OR

## Configuration  
Define splash screen settings in `pubspec.yaml`:  
```yaml
flutter_native_splash:
  color: "#ffffff"  # Background color
  image: assets/splash.png  # Splash screen image
  android_12:
    color: "#ffffff"
    image: assets/splash.png
```

### **3. Generate splash screen**
Run:
```sh
flutter pub run flutter_native_splash:create
```

## Remove Splash Screen  
If you want to remove the splash screen, run:  
```sh
flutter pub run flutter_native_splash:remove
```

### **4. Remove the default white screen delay**
Edit `main.dart` and remove `FlutterActivity` delay:
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
```

---

## **Method 2: Using a Custom Flutter Splash Screen Widget**
This method shows a splash screen inside your Flutter app before transitioning to the main screen.

### **1. Create `splash_screen.dart`**
```dart
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home'); // Navigate to HomeScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/splash_logo.png', width: 150), // Your splash image
      ),
    );
  }
}
```

# OR

```dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_local_service/screens/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(title: 'Home')),
      ); // Navigate to HomeScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/splash_logo.png', width: 150), // Your splash image
      ),
    );
  }
}
```

### **2. Update `main.dart`**
```dart
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(), // Define the Home screen
      },
    );
  }
}
```

### **3. Create `home_screen.dart`**
```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen")),
      body: Center(child: Text("Welcome to the app!")),
    );
  }
}
```

---

### **Which Method to Use?**
- **Use `flutter_native_splash`** for a faster and more native experience.
- **Use a Flutter widget-based splash screen** if you need animations or complex logic.

Let me know if you need modifications!
