# Step 1: Secure Your Android Configuration

Instead of writing your key inside AndroidManifest.xml, pull it from a local properties file that you will hide from Git.

# 1. Open your `android/local.properties` file and add your API key at the bottom:
```
MAPS_API_KEY=AIzaSyYourActualKeyHere
```
# 2. Open `android/app/build.gradle` and configure it to read that key:
```
def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

android {
    defaultConfig {
        // Inject the key as a manifest placeholder
        manifestPlaceholders = [mapsApiKey: localProperties.getProperty("MAPS_API_KEY") ?: ""]
    }
}
```

# 3. Open `android/app/src/main/AndroidManifest.xml` and swap out your hardcoded key with the dynamic variable:
```
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="${mapsApiKey}" />
```

# Step 2: Secure Your iOS Configuration

For iOS, you can safely use Xcode build configuration (.xcconfig) files to hold the key safely outside of Git tracking.

1. Go to the `ios/Flutter/` folder.
2. Open `Debug.xcconfig` and add your key:
```
MAPS_API_KEY=AIzaSyYourActualKeyHere
```
3. Open `Release.xcconfig` and reference the variable:
```
MAPS_API_KEY=$(MAPS_API_KEY)
```
4. Open `ios/Runner/Info.plist` and add a new dictionary property mapping to that variable:
```
<key>GoogleMapsAPIKey</key>
<string>$(MAPS_API_KEY)</string>
```
5. Open `ios/Runner/AppDelegate.swift` and extract it safely inside your swift logic:
```
if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as? String {
    GMSServices.provideAPIKey(apiKey)
}
```

# Step 3: Update Your `.gitignore` File

The absolute most critical step is ensuring your private configuration files never reach GitHub. Open your root .gitignore file and ensure the following local tracking paths are added:
```
# Android keys
android/local.properties

# iOS keys 
ios/Flutter/Debug.xcconfig
```
