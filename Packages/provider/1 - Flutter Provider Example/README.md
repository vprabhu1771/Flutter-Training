Here's a basic example of using **Provider** and **Consumer** in Flutter for state management:

1. **Add `provider` package to `pubspec.yaml`:**

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
```

2. **Create a simple model (e.g., a counter):**

```dart
import 'package:flutter/foundation.dart';

class Counter with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}
```

3. **Set up the `Provider` in the main app:**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter.dart';  // Import the Counter model

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Counter(),  // Provide the Counter model
      child: MaterialApp(
        home: CounterScreen(),
      ),
    );
  }
}
```

4. **Create a UI that uses `Consumer` to listen for state changes:**

```dart
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter Example')),
      body: Center(
        child: Consumer<Counter>(
          builder: (context, counter, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Count: ${counter.count}',
                  style: TextStyle(fontSize: 30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: counter.increment,
                      child: Text('Increment'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: counter.decrement,
                      child: Text('Decrement'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

### Explanation:

* **ChangeNotifier**: The `Counter` class extends `ChangeNotifier`, which allows us to notify listeners (widgets) when the state changes.
* **Provider**: The `ChangeNotifierProvider` is used to provide the `Counter` instance to the widget tree.
* **Consumer**: The `Consumer<Counter>` widget listens to changes in the `Counter` and rebuilds the UI when the state updates.

### Run the app:

* When you press the "Increment" or "Decrement" buttons, the count will update, and the UI will reflect the changes automatically.
