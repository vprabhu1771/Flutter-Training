# ReCaptcha – Implements Google reCAPTCHA for bot protection.

Here’s how you can implement **Google reCAPTCHA** in a **Flutter** app using `flutter_recaptcha_v2`:

---

### **Step 1: Add Dependencies**
Add the `flutter_recaptcha_v2` package in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_recaptcha_v2: ^0.0.4
  webview_flutter: ^4.7.0
```

Run:
```sh
flutter pub get
```

---

### **Step 2: Get reCAPTCHA API Keys**
1. Go to [Google reCAPTCHA Admin](https://www.google.com/recaptcha/admin/create).
2. Register your site with **reCAPTCHA v2 (Checkbox)**.
3. Copy your **Site Key** and **Secret Key**.

---

### **Step 3: Implement reCAPTCHA in Flutter**
Create a new file `recaptcha_screen.dart` and add:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2/flutter_recaptcha_v2.dart';

class RecaptchaScreen extends StatefulWidget {
  @override
  _RecaptchaScreenState createState() => _RecaptchaScreenState();
}

class _RecaptchaScreenState extends State<RecaptchaScreen> {
  late RecaptchaV2Controller recaptchaController;
  String verificationMessage = "Click Verify to continue";

  @override
  void initState() {
    super.initState();
    recaptchaController = RecaptchaV2Controller();
  }

  void onVerified(String token) {
    setState(() {
      verificationMessage = "reCAPTCHA Verified! Token: $token";
    });
    print("reCAPTCHA Token: $token");
  }

  void onFailed() {
    setState(() {
      verificationMessage = "reCAPTCHA Verification Failed. Try again.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google reCAPTCHA")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RecaptchaV2(
            apiKey: "YOUR_SITE_KEY", // Replace with your Google reCAPTCHA Site Key
            controller: recaptchaController,
            onVerified: onVerified,
            onFailed: onFailed,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              recaptchaController.show();
            },
            child: Text("Verify reCAPTCHA"),
          ),
          SizedBox(height: 20),
          Text(verificationMessage, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
```

---

### **Step 4: Use the reCAPTCHA Screen**
In your `main.dart` file:

```dart
import 'package:flutter/material.dart';
import 'recaptcha_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RecaptchaScreen(),
  ));
}
```

---

### **Step 5: Verify reCAPTCHA on Backend (Optional)**
On the **backend (Laravel/PHP/Node.js, etc.)**, validate the reCAPTCHA token with:

**Example API Call to Google reCAPTCHA:**
```sh
curl -X POST "https://www.google.com/recaptcha/api/siteverify" \
-d "secret=YOUR_SECRET_KEY" \
-d "response=USER_TOKEN"
```

---

### **Output**:
✅ When the user clicks "Verify reCAPTCHA," a Google reCAPTCHA dialog appears.  
✅ On successful verification, it shows `reCAPTCHA Verified! Token: XYZ`.  

---

This method helps prevent bots in **login, signup, contact forms, etc.** 🚀  
Let me know if you need **backend integration!** 😊