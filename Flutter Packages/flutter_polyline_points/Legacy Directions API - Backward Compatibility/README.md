Here's a complete Flutter implementation for drawing a polyline on Google Maps using the `flutter_polyline_points` package:

## 1. Add Dependencies

First, add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.5.0
  flutter_polyline_points: ^2.0.0
  # For the legacy Directions API (optional, but recommended)
  http: ^1.1.0
```

## 2. Complete Implementation

Here's a complete example with both legacy and modern approaches:

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PolylineMapScreen extends StatefulWidget {
  @override
  _PolylineMapScreenState createState() => _PolylineMapScreenState();
}

class _PolylineMapScreenState extends State<PolylineMapScreen> {
  GoogleMapController? _mapController;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  final List<LatLng> _polylineCoordinates = [];

  // Initialize PolylinePoints
  late PolylinePoints polylinePoints;
  final String _apiKey = "YOUR_GOOGLE_MAPS_API_KEY"; // Replace with your API key

  // Sample locations
  final LatLng _origin = LatLng(37.7749, -122.4194); // San Francisco
  final LatLng _destination = LatLng(37.3382, -121.8863); // San Jose

  @override
  void initState() {
    super.initState();
    polylinePoints = PolylinePoints(apiKey: _apiKey);
    _getRoute();
  }

  // Method 1: Using Legacy Directions API
  Future<void> _getRoute() async {
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(_origin.latitude, _origin.longitude),
          destination: PointLatLng(_destination.latitude, _destination.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        setState(() {
          _polylineCoordinates.clear();
          _polylineCoordinates.addAll(
            result.points.map(
              (point) => LatLng(point.latitude, point.longitude)
            )
          );

          // Add polyline to map
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: _polylineCoordinates,
              color: Colors.blue,
              width: 5,
              geodesic: true,
            ),
          );

          // Add markers
          _markers.addAll([
            Marker(
              markerId: MarkerId('origin'),
              position: _origin,
              infoWindow: InfoWindow(title: 'Origin', snippet: 'San Francisco'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            ),
            Marker(
              markerId: MarkerId('destination'),
              position: _destination,
              infoWindow: InfoWindow(title: 'Destination', snippet: 'San Jose'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
          ]);
        });
      } else {
        print('No points found: ${result.errorMessage}');
      }
    } catch (e) {
      print('Error getting route: $e');
    }
  }

  // Method 2: Using Modern Directions API (Recommended)
  Future<void> _getRouteModern() async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${_origin.latitude},${_origin.longitude}'
          '&destination=${_destination.latitude},${_destination.longitude}'
          '&mode=driving'
          '&key=$_apiKey';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          // Decode polyline from route
          final route = data['routes'][0];
          final polylinePoint = route['overview_polyline']['points'];
          
          // Decode the polyline
          List<PointLatLng> decodedPoints = 
              polylinePoints.decodePolyline(polylinePoint);
          
          setState(() {
            _polylineCoordinates.clear();
            _polylineCoordinates.addAll(
              decodedPoints.map(
                (point) => LatLng(point.latitude, point.longitude)
              )
            );

            _polylines.add(
              Polyline(
                polylineId: PolylineId('route'),
                points: _polylineCoordinates,
                color: Colors.blue,
                width: 5,
                geodesic: true,
              ),
            );
          });
        }
      }
    } catch (e) {
      print('Error getting route: $e');
    }
  }

  // Method 3: Using Directions API with Waypoints
  Future<void> _getRouteWithWaypoints() async {
    try {
      // Example with waypoints
      List<PointLatLng> waypoints = [
        PointLatLng(37.4512, -122.1728), // San Mateo
        PointLatLng(37.5222, -122.1402), // Redwood City
      ];

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(_origin.latitude, _origin.longitude),
          destination: PointLatLng(_destination.latitude, _destination.longitude),
          wayPoints: waypoints,
          mode: TravelMode.driving,
          optimizeWaypoints: true, // Optimize waypoint order
        ),
      );

      if (result.points.isNotEmpty) {
        setState(() {
          _polylineCoordinates.clear();
          _polylineCoordinates.addAll(
            result.points.map(
              (point) => LatLng(point.latitude, point.longitude)
            )
          );

          _polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: _polylineCoordinates,
              color: Colors.blue,
              width: 5,
              geodesic: true,
            ),
          );
        });
      }
    } catch (e) {
      print('Error getting route: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Polyline'),
        backgroundColor: Colors.blue,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.5, -122.2),
          zoom: 10,
        ),
        polylines: _polylines,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          
          // Animate camera to show entire route
          if (_polylineCoordinates.isNotEmpty) {
            _mapController?.animateCamera(
              CameraUpdate.newLatLngBounds(
                _getBoundsFromPoints(_polylineCoordinates),
                50,
              ),
            );
          }
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn1',
            onPressed: _getRoute,
            child: Icon(Icons.directions),
            backgroundColor: Colors.blue,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'btn2',
            onPressed: _getRouteModern,
            child: Icon(Icons.refresh),
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }

  // Helper method to calculate bounds from points
  LatLngBounds _getBoundsFromPoints(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
```

## 3. Android Configuration

Update `android/app/src/main/AndroidManifest.xml`:

```xml
<application>
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
</application>
```

## 4. iOS Configuration

Add to `ios/Runner/AppDelegate.swift`:

```swift
import GoogleMaps

override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
```

## 5. Key Features

The implementation includes:

- **Multiple routing methods** (Legacy and Modern Directions API)
- **Waypoint support** for complex routes
- **Markers** at origin and destination
- **Auto-zoom** to fit the entire route
- **Error handling** for API failures
- **Clean UI** with floating action buttons

## 6. Getting Your API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable the following APIs:
   - Maps SDK for Android/iOS
   - Directions API
   - Geocoding API (if needed)
3. Create credentials and copy your API key

Replace `YOUR_GOOGLE_MAPS_API_KEY` in the code with your actual API key.

This implementation handles both legacy (`flutter_polyline_points` package) and modern approaches, giving you flexibility and backward compatibility.
