To open the Flutter app when the chat head is tapped, you need:

1. Main Flutter app
2. Overlay entry point
3. Android overlay service registration
4. Launch app from overlay using `moveToForeground()`

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_overlay_window: ^0.5.0
```

---

## main.dart

```dart
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OverlayScreen(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ReceivePort _receivePort = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      "overlay_port",
    );

    _receivePort.listen((message) {
      debugPrint("Overlay Message: $message");
    });
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping("overlay_port");
    super.dispose();
  }

  Future<void> showOverlay() async {
    bool permission =
        await FlutterOverlayWindow.isPermissionGranted() ?? false;

    if (!permission) {
      permission = await FlutterOverlayWindow.requestPermission() ?? false;
    }

    if (!permission) return;

    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: "Chat Head",
      overlayContent: "Running",
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
      height: 120,
      width: 120,
    );
  }

  Future<void> closeOverlay() async {
    await FlutterOverlayWindow.closeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Messenger Chat Head")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: showOverlay,
                child: const Text("Show Chat Head"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: closeOverlay,
                child: const Text("Close Chat Head"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OverlayScreen extends StatelessWidget {
  const OverlayScreen({super.key});

  Future<void> onBubbleTap() async {
    await FlutterOverlayWindow.moveToForeground();

    final sendPort =
        IsolateNameServer.lookupPortByName("overlay_port");

    sendPort?.send("bubble_clicked");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: GestureDetector(
          onTap: onBubbleTap,
          child: Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.message,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## AndroidManifest.xml

Inside `<application>`:

```xml
<service
    android:name="flutter.overlay.window.flutter_overlay_window.OverlayService"
    android:exported="false" />
```

Add permissions above `<application>`:

```xml
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
```

For Android 14:

```xml
<uses-permission
    android:name="android.permission.FOREGROUND_SERVICE_SPECIAL_USE" />
```

---

## MainActivity.kt

```kotlin
package com.example.app

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()
```

---

## Important

The plugin must know which entry point to use for the overlay. In newer versions, add this before `showOverlay()`:

```dart
await FlutterOverlayWindow.showOverlay(
  enableDrag: true,
  overlayTitle: "Chat Head",
  overlayContent: "Running",
);
```

and in Android configure the overlay entry point according to the package documentation.

When the blue bubble is tapped:

```dart
await FlutterOverlayWindow.moveToForeground();
```

brings your Flutter app back to the front, giving a Messenger/Truecaller-like experience.
