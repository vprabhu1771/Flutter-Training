```
geolocator: ^11.0.0 # Use the latest version
geocoding: ^2.1.0
google_maps_flutter: any
location: any
crypto: ^3.0.6
```

```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:crypto/crypto.dart';


class GoogleMapTrackingScreen extends StatefulWidget {
  const GoogleMapTrackingScreen({super.key});

  @override
  State<GoogleMapTrackingScreen> createState() => _GoogleMapTrackingScreenState();
}

class _GoogleMapTrackingScreenState extends State<GoogleMapTrackingScreen> {

  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;

  @override
  void initState() {
    _init();
    super.initState();
  }


  String gravatarUrl(String email, {int size = 200}) {
    final hash = md5.convert(utf8.encode(email.trim().toLowerCase())).toString();
    return 'https://www.gravatar.com/avatar/$hash?s=$size&d=mp';
  }

  _init() async {
    _location = Location();
    _cameraPosition = CameraPosition(
        target: LatLng(0, 0), // this is just the example lat and lng for initializing
        zoom: 15
    );
    _initLocation();
  }

  //function to listen when we move position
  _initLocation() {
    //use this to go to current location instead
    _location?.getLocation().then((location) {
      _currentLocation = location;
    });
    _location?.onLocationChanged.listen((newLocation) {
      _currentLocation = newLocation;
      moveToPosition(LatLng(_currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0));
    });
  }

  moveToPosition(LatLng latLng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
                target: latLng,
                zoom: 15
            )
        )
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

  // Widget _getMarker() {
  //   return Container(
  //     width: 40,
  //     height: 40,
  //     padding: EdgeInsets.all(2),
  //     decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(100),
  //         boxShadow: [
  //           BoxShadow(
  //               color: Colors.grey,
  //               offset: Offset(0,3),
  //               spreadRadius: 4,
  //               blurRadius: 6
  //           )
  //         ]
  //     ),
  //     child:  ClipOval(child: Image.asset("assets/profile.jpg")),
  //   );
  // }

  Widget _getMarker() {
    const email = "user@example.com"; // User's email

    return Container(
      width: 50,
      height: 50,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [
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
            // now we need a variable to get the controller of google map
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },
        ),

        Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: _getMarker()
            )
        )
      ],
    );
  }
}

```
