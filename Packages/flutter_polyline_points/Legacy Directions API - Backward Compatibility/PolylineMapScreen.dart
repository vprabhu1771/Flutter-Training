import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:live_order_tracking/config/AppConfig.dart';

class PolylineMapScreen extends StatefulWidget {
  @override
  _PolylineMapScreenState createState() => _PolylineMapScreenState();
}

class _PolylineMapScreenState extends State<PolylineMapScreen> {
  GoogleMapController? _mapController;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  final List<LatLng> _polylineCoordinates = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Initialize PolylinePoints
  late PolylinePoints polylinePoints;
  final String _apiKey = AppConfig.GOOGLE_MAP_API_KEY;

  // Sample locations
  final LatLng _origin = LatLng(11.7505243, 79.7492756); // San Francisco
  final LatLng _destination = LatLng(11.74631, 79.7557); // San Jose

  @override
  void initState() {
    super.initState();
    // ✅ Initialize without API key (the package doesn't accept it in constructor)
    polylinePoints = PolylinePoints();
    _getRoute();
  }

  // Method 1: Using Legacy Directions API
  Future<void> _getRoute() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      print('🔵 Getting route using Legacy API...');
      print('Origin: ${_origin.latitude}, ${_origin.longitude}');
      print('Destination: ${_destination.latitude}, ${_destination.longitude}');
      print('API Key: ${_apiKey.substring(0, 10)}...');

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: _apiKey, // ✅ Pass API key here instead of constructor
        request: PolylineRequest(
          origin: PointLatLng(_origin.latitude, _origin.longitude),
          destination: PointLatLng(_destination.latitude, _destination.longitude),
          mode: TravelMode.driving,
        ),
      );

      print('Result status: ${result.status}');
      print('Points count: ${result.points.length}');
      print('Error message: ${result.errorMessage}');

      if (result.points.isNotEmpty) {
        setState(() {
          _polylines.clear();
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
              width: 6,
              geodesic: true,
              patterns: [], // Empty list for solid line
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

          _isLoading = false;
        });

        // Zoom to show the route
        _zoomToRoute();
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No points found: ${result.errorMessage}';
        });
        print('❌ No points found: ${result.errorMessage}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
      print('❌ Error getting route: $e');
    }
  }

  // Method 2: Using Modern Directions API (Recommended)
  Future<void> _getRouteModern() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      print('🟢 Getting route using Modern API...');

      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${_origin.latitude},${_origin.longitude}'
          '&destination=${_destination.latitude},${_destination.longitude}'
          '&mode=driving'
          '&key=$_apiKey';

      print('URL: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response status: ${data['status']}');

        if (data['status'] == 'OK') {
          // Decode polyline from route
          final route = data['routes'][0];
          final polylinePoint = route['overview_polyline']['points'];
          print('Polyline point: $polylinePoint');

          // Decode the polyline
          List<PointLatLng> decodedPoints =
          polylinePoints.decodePolyline(polylinePoint);
          print('Decoded points count: ${decodedPoints.length}');

          setState(() {
            _polylines.clear();
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
                color: Colors.green,
                width: 6,
                geodesic: true,
              ),
            );

            _isLoading = false;
          });

          _zoomToRoute();
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'API Error: ${data['status']}';
          });
          print('❌ API Error: ${data['status']}');
          print('Error message: ${data['error_message'] ?? 'No error message'}');
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'HTTP Error: ${response.statusCode}';
        });
        print('❌ HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
      print('❌ Error getting route: $e');
    }
  }

  // Method 3: Using Directions API with Waypoints
  Future<void> _getRouteWithWaypoints() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      print('🟠 Getting route with waypoints...');

      // Convert PointLatLng to PolylineWayPoint
      List<PolylineWayPoint> waypoints = [
        PolylineWayPoint(
          location: "37.4512,-122.1728", // San Mateo as string
          stopOver: true,
        ),
        PolylineWayPoint(
          location: "37.5222,-122.1402", // Redwood City as string
          stopOver: true,
        ),
      ];

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(_origin.latitude, _origin.longitude),
          destination: PointLatLng(_destination.latitude, _destination.longitude),
          wayPoints: waypoints,
          mode: TravelMode.driving,
          optimizeWaypoints: true,
        ),
      );

      print('Result status: ${result.status}');
      print('Points count: ${result.points.length}');

      if (result.points.isNotEmpty) {
        setState(() {
          _polylines.clear();
          _polylineCoordinates.clear();
          _polylineCoordinates.addAll(
              result.points.map(
                      (point) => LatLng(point.latitude, point.longitude)
              )
          );

          _polylines.add(
            Polyline(
              polylineId: PolylineId('route_with_waypoints'),
              points: _polylineCoordinates,
              color: Colors.orange,
              width: 6,
              geodesic: true,
            ),
          );

          _isLoading = false;
        });

        _zoomToRoute();
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No points found: ${result.errorMessage}';
        });
        print('❌ No points found: ${result.errorMessage}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
      print('❌ Error getting route with waypoints: $e');
    }
  }

  // Method 4: Test route with different locations
  Future<void> _testRoute() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _polylines.clear();
      _polylineCoordinates.clear();
      _markers.clear();
    });

    try {
      // Test with a simple route that should work
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=37.7749,-122.4194'
          '&destination=37.3382,-121.8863'
          '&mode=driving'
          '&key=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Test route status: ${data['status']}');

        if (data['status'] == 'OK') {
          final route = data['routes'][0];
          final polylinePoint = route['overview_polyline']['points'];

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
                polylineId: PolylineId('test_route'),
                points: _polylineCoordinates,
                color: Colors.red,
                width: 8,
                geodesic: true,
              ),
            );

            _markers.addAll([
              Marker(
                markerId: MarkerId('origin'),
                position: _origin,
                infoWindow: InfoWindow(title: 'Origin'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              ),
              Marker(
                markerId: MarkerId('destination'),
                position: _destination,
                infoWindow: InfoWindow(title: 'Destination'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            ]);

            _isLoading = false;
          });

          _zoomToRoute();
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Test failed: ${data['status']}';
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Test error: $e';
      });
    }
  }

  void _zoomToRoute() {
    if (_polylineCoordinates.isNotEmpty && _mapController != null) {
      try {
        final bounds = _getBoundsFromPoints(_polylineCoordinates);
        _mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50),
        );
      } catch (e) {
        print('Error zooming: $e');
        // Fallback zoom
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(37.5, -122.2), 10),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Polyline'),
        backgroundColor: Colors.blue,
        actions: [
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.5, -122.2),
              zoom: 10,
            ),
            polylines: _polylines,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
          ),
          if (_errorMessage.isNotEmpty)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red.shade900),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Text(
              'Polylines: ${_polylines.length}, Points: ${_polylineCoordinates.length}',
              style: TextStyle(
                backgroundColor: Colors.black54,
                color: Colors.white,
                // padding: EdgeInsets.all(8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'btn3',
            onPressed: _getRouteWithWaypoints,
            child: Icon(Icons.route),
            backgroundColor: Colors.orange,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'btn4',
            onPressed: _testRoute,
            child: Icon(Icons.bug_report),
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  // Helper method to calculate bounds from points
  LatLngBounds _getBoundsFromPoints(List<LatLng> points) {
    if (points.isEmpty) {
      return LatLngBounds(
        southwest: LatLng(37.0, -122.5),
        northeast: LatLng(38.0, -121.5),
      );
    }

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