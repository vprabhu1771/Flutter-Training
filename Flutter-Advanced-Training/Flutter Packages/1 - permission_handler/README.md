```
https://pub.dev/packages/permission_handler
```

Here’s a simple example showing how to use the permission_handler package in a Flutter app to check and request permissions. I’ll walk you through setup + code + tips.

---

### ✅ Setup

1. Add the package to `pubspec.yaml`:

   ```yaml
   dependencies:
     permission_handler: ^12.0.1
   ```

   (any latest version is fine) ([Dart packages][1])
2. **Android**: Add the required permissions to `AndroidManifest.xml` (in `android/app/src/main/AndroidManifest.xml`) for the permissions you need. ([Dart packages][1])
3. **iOS**: Add relevant keys to `Info.plist` such as `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, etc. failing to do so may cause crashes. ([Dart packages][1])
4. (Optional) Make sure AndroidX is enabled and your `compileSdkVersion` is updated (for Android) if required by the plugin. ([Dart packages][1])

---

### 📄 Example Code

Here’s a sample Flutter widget that asks for **camera** permission and acts accordingly:

```dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionPage extends StatefulWidget {
  @override
  _CameraPermissionPageState createState() => _CameraPermissionPageState();
}

class _CameraPermissionPageState extends State<CameraPermissionPage> {
  String _status = 'Unknown';

  // Check permission status
  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    setState(() {
      _status = status.toString();
    });
  }

  // Request permission
  Future<void> _requestPermission() async {
    final result = await Permission.camera.request();
    setState(() {
      _status = result.toString();
    });

    if (result.isGranted) {
      // Permission granted — you can access the camera
      print('Camera permission granted');
    } 
    else if (result.isDenied) {
      // Permission denied (but not permanently)
      print('Camera permission denied');
    } 
    else if (result.isPermanentlyDenied) {
      // Permission permanently denied — you need to direct user to app settings
      print('Camera permission permanently denied. Please open settings.');
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Permission Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Permission status: $_status'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestPermission,
              child: Text('Request Camera Permission'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 🎯 Multi-permission & service status example

If you want to request multiple permissions at once and check a “service status” (for example location service enabled), you can do something like:

```dart
Future<void> _requestMultiple() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.storage,
    Permission.camera,
  ].request();

  if (statuses[Permission.location]?.isGranted == true) {
    print('Location granted');
  }
  if (statuses[Permission.storage]?.isDenied == true) {
    print('Storage denied');
  }
  // etc.
  
  // Example of checking service status (for permissions where OS has “service” concept)
  final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
  if (serviceStatus.isEnabled) {
    print('Location service enabled');
  } else {
    print('Location service disabled');
  }
}
```

This is supported by the plugin. ([Dart packages][1])

---

### ⚠️ Tips & Gotchas

* On **iOS**, if you check/request a permission whose `Info.plist` key is missing, the app **may crash**. ([Dart packages][1])
* On **Android 13+ (API 33+)**, storage permission behavior changed: `Permission.storage` may not work as expected — you might need to request `Permission.photos`, `Permission.videos`, etc. ([Dart packages][1])
* For background location (`locationAlways`) on Android: you must first request foreground (`locationWhenInUse`) before you can request “always”. ([Dart packages][1])
* If the user permanently denies a permission, you must direct them to open the app settings (via `openAppSettings()` from the plugin). Without that, you cannot request it again.
* Always test on **real devices**, especially for permissions, because emulators/simulators might behave differently.

---

If you like, I can **generate a full working minimal Flutter example project** (e.g., for camera + gallery permissions) for you — would that be helpful?

[1]: https://pub.dev/packages/permission_handler "permission_handler | Flutter package"
