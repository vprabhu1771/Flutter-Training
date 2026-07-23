```dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class DriverMap extends StatefulWidget {
  const DriverMap({super.key});

  @override
  State<DriverMap> createState() => _DriverMapState();
}

class _DriverMapState extends State<DriverMap> {
  // Firestore reference
  final DocumentReference driverRef = FirebaseFirestore.instance
      .collection('drivers')
      .doc('driver_001');

  String _location = "Getting location...";
  bool _isLoading = false;
  String? _errorMessage;

  // Driver data fields
  double? _currentLatitude;
  double? _currentLongitude;
  double? _currentSpeed;
  double? _currentHeading;
  String _status = "offline";

  Future<void> _getCurrentLocation() async {
    // Don't allow multiple simultaneous requests
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _location = "Getting location...";
    });

    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _location = "Location services are disabled.";
          _errorMessage = "Please enable location services";
          _isLoading = false;
        });
        return;
      }

      // Check location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _location = "Location permissions are denied.";
            _errorMessage = "Please grant location permissions";
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _location = "Location permissions are permanently denied.";
          _errorMessage = "Please enable location permissions in settings";
          _isLoading = false;
        });
        return;
      }

      // Get the current position with speed and heading
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Store values
      _currentLatitude = position.latitude;
      _currentLongitude = position.longitude;
      _currentSpeed = position.speed; // Speed in m/s
      _currentHeading = position.heading; // Heading in degrees (0-360)

      // Update location string
      setState(() {
        _location = "Lat: ${position.latitude}, Lng: ${position.longitude}";
        _isLoading = false;
      });

      // Send location to Firestore with all fields
      await _updateDriverLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        speed: position.speed,
        heading: position.heading,
      );

    } catch (e) {
      setState(() {
        _location = "Error getting location: $e";
        _errorMessage = "Failed to get location";
        _isLoading = false;
      });
    }
  }

  Future<void> _updateDriverLocation({
    required double latitude,
    required double longitude,
    required double? speed,
    required double? heading,
  }) async {
    try {
      // Get current timestamp in seconds (Unix timestamp)
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Update driver document with your structure
      await driverRef.update({
        'latitude': latitude,
        'longitude': longitude,
        'speed': speed ?? 0.0, // Default to 0 if null
        'heading': heading ?? 0.0, // Default to 0 if null
        'updated_at': timestamp,
        'status': 'online', // Set status to online when updating location
      });

      print("✅ Location updated in Firestore successfully");
      print("📍 Lat: $latitude, Lng: $longitude");
      print("🚗 Speed: ${speed ?? 0} m/s, Heading: ${heading ?? 0}°");
      print("🕐 Updated at: $timestamp");

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location updated! Speed: ${(speed ?? 0) * 3.6} km/h'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }

    } catch (e) {
      print("❌ Error updating location in Firestore: $e");

      // If document doesn't exist, create it
      if (e.toString().contains('not found')) {
        await _createDriverDocument(latitude, longitude, speed, heading);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating location: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _createDriverDocument(
      double latitude,
      double longitude,
      double? speed,
      double? heading,
      ) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await driverRef.set({
        'latitude': latitude,
        'longitude': longitude,
        'speed': speed ?? 0.0,
        'heading': heading ?? 0.0,
        'updated_at': timestamp,
        'status': 'online',
      });

      print("✅ New driver document created");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver profile created with location'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("❌ Error creating driver document: $e");
    }
  }

  Future<void> _updateDriverStatus(String status) async {
    try {
      await driverRef.update({
        'status': status,
        'updated_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      });

      setState(() {
        _status = status;
      });

      print("✅ Status updated to: $status");
    } catch (e) {
      print("❌ Error updating status: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    // Fetch driver data when screen opens
    _fetchDriverData();

    // Get current location when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  Future<void> _fetchDriverData() async {
    try {
      final snapshot = await driverRef.get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        print("✅ Driver data loaded");
        print("📊 Data: $data");

        setState(() {
          _currentLatitude = data['latitude']?.toDouble();
          _currentLongitude = data['longitude']?.toDouble();
          _currentSpeed = data['speed']?.toDouble();
          _currentHeading = data['heading']?.toDouble();
          _status = data['status'] ?? 'offline';

          if (_currentLatitude != null && _currentLongitude != null) {
            _location = "Lat: ${_currentLatitude}, Lng: ${_currentLongitude}";
          }
        });
      } else {
        print("⚠️ Driver document doesn't exist");
        // Will be created when location is fetched
      }
    } catch (e) {
      print("❌ Error fetching driver data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Map"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Status indicator
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _status == 'online' ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _status.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isLoading ? Icons.location_searching : Icons.location_on,
                size: 80,
                color: _isLoading ? Colors.orange : Colors.blue,
              ),
              const SizedBox(height: 20),
              Text(
                "Current Location",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      _location,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_currentSpeed != null && _currentSpeed! > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        "Speed: ${(_currentSpeed! * 3.6).toStringAsFixed(1)} km/h",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                    if (_currentHeading != null && _currentHeading! > 0) ...[
                      Text(
                        "Heading: ${_currentHeading!.toStringAsFixed(0)}°",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ],
              if (_isLoading) ...[
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _getCurrentLocation,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Update Location'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      final newStatus = _status == 'online' ? 'offline' : 'online';
                      _updateDriverStatus(newStatus);
                      setState(() {
                        _status = newStatus;
                      });
                    },
                    icon: Icon(
                      _status == 'online' ? Icons.power_settings_new : Icons.power_off,
                    ),
                    label: Text(_status == 'online' ? 'Go Offline' : 'Go Online'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      backgroundColor: _status == 'online' ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _getCurrentLocation,
        icon: _isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Icon(Icons.my_location),
        label: Text(_isLoading ? 'Getting...' : 'Get Location'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }
}
```