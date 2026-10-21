The issue with your theme not working is likely because you're using `ColorScheme.fromSwatch()` which doesn't properly apply your primary color to the app bar and other components. Here are a few ways to fix it:

## Solution 1: Use a complete ThemeData (Recommended)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/screens/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green, // This creates a proper color scheme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF075E54),
          foregroundColor: Colors.white,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF075E54),
          secondary: Color(0xFF128C7E),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
```

## Solution 2: Use a custom ColorScheme

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF075E54),
        primary: const Color(0xFF075E54),
        secondary: const Color(0xFF128C7E),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF075E54),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      scaffoldBackgroundColor: Colors.white,
    ),
    home: const HomeScreen(),
  );
}
```

## Solution 3: Most Explicit (Full Control)

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData(
      primaryColor: const Color(0xFF075E54),
      primaryColorLight: const Color(0xFF128C7E),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF075E54),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
      ).copyWith(
        primary: const Color(0xFF075E54),
        secondary: const Color(0xFF128C7E),
      ),
    ),
    home: const HomeScreen(),
  );
}
```

## Why Your Code Didn't Work:

1. **`ColorScheme.fromSwatch()`** is deprecated and doesn't properly apply custom colors
2. **The primary color wasn't being propagated** to widgets like AppBar
3. **Modern Flutter** requires explicit color scheme definitions

## Complete Working Example:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Clone',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF075E54),
          brightness: Brightness.light,
        ).copyWith(
          primary: const Color(0xFF075E54),
          secondary: const Color(0xFF128C7E),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF075E54),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        scaffoldBackgroundColor: Colors.white,
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.white, width: 3),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
```

The **first solution** is recommended as it's the most straightforward and follows Flutter best practices.
