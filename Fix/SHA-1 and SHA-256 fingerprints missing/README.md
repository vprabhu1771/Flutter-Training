The error:

```text
E/FirebaseAuth: [SmsRetrieverHelper] SMS verification code request failed:
unknown status code: 17093
```

usually indicates Firebase could not start SMS auto-retrieval because of an app configuration problem.

Check these items:

### 1. SHA-1 and SHA-256 fingerprints missing

This is the most common cause.

Run:

```bash
cd android
./gradlew signingReport
```

Copy both:

* SHA1
* SHA-256

Add them in:

[Firebase Console Project Settings](https://console.firebase.google.com?utm_source=chatgpt.com)

Project Settings → Your Android App → Add Fingerprints

Then download a fresh:

```text
google-services.json
```

Replace the old file in:

```text
android/app/google-services.json
```

Clean and rebuild:

```bash
flutter clean
flutter pub get
flutter run
```

---
