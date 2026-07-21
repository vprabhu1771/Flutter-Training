```dart
GoogleMap(
  markers: {
    Marker(
      markerId: const MarkerId('current_location'),
      position: LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      ),// Your tracked LatLng
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), // Change color hue
    ),
  },
),
```
