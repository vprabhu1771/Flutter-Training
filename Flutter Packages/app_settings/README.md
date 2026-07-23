The `app_settings` package lets your Flutter app open specific device settings screens such as App Settings, Location, Wi-Fi, Bluetooth, Notification, Battery Optimization, and more. The latest version is **8.0.3**. ([Dart packages][1])

You can find it here:

[app_settings on pub.dev](https://pub.dev/packages/app_settings/versions?utm_source=chatgpt.com)

### Install

```yaml
dependencies:
  app_settings: ^8.0.3
```

or

```bash
flutter pub add app_settings
```

### Import

```dart
import 'package:app_settings/app_settings.dart';
```

### Open App Settings

```dart
ElevatedButton(
  onPressed: () {
    AppSettings.openAppSettings();
  },
  child: const Text("Open App Settings"),
);
```

### Open Location Settings

Useful when GPS is disabled.

```dart
AppSettings.openAppSettings(
  type: AppSettingsType.location,
);
```

### Open Notification Settings

```dart
AppSettings.openAppSettings(
  type: AppSettingsType.notification,
);
```

### Open Wi-Fi Settings

```dart
AppSettings.openAppSettings(
  type: AppSettingsType.wifi,
);
```

### Open Bluetooth Settings

```dart
AppSettings.openAppSettings(
  type: AppSettingsType.bluetooth,
);
```

### Open Battery Optimization Settings

```dart
AppSettings.openAppSettings(
  type: AppSettingsType.batteryOptimization,
);
```

### Open App Details Page

```dart
AppSettings.openAppSettings(
  type: AppSettingsType.settings,
);
```

---

## Example for your Flutter Location Tracking app

If the user denies location permission or GPS is turned off:

```dart
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

void showLocationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Location Required"),
      content: const Text(
        "Please enable Location Services to continue tracking.",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            AppSettings.openAppSettings(
              type: AppSettingsType.location,
            );
          },
          child: const Text("Open Settings"),
        ),
      ],
    ),
  );
}
```

This is particularly useful in your **Google Maps live tracking / delivery app**, where the driver must enable GPS before sharing live location.

### Supported Settings

* ✅ App Settings
* ✅ Location
* ✅ Wi-Fi
* ✅ Bluetooth
* ✅ Notifications
* ✅ NFC
* ✅ Security
* ✅ Sound
* ✅ Data Roaming
* ✅ Battery Optimization
* ✅ Hotspot
* ✅ VPN
* ✅ Accessibility
* ✅ Display (platform-dependent)

If a particular settings page isn't supported on the device or platform, the plugin falls back to the general app settings page. ([Dart packages][2])

[1]: https://pub.dev/packages/app_settings/versions?utm_source=chatgpt.com "app_settings package - All Versions"
[2]: https://pub.dev/documentation/app_settings/latest/?utm_source=chatgpt.com "app_settings - Dart API docs"
