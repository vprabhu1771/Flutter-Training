You can display the current app version in the About screen of your Flutter app using the `package_info_plus` package. Follow these steps:

### 1. Install `package_info_plus`
Run the following command in your terminal:  
```sh
flutter pub add package_info_plus
```

### 2. Import the Package
In your Dart file, import the package:
```dart
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
```

### 3. Retrieve and Display the App Version
Modify your About screen to include the app version:

```dart
class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String appVersion = "Loading...";

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = "Version ${packageInfo.version} (${packageInfo.buildNumber})";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: Center(
        child: Text(appVersion, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
```

### Explanation:
- `PackageInfo.fromPlatform()` retrieves the app's package information.
- `version` provides the app's version (e.g., `1.0.0`).
- `buildNumber` provides the build number.
- The app version is displayed inside a `Text` widget.

This ensures your About screen always displays the latest app version.

To update and deploy your Flutter app with an incremented version, follow these steps:

### **4. Increment the App Version**
In your `pubspec.yaml` file, update the `version` field:
```yaml
version: 1.0.1+2
```
- The format is **`major.minor.patch+buildNumber`**.
- Example: `1.2.0+5` (where `1.2.0` is the app version and `5` is the build number).
