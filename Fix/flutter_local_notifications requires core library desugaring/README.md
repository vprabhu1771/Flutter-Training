## Dependency ':flutter_local_notifications' requires core library desugaring to be enabled for :app.

```
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.untitled"
//    compileSdk = flutter.compileSdkVersion
    compileSdk = 35
//    ndkVersion = flutter.ndkVersion
    ndkVersion = "27.0.12077973"

    // ✅ CORRECT for Kotlin DSL - use this syntax
    buildFeatures {
        viewBinding = true  // optional, but shows correct syntax
    }

    compileOptions {
        // ✅ Desugaring is enabled here for Kotlin DSL
        isCoreLibraryDesugaringEnabled = true  // Note the "is" prefix
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.untitled"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
//        minSdk = flutter.minSdkVersion
        minSdk = 24
//        targetSdk = flutter.targetSdkVersion
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// ✅ CORRECT: Dependencies block goes HERE, outside the android block
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")  // Use 2.0.4 (latest)
}

flutter {
    source = "../.."
}

```
