```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const OlaCloneApp());
}

class OlaCloneApp extends StatelessWidget {
  const OlaCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ola UI Clone',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto', // Default Android font
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We use a Stack to place elements over the "Map"
      body: Stack(
        children: [
          // 1. Map Background (Simulated)
          _buildMapBackground(),

          // 2. Top Bar (Menu & Location)
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: _buildTopBar(),
          ),

          // 3. Bottom Sheet Content
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomSheet(),
          ),
        ],
      ),
      // 4. Bottom Navigation Bar
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildMapBackground() {
    // Coordinates for the area shown in your screenshot (Kammiyampettai/Chennai)
    // Adjust these values to match the exact temple location.
    const LatLng _center = LatLng(13.0827, 80.2707);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 15.0, // Adjust zoom level
      ),
      // Enable the blue location dot (requires location permissions at runtime)
      myLocationEnabled: true,
      myLocationButtonEnabled: false, // Set to true if you want the default button
      zoomControlsEnabled: false, // Hide default zoom buttons for a cleaner look

      // Add the Temple marker
      markers: {
        Marker(
          markerId: const MarkerId('temple_marker'),
          position: _center,
          infoWindow: const InfoWindow(
            title: 'Shri Padaleeswarar Temple',
            snippet: 'Kammiyampettai',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet, // Matches the purple tint in your UI
          ),
        ),
      },
      // Optional: Add a callback if you need to control the map later
      onMapCreated: (GoogleMapController controller) {
        // You can customize the map style here if needed
      },
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        // Menu Icon
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 12),
        // Location Chip
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ],
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    "QP2X+6G3, Puth...",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Heart Icon
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      height: 450,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.black),
                  hintText: "Enter destination",
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Service Icons Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildServiceIcon(
                  icon: Icons.motorcycle,
                  label: "Bike",
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                _buildServiceIcon(
                  icon: Icons.inventory_2,
                  label: "Parcel",
                  color: Colors.greenAccent,
                ),
                const SizedBox(width: 12),
                _buildServiceIcon(
                  icon: Icons.monetization_on,
                  label: "Loans",
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                _buildServiceIcon(
                  icon: Icons.account_balance_wallet,
                  label: "Money",
                  color: Colors.green,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Branding Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "#OlaOnTheMove",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Moving India since 2010 🇮🇳",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Cloud Background Image Placeholder
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5), // Light grey background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              // Simulating the cloud graphic with icons/positions
              child: Stack(
                children: [
                  Positioned(
                    bottom: -20,
                    left: -20,
                    child: _buildCloudCircle(150),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 40,
                    child: _buildCloudCircle(80),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 100,
                    child: _buildCloudCircle(100),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloudCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildServiceIcon({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Using a Container to simulate the specific graphic style
          Container(
            height: 40,
            width: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.black : Colors.grey,
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
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