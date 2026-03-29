# AuthButton – Provides social login buttons (Google, Facebook, etc.).

You can use the `flutter_auth_buttons` or `sign_in_button` package to create social login buttons in Flutter. Here's an example using **sign_in_button** to implement Google and Facebook login buttons:

### **Step 1: Add Dependencies**
Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  sign_in_button: ^3.2.0
  firebase_auth: ^4.15.0
  google_sign_in: ^6.1.5
  flutter_facebook_auth: ^6.0.2
```

Then, run:
```sh
flutter pub get
```

---

### **Step 2: Implement Google & Facebook Sign-In**
Create a new file `auth_button.dart` and add the following code:

```dart
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthButtons extends StatefulWidget {
  @override
  _AuthButtonsState createState() => _AuthButtonsState();
}

class _AuthButtonsState extends State<AuthButtons> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // Facebook Sign-In
  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
        return await _auth.signInWithCredential(credential);
      } else {
        print("Facebook Sign-In Failed: ${result.status}");
        return null;
      }
    } catch (e) {
      print("Facebook Sign-In Error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google Sign-In Button
        SignInButton(
          Buttons.google,
          onPressed: () async {
            UserCredential? user = await signInWithGoogle();
            if (user != null) {
              print("Google Login Successful: ${user.user!.displayName}");
            }
          },
        ),
        SizedBox(height: 10),

        // Facebook Sign-In Button
        SignInButton(
          Buttons.facebook,
          onPressed: () async {
            UserCredential? user = await signInWithFacebook();
            if (user != null) {
              print("Facebook Login Successful: ${user.user!.displayName}");
            }
          },
        ),
      ],
    );
  }
}
```

---

### **Step 3: Use AuthButtons in Your App**
In your `main.dart` or login screen:

```dart
import 'package:flutter/material.dart';
import 'auth_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Social Login")),
        body: Center(child: AuthButtons()),
      ),
    );
  }
}
```

---

### **Step 4: Firebase Setup**
Make sure you **enable Google & Facebook sign-in** in your Firebase console:
1. Go to **Firebase Console** → Authentication → Sign-in Method.
2. Enable **Google Sign-In** and **Facebook Sign-In**.
3. For Facebook, get the **App ID and Secret** from [Facebook Developer Console](https://developers.facebook.com/).
4. Update `android/app/google-services.json` for Google Sign-In.

---

### **Output**
- Google and Facebook login buttons will appear.
- When clicked, it will authenticate the user using Firebase.
- After a successful login, it prints the **user’s display name**.

---

### ✅ **Done!**
Now your Flutter app supports Google & Facebook login using Firebase! 🎉🚀 Let me know if you need further help!

![Image](1.png)