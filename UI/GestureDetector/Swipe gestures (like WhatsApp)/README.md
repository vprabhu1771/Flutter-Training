If you want **WhatsApp-style swipe gestures (swipe to reply / swipe actions)** in Flutter, you typically combine `GestureDetector` or use widgets like `Dismissible` or packages like `flutter_slidable`.

Let me show you a clean **manual swipe (like WhatsApp reply swipe)** first 👇

---

## 🔹 WhatsApp-style Swipe (Drag Right to Reply)

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatSwipeExample(),
    );
  }
}

class ChatSwipeExample extends StatefulWidget {
  @override
  _ChatSwipeExampleState createState() => _ChatSwipeExampleState();
}

class _ChatSwipeExampleState extends State<ChatSwipeExample> {
  double offsetX = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Swipe to Reply")),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                offsetX += details.delta.dx;

                // Limit swipe distance
                if (offsetX < 0) offsetX = 0;
                if (offsetX > 100) offsetX = 100;
              });
            },
            onHorizontalDragEnd: (details) {
              if (offsetX > 60) {
                print("Reply triggered on item $index");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Reply to message $index")),
                );
              }

              // Reset position
              setState(() {
                offsetX = 0;
              });
            },
            child: Stack(
              children: [
                // Background (reply icon)
                Container(
                  height: 70,
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(Icons.reply, color: Colors.white),
                ),

                // Foreground message
                Transform.translate(
                  offset: Offset(offsetX, 0),
                  child: Container(
                    height: 70,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(16),
                    child: Text("Message $index"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

---

## 🔥 What’s Happening

* User **drags right**
* Message moves with finger (`Transform.translate`)
* When drag passes threshold (`> 60`):
  → trigger reply action
* Then it resets back (like WhatsApp)

---

## ⚠️ Important Fix (Real-world)

Right now `offsetX` is shared across all items.
For production, store offset **per item**:

```dart
Map<int, double> offsets = {};
```

---

## 🔹 Easier Alternative (Recommended)

Use Flutter’s built-in:

### 👉 `Dismissible` (quick swipe actions)

```dart
Dismissible(
  key: Key(index.toString()),
  direction: DismissDirection.startToEnd,
  onDismissed: (_) {
    print("Swiped item $index");
  },
  background: Container(
    color: Colors.green,
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(left: 20),
    child: Icon(Icons.reply, color: Colors.white),
  ),
  child: ListTile(title: Text("Message $index")),
)
```

---

## 🔹 Best Production Option (WhatsApp-like)

Use package:

👉 `flutter_slidable`

```yaml
dependencies:
  flutter_slidable: ^3.0.0
```

```dart
Slidable(
  startActionPane: ActionPane(
    motion: DrawerMotion(),
    children: [
      SlidableAction(
        onPressed: (_) {},
        backgroundColor: Colors.green,
        icon: Icons.reply,
        label: 'Reply',
      ),
    ],
  ),
  child: ListTile(title: Text("Message")),
)
```

---

## 💡 Summary

* `GestureDetector` → full custom control (WhatsApp-style)
* `Dismissible` → simple swipe
* `flutter_slidable` → best UI + production ready

---

If you want, I can build:

* Full WhatsApp chat UI with swipe reply
* Left swipe for delete + right swipe for reply
* Animated smooth bounce effect

Just tell 👍
