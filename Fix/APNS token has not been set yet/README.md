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
