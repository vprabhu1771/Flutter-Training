This error means your Flutter project is using one Android NDK version, while one or more plugins require a newer version.

Example:

```text
Your project is configured with Android NDK 26.3.11579264,
but the following plugin(s) depend on a different Android NDK version:
- flutter_overlay_window requires Android NDK 27.0.xxxxx
- ...
```

### Find the required NDK version

Look at the lines immediately below the error. Flutter usually tells you:

```text
flutter_overlay_window requires Android NDK 27.0.12077973
```

Use the **highest version** listed.

### Update `android/app/build.gradle`

Add or update:

```gradle
android {
    ndkVersion "27.0.12077973"

    compileSdkVersion 35

    defaultConfig {
        ...
    }
}
```

Or in newer Flutter projects (`android/app/build.gradle.kts`):

```kotlin
android {
    ndkVersion = "27.0.12077973"
}
```

### Install the NDK

Open Android Studio:

**Tools → SDK Manager → SDK Tools**

Check:

```text
Android SDK Command-line Tools
Android SDK Build-Tools
NDK (Side by side)
```

Install the required NDK version.

### Verify installed NDKs

Check:

```text
C:\Users\<username>\AppData\Local\Android\Sdk\ndk\
```

You should see something like:

```text
26.3.11579264
27.0.12077973
```

### Clean and rebuild

```bash
flutter clean
flutter pub get
flutter build apk
```

---

Please paste the complete NDK error, especially the lines after:

```text
Your project is configured with Android NDK 26.3.11579264,
but the following plugin(s) depend on a different Android NDK version:
```

Then I can tell you the exact `ndkVersion` you should use.
