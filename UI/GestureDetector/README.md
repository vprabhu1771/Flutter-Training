Here’s a clear and practical **Flutter `GestureDetector` example** showing how to detect common touch interactions like tap, double tap, and long press.

---

## 🔹 Basic GestureDetector Example

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureExample(),
    );
  }
}

class GestureExample extends StatefulWidget {
  @override
  _GestureExampleState createState() => _GestureExampleState();
}

class _GestureExampleState extends State<GestureExample> {
  String message = "No Gesture Detected";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GestureDetector Example")),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              message = "Tapped";
            });
          },
          onDoubleTap: () {
            setState(() {
              message = "Double Tapped";
            });
          },
          onLongPress: () {
            setState(() {
              message = "Long Pressed";
            });
          },
          child: Container(
            width: 200,
            height: 200,
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 🔹 What This Does

* **onTap** → triggers when user taps once
* **onDoubleTap** → triggers on double tap
* **onLongPress** → triggers when user presses and holds

---

## 🔹 More Gesture Options

You can also use:

```dart
onPanUpdate: (details) {
  print("Dragging: ${details.delta}");
},

onVerticalDragUpdate: (details) {
  print("Vertical drag");
},

onHorizontalDragUpdate: (details) {
  print("Horizontal drag");
},
```

---

## 🔹 Simple Use Case

Wrap any widget (like `Container`, `Image`, `Card`) inside `GestureDetector` to make it interactive.

---

If you want, I can show:

* Swipe gestures (like WhatsApp)
* Drag & drop example
* GestureDetector vs InkWell difference

Just tell 👍
