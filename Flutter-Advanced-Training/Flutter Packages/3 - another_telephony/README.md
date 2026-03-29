```
https://pub.dev/packages/another_telephony
```
# Call 

Here’s how you can use the another_telephony package to initiate a phone call in a Flutter app. Note: This package works **only on Android**. ([Dart packages][1])

---

## ✅ Setup

1. Add the dependency in your `pubspec.yaml`

   ```yaml
   dependencies:
     another_telephony: ^0.4.1
   ```

   ([Dart packages][1])
2. On Android, update `AndroidManifest.xml` to include permissions:

   ```xml
   <uses-permission android:name="android.permission.CALL_PHONE"/>
   <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
   ```

   (Depending on your needs)
3. Import the package in your Dart code:

   ```dart
   import 'package:another_telephony/telephony.dart';
   ```

---

## 🧩 Example code to make a call

Here’s a simple widget that asks for permission and then starts a phone call when you press a button:

```dart
import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';

class CallExamplePage extends StatefulWidget {
  const CallExamplePage({Key? key}) : super(key: key);

  @override
  State<CallExamplePage> createState() => _CallExamplePageState();
}

class _CallExamplePageState extends State<CallExamplePage> {
  final Telephony _telephony = Telephony.instance;
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final bool? granted = await _telephony.requestPhoneAndSmsPermissions;
    if (granted == true) {
      setState(() {
        _permissionsGranted = true;
      });
    } else {
      // handle permission denied
      setState(() {
        _permissionsGranted = false;
      });
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (!_permissionsGranted) {
      await _checkPermissions();
      if (!_permissionsGranted) return;
    }

    // Use the openDialer or call directly
    await _telephony.openDialer(phoneNumber);
    // Or if you want to start the call directly (if supported):
    // await _telephony.callNumber(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Call Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _makePhoneCall("1234567890"),
          child: const Text("Call 123-456-7890"),
        ),
      ),
    );
  }
}
```

**Notes:**

* We ask for *phone & SMS permissions* using `requestPhoneAndSmsPermissions`. ([Dart packages][2])
* `openDialer(phoneNumber)` opens the dialer with the number filled in.
* Depending on OS version and manufacturer restrictions, direct calling (`callNumber`) might require extra handling or not work.
* The plugin is Android-only. ([Dart packages][1])

---

## ⚠️ Important caveats

* Because making a phone call involves sensitive permissions, ensure your app handles **runtime permissions**, checks for `CALL_PHONE`, and gracefully handles denial.
* On newer Android versions, you may need to handle **default dialer or special permissions**.
* Test on a **real device** (not just emulator) since call features typically don’t behave like normal on simulators.
* If the user denies permission permanently, you may need to direct them to settings to enable it.
* The plugin states it supports *start phone call* among its features. ([Dart packages][1])

---

If you like, I can pull the **full example code from the plugin’s `example/` folder** and adapt it for you (including UI + permission workflow) so you can integrate it directly into your project. Would you like that?

[1]: https://pub.dev/packages/another_telephony?utm_source=chatgpt.com "another_telephony | Flutter package - Pub.dev"
[2]: https://pub.dev/packages/another_telephony/example?utm_source=chatgpt.com "another_telephony example | Flutter package - Pub.dev"
