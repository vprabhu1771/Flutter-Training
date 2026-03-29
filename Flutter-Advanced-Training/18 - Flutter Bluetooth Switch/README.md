You can use the [`flutter_blue_plus`](https://pub.dev/packages/flutter_blue_plus) package to turn Bluetooth on and off in a Flutter app using a `Switch` widget. However, enabling/disabling Bluetooth directly from a Flutter app is **not allowed** on iOS and newer Android versions due to security restrictions. Users must enable or disable Bluetooth manually via system settings.

### Steps to Implement:

1. Add the `flutter_blue_plus` package to your `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     flutter_blue_plus: ^1.27.1
   ```

2. Create a `Switch` widget to check and request Bluetooth activation:

   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_blue_plus/flutter_blue_plus.dart';

   class BluetoothToggle extends StatefulWidget {
     @override
     _BluetoothToggleState createState() => _BluetoothToggleState();
   }

   class _BluetoothToggleState extends State<BluetoothToggle> {
     bool _isBluetoothOn = false;

     @override
     void initState() {
       super.initState();
       _checkBluetoothState();
     }

     void _checkBluetoothState() async {
       FlutterBluePlus.instance.state.listen((state) {
         setState(() {
           _isBluetoothOn = (state == BluetoothState.on);
         });
       });
     }

     void _toggleBluetooth(bool value) async {
       if (value) {
         // Open Bluetooth settings (since direct control is not possible)
         FlutterBluePlus.instance.turnOn();
       } else {
         FlutterBluePlus.instance.turnOff();
       }
     }

     @override
     Widget build(BuildContext context) {
       return SwitchListTile(
         title: Text("Bluetooth"),
         value: _isBluetoothOn,
         onChanged: (bool value) {
           _toggleBluetooth(value);
         },
       );
     }
   }

   void main() {
     runApp(MaterialApp(home: Scaffold(body: BluetoothToggle())));
   }
   ```

### Notes:
- **Android:** You need **BLUETOOTH, BLUETOOTH_ADMIN, and ACCESS_FINE_LOCATION** permissions in `AndroidManifest.xml`.
- **iOS:** You must add `NSBluetoothAlwaysUsageDescription` in `Info.plist`.
- Directly enabling/disabling Bluetooth via code is **not allowed** on Android 13+ and iOS. Instead, prompt users to turn Bluetooth on via system settings.

Would you like an alternative approach using the system settings intent?