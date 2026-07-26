# 🤖 Android Setup
Open the main manifest file located at `android/app/src/main/AndroidManifest.xml`. Add the `INTERNET` permission tag inside the `<manifest>` tag, but outside the `<application>` tag

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- Add this line for internet access -->
    <uses-permission android:name="android.permission.INTERNET" />
    
    <!-- Optional: Add this line to monitor network status (Wi-Fi vs Mobile data) -->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

    <application
        android:label="my_app"
        android:name="${applicationName}"
        ... >
        <!-- ... -->
    </application>
</manifest>
```

# 🍏 macOS Setup

Desktop apps on macOS are sandboxed by default, which blocks outgoing network requests. Open both entitlement files found in `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements`

Add the `com.apple.security.network.client` key inside the `<dict>` block

```xml
<dict>
    <!-- Add this key to allow outgoing connections -->
    <key>com.apple.security.network.client</key>
    <true/>
</dict>
```

# 🍏 iOS Setup
- Standard Network Requests: iOS grants internet access by default. No changes are needed in `Info.plist`
- HTTP (Non-Secure) Requests: If your app connects to insecure `http://` servers instead of `https://`, you must explicitly allow insecure loads. Add this to `ios/Runner/Info.plist`

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

# 🛠️ Troubleshooting Tip

If your app still fails to fetch data after adding these configurations, run the following sequence in your terminal to clear old build caches:

```
flutter clean
flutter pub get
flutter run
```
