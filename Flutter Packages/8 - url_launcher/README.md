https://pub.dev/packages/url_launcher

Your issue is likely due to the `url_launcher` package requiring additional setup for different platforms. Here’s how you can fix it:

### 1. **Update `pubspec.yaml`**  
Make sure you have the latest version of `url_launcher` by adding it to your `pubspec.yaml`:  
```yaml
dependencies:
  flutter:
    sdk: flutter
  url_launcher: ^6.2.4
```
Then run:
```sh
flutter pub get
```

---

### 2. **Platform-Specific Configuration**  

#### **For Android:**  
- Open `android/app/src/main/AndroidManifest.xml` and **add** the following permissions inside the `<manifest>` tag:  
```xml
<uses-permission android:name="android.permission.CALL_PHONE"/>
```
- Also, **add this inside `<application>` tag**:
```xml
<queries>
    <intent>
        <action android:name="android.intent.action.DIAL" />
        <data android:scheme="tel"/>
    </intent>
</queries>
```

---

#### **For iOS:**  
- Open `ios/Runner/Info.plist` and **add**:  
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>tel</string>
</array>
```

---

### 3. **Update Your Flutter Code**  
Modify `_makeCall()` to use `launchUrl()` instead of `launch()` because `launch()` is deprecated in newer versions:
```dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallScreen extends StatelessWidget {
  final String phoneNumber;

  const CallScreen({Key? key, required this.phoneNumber}) : super(key: key);

  Future<void> _makeCall() async {
    Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Call Screen'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.phone,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              Text(
                'Call $phoneNumber',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _makeCall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'Make Call',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

### 4. **Restart and Test**
Run the following commands:
```sh
flutter clean
flutter pub get
flutter run
```

**Note:**  
- On Android **emulators**, direct calling might **not work** due to missing dialer capabilities. Test on a real device.  
- Ensure **the phone number is valid** (e.g., `+1234567890`).  
- If calling **does not work on iOS**, you must use `telprompt:` instead of `tel:`.

Let me know if you still face issues! 🚀
