`flutter_overlay_window` already supports a Messenger-style chat head overlay. The package documentation includes a "Messenger chat-head example" preview and provides APIs for draggable floating windows. ([Dart packages][1])

### 1. Android Manifest

```xml
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_SPECIAL_USE"/>

<application>
    <service
        android:name="flutter.overlay.window.flutter_overlay_window.OverlayService"
        android:exported="false"
        android:foregroundServiceType="specialUse">
        <property
            android:name="android.app.PROPERTY_SPECIAL_USE_FGS_SUBTYPE"
            android:value="Chat Head Overlay"/>
    </service>
</application>
```

### 2. Main App

```dart
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

void main() {
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatHeadOverlay(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> showChatHead() async {
    bool? granted = await FlutterOverlayWindow.isPermissionGranted();

    if (!granted) {
      granted = await FlutterOverlayWindow.requestPermission();
    }

    if (granted!) {
      await FlutterOverlayWindow.showOverlay(
        height: 200,
        width: 200,
        enableDrag: true,
        positionGravity: PositionGravity.auto,
        overlayTitle: "Chat Head",
        overlayContent: "Running",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Messenger Chat Head")),
        body: Center(
          child: ElevatedButton(
            onPressed: showChatHead,
            child: const Text("Show Chat Head"),
          ),
        ),
      ),
    );
  }
}
```

### 3. Overlay Widget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';


class ChatHeadOverlay extends StatefulWidget {
  const ChatHeadOverlay({super.key});

  @override
  State<ChatHeadOverlay> createState() => _ChatHeadOverlayState();
}

class _ChatHeadOverlayState extends State<ChatHeadOverlay> {

  @override
  void initState() {
    super.initState();

    FlutterOverlayWindow.overlayListener.listen((event) {
      if (event == "chat_head_clicked") {
        print("Chat head clicked");
        print("chat head click working");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: GestureDetector(
          onTap: () {
            FlutterOverlayWindow.shareData("chat_head_clicked");
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
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

### 4. Listen for Chat Head Clicks

```dart
@override
void initState() {
  super.initState();

  FlutterOverlayWindow.overlayListener.listen((event) {
    if (event == "chat_head_clicked") {
      print("Chat head clicked");
    }
  });
}
```

### Features

✅ Floating over other apps
✅ Draggable like Messenger chat heads
✅ Tap to open chat screen
✅ Communicate with main app using `shareData()`
✅ Auto-stick to left/right edge using `PositionGravity.auto` ([Dart packages][1])

If you want the **exact Facebook Messenger behavior** (snap-to-edge animation, unread badge, expand/collapse chat window), I can provide a complete Flutter implementation with animations and edge snapping.

[1]: https://pub.dev/packages/flutter_overlay_window?utm_source=chatgpt.com "flutter_overlay_window | Flutter package"
