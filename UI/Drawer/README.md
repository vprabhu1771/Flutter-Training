Here's a simple Flutter `Drawer` example with a header and menu items:

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
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drawer Example"),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Prabhu"),
              accountEmail: const Text("prabhu@example.com"),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      body: const Center(
        child: Text(
          "Swipe from left or tap menu icon",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
```

### Modern Drawer Menu UI

```dart
Drawer(
  child: Column(
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 60,
          bottom: 20,
        ),
        color: Colors.blue,
        child: const Column(
          children: [
            CircleAvatar(
              radius: 35,
              child: Icon(Icons.person, size: 40),
            ),
            SizedBox(height: 10),
            Text(
              "Prabhu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),

      ListTile(
        leading: Icon(Icons.dashboard),
        title: Text("Dashboard"),
      ),

      ListTile(
        leading: Icon(Icons.receipt_long),
        title: Text("Collections"),
      ),

      ListTile(
        leading: Icon(Icons.people),
        title: Text("Customers"),
      ),

      ListTile(
        leading: Icon(Icons.settings),
        title: Text("Settings"),
      ),

      Spacer(),

      ListTile(
        leading: Icon(Icons.logout, color: Colors.red),
        title: Text("Logout"),
      ),
    ],
  ),
)
```

This second design is suitable for your loan collection/EMI Flutter app.
