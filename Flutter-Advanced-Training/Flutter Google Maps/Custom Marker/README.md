Excellent — you’ve already built a strong structure 👏

Let’s fix **two issues**:

1. 🧭 Polyline not showing
2. 📍 Custom delivery marker instead of the default red pin

---

## ✅ 1️⃣ Polyline not showing — Common causes & fix

Your logic is almost correct, but there are **two key issues**:

### **A. Wrong `serviceEnabled` check logic**

You wrote:

```dart
serviceEnabled = await locationController.serviceEnabled();
if (serviceEnabled) {
  serviceEnabled = await locationController.requestService();
}
```

This logic is **inverted**. It should be:

```dart
serviceEnabled = await locationController.serviceEnabled();
if (!serviceEnabled) {
  serviceEnabled = await locationController.requestService();
  if (!serviceEnabled) return;
}
```

Otherwise, it might **never fetch location updates** → map remains at `googlePlex`.

---

### **B. Polyline request requires valid Google API setup**

Make sure:

1. You have enabled:

   * **Directions API**
   * **Maps SDK for Android**
   * **Maps SDK for iOS**
     in your [Google Cloud Console](https://console.cloud.google.com/).
2. You’re using the **same key** in:

   * `AndroidManifest.xml` (for Google Maps)
   * `.env` file (for `flutter_polyline_points`)

Example `.env`:

```
GOOGLE_MAP_KEY=YOUR_REAL_API_KEY
```

---

### **C. Update the polyline creation order**

Currently, `fetchPolylinePoints()` runs **before** the user’s location is fetched sometimes.
You can fix this by awaiting `fetchLocationUpdates()` fully first.

So, modify:

```dart
await fetchLocationUpdates();
final coordinates = await fetchPolylinePoints();
```

to:

```dart
await fetchLocationUpdates(); // ensures location ready
final coordinates = await fetchPolylinePoints();
await generatePolyLineFromPoints(coordinates);
```

---

## ✅ 2️⃣ Change default marker to a custom delivery icon

### Step 1: Add a custom marker image

Put a PNG inside:

```
assets/icons/delivery_bike.png
```

Update `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/icons/delivery_bike.png
```

### Step 2: Load the marker in `initState()`

We’ll prepare a custom `BitmapDescriptor` before creating the map.

---

## ✅ Updated full working code

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class DeliveryMapScreen extends StatefulWidget {
  const DeliveryMapScreen({super.key});

  @override
  State<DeliveryMapScreen> createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> {
  final locationController = Location();
  GoogleMapController? mapController;

  static const googlePlex = LatLng(37.4223, -122.0848);
  static const mountainView = LatLng(37.3861, -122.0839);

  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};
  BitmapDescriptor? deliveryIcon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadCustomMarker();
      await initializeMap();
    });
  }

  Future<void> _loadCustomMarker() async {
    deliveryIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/delivery_bike.png',
    );
  }

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
    final coordinates = await fetchPolylinePoints();
    await generatePolyLineFromPoints(coordinates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delivery Tracking")),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition: const CameraPosition(
                target: googlePlex,
                zoom: 13,
              ),
              markers: {
                if (currentPosition != null)
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    icon: deliveryIcon ?? BitmapDescriptor.defaultMarker,
                    position: currentPosition!,
                  ),
                Marker(
                  markerId: const MarkerId('sourceLocation'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                  position: googlePlex,
                ),
                Marker(
                  markerId: const MarkerId('destinationLocation'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  position: mountainView,
                ),
              },
              polylines: Set<Polyline>.of(polylines.values),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final currentLocation = await locationController.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      setState(() {
        currentPosition = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      });
    }

    locationController.onLocationChanged.listen((newLoc) {
      if (newLoc.latitude != null && newLoc.longitude != null) {
        setState(() {
          currentPosition = LatLng(newLoc.latitude!, newLoc.longitude!);
        });
      }
    });
  }

  Future<List<LatLng>> fetchPolylinePoints() async {
    final polylinePoints = PolylinePoints();

    final result = await polylinePoints.getRouteBetweenCoordinates(
      dotenv.env['GOOGLE_MAP_KEY'] ?? "",
      PointLatLng(googlePlex.latitude, googlePlex.longitude),
      PointLatLng(mountainView.latitude, mountainView.longitude),
    );

    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      debugPrint("Polyline error: ${result.errorMessage}");
      return [];
    }
  }

  Future<void> generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    const id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 5,
    );

    setState(() => polylines[id] = polyline);
  }
}
```

---

## ✅ Quick Checklist

| Item                                       | Status |
| ------------------------------------------ | ------ |
| `.env` has `GOOGLE_MAP_KEY`                | ✅      |
| `Directions API` enabled                   | ✅      |
| `Maps SDK for Android/iOS` enabled         | ✅      |
| `delivery_bike.png` added to assets        | ✅      |
| Android `meta-data` key matches `.env` key | ✅      |

---

Would you like me to show how to **animate the delivery marker** along the route (real-time movement simulation)?
