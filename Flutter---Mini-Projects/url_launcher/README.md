# https://pub.dev/packages/url_launcher


```dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void openSoundSettings() {
    launchUrl('android.settings.SOUND_SETTINGS' as Uri);
}
```