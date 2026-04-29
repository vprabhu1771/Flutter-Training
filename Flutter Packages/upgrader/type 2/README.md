# Force Users to Update Your flutter App from the Store
```
https://www.youtube.com/watch?v=exu6efioomQ
```

```
https://github.com/M1chaelAdel654/upgrader/tree/main
```

## ✅ FINAL CORRECT & SAFE VERSION

### UpdatePopup
```dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePopup extends StatelessWidget {
  const UpdatePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.update,
              size: 60,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              'Update Available!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A new version of the app is available. Update now to enjoy the latest features and improvements.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.bughunt.school',
                  );

                  if (await canLaunchUrl(url)) {
                    await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unable to open the app store'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Update Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### ✅ SplashScreen (Production-ready)

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';

import '../screens/auth/LoginScreen.dart';
import 'UpdatePopup.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  String appVersion = "Loading...";
  bool isNeedUpdate = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await fetchPlayStoreVersion();
    await _getAppVersion();

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isNeedUpdate) {
        _showUpdateDialog();
      } else {
        _navigateToLogin();
      }
    });
  }

  Future<void> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion =
        "Version ${packageInfo.version} (${packageInfo.buildNumber})";
      });
    } catch (_) {
      setState(() {
        appVersion = "Version info unavailable";
      });
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // force update
      builder: (_) => const UpdatePopup(),
    );
  }

  Future<void> fetchPlayStoreVersion() async {
    final upgrader = Upgrader();

    await Upgrader.clearSavedSettings();
    await upgrader.initialize();

    final storeVersion = upgrader.currentAppStoreVersion;
    final installedVersion = upgrader.versionInfo?.installedVersion;

    if (storeVersion != null && installedVersion != null) {
      isNeedUpdate = _isVersionHigher(
        storeVersion,
        installedVersion.toString(),
      );
    }
  }

  bool _isVersionHigher(String store, String current) {
    final storeParts = store.split('.').map(int.parse).toList();
    final currentParts = current.split('.').map(int.parse).toList();

    for (int i = 0; i < storeParts.length; i++) {
      final currentPart = i < currentParts.length ? currentParts[i] : 0;
      if (storeParts[i] > currentPart) return true;
      if (storeParts[i] < currentPart) return false;
    }
    return false;
  }

  void _navigateToLogin() {
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              LoginScreen(title: 'Bughunt School'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(appVersion),
      ),
    );
  }
}
```

---

## ✅ Why This Works 100%

✔ `initState()` is synchronous
✔ Dialog shown **after first frame**
✔ Navigation blocked when update needed
✔ `mounted` checks prevent crashes
✔ Force update (user cannot dismiss popup)

---

## 🔒 Resulting App Flow

```
SplashScreen
   ↓
Check Play Store version
   ↓
Update available?
   ├─ YES → UpdatePopup (forced)
   └─ NO  → LoginScreen (after 3 sec)
```

---

## 🚀 Optional Enhancements (Tell me if you want)

* Skip update for **minor versions**
* Show **What's new**
* Handle **iOS App Store**
* Custom animation dialog

Just say the word 👍


Got it 👍
You **already have the app in Play Store**, but you want to **test the update-check logic locally (debug / local build)**.

This is a very common situation. Here are **3 practical & safe ways** to do it.

---

## ✅ OPTION 1 (BEST): **Force Mock Version Check (Local Only)**

Use a **debug flag** to simulate Play Store versions.

### 🔹 Step 1: Add debug flag

```dart
import 'package:flutter/foundation.dart';
```

### 🔹 Step 2: Modify `fetchPlayStoreVersion()`

```dart
Future<void> fetchPlayStoreVersion() async {
  if (kDebugMode) {
    // 🔥 MOCK VALUES FOR LOCAL TESTING
    const fakePlayStoreVersion = "2.0.0";
    const fakeInstalledVersion = "1.0.0";

    isNeedUpdate = _isVersionHigher(
      fakePlayStoreVersion,
      fakeInstalledVersion,
    );

    debugPrint(
      "DEBUG MODE → Installed: $fakeInstalledVersion | Store: $fakePlayStoreVersion",
    );
    return;
  }

  // ✅ REAL PLAY STORE CHECK (RELEASE ONLY)
  final upgrader = Upgrader();
  await Upgrader.clearSavedSettings();
  await upgrader.initialize();

  final storeVersion = upgrader.currentAppStoreVersion;
  final installedVersion = upgrader.versionInfo?.installedVersion;

  if (storeVersion != null && installedVersion != null) {
    isNeedUpdate = _isVersionHigher(
      storeVersion,
      installedVersion.toString(),
    );
  }
}
```

### ✅ Result

* Debug → **Popup always shows**
* Release → **Real Play Store check**

---

## ✅ OPTION 2: Use `Upgrader.debugDisplayAlways`

This forces the update dialog **even if versions are same**.

```dart
final upgrader = Upgrader(
  debugDisplayAlways: true,
);
```

⚠️ **Only for testing**
⚠️ Not recommended for production logic

---

## ✅ OPTION 3: Test with Play Store Internal Testing (Real Check)

This is how Google expects it to work.

### Steps:

1. Increase version in `pubspec.yaml`

```yaml
version: 1.0.1+2
```

2. Upload APK/AAB to **Internal Testing**
3. Install from Play Store test link
4. Splash screen will detect update correctly

✅ **Most accurate real-world test**

---

## 🔥 Recommended Setup (Best Practice)

| Environment  | Method                      |
| ------------ | --------------------------- |
| Local Debug  | **Option 1 (Mock version)** |
| QA / Staging | Internal testing            |
| Production   | Real Play Store check       |

---

## 🧠 Why Upgrader Doesn’t Work Locally

* Play Store API **does NOT return version info** for:

  * Debug builds
  * Sideloaded APKs
* That’s expected behavior 👍

---

## ✅ TL;DR (Do This Now)

👉 **Use mock versions in `kDebugMode`**

If you want, I can:
✔ Add environment-based version config
✔ Add Firebase Remote Config update control
✔ Auto-force update only for critical versions

Just tell me 🚀
