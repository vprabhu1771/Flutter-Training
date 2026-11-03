If you want to **prevent your Flutter app from going to sleep (keep the screen awake)** while the app is open (common for driver, navigation, or ride apps), use the `wakelock_plus` package.

### 1. Add the dependency

```yaml
dependencies:
  wakelock_plus: ^1.3.2
```

Run:

```bash
flutter pub get
```

### 2. Enable wakelock

In your `main()`:

```dart
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WakelockPlus.enable();

  runApp(const MyApp());
}
```

Or inside a specific screen:

```dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Driver Online")),
    );
  }
}
```

### 3. Check status (optional)

```dart
bool enabled = await WakelockPlus.enabled;
print(enabled);
```

### Driver app recommendation

For a taxi/driver app like **Pushpa Driver**, don't keep the screen awake all the time. Instead:

* ✅ Enable wakelock when the driver is **Online** or during an active trip.
* ✅ Disable wakelock when the driver goes **Offline** or logs out.

Example:

```dart
Future<void> goOnline() async {
  await WakelockPlus.enable();
}

Future<void> goOffline() async {
  await WakelockPlus.disable();
}
```

### Note

`wakelock_plus` **only keeps the screen from turning off**. It **does not** prevent Android from:

* putting the app into Doze mode,
* killing the app in the background,
* applying battery optimization.

For a ride-hailing app that must receive ride requests reliably in the background, you should also:

* Use a foreground service when tracking location.
* Ask users to disable battery optimization for your app.
* Continue using Firebase Cloud Messaging (FCM) for notifications, as you already are.
