#  Method Channel in Flutter - Load Device Ringtones 
```
https://www.youtube.com/watch?v=6kELAssXkAs
```

`MainActivity.kt`
```kotlin
package com.example.untitled

import android.media.RingtoneManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.database.Cursor

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = "flutter_channel"

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getRingtones" -> {
                        val ringtones = getAllRingtones(this)
                        result.success(ringtones)
                    }
                }
            }
    }

    private fun getAllRingtones(context: Context): List<String> {
        val manager = RingtoneManager(context)
        manager.setType(RingtoneManager.TYPE_RINGTONE)

        val cursor: Cursor = manager.cursor
        val list: MutableList<String> = mutableListOf()

        while (cursor.moveToNext()) {
            val notificationTitle: String = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
            list.add(notificationTitle) // Fixed: changed 'all' to 'add'
        }

        return list
    }

}
```

Here is the complete Flutter implementation to communicate with your Android native code using `MethodChannel`.

This includes a dedicated service to handle the native channel and a clean UI screen to fetch and display the ringtones in a list.

### 1. Create the Ringtone Service

First, create a separate file (e.g., `ringtone_service.dart`) to handle the platform channel logic. This keeps your UI code clean and maintainable.

```dart
import 'package:flutter/services.dart';

class RingtoneService {
  // Must match the channel name defined in MainActivity.kt
  static const MethodChannel _channel = MethodChannel('flutter_channel');

  static Future<List<String>> getRingtones() async {
    try {
      // Invokes the 'getRingtones' method on the native side
      final List<dynamic>? result = await _channel.invokeMethod('getRingtones');
      
      if (result != null) {
        return List<String>.from(result);
      }
      return [];
    } on PlatformException catch (e) {
      print("Failed to get ringtones: '${e.message}'.");
      return [];
    }
  }
}

```

---

### 2. Create the Flutter UI Screen

Now, create your UI screen (e.g., `ringtone_screen.dart`). It uses a `FutureBuilder` to automatically handle loading, error, and success states when fetching data from the native side.

```dart
import 'package:flutter/material.dart';
import 'ringtone_service.dart'; // Import the service created above

class RingtoneScreen extends StatefulWidget {
  const RingtoneScreen({Key? key}) : super(key: key);

  @override
  State<RingtoneScreen> createState() => _RingtoneScreenState();
}

class _RingtoneScreenState extends State<RingtoneScreen> {
  late Future<List<String>> _ringtonesFuture;

  @override
  void initState() {
    super.initState();
    // Fetch ringtones when the screen loads
    _ringtonesFuture = RingtoneService.getRingtones();
  }

  // Method to refresh the list if needed
  void _refreshRingtones() {
    setState(() {
      _ringtonesFuture = RingtoneService.getRingtones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Android Ringtones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshRingtones,
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _ringtonesFuture,
        builder: (context, snapshot) {
          // 1. Show loading spinner while waiting for native data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. Handle errors if something goes wrong
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // 3. Display data if successfully retrieved
          if (snapshot.hasData) {
            final ringtones = snapshot.data!;

            if (ringtones.isEmpty) {
              return const Center(
                child: Text('No ringtones found.'),
              );
            }

            return ListView.separated(
              itemCount: ringtones.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.music_note, color: Colors.blue),
                  title: Text(
                    ringtones[index],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    // Handle ringtone selection here if needed
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected: ${ringtones[index]}')),
                    );
                  },
                );
              },
            );
          }

          return const Center(child: Text('No data available.'));
        },
      ),
    );
  }
}

```

---

### 💡 Quick Notes for Success

* **Channel Names match:** The `MethodChannel('flutter_channel')` in your Dart code perfectly matches the `val channel = "flutter_channel"` inside your Kotlin file.
* **Method Names match:** `_channel.invokeMethod('getRingtones')` perfectly targets the `when (call.method) { "getRingtones" -> ... }` block in Kotlin.
* **Pro-tip:** Don't forget to pass `this` (the context) to `getAllRingtones(this)` in your Kotlin file to avoid null-pointer exceptions during the platform call. You already have this implemented correctly in your snippet!
