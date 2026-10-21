Here is the complete Flutter code to replicate the UI shown in the screenshot.

I have broken the UI down into three main parts:
1.  **The AppBar** (with the back arrow and title).
2.  **The Body** (containing the empty state text).
3.  **The Bottom Navigation Bar** (with the custom icons and labels).

### Flutter Code

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
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto', // Default Android font
      ),
      home: const ParcelHistoryScreen(),
    );
  }
}

class ParcelHistoryScreen extends StatelessWidget {
  const ParcelHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back navigation
          },
        ),
        title: const Text(
          'Parcel history',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0, // Aligns title closer to the arrow
      ),
      body: Center(
        child: Text(
          'No orders placed',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: 1, // "Parcel" tab is selected in the screenshot
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            // Using a generic icon to represent the parcel box icon
            icon: Icon(Icons.inventory_2), 
            label: 'Parcel',
          ),
          BottomNavigationBarItem(
            // Using a generic icon to represent the "Electric" (robot/bulb) icon
            icon: Icon(Icons.smart_toy_outlined), 
            label: 'Electric',
          ),
          BottomNavigationBarItem(
            // Using a money icon for loans
            icon: Icon(Icons.currency_rupee), 
            label: 'Loans',
          ),
        ],
      ),
    );
  }
}
```

### Key Implementation Details:

*   **AppBar:** I set `elevation: 0` and `backgroundColor: Colors.white` to match the clean look. The `titleSpacing: 0` helps pull the title text closer to the back button, mimicking the screenshot.
*   **Icons:**
    *   Since I don't have the specific SVG assets from the screenshot, I used standard Material Icons that closely resemble them:
    *   **Home:** `Icons.home`
    *   **Parcel:** `Icons.inventory_2` (a box shape)
    *   **Electric:** `Icons.smart_toy_outlined` (looks somewhat like the robot/bulb head)
    *   **Loans:** `Icons.currency_rupee` (looks like the coin icon)
*   **Typography:** The text "Parcel history" is bold and large, while the "No orders placed" text is medium weight and centered.
*   **Bottom Navigation:** I set `type: BottomNavigationBarType.fixed` to ensure all labels are always visible (by default, they might animate or hide). I set the `currentIndex` to `1` so the "Parcel" tab is highlighted black like in the image.