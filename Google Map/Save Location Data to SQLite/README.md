`pubspec.yaml`
```
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.5.0
  location: ^5.0.0
  crypto: ^3.0.3
  sqflite: ^2.3.0
  path: ^1.8.3
```

```dart
import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GoogleMapTrackingScreen extends StatefulWidget {
  const GoogleMapTrackingScreen({super.key});

  @override
  State<GoogleMapTrackingScreen> createState() => _GoogleMapTrackingScreenState();
}

class _GoogleMapTrackingScreenState extends State<GoogleMapTrackingScreen> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;
  Database? _database;

  @override
  void initState() {
    super.initState();
    _init();
  }

  String gravatarUrl(String email, {int size = 200}) {
    final hash = md5.convert(utf8.encode(email.trim().toLowerCase())).toString();
    return 'https://www.gravatar.com/avatar/$hash?s=$size&d=mp';
  }

  Future<void> _init() async {
    _location = Location();
    _cameraPosition = const CameraPosition(
      target: LatLng(0, 0),
      zoom: 15,
    );
    
    // 1. Initialize SQLite Database
    await _initDatabase();
    
    // 2. Initialize Location Tracking
    _initLocation();
  }

  // --- SQLite Helpers ---
  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'location_tracker.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE locations(id INTEGER PRIMARY KEY AUTOINCREMENT, latitude REAL, longitude REAL, timestamp TEXT)',
        );
      },
    );
  }

  Future<void> _saveLocationToDatabase(double latitude, double longitude) async {
    if (_database == null) return;

    await _database!.insert(
      'locations',
      {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    debugPrint("Saved Location: $latitude, $longitude");
  }

  // --- Location Listener ---
  void _initLocation() async {
    // Request permission if not already granted
    bool serviceEnabled = await _location!.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location!.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location!.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location!.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Get initial position
    _location?.getLocation().then((location) {
      if (location.latitude != null && location.longitude != null) {
        _currentLocation = location;
        _saveLocationToDatabase(location.latitude!, location.longitude!);
      }
    });

    // Listen for continuous updates
    _location?.onLocationChanged.listen((newLocation) {
      if (newLocation.latitude != null && newLocation.longitude != null) {
        setState(() {
          _currentLocation = newLocation;
        });

        LatLng currentLatLng = LatLng(newLocation.latitude!, newLocation.longitude!);
        
        // Move Camera
        moveToPosition(currentLatLng);

        // Save position to SQLite database
        _saveLocationToDatabase(newLocation.latitude!, newLocation.longitude!);
      }
    });
  }

  Future<void> moveToPosition(LatLng latLng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return _getMap();
  }

  Widget _getMarker() {
    const email = "user@example.com";

    return Container(
      width: 50,
      height: 50,
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          gravatarUrl(email),
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 30,
              color: Colors.grey,
            );
          },
        ),
      ),
    );
  }

  Widget _getMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: _getMarker(),
          ),
        ),
      ],
    );
  }
}
```