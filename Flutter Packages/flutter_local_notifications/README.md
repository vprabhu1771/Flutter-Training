```
https://pub.dev/packages/flutter_local_notifications
```

# 🔔📱 Local Notifications • Flutter Tutorial 
```
https://www.youtube.com/watch?v=uKz8tWbMuUw
```

`NotificationService.dart`
```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // Initialize
  Future<void> initNotification() async {
    if (_isInitialized) return; // prevent re-initialization

    // prepare android init settings
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // prepare ios init settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // init settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    // finally, initialize the plugin!
    await notificationsPlugin.initialize(settings: initSettings);
  }

  // Notification Detail Setup
  NotificationDetails notificationDetails() {
      return const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily_channel_id',
            'Daily Notification',
            channelDescription: 'Daily Notification Channel',
            importance: Importance.max,
            priority: Priority.high
        ), // Android Notification Detail
        iOS: DarwinNotificationDetails(),
      );
  }

  // Show Notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(),
    );
  }

  // On Notification Tap

}
```
