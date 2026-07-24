`foreground_service.dart`

```dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

// The callback function should always be a top-level or static function.
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(DriverTaskHandler());
}

class DriverTaskHandler extends TaskHandler {
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    debugPrint('Foreground task started');

    // Start location tracking
    _startLocationTracking();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // This is called periodically based on interval
    debugPrint('Driver service running: ${timestamp.toIso8601String()}');
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    debugPrint('Foreground task destroyed');
    _positionStreamSubscription?.cancel();
  }

  @override
  void onReceiveData(Object data) {
    debugPrint('Received data from main: $data');
  }

  void _startLocationTracking() async {
    try {
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      );

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        // Send location back to main isolate
        FlutterForegroundTask.sendDataToMain({
          'type': 'location',
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
      });
    } catch (e) {
      debugPrint('Error starting location tracking: $e');
    }
  }
}

class DriverForegroundService {
  static final DriverForegroundService _instance =
      DriverForegroundService._internal();
  factory DriverForegroundService() => _instance;
  DriverForegroundService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isRunning = false;
  Function(Map<String, dynamic>)? onLocationUpdate;

  bool get isRunning => _isRunning;

  Future<void> initialize() async {
    // Initialize local notifications
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _notificationsPlugin.initialize(initializationSettings);

    // Initialize foreground task
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'driver_service_channel',
        channelName: 'Driver Service',
        channelDescription: 'This notification appears when driver is online',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );

    // Listen for data from the foreground task
    FlutterForegroundTask.addTaskDataCallback(_onReceiveData);
  }

  void _onReceiveData(Object data) {
    if (data is Map<String, dynamic>) {
      if (data['type'] == 'location') {
        onLocationUpdate?.call(data);
      }
    }
  }

  Future<bool> startService() async {
    if (_isRunning) return true;

    // CRITICAL on Android 14+ (targetSdk 34+): the service is registered with
    // foregroundServiceType="location|specialUse". Android refuses to start it
    // unless ACCESS_FINE_LOCATION or ACCESS_COARSE_LOCATION is granted at
    // runtime — and that refusal arrives as a SecurityException on the
    // service's own thread, which CANNOT be caught here. The process simply
    // crashes. So we must check the permission BEFORE asking Android to start.
    final locationPermission = await Geolocator.checkPermission();
    final hasLocation = locationPermission == LocationPermission.whileInUse ||
        locationPermission == LocationPermission.always;
    if (!hasLocation) {
      debugPrint(
          'Foreground service NOT started — location permission is '
          '$locationPermission. Caller should keep driver offline until the '
          'user grants location access.');
      return false;
    }

    // Request notification permission (non-fatal on older Android)
    final notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    // Check if already running
    if (await FlutterForegroundTask.isRunningService) {
      _isRunning = true;
      return true;
    }

    // Start the foreground service
    try {
      await FlutterForegroundTask.startService(
        notificationTitle: 'Pushpa Driver',
        notificationText: 'Waiting for orders...',
        notificationIcon: null,
        callback: startCallback,
      );

      _isRunning = true;
      return true;
    } catch (e) {
      debugPrint('Error starting foreground service: $e');
      return false;
    }
  }

  Future<bool> stopService() async {
    if (!_isRunning) return true;

    try {
      await FlutterForegroundTask.stopService();
      _isRunning = false;
      return true;
    } catch (e) {
      debugPrint('Error stopping foreground service: $e');
      return false;
    }
  }

  Future<void> updateNotification({
    required String title,
    required String text,
  }) async {
    if (_isRunning) {
      await FlutterForegroundTask.updateService(
        notificationTitle: title,
        notificationText: text,
      );
    }
  }

  // Update notification when ride is in progress
  Future<void> showRideInProgressNotification(String passengerName) async {
    await updateNotification(
      title: 'Ride in Progress',
      text: 'Taking $passengerName to destination',
    );
  }

  // Update notification when heading to pickup
  Future<void> showHeadingToPickupNotification(String passengerName) async {
    await updateNotification(
      title: 'New Ride',
      text: 'Heading to pick up $passengerName',
    );
  }

  // Update notification to waiting for orders
  Future<void> showWaitingForOrdersNotification() async {
    await updateNotification(
      title: 'Pushpa Driver',
      text: 'Waiting for orders...',
    );
  }
}
```
