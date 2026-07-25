#  google map flutter | live tracking | live google map tracking flutter | flutter live order tracking 
```
https://www.youtube.com/watch?v=NBuA3DouU2o
```

The error is occurring because you're using `Get.to()` for navigation but your app doesn't have a `GetMaterialApp` at the root. You need to either:

1. **Replace `MaterialApp` with `GetMaterialApp`** (Recommended for GetX)
2. **Use standard Navigator instead of GetX navigation**

Here's how to fix it:

## Solution 1: Use GetMaterialApp (Recommended)

### Update your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer_app/screens/home_screen.dart'; // Adjust path as needed

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  // Changed from MaterialApp to GetMaterialApp
      title: 'Customer App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### Then update your `HomeScreen`:

```dart
import 'package:customer_app/order/add_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose App"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: (){
                  // Using GetX navigation with GetMaterialApp
                  Get.to(() => const AddOrder());
                },
                child: const Text("Client App", style: TextStyle(fontSize: 18))
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: (){
                  Get.snackbar(
                    'Info', 
                    'Delivery Boy App coming soon!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.grey[800],
                    colorText: Colors.white,
                  );
                },
                child: const Text("Delivery Boy App", style: TextStyle(fontSize: 18))
            )
          ],
        ),
      ),
    );
  }
}
```

## Solution 2: Use Standard Navigator (Without GetX)

If you prefer not to use GetMaterialApp, just use standard Flutter navigation:

### Keep `main.dart` as MaterialApp:

```dart
import 'package:flutter/material.dart';
import 'package:customer_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(  // Keep as MaterialApp
      title: 'Customer App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### Update `HomeScreen` to use standard navigation:

```dart
import 'package:customer_app/order/add_order.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose App"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: (){
                  // Using standard Flutter navigation
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddOrder()),
                  );
                },
                child: const Text("Client App", style: TextStyle(fontSize: 18))
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: (){
                  // Show a snackbar using standard Flutter
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Delivery Boy App coming soon!'),
                    ),
                  );
                },
                child: const Text("Delivery Boy App", style: TextStyle(fontSize: 18))
            )
          ],
        ),
      ),
    );
  }
}
```

### Update `AddOrder` to use standard navigation consistently:

```dart
// In AddOrder's submit button
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red, 
    foregroundColor: Colors.white,
  ),
  onPressed: _isLoading ? null : _submitOrder,
  child: _isLoading 
    ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
    : const Text("Submit Order")
)

// _submitOrder method with standard navigation
void _submitOrder() {
  // ... validation and loading code ...
  
  // Navigate using standard Flutter navigation
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const OrderList()),
  );
}
```

## Recommendation:

**Use Solution 1 (GetMaterialApp)** because:
- You're already using GetX in your code
- GetX provides more features (dependency injection, reactive state management, etc.)
- Better performance with GetX navigation
- You can use GetX features like `Get.snackbar()`, `Get.dialog()`, etc.

Just remember to:
1. Import `package:get/get.dart` in your `main.dart`
2. Use `GetMaterialApp` instead of `MaterialApp`
3. Make sure all `Get.to()` calls have `()` properly: `Get.to(() => YourPage())`

This will resolve the "contextless navigation" error completely.
