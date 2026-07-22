To change the `mapType` in `google_maps_flutter`, you need to set the `mapType` property of the `GoogleMap` widget to `MapType.terrain`. You must also manage this change in the widget's state so the map rebuilds with the new type .

The complete list of map types available are:
*   `MapType.none`
*   `MapType.normal`
*   `MapType.hybrid`
*   `MapType.satellite`
*   `MapType.terrain` 

Here’s a practical example of how to implement this:
1.  **Declare a state variable** to hold the current map type.
2.  **Reference this variable** in the `GoogleMap` widget's `mapType` parameter.
3.  **Update the state** (e.g., on a button press) using `setState()` to assign `MapType.terrain`. The widget will then rebuild to reflect the change .

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        // Use the current map type
        mapType: _currentMapType,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // Change the map type to terrain
            _currentMapType = MapType.terrain;
          });
        },
        child: Icon(Icons.map),
      ),
    );
  }
}
```
