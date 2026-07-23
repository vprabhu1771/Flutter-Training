`app/src/main/AndroidManifest.xml`

```
<uses-permission android:name="android.permission.INTERNET"/>

    <application
        android:usesCleartextTraffic="true">

        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR API KEY"/>
    </application>
```

`app_config.dart`

```dart
class AppConfig {
  // Google Maps
  static const String GOOGLE_MAPS_API_KEY =
      "YOUR API KEY";
}
```

`customer_map2.dart`

```dart
// This Code using cloud firestore

import 'dart:async';
import 'package:customer_app/app_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class CustomerMap2 extends StatefulWidget {
  const CustomerMap2({super.key});

  @override
  State<CustomerMap2> createState() => _CustomerMap2State();
}

class _CustomerMap2State extends State<CustomerMap2> {
  final Completer<GoogleMapController> _controller = Completer();

  // Firestore reference instead of Realtime Database
  final DocumentReference driverRef = FirebaseFirestore.instance
      .collection('drivers')
      .doc('driver_001');

  final Set<Marker> markers = {};

  StreamSubscription<DocumentSnapshot>? subscription;

  LatLng driverPosition = const LatLng(
    11.7442,
    79.7681,
  );

  LatLng pickupLocation = const LatLng(
    11.7505243,
    79.7492756,
  );

  final String googleApiKey = AppConfig.GOOGLE_MAPS_API_KEY;

  final PolylinePoints polylinePoints = PolylinePoints();

  List<LatLng> polylineCoordinates = [];

  Set<Polyline> polylines = {};

  bool isMapReady = false; // Add this flag

  Future<void> getPolyline() async {
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleApiKey,
        request: PolylineRequest(
          origin: PointLatLng(
            driverPosition.latitude,
            driverPosition.longitude,
          ),
          destination: PointLatLng(
            pickupLocation.latitude,
            pickupLocation.longitude,
          ),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        polylineCoordinates.clear();

        for (var point in result.points) {
          polylineCoordinates.add(
            LatLng(
              point.latitude,
              point.longitude,
            ),
          );
        }

        polylines.clear();

        polylines.add(
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            width: 6,
            color: Colors.blue, // Add color for better visibility
          ),
        );

        setState(() {});
        print("Polyline drawn with ${polylineCoordinates.length} points");
      } else {
        print("No points returned from polyline API");
      }
    } catch (e) {
      print("Error getting polyline: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    // Fetch driver data from Firestore
    driverRef.get().then((snapshot) {
      print("Exists: ${snapshot.exists}");
      print("ID: ${snapshot.id}");
      print("Data: ${snapshot.data()}");
    });

    markers.add(
      Marker(
        markerId: const MarkerId("pickup"),
        position: pickupLocation,
        infoWindow: InfoWindow(
          title: "Pickup",
          snippet: "Lat: ${pickupLocation.latitude}, Lng: ${pickupLocation.longitude}",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId("driver"),
        position: driverPosition,
        infoWindow: InfoWindow(
          title: "Driver",
          snippet: "Lat: ${driverPosition.latitude}, Lng: ${driverPosition.longitude}",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    listenDriver();
  }

  void listenDriver() {
    // Listen to real-time updates from Firestore
    subscription = driverRef.snapshots().listen(
          (DocumentSnapshot snapshot) async {
        print("=== Listen Driver ===");
        print(snapshot.data());

        if (!snapshot.exists) return;

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        driverPosition = LatLng(
          (data["latitude"] as num).toDouble(),
          (data["longitude"] as num).toDouble(),
        );

        markers.removeWhere(
              (marker) => marker.markerId.value == "driver",
        );

        markers.add(
          Marker(
            markerId: const MarkerId("driver"),
            position: driverPosition,
            infoWindow: InfoWindow(
              title: "Driver",
              snippet: "Lat: ${driverPosition.latitude}, Lng: ${driverPosition.longitude}",
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),
        );

        setState(() {});

        final GoogleMapController controller = await _controller.future;

        controller.animateCamera(
          CameraUpdate.newLatLng(driverPosition),
        );

        // Draw polyline whenever driver position updates (if map is ready)
        if (isMapReady) {
          await getPolyline();
        }
      },
      onError: (error) {
        print("Error listening to driver updates: $error");
      },
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Driver Tracking"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: driverPosition,
          zoom: 15,
        ),
        markers: markers,
        polylines: polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);
          isMapReady = true;
          // Draw initial polyline when map is created
          await getPolyline();
        },
      ),
    );
  }
}
```

`main.dart`

```dart
import 'package:customer_app/customer_map2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'customer_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: CustomerMap(),
      home: CustomerMap2(),
    ),
  );
}
```
