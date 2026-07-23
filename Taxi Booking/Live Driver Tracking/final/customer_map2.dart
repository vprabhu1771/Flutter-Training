// This Code using cloud firestore

import 'dart:async';
import 'dart:math';
import 'package:customer_app/app_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class CustomerMap2 extends StatefulWidget {
  const CustomerMap2({super.key});

  @override
  State<CustomerMap2> createState() => _CustomerMap2State();
}

class _CustomerMap2State extends State<CustomerMap2> {
  String _location = "Press the button to get location";

  final Completer<GoogleMapController> _controller = Completer();

  // Firestore reference
  final DocumentReference driverRef = FirebaseFirestore.instance
      .collection('drivers')
      .doc('driver_001');

  final Set<Marker> markers = {};

  StreamSubscription<DocumentSnapshot>? subscription;

  LatLng driverPosition = const LatLng(
    11.7442,
    79.7681,
  );

  // Initialize with null to check if pickup is set
  LatLng? pickupLocation;

  final String googleApiKey = AppConfig.GOOGLE_MAPS_API_KEY;

  final PolylinePoints polylinePoints = PolylinePoints();

  List<LatLng> polylineCoordinates = [];

  Set<Polyline> polylines = {};

  bool isMapReady = false;
  bool isFirstLoad = true;

  Future<void> getPolyline() async {
    try {
      // Clear existing polylines
      polylines.clear();

      // Check if we have valid positions
      if (pickupLocation == null) {
        print("Pickup location not set yet");
        return;
      }

      if (driverPosition == const LatLng(0, 0) ||
          pickupLocation == const LatLng(0, 0)) {
        print("Invalid positions for polyline");
        return;
      }

      print("Getting polyline from: ${driverPosition.latitude}, ${driverPosition.longitude}");
      print("To: ${pickupLocation!.latitude}, ${pickupLocation!.longitude}");

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleApiKey,
        request: PolylineRequest(
          origin: PointLatLng(
            driverPosition.latitude,
            driverPosition.longitude,
          ),
          destination: PointLatLng(
            pickupLocation!.latitude,
            pickupLocation!.longitude,
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

        polylines.add(
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            width: 6,
            color: Colors.blue,
          ),
        );

        setState(() {});
        print("Polyline drawn with ${polylineCoordinates.length} points");
      } else {
        print("No points returned from polyline API");
        if (result.errorMessage != null) {
          print("API Error: ${result.errorMessage}");
        }
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

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        driverPosition = LatLng(
          (data["latitude"] as num).toDouble(),
          (data["longitude"] as num).toDouble(),
        );
        setState(() {});
      }
    });

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

        // Update driver position
        driverPosition = LatLng(
          (data["latitude"] as num).toDouble(),
          (data["longitude"] as num).toDouble(),
        );

        // Update markers
        markers.clear(); // Clear all markers first

        // Add driver marker
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

        // Add pickup marker if location is set
        if (pickupLocation != null) {
          markers.add(
            Marker(
              markerId: const MarkerId("pickup"),
              position: pickupLocation!,
              infoWindow: InfoWindow(
                title: "Pickup",
                snippet: "Lat: ${pickupLocation!.latitude}, Lng: ${pickupLocation!.longitude}",
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
          );
        }

        setState(() {});

        // Only animate camera and draw polyline if map is ready
        if (isMapReady) {
          final GoogleMapController controller = await _controller.future;

          // Animate to driver position
          await controller.animateCamera(
            CameraUpdate.newLatLng(driverPosition),
          );

          // Draw polyline if pickup location is set
          if (pickupLocation != null) {
            await getPolyline();
          }
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

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location services are disabled.")),
      );
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permissions are denied.")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permissions are permanently denied.")),
      );
      return;
    }

    try {
      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      setState(() {
        _location = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
        pickupLocation = LatLng(
          position.latitude,
          position.longitude,
        );
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pickup location set: ${_location}"),
          backgroundColor: Colors.green,
        ),
      );

      // Update markers with pickup location
      markers.clear();

      // Add driver marker
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

      // Add pickup marker
      markers.add(
        Marker(
          markerId: const MarkerId("pickup"),
          position: pickupLocation!,
          infoWindow: InfoWindow(
            title: "Pickup Location",
            snippet: "Lat: ${pickupLocation!.latitude}, Lng: ${pickupLocation!.longitude}",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      // Draw polyline between driver and pickup
      if (isMapReady && _controller.isCompleted) {
        final GoogleMapController controller = await _controller.future;

        // Draw the polyline
        await getPolyline();

        // Animate camera to show both locations
        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(
            min(driverPosition.latitude, pickupLocation!.latitude) - 0.01,
            min(driverPosition.longitude, pickupLocation!.longitude) - 0.01,
          ),
          northeast: LatLng(
            max(driverPosition.latitude, pickupLocation!.latitude) + 0.01,
            max(driverPosition.longitude, pickupLocation!.longitude) + 0.01,
          ),
        );

        await controller.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50),
        );
      }

      setState(() {});

    } catch (e) {
      print("Error getting location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error getting location: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Driver Tracking"),
        actions: [
          IconButton(
            onPressed: _getCurrentLocation,
            icon: const Icon(Icons.my_location),
            tooltip: "Get My Location",
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
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

              // Wait a moment for map to fully load
              await Future.delayed(const Duration(milliseconds: 500));

              // Draw initial polyline if pickup location exists
              if (pickupLocation != null) {
                await getPolyline();
              }

              // Show initial markers
              setState(() {});
            },
          ),
          // Position Info at bottom
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "📍 Driver: ${driverPosition.latitude.toStringAsFixed(6)}, ${driverPosition.longitude.toStringAsFixed(6)}",
                    style: const TextStyle(fontSize: 12),
                  ),
                  if (pickupLocation != null)
                    Text(
                      "📌 You: ${pickupLocation!.latitude.toStringAsFixed(6)}, ${pickupLocation!.longitude.toStringAsFixed(6)}",
                      style: const TextStyle(fontSize: 12),
                    )
                  else
                    const Text(
                      "📌 Click location button to set pickup",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ),
          // Refresh button
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              onPressed: () async {
                if (pickupLocation == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please set pickup location first")),
                  );
                  return;
                }
                await getPolyline();
                if (_controller.isCompleted) {
                  final controller = await _controller.future;
                  await controller.animateCamera(
                    CameraUpdate.newLatLngBounds(
                      LatLngBounds(
                        southwest: LatLng(
                          min(driverPosition.latitude, pickupLocation!.latitude) - 0.01,
                          min(driverPosition.longitude, pickupLocation!.longitude) - 0.01,
                        ),
                        northeast: LatLng(
                          max(driverPosition.latitude, pickupLocation!.latitude) + 0.01,
                          max(driverPosition.longitude, pickupLocation!.longitude) + 0.01,
                        ),
                      ),
                      50,
                    ),
                  );
                }
              },
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}

// This Code using cloud firestore

// import 'dart:async';
// import 'dart:math';
// import 'package:customer_app/app_config.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//
// class CustomerMap2 extends StatefulWidget {
//   const CustomerMap2({super.key});
//
//   @override
//   State<CustomerMap2> createState() => _CustomerMap2State();
// }
//
// class _CustomerMap2State extends State<CustomerMap2> {
//   // Location text for display
//   String _location = "Press the button to get location";
//
//   // Google Map Controller
//   final Completer<GoogleMapController> _controller = Completer();
//
//   // Firestore reference
//   final DocumentReference driverRef = FirebaseFirestore.instance
//       .collection('drivers')
//       .doc('driver_001');
//
//   // Markers set
//   final Set<Marker> markers = {};
//
//   // Stream subscription for real-time updates
//   StreamSubscription<DocumentSnapshot>? subscription;
//
//   // Driver position (initial default)
//   LatLng driverPosition = const LatLng(
//     11.7442,
//     79.7681,
//   );
//
//   // Pickup location (null until set)
//   LatLng? pickupLocation;
//
//   // Google Maps API Key
//   final String googleApiKey = AppConfig.GOOGLE_MAPS_API_KEY;
//
//   // Polyline points
//   final PolylinePoints polylinePoints = PolylinePoints();
//   List<LatLng> polylineCoordinates = [];
//   Set<Polyline> polylines = {};
//
//   // Map state flags
//   bool isMapReady = false;
//   bool isFirstLoad = true;
//
//   // Driver data
//   String driverStatus = "offline";
//   double driverSpeed = 0.0;
//   double driverHeading = 0.0;
//   String driverName = "Driver";
//   DateTime? lastUpdated;
//
//   // ETA information
//   String etaText = "Calculating...";
//   double etaMinutes = 0;
//   double distanceToPickup = 0;
//
//   // Camera animation control
//   bool isCameraAnimating = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Fetch initial driver data
//     _fetchInitialDriverData();
//
//     // Start listening to real-time updates
//     listenDriver();
//   }
//
//   @override
//   void dispose() {
//     subscription?.cancel();
//     super.dispose();
//   }
//
//   // Fetch initial driver data from Firestore
//   Future<void> _fetchInitialDriverData() async {
//     try {
//       DocumentSnapshot snapshot = await driverRef.get();
//
//       if (snapshot.exists) {
//         Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//
//         setState(() {
//           driverPosition = LatLng(
//             (data["latitude"] as num).toDouble(),
//             (data["longitude"] as num).toDouble(),
//           );
//           driverStatus = data["status"] ?? "offline";
//           driverSpeed = (data["speed"] as num?)?.toDouble() ?? 0.0;
//           driverHeading = (data["heading"] as num?)?.toDouble() ?? 0.0;
//           driverName = data["name"] ?? "Driver";
//           lastUpdated = (data["last_updated"] as Timestamp?)?.toDate();
//         });
//
//         // Add initial driver marker
//         _updateDriverMarker();
//       }
//     } catch (e) {
//       print("Error fetching initial driver data: $e");
//     }
//   }
//
//   // Listen to real-time driver updates from Firestore
//   void listenDriver() {
//     subscription = driverRef.snapshots().listen(
//           (DocumentSnapshot snapshot) async {
//         print("=== Driver Update Received ===");
//
//         if (!snapshot.exists) {
//           print("Driver document doesn't exist");
//           return;
//         }
//
//         try {
//           Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//
//           // Extract data with fallbacks
//           double lat = (data["latitude"] as num?)?.toDouble() ?? 0;
//           double lng = (data["longitude"] as num?)?.toDouble() ?? 0;
//           String status = data["status"] ?? "offline";
//           double speed = (data["speed"] as num?)?.toDouble() ?? 0;
//           double heading = (data["heading"] as num?)?.toDouble() ?? 0;
//           String name = data["name"] ?? "Driver";
//           Timestamp? timestamp = data["last_updated"] as Timestamp?;
//
//           // Validate coordinates
//           if (lat == 0 && lng == 0) {
//             print("Invalid coordinates received");
//             return;
//           }
//
//           LatLng newPosition = LatLng(lat, lng);
//
//           // Update state
//           setState(() {
//             driverPosition = newPosition;
//             driverStatus = status;
//             driverSpeed = speed;
//             driverHeading = heading;
//             driverName = name;
//             lastUpdated = timestamp?.toDate();
//           });
//
//           // Update driver marker
//           _updateDriverMarker();
//
//           // Auto-center on driver if no pickup set and map is ready
//           if (isMapReady && pickupLocation == null && !isCameraAnimating) {
//             final GoogleMapController controller = await _controller.future;
//             isCameraAnimating = true;
//             await controller.animateCamera(
//               CameraUpdate.newLatLng(driverPosition),
//             );
//             isCameraAnimating = false;
//           }
//
//           // Update polyline and ETA if pickup is set
//           if (pickupLocation != null) {
//             await _updateRouteAndETA();
//           }
//
//           print("Driver position updated: $lat, $lng | Status: $status");
//
//         } catch (e) {
//           print("Error processing driver update: $e");
//         }
//       },
//       onError: (error) {
//         print("Error listening to driver updates: $error");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Error receiving driver updates: $error"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       },
//     );
//   }
//
//   // Update driver marker with current data
//   void _updateDriverMarker() {
//     setState(() {
//       // Remove existing driver marker
//       markers.removeWhere((marker) =>
//       marker.markerId.value == "driver" ||
//           marker.markerId.value == "driver_status"
//       );
//
//       // Determine marker color based on status
//       BitmapDescriptor markerIcon;
//       if (driverStatus == "online") {
//         markerIcon = BitmapDescriptor.defaultMarkerWithHue(
//             BitmapDescriptor.hueBlue
//         );
//       } else if (driverStatus == "busy") {
//         markerIcon = BitmapDescriptor.defaultMarkerWithHue(
//             BitmapDescriptor.hueOrange
//         );
//       } else {
//         markerIcon = BitmapDescriptor.defaultMarkerWithHue(
//             BitmapDescriptor.hueRed
//         );
//       }
//
//       // Add driver marker
//       markers.add(
//         Marker(
//           markerId: const MarkerId("driver"),
//           position: driverPosition,
//           infoWindow: InfoWindow(
//             title: driverName,
//             snippet: "Status: ${driverStatus.toUpperCase()}\n"
//                 "Speed: ${driverSpeed.toStringAsFixed(1)} km/h\n"
//                 "Last update: ${_formatTimestamp(lastUpdated)}",
//           ),
//           icon: markerIcon,
//           rotation: driverHeading,
//           anchor: const Offset(0.5, 0.5),
//         ),
//       );
//
//       // Add pickup marker if exists
//       if (pickupLocation != null) {
//         markers.removeWhere((marker) => marker.markerId.value == "pickup");
//         markers.add(
//           Marker(
//             markerId: const MarkerId("pickup"),
//             position: pickupLocation!,
//             infoWindow: const InfoWindow(
//               title: "Pickup Location",
//               snippet: "Your pickup point",
//             ),
//             icon: BitmapDescriptor.defaultMarkerWithHue(
//                 BitmapDescriptor.hueRed
//             ),
//           ),
//         );
//       }
//     });
//   }
//
//   // Format timestamp for display
//   String _formatTimestamp(DateTime? timestamp) {
//     if (timestamp == null) return "N/A";
//     final now = DateTime.now();
//     final difference = now.difference(timestamp);
//
//     if (difference.inSeconds < 60) {
//       return "${difference.inSeconds}s ago";
//     } else if (difference.inMinutes < 60) {
//       return "${difference.inMinutes}m ago";
//     } else if (difference.inHours < 24) {
//       return "${difference.inHours}h ago";
//     } else {
//       return "${difference.inDays}d ago";
//     }
//   }
//
//   // Get polyline route between driver and pickup
//   Future<void> getPolyline() async {
//     try {
//       // Clear existing polylines
//       polylines.clear();
//
//       // Check if we have valid positions
//       if (pickupLocation == null) {
//         print("Pickup location not set yet");
//         return;
//       }
//
//       if (driverPosition == const LatLng(0, 0) ||
//           pickupLocation == const LatLng(0, 0)) {
//         print("Invalid positions for polyline");
//         return;
//       }
//
//       print("Getting polyline from: ${driverPosition.latitude}, ${driverPosition.longitude}");
//       print("To: ${pickupLocation!.latitude}, ${pickupLocation!.longitude}");
//
//       PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         googleApiKey: googleApiKey,
//         request: PolylineRequest(
//           origin: PointLatLng(
//             driverPosition.latitude,
//             driverPosition.longitude,
//           ),
//           destination: PointLatLng(
//             pickupLocation!.latitude,
//             pickupLocation!.longitude,
//           ),
//           mode: TravelMode.driving,
//         ),
//       );
//
//       if (result.points.isNotEmpty) {
//         polylineCoordinates.clear();
//
//         for (var point in result.points) {
//           polylineCoordinates.add(
//             LatLng(
//               point.latitude,
//               point.longitude,
//             ),
//           );
//         }
//
//         polylines.add(
//           Polyline(
//             polylineId: const PolylineId("route"),
//             points: polylineCoordinates,
//             width: 6,
//             color: Colors.blue,
//             patterns: [
//               PatternItem.dash(30),
//               PatternItem.gap(10),
//             ],
//           ),
//         );
//
//         setState(() {});
//         print("Polyline drawn with ${polylineCoordinates.length} points");
//
//         // Calculate route distance and duration
//         await _calculateRouteInfo(result);
//
//       } else {
//         print("No points returned from polyline API");
//         if (result.errorMessage != null) {
//           print("API Error: ${result.errorMessage}");
//         }
//       }
//     } catch (e) {
//       print("Error getting polyline: $e");
//     }
//   }
//
//   // Calculate route information
//   Future<void> _calculateRouteInfo(PolylineResult result) async {
//     try {
//       if (result.points.isEmpty) return;
//
//       // Calculate total distance
//       double totalDistance = 0;
//       for (int i = 0; i < result.points.length - 1; i++) {
//         var p1 = result.points[i];
//         var p2 = result.points[i + 1];
//         totalDistance += _calculateDistance(
//             p1.latitude, p1.longitude,
//             p2.latitude, p2.longitude
//         );
//       }
//
//       setState(() {
//         distanceToPickup = totalDistance;
//
//         // Calculate ETA based on driver speed or average speed
//         if (driverSpeed > 5) {
//           // Use actual driver speed if available
//           etaMinutes = (totalDistance / 1000) / driverSpeed * 60;
//         } else {
//           // Default average speed of 40 km/h
//           etaMinutes = (totalDistance / 1000) / 40 * 60;
//         }
//
//         // Format ETA text
//         if (etaMinutes < 1) {
//           etaText = "Less than a minute";
//         } else if (etaMinutes < 60) {
//           etaText = "${etaMinutes.round()} minutes";
//         } else {
//           int hours = etaMinutes ~/ 60;
//           int minutes = etaMinutes.round() % 60;
//           etaText = "$hours hour${hours > 1 ? 's' : ''} ${minutes > 0 ? '$minutes min' : ''}";
//         }
//       });
//
//     } catch (e) {
//       print("Error calculating route info: $e");
//     }
//   }
//
//   // Update route and ETA
//   Future<void> _updateRouteAndETA() async {
//     await getPolyline();
//   }
//
//   // Calculate distance between two points (in km)
//   double _calculateDistance(lat1, lon1, lat2, lon2) {
//     var p = 0.017453292519943295;
//     var a = 0.5 - cos((lat2 - lat1) * p) / 2 +
//         cos(lat1 * p) * cos(lat2 * p) *
//             (1 - cos((lon2 - lon1) * p)) / 2;
//     return 12742 * asin(sqrt(a)); // Returns distance in km
//   }
//
//   // Get current location for pickup
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Location services are disabled.")),
//       );
//       return;
//     }
//
//     // Check location permission
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Location permissions are denied.")),
//         );
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Location permissions are permanently denied.")),
//       );
//       return;
//     }
//
//     try {
//       // Show loading
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Getting your location..."),
//           backgroundColor: Colors.blue,
//         ),
//       );
//
//       // Get the current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: const Duration(seconds: 10),
//       );
//
//       setState(() {
//         _location = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
//         pickupLocation = LatLng(
//           position.latitude,
//           position.longitude,
//         );
//       });
//
//       // Update markers
//       _updateDriverMarker();
//
//       // Draw polyline and update ETA
//       if (isMapReady && _controller.isCompleted) {
//         final GoogleMapController controller = await _controller.future;
//
//         // Draw the polyline
//         await _updateRouteAndETA();
//
//         // Animate camera to show both locations
//         LatLngBounds bounds = LatLngBounds(
//           southwest: LatLng(
//             min(driverPosition.latitude, pickupLocation!.latitude) - 0.01,
//             min(driverPosition.longitude, pickupLocation!.longitude) - 0.01,
//           ),
//           northeast: LatLng(
//             max(driverPosition.latitude, pickupLocation!.latitude) + 0.01,
//             max(driverPosition.longitude, pickupLocation!.longitude) + 0.01,
//           ),
//         );
//
//         isCameraAnimating = true;
//         await controller.animateCamera(
//           CameraUpdate.newLatLngBounds(bounds, 50),
//         );
//         isCameraAnimating = false;
//       }
//
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Pickup location set! Distance: ${distanceToPickup.toStringAsFixed(1)} km"),
//           backgroundColor: Colors.green,
//         ),
//       );
//
//     } catch (e) {
//       print("Error getting location: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error getting location: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   // Zoom to show both driver and pickup
//   Future<void> _zoomToFit() async {
//     if (pickupLocation == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please set pickup location first")),
//       );
//       return;
//     }
//
//     if (!_controller.isCompleted) return;
//
//     try {
//       final GoogleMapController controller = await _controller.future;
//
//       LatLngBounds bounds = LatLngBounds(
//         southwest: LatLng(
//           min(driverPosition.latitude, pickupLocation!.latitude) - 0.01,
//           min(driverPosition.longitude, pickupLocation!.longitude) - 0.01,
//         ),
//         northeast: LatLng(
//           max(driverPosition.latitude, pickupLocation!.latitude) + 0.01,
//           max(driverPosition.longitude, pickupLocation!.longitude) + 0.01,
//         ),
//       );
//
//       isCameraAnimating = true;
//       await controller.animateCamera(
//         CameraUpdate.newLatLngBounds(bounds, 50),
//       );
//       isCameraAnimating = false;
//     } catch (e) {
//       print("Error zooming to fit: $e");
//     }
//   }
//
//   // Clear pickup location
//   void _clearPickupLocation() {
//     setState(() {
//       pickupLocation = null;
//       polylines.clear();
//       polylineCoordinates.clear();
//       etaText = "Calculating...";
//       distanceToPickup = 0;
//       etaMinutes = 0;
//
//       // Update markers (remove pickup marker)
//       markers.removeWhere((marker) => marker.markerId.value == "pickup");
//       _updateDriverMarker();
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Pickup location cleared"),
//         backgroundColor: Colors.orange,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Live Driver Tracking"),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             onPressed: _getCurrentLocation,
//             icon: const Icon(Icons.my_location),
//             tooltip: "Set Pickup Location",
//           ),
//           IconButton(
//             onPressed: pickupLocation != null ? _zoomToFit : null,
//             icon: const Icon(Icons.zoom_out_map),
//             tooltip: "Zoom to Fit",
//           ),
//           IconButton(
//             onPressed: pickupLocation != null ? _clearPickupLocation : null,
//             icon: const Icon(Icons.clear),
//             tooltip: "Clear Pickup",
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // Google Map
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: driverPosition,
//               zoom: 15,
//             ),
//             markers: markers,
//             polylines: polylines,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             zoomControlsEnabled: true,
//             compassEnabled: true,
//             mapToolbarEnabled: true,
//             onMapCreated: (GoogleMapController controller) async {
//               _controller.complete(controller);
//               isMapReady = true;
//
//               // Wait a moment for map to fully load
//               await Future.delayed(const Duration(milliseconds: 500));
//
//               // Draw initial polyline if pickup location exists
//               if (pickupLocation != null) {
//                 await _updateRouteAndETA();
//               }
//
//               // Update markers
//               _updateDriverMarker();
//             },
//           ),
//
//           // Driver Status Indicator (Top)
//           Positioned(
//             top: 10,
//             left: 10,
//             right: 10,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 12,
//                     height: 12,
//                     decoration: BoxDecoration(
//                       color: driverStatus == "online" ? Colors.green :
//                       driverStatus == "busy" ? Colors.orange : Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     "Driver: ${driverName.toUpperCase()} • ${driverStatus.toUpperCase()}",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                   if (driverSpeed > 0) ...[
//                     const SizedBox(width: 8),
//                     Icon(Icons.speed, size: 16, color: Colors.blue),
//                     Text(
//                       " ${driverSpeed.toStringAsFixed(1)} km/h",
//                       style: const TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//
//           // ETA Information (Middle)
//           if (pickupLocation != null)
//             Positioned(
//               top: 70,
//               left: 10,
//               right: 10,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Column(
//                       children: [
//                         const Text(
//                           "ETA",
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                         Text(
//                           etaText,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       width: 1,
//                       height: 30,
//                       color: Colors.grey[300],
//                     ),
//                     Column(
//                       children: [
//                         const Text(
//                           "Distance",
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                         Text(
//                           "${distanceToPickup.toStringAsFixed(1)} km",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Colors.green,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       width: 1,
//                       height: 30,
//                       color: Colors.grey[300],
//                     ),
//                     Column(
//                       children: [
//                         const Text(
//                           "Status",
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                         Text(
//                           driverStatus.toUpperCase(),
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                             color: driverStatus == "online" ? Colors.green :
//                             driverStatus == "busy" ? Colors.orange : Colors.red,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//           // Location Info (Bottom)
//           Positioned(
//             bottom: 20,
//             left: 16,
//             right: 16,
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.directions_car, size: 16, color: Colors.blue),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           "Driver: ${driverPosition.latitude.toStringAsFixed(6)}, ${driverPosition.longitude.toStringAsFixed(6)}",
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   if (pickupLocation != null)
//                     Row(
//                       children: [
//                         Icon(Icons.location_on, size: 16, color: Colors.red),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             "You: ${pickupLocation!.latitude.toStringAsFixed(6)}, ${pickupLocation!.longitude.toStringAsFixed(6)}",
//                             style: const TextStyle(fontSize: 12),
//                           ),
//                         ),
//                       ],
//                     )
//                   else
//                     Row(
//                       children: [
//                         Icon(Icons.info, size: 16, color: Colors.grey),
//                         const SizedBox(width: 8),
//                         const Text(
//                           "Tap location button (📍) to set pickup point",
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   if (lastUpdated != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Text(
//                         "Last update: ${_formatTimestamp(lastUpdated)}",
//                         style: const TextStyle(
//                           fontSize: 10,
//                           color: Colors.grey,
//                           fontStyle: FontStyle.italic,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Refresh and Zoom buttons
//           Positioned(
//             bottom: 120,
//             right: 16,
//             child: Column(
//               children: [
//                 FloatingActionButton(
//                   mini: true,
//                   heroTag: "refresh",
//                   onPressed: pickupLocation != null ? _updateRouteAndETA : null,
//                   backgroundColor: Colors.white,
//                   foregroundColor: Colors.blue,
//                   child: const Icon(Icons.refresh),
//                 ),
//                 const SizedBox(height: 8),
//                 FloatingActionButton(
//                   mini: true,
//                   heroTag: "zoom",
//                   onPressed: pickupLocation != null ? _zoomToFit : null,
//                   backgroundColor: Colors.white,
//                   foregroundColor: Colors.blue,
//                   child: const Icon(Icons.center_focus_strong),
//                 ),
//               ],
//             ),
//           ),
//
//           // Loading indicator (if needed)
//           if (!isMapReady)
//             const Center(
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
// }