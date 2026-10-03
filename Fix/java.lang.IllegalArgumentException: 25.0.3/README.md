You can configure the JDK path directly in your project's `gradle.properties` file instead of changing it globally using the Flutter CLI.
Add the `org.gradle.java.home` property to your `android/gradle.properties` file, pointing it to your JDK installation directory:

# Add this line at the bottom of your android/gradle.properties file
```
org.gradle.java.home=C:/Program Files/Java/jdk-17
```
## Important Steps to Follow:

* Use forward slashes: Gradle requires forward slashes (`/`) in paths, even on Windows. Do not use backslashes (`\`).
* Match your exact path: Double-check your `C:/Program Files/Java/` directory to ensure you are targeting the exact folder name where JDK 17 (or JDK 21) is installed.
* Clean your build: After saving the file, run `flutter clean` in your terminal before building your app again to make sure the cache clears.

If you try this and it still throws an error, let me know:

* What error message appears next?
* What Gradle version is listed in your gradle-wrapper.properties?


