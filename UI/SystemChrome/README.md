```dart
void main() async {
  // 1. Crucial: This must be called before interacting with the native platform
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 3. Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

```

### Why is `WidgetsFlutterBinding.ensureInitialized()` needed?

The `SystemChrome` methods communicate with the native host platform (Android/iOS) using asynchronous platform channels. If you call these before `runApp()`, Flutter hasn't fully booted its connection to the native side yet. `WidgetsFlutterBinding.ensureInitialized()` forces that connection to open early.
