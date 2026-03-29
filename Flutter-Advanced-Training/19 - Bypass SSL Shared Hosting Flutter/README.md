The `CERTIFICATE_VERIFY_FAILED: self signed certificate(handshake.cc:393))` error in Flutter occurs when the SSL certificate of the server is not trusted by the device or emulator. Here’s how you can fix it:

### **Solution 1: Bypass SSL Certificate Verification (Development Only)**
Add the following code inside the `HttpOverrides` class to allow untrusted SSL certificates. **(Use this only for development, not production!)**

#### **Dart Code (Override HTTP Requests)**
```dart
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}
```
This bypasses SSL verification and allows the request to go through.

---

### **Solution 2: Use a Trusted SSL Certificate**
If you're using a self-signed certificate, consider:
1. Getting a **valid SSL certificate** from a trusted provider (e.g., Let's Encrypt, Cloudflare, etc.).
2. Installing the certificate on your server properly.

---

### **Solution 3: Add Certificate to Flutter’s Trusted CA List**
If your app needs to communicate with a self-signed certificate, embed it inside your app:

1. **Download the SSL certificate** (`.crt` or `.pem` file).
2. **Convert it to DER format** if necessary.
3. **Bundle it inside your Flutter app** and use `SecurityContext`.

---

### **Solution 4: Disable SSL Pinning in OneSignal**
If you are using OneSignal, you might be facing SSL pinning issues. Try disabling SSL verification in OneSignal:

```dart
OneSignal.shared.setRequiresUserPrivacyConsent(true);
OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
```

---

### **Solution 5: Check Device Date & Network**
- Ensure your device's **date and time are correct**.
- Try switching to a different **Wi-Fi network or use mobile data**.

Would you like help debugging your server’s SSL certificate?