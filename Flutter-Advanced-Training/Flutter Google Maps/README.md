```
https://www.youtube.com/watch?v=4ucWoHtBby0
```

```
https://pub.dev/packages/google_maps_flutter
```

```
https://pub.dev/packages/geolocator
```

```
https://pub.dev/packages/location
```

```
https://pub.dev/packages/flutter_polyline_points
```

```
https://github.com/HeyFlutter-Public/google_maps_app/blob/main/lib/pages/google_map_page.dart
```

The **"Authorization failure"** error occurs because the **Google Maps API key** is missing, improperly set up, or not enabled for the correct APIs. Here’s how to fix it:

---

### ✅ **Step 1: Get a Google Maps API Key**  
1. Go to the [Google Cloud Console](https://console.cloud.google.com/).  
2. Create a new project or select an existing one.  
3. Navigate to **APIs & Services > Credentials**.  
4. Click **Create credentials > API key**.  
5. Copy the generated API key.  

---

### ✅ **Step 2: Enable Required APIs**  
1. In the Cloud Console, go to **APIs & Services > Library**.  
2. Enable the following APIs for your project:  
   - **Maps SDK for Android**  
   - **Maps SDK for iOS** *(if you’re targeting iOS too)*  

---

### ✅ **Step 3: Add API Key to Your Flutter Project**  

#### For **Android**:  
1. Open `android/app/src/main/AndroidManifest.xml`.  
2. Add this inside the `<application>` tag:  
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY_HERE"/>
   ```

#### For **iOS**:  
1. Open `ios/Runner/AppDelegate.swift` (or `AppDelegate.m` if using Objective-C).  
2. Inside `didFinishLaunchingWithOptions`, add:  
   ```swift
   GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
   ```

3. Also, in `ios/Runner/Info.plist`, add:  
   ```xml
   <key>io.flutter.embedded_views_preview</key>
   <true/>
   ```

---

### ✅ **Step 4: Clean and Rebuild the Project**  
Run these commands to clear cache and rebuild:  
```bash
flutter clean
flutter pub get
flutter run
```

---

### 🚀 **Result:**  
The map should now display without the **"Authorization failure"** error!  

🔒 **Tip:** Restrict your API key to prevent unauthorized usage in the Google Cloud Console.



# DeliveryMapScreen

Perfect 👍 — let’s enhance your `DeliveryMapScreen` so it:
✅ Requests **location permission** using `permission_handler`,
✅ Displays the **Google Map** centered on the user’s location (if granted),
✅ Shows a fallback default position (e.g. Google HQ) if denied.

---

### 🧩 Step 1: Add dependencies in `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.7.0
  permission_handler: ^12.0.1
  geolocator: ^12.0.0
```

Then run:

```bash
flutter pub get
```

---

### ⚙️ Step 2: Android Setup

In `android/app/src/main/AndroidManifest.xml` add:

```xml
<!-- Required for Google Maps -->
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

<application>
    ...
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>
</application>
```

---

### 🍏 Step 3: iOS Setup

In `ios/Runner/Info.plist` add:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app requires location access to show your current position on the map.</string>
```

---

### 🚀 Step 4: Updated Flutter Code

Here’s your **complete `DeliveryMapScreen`** with location + permission handling:

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class DeliveryMapScreen extends StatefulWidget {
  const DeliveryMapScreen({super.key});

  @override
  State<DeliveryMapScreen> createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> {
  GoogleMapController? _mapController;
  static const LatLng googlePlex = LatLng(37.4220, -122.0841); // Default
  LatLng? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    // Request location permission
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } else if (status.isPermanentlyDenied) {
      // Open settings if permanently denied
      await openAppSettings();
    } else {
      // If denied, show default location
      setState(() {
        _currentPosition = googlePlex;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Map"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition ?? googlePlex,
          zoom: 14,
        ),
        myLocationEnabled: true, // Show blue dot
        myLocationButtonEnabled: true, // Show location button
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }
}
```

---

### 🧠 How It Works

1. On startup (`initState`), the app requests **location permission**.
2. If granted:

   * Gets the **current GPS coordinates** via `Geolocator`.
   * Centers the map on that position.
3. If denied:

   * Falls back to `googlePlex` (Google HQ).
   * You can later re-request permission.
4. If **permanently denied**, it opens app settings.

---

### ✅ Optional Improvement

You can also listen to **real-time location updates**:

```dart
Geolocator.getPositionStream().listen((Position position) {
  _mapController?.animateCamera(CameraUpdate.newLatLng(
    LatLng(position.latitude, position.longitude),
  ));
});
```

---

Would you like me to include **markers for delivery locations** (for example, driver and destination pins)?
