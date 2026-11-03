Here's a **simple Flutter TODO app example using Provider** for state management. This app allows users to:

* Add new TODO items
* Toggle completion
* Remove TODO items

---

### 🧱 Step-by-step Project Structure

```
lib/
├── main.dart
├── models/
│   └── todo.dart
├── providers/
│   └── todo_provider.dart
├── screens/
│   └── todo_screen.dart
└── widgets/
    └── todo_tile.dart
```

---

### ✅ 1. `models/todo.dart`

```dart
class Todo {
  final String id;
  final String title;
  bool isDone;

  Todo({required this.id, required this.title, this.isDone = false});
}
```

---

### ✅ 2. `providers/todo_provider.dart`

```dart
import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(String title) {
    _todos.add(Todo(id: DateTime.now().toString(), title: title));
    notifyListeners();
  }

  void toggleTodo(String id) {
    final todo = _todos.firstWhere((todo) => todo.id == id);
    todo.isDone = !todo.isDone;
    notifyListeners();
  }

  void removeTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }
}
```

---

### ✅ 3. `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'screens/todo_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoScreen(),
    );
  }
}
```

---

### ✅ 4. `screens/todo_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_tile.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodo() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      Provider.of<TodoProvider>(context, listen: false).addTodo(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('TODO List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'Add TODO'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTodo,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoProvider.todos.length,
              itemBuilder: (context, index) {
                final todo = todoProvider.todos[index];
                return TodoTile(todo: todo);
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

---

### ✅ 5. `widgets/todo_tile.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (_) {
          Provider.of<TodoProvider>(context, listen: false)
              .toggleTodo(todo.id);
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          Provider.of<TodoProvider>(context, listen: false)
              .removeTodo(todo.id);
        },
      ),
    );
  }
}
```

---

### 🔧 Add Dependency

In `pubspec.yaml`, include:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
```

---

Let me know if you want this to work with Hive or SQLite for persistence!
