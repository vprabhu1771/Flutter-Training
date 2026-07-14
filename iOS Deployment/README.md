To publish a Flutter app on the iOS App Store for production, you must use a macOS machine running Xcode and hold a paid Apple Developer Program membership ($99/year).

The step-by-step process requires configuring your identifier, preparing your release build, uploading the archive, and submitting the store metadata.

# 1. Register App Identification

Before building, you must register your app's unique identity with Apple.

  - `Bundle ID`: Log into the Apple Developer Portal. Navigate to `Identifiers`, click `+`, choose `App ID`s, select `Explicit`, and enter a reverse-domain string (e.g., `com.yourcompany.myapp`).
  - `App Store Connect Record`: Log into App Store Connect. Go to `Apps`, click `+`, select `New App`, fill in your app's name, select `iOS`, and choose the precise Bundle ID you just created.

# 2. Configure Xcode Settings

Open the native iOS wrapper of your project to align it with Apple's requirements.

  - Open `ios/Runner.xcworkspace` in Xcode.
  - Select `Runner` in the project navigator sidebar, then click the `Runner` target.
  - Under `Signing & Capabilities`, check `Automatically manage signing` and choose your Apple Developer team.
  - Under `General`, verify that the `Bundle Identifier` matches your registered Bundle ID exactly.
  - Update your user-facing `Version` string (e.g., 1.0.0) and set a unique `Build` number (e.g., `1`).
