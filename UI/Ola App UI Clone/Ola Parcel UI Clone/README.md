This is a clean, modern UI typical of logistics or delivery apps. Here is the complete Flutter code to replicate this screen.

I have broken down the code into widgets for reusability (like the custom buttons and specification items) and used a `Scaffold` with a `SingleChildScrollView` to ensure it works on different screen sizes.

### Prerequisites
Make sure you have a standard Flutter environment set up. No external packages are required for this UI (using standard Material icons and fonts).

### The Flutter Code

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
      title: 'Ola Parcel Clone',
      theme: ThemeData(
        primarySwatch: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto', // Default Android font
      ),
      home: const ParcelScreen(),
    );
  }
}

class ParcelScreen extends StatefulWidget {
  const ParcelScreen({super.key});

  @override
  State<ParcelScreen> createState() => _ParcelScreenState();
}

class _ParcelScreenState extends State<ParcelScreen> {
  // State to toggle between Send and Receive
  bool isSendMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'OLA ',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: 1.2,
                ),
              ),
              TextSpan(
                text: 'PARCEL',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 22,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Toggle Section (Send/Receive)
              _buildToggleSection(),
              
              const SizedBox(height: 24),
              
              // 2. Address Input Section
              const Text(
                "Send or Receive Parcel",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildAddressCard(),
              
              const SizedBox(height: 24),
              
              // 3. Specifications Section
              _buildSpecificationsCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // --- Widget Builders ---

  Widget _buildToggleSection() {
    return Row(
      children: [
        // Send Parcel Button
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isSendMode = true),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSendMode ? Colors.black : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Send Parcel",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Send within city limit",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSendMode)
                    const Icon(Icons.check_circle, color: Colors.black, size: 20),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Receive Parcel Button
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isSendMode = false),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: !isSendMode ? Colors.black : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Receive Parcel",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Get parcel within city limit",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isSendMode)
                    const Icon(Icons.check_circle, color: Colors.black, size: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Pickup Row
          Row(
            children: [
              _buildLocationIcon(const Color(0xFF43A047), "A"),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Collect from:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Add Sender Address",
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: () {},
              )
            ],
          ),
          
          // Dotted Line Divider
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 4, bottom: 4),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 1,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                      style: BorderStyle.solid, // For simplicity, using solid. Use dotted_line package for exact dashed lines.
                      width: 0.5
                    )
                  ),
                ),
              ],
            ),
          ),

          // Drop Row
          Row(
            children: [
              _buildLocationIcon(const Color(0xFFE53935), "B"),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Deliver to:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Add Recipient Address",
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: () {},
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationIcon(Color color, String text) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSpecificationsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6), // Light grey background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fit these specifications:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildSpecItem(Icons.shopping_bag, "Parcel weighs 20kg or less"),
          const SizedBox(height: 16),
          _buildSpecItem(Icons.warning_amber_rounded, "No illegal, alcohol or restricted items"),
          const SizedBox(height: 16),
          _buildSpecItem(Icons.backpack, "Item should fit in a backpack"),
          const SizedBox(height: 16),
          _buildSpecItem(Icons.wine_bar_outlined, "Avoid sending high value & fragile items"),
        ],
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFD1F0D1), // Very light green bg
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2E7D32), // Dark green icon
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      currentIndex: 1, // Parcel is selected
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2),
          label: "Parcel",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.electric_rickshaw), // Approximation for auto icon
          label: "Electric",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.currency_rupee),
          label: "Loans",
        ),
      ],
    );
  }
}
```

### Key Implementation Details:

1.  **Layout Structure**:
    *   `Scaffold` handles the standard app structure.
    *   `AppBar` uses `RichText` to get the bold "OLA" and lighter "PARCEL" logo look.
    *   `SingleChildScrollView` ensures the content is scrollable on smaller screens.

2.  **State Management**:
    *   The screen uses a simple `StatefulWidget`.
    *   `isSendMode` boolean determines which box is highlighted (black border + checkmark icon) at the top.

3.  **Styling**:
    *   **Colors**: Used exact hex codes like `0xFFF2F4F6` for the spec background and `0xFF43A047` / `0xFFE53935` for the A/B location bubbles.
    *   **Shadows**: Added a very subtle `BoxShadow` to the address input card to give it that "floating" card look seen in the screenshot.
    *   **Icons**: Used standard Material Icons (`Icons.inventory_2`, `Icons.backpack`, etc.) to match the visuals closely.

4.  **Custom Widgets**:
    *   `_buildToggleSection()`: Creates the "Send" vs "Receive" buttons.
    *   `_buildAddressCard()`: Creates the "A to B" input form.
    *   `_buildSpecificationsCard()`: Creates the grey section with the green circular icons.