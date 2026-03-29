To implement the double-tap functionality with a boolean variable to display "Started" or "Stopped" based on whether the double tap has occurred, you can use a `StatefulWidget` to manage the state. Here's how you can achieve it:

```dart
import 'package:flutter/material.dart';

class HelloWorldScreen extends StatefulWidget {
  const HelloWorldScreen({super.key});

  @override
  State<HelloWorldScreen> createState() => _HelloWorldScreenState();
}

class _HelloWorldScreenState extends State<HelloWorldScreen> {

  // Initially set to false
  bool isWorking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Good Morning'),
      ),
      body: Center(
        child: GestureDetector(
          onDoubleTap: () {
            setState(() {
              isWorking = !isWorking; // Toggle the value of isWorking on double tap
            });
          },
          child: Container(
            // color: Colors.blue, // Replace with your design
            child: Center(
              child: Text(
                isWorking ? 'Started' : 'Stopped',
                style: TextStyle(
                  // color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### Explanation:
- `isWorking`: A boolean variable that tracks whether the action has "Started" or is "Stopped".
- `GestureDetector`: Detects the double-tap event.
- On double-tap, the `isWorking` state is toggled using `setState()`, which updates the UI to display either "Started" or "Stopped" in the `Text` widget.