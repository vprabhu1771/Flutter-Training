Here’s the **full Flutter code** that retrieves the **current location (latitude & longitude)** and **reverse geocodes** it to an **address** using the `geolocator` and `geocoding` packages.

---

### ✅ **Step 1: Add dependencies**  
Add these to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  geolocator: ^11.0.0  # Latest version
  geocoding: ^3.0.0    # Latest version
```

Run:
```bash
flutter pub get
```

---

### ✅ **Step 2: Platform configurations**

#### **Android:**  
Add permissions to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

#### **iOS:**  
Add these keys to `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show accurate data.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to provide better services.</string>
```

---

### ✅ **Step 3: Full Flutter code**

```dart
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  String _location = "Press the button to get location";
  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _location = "Fetching location...";
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _location = "Location services are disabled.";
          _isLoading = false;
        });
        return;
      }

      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _location = "Location permissions are denied.";
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _location =
          "Location permissions are permanently denied. Please enable them in settings.";
          _isLoading = false;
        });
        return;
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      await _getAddressFromLatLng(position);
    } catch (e) {
      setState(() {
        _location = "Error: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _location =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      } else {
        setState(() {
          _location = "No address available for this location.";
        });
      }
    } catch (e) {
      setState(() {
        _location = "Failed to get address: $e";
      });
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get Current Location")),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(
          _location,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
```

---

### 📝 **Explanation:**

1. **Permissions Handling:**  
   - Checks if location services are enabled.  
   - Requests permissions if denied.

2. **Getting Location:**  
   - Uses `Geolocator.getCurrentPosition()` for latitude and longitude.

3. **Reverse Geocoding:**  
   - Uses `placemarkFromCoordinates()` to convert coordinates to a human-readable address.

4. **UI:**  
   - Press the floating action button to get location and address.

---

### 🚀 **Sample Output:**  
- **Latitude:** 37.4219983  
- **Longitude:** -122.084  
- **Address:** 1600 Amphitheatre Parkway, Mountain View, California, 94043, USA  

---

### 🛡️ **Pro Tips:**  
✅ Test on a real device for accurate results.  
✅ For Android 10+, add `android:usesCleartextTraffic="true"` in `AndroidManifest.xml` if location services act up.  
✅ Use `LocationAccuracy.bestForNavigation` for navigation apps.

---

🎉 **Done!** Press the button in the app, and you’ll get the **current coordinates** and **address** instantly. Let me know if you need further customization! 😊