flutter: Error getting FCM token: [firebase_messaging/apns-token-not-set] APNS token has not been set yet. Please ensure the APNS token is available by calling getAPNSToken().

To fix the [`firebase_messaging/apns-token-not-set`] error, you must ensure that Apple Push Notification service (APNs) is fully configured and that the plugin finishes registering with Apple before you call `FirebaseMessaging.instance.getToken()`.

This error happens on iOS and macOS because the Firebase SDK requires an APNs token from Apple before it can safely generate a unique FCM registration token for the device.

Follow this checklist from Xcode setup to code implementation to resolve the issue:

# 1. Enable Xcode Capabilities

Your application cannot request an APNs token from Apple's servers unless the capabilities are explicitly configured.
 - Open the `ios/Runner.xcworkspace` file inside Xcode.
 - Select the `Runner` root project in the left navigation panel.
 - Navigate to the `Signing & Capabilities` tab.
 - Click the `+ Capability` button in the top left.
 - Add `Push Notifications`.
 - Add `Background Modes` and explicitly check the box for `Remote notifications`.

# 2. Configure Firebase Console

Ensure Apple can securely communicate your notification payloads directly to Firebase.

 - Log into the Firebase Console and navigate to your `Project Settings`.
 - Open the `Cloud Messaging` tab and find your iOS app configuration.
 - Ensure you have uploaded your `APNs Authentication Key` (`.p8` file) generated from your Apple Developer Account.
 - Verify that your `Team ID` and `Bundle ID` match your Xcode configurations exactly.

# 3. Implement a Retry Delay (The Timing Fix)

Sometimes your Flutter code attempts to grab the token immediately at startup before the asynchronous native iOS system has fetched it. Wrapping your retrieval logic with a retry loop solves this race condition:
```
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getSecureFcmToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 1. Request notification permissions from the user
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // 2. On Apple platforms, verify APNs readiness before requesting FCM
  if (Platform.isIOS || Platform.isMacOS) {
    String? apnsToken;
    int retryCount = 0;

    // Retry checking for APNs availability over a brief period
    while (apnsToken == null && retryCount < 5) {
      apnsToken = await messaging.getAPNSToken();
      if (apnsToken == null) {
        await Future.delayed(const Duration(seconds: 2));
        retryCount++;
      }
    }

    // Stop execution if APNs registration completely failed
    if (apnsToken == null) {
      print("APNs registration failed. Verify Xcode profile configurations.");
      return null;
    }
  }

  // 3. Now it is perfectly safe to call getToken()
  try {
    String? fcmToken = await messaging.getToken();
    print("FCM Token successfully generated: $fcmToken");
    return fcmToken;
  } catch (e) {
    print("Error fetching token: $e");
    return null;
  }
}

```

# 4. Test on a Physical iOS Device

 - `Do not use the iOS Simulator`. While simulators support basic setups, they frequently experience registration issues or completely fail to return an APNs device token.
 - Always test push notifications using a physical iPhone or iPad connected via USB.
