For a more organized Flutter project with Riverpod, let's set up a folder structure that separates the provider, screens, and main app logic. Here’s how to structure your project files:

### Folder Structure

```plaintext
lib/
│
├── main.dart
├── providers/
│   └── CounterProvider.dart
└── screens/
    └── counter_screen.dart
```

### Step 1: Create the Counter Provider

In the `lib/services` directory, create a file called `CounterProvider.dart`.

**`lib/services/CounterProvider.dart`:**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>((ref) => 0);
```

### Step 2: Create the Counter Screen

In the `lib/screens` directory, create a file called `CounterScreen.dart`.

**`lib/screens/CounterScreen.dart`:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/CounterProvider.dart';

class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Counter App with Riverpod"),
      ),
      body: Center(
        child: Text(
          "$counter",
          style: TextStyle(fontSize: 50),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              ref.read(counterProvider.notifier).state++;
            },
            child: Icon(Icons.add),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              ref.read(counterProvider.notifier).state--;
            },
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

### Step 3: Set up the Main App File

In `lib/main.dart`, set up the main app to use `ProviderScope` and navigate to the `CounterScreen`.

**`lib/main.dart`:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/CounterScreen.dart';

void main() {
  runApp(ProviderScope(child: CounterApp()));
}

class CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterScreen(),
    );
  }
}
```

### Summary

1. **`counter_provider.dart`**: Defines the `counterProvider` which manages the counter state.
2. **`counter_screen.dart`**: UI for the counter app, with FABs for increment and decrement.
3. **`main.dart`**: Entry point of the app, setting up `ProviderScope` and loading the `CounterScreen`.

This structure keeps the provider logic separate from UI and main app setup, making it scalable and maintainable.