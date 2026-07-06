# 1. Setup the Global Navigator Key
Define a global key inside your `main.dart` or a routing configuration file:
```dart
import 'package:flutter/material.dart';

// Create a globally accessible navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
```

Attach this key to your MaterialApp:

```dart
MaterialApp(
  navigatorKey: navigatorKey, // Crucial for context-less navigation
  home: const HomeScreen(),
  routes: {
    '/details': (context) => const DetailsScreen(),
  },
);
```

####

# 2. Handle the 3 App States

Implement handlers for Terminated, Background, and Foreground states. Place this setup logic early in your application lifecycle (e.g., inside the initState of your main widget or a dedicated initialization service).
```dart
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // 1. Request permission (Required for iOS and Android 13+)
    await _firebaseMessaging.requestPermission();

    // 2. TERMINATED STATE
    // Check if the app was opened directly from a killed/closed state via notification
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage);
    }

    // 3. BACKGROUND STATE
    // Listen for notification taps when the app is minimized in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message);
    });

    // 4. FOREGROUND STATE (Optional)
    // Run logic if a notification arrives while the user is actively using the app
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Typically, the OS does not show a system tray banner when the app is in the foreground.
      // Use the 'flutter_local_notifications' package to manually show a banner if desired.
    });
  }

  // Common routing logic
  void _handleNotificationClick(RemoteMessage message) {
    // Retrieve custom data payload sent from your backend/Firebase console
    final data = message.data;

    if (data.containsKey('screen')) {
      String route = data['screen']; // e.g., '/details'
      
      // Navigate using the global navigator key
      navigatorKey.currentState?.pushNamed(route, arguments: data);
    }
  }
}
```

# 📦 Formatting Your Notification Payload

For your routing logic to match your application paths, ensure your backend or Firebase Console sends key-value pairs inside the Data block of the notification payload.

Example JSON structure for your notification:

```json
{
  "to": "USER_FCM_TOKEN",
  "notification": {
    "title": "New Message!",
    "body": "Tap to read your new message."
  },
  "data": {
    "screen": "/details",
    "itemId": "12345"
  }
}
```

🚀 Pro Tip: When a notification is clicked while the app is in a Terminated state, the application takes a moment to boot. Ensure your initNotifications() code is executed after WidgetsFlutterBinding.ensureInitialized() and Firebase.initializeApp() inside your main() method to prevent execution delays or dropped routes.
