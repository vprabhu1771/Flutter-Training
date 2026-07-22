```yaml
geolocator: ^11.0.0 # Use the latest version
geocoding: ^2.1.0
google_maps_flutter: any
location: any
crypto: ^3.0.6
sqflite: ^2.3.0
path: ^1.8.3
intl: ^0.18.0
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

  // Map-related variables
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> _locationPoints = [];
  List<Map<String, dynamic>> _locationRecords = [];
  bool _isLoading = false;

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
      target: LatLng(11.7498, 79.7499),
      zoom: 17,
    );

    // 1. Initialize SQLite Database
    await _initDatabase();

    // 2. Load all locations from database
    await _loadAllLocationsFromDatabase();

    // 3. Initialize Location Tracking
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

    // Reload locations to update the map
    await _loadAllLocationsFromDatabase();
  }

  Future<void> _loadAllLocationsFromDatabase() async {
    if (_database == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final records = await _database!.rawQuery(
          'SELECT * FROM locations ORDER BY id ASC'
      );

      setState(() {
        _locationRecords = records;
        _locationPoints.clear();
        _markers.clear();
        _polylines.clear();
      });

      // Process each location record
      for (var record in records) {
        final lat = record['latitude'] as double;
        final lng = record['longitude'] as double;
        final id = record['id'] as int;
        final timestamp = record['timestamp'] as String;

        LatLng point = LatLng(lat, lng);
        _locationPoints.add(point);

        // Add marker for each location
        _markers.add(
          Marker(
            markerId: MarkerId(id.toString()),
            position: point,
            infoWindow: InfoWindow(
              title: 'Location #$id',
              snippet: _formatTimestamp(timestamp),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              id == records.first['id']
                  ? BitmapDescriptor.hueGreen
                  : id == records.last['id']
                  ? BitmapDescriptor.hueBlue
                  : BitmapDescriptor.hueRed,
            ),
          ),
        );
      }

      // Create polylines if we have points
      if (_locationPoints.isNotEmpty) {
        // Main dashed polyline
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('user_path'),
            points: _locationPoints,
            color: Colors.blue,
            width: 4,
            patterns: [
              PatternItem.dash(20),
              PatternItem.gap(10),
            ],
          ),
        );

        // Solid path
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('user_path_solid'),
            points: _locationPoints,
            color: Colors.blue.withOpacity(0.6),
            width: 2,
          ),
        );
      }

      debugPrint('Loaded ${records.length} locations from database');

    } catch (e) {
      debugPrint('Error loading locations: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  String _formatTimestamp(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return '${dateTime.month}/${dateTime.day} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }

  Future<void> _getAllLocations(BuildContext context) async {
    if (_database == null) return;

    final records = await _database!.rawQuery('SELECT * FROM locations ORDER BY id DESC');

    // Show dialog with locations
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Locations'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return ListTile(
                title: Text('Location #${record['id']}'),
                subtitle: Text(
                    'Lat: ${record['latitude']}, Lng: ${record['longitude']}'
                ),
                trailing: Text(
                  _formatTimestamp(record['timestamp'] as String),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () async {
              await _clearAllLocations();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllLocations() async {
    if (_database == null) return;

    await _database!.delete('locations');
    setState(() {
      _locationPoints.clear();
      _markers.clear();
      _polylines.clear();
      _locationRecords.clear();
    });
    debugPrint('All locations cleared');
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
        setState(() {
          _currentLocation = location;
        });
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
          zoom: 17,
        ),
      ),
    );
  }

  void _fitToPath() {
    if (_locationPoints.isNotEmpty) {
      _googleMapController.future.then((controller) {
        controller.animateCamera(
          CameraUpdate.newLatLngBounds(
            _getBounds(_locationPoints),
            50,
          ),
        );
      });
    }
  }

  LatLngBounds _getBounds(List<LatLng> points) {
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

    double latPadding = (maxLat - minLat) * 0.1;
    double lngPadding = (maxLng - minLng) * 0.1;

    if (latPadding == 0) latPadding = 0.001;
    if (lngPadding == 0) lngPadding = 0.001;

    return LatLngBounds(
      southwest: LatLng(minLat - latPadding, minLng - lngPadding),
      northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracker'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => _getAllLocations(context), // Pass context
            tooltip: 'View All Locations',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllLocationsFromDatabase,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'fit',
            onPressed: _fitToPath,
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            child: const Icon(Icons.fit_screen),
            tooltip: 'Fit to Path',
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'stats',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Statistics'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Locations: ${_locationPoints.length}'),
                      const SizedBox(height: 8),
                      if (_locationPoints.isNotEmpty) ...[
                        Text('Start: ${_formatTimestamp(_locationRecords.first['timestamp'] as String)}'),
                        Text('End: ${_formatTimestamp(_locationRecords.last['timestamp'] as String)}'),
                      ],
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            child: const Icon(Icons.storage),
            tooltip: 'Statistics',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
            // Fit to path after map is created
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _fitToPath();
            });
          },
          markers: _markers,
          polylines: _polylines,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
        ),
        Positioned(
          bottom: 100,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_locationPoints.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Text(
                  'Points',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        if (_currentLocation != null)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '📍 ${_currentLocation!.latitude?.toStringAsFixed(6)}, ${_currentLocation!.longitude?.toStringAsFixed(6)}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
      ],
    );
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
}
```
