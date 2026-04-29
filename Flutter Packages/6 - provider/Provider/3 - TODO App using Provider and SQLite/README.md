Here's a full example of a **Flutter TODO app using Provider and SQLite**. This will:

* Use `provider` for state management
* Use `sqflite` and `path_provider` for local SQLite storage
* Perform **CRUD** operations (Create, Read, Update, Delete)

---

### ✅ Dependencies (add in `pubspec.yaml`):

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  sqflite: ^2.3.2
  path_provider: ^2.1.2
  path: ^1.8.3
```

---

### 📁 File Structure:

```
lib/
├── db/
│   └── todo_database.dart
├── models/
│   └── todo.dart
├── providers/
│   └── todo_provider.dart
├── screens/
│   └── todo_screen.dart
├── widgets/
│   └── todo_tile.dart
└── main.dart
```

---

### ✅ 1. `models/todo.dart`

```dart
class Todo {
  final int? id;
  final String title;
  final bool isDone;

  Todo({this.id, required this.title, this.isDone = false});

  Todo copy({int? id, String? title, bool? isDone}) => Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        isDone: isDone ?? this.isDone,
      );

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        id: json['id'],
        title: json['title'],
        isDone: json['isDone'] == 1,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'isDone': isDone ? 1 : 0,
      };
}
```

---

### ✅ 2. `db/todo_database.dart`

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();
  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        isDone INTEGER NOT NULL
      )
    ''');
  }

  Future<Todo> create(Todo todo) async {
    final db = await instance.database;
    final id = await db.insert('todos', todo.toMap());
    return todo.copy(id: id);
  }

  Future<List<Todo>> readAllTodos() async {
    final db = await instance.database;
    final result = await db.query('todos', orderBy: 'id DESC');
    return result.map((map) => Todo.fromMap(map)).toList();
  }

  Future<int> update(Todo todo) async {
    final db = await instance.database;
    return db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
```

---

### ✅ 3. `providers/todo_provider.dart`

```dart
import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../db/todo_database.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future loadTodos() async {
    _todos = await TodoDatabase.instance.readAllTodos();
    notifyListeners();
  }

  Future addTodo(String title) async {
    final todo = Todo(title: title);
    final newTodo = await TodoDatabase.instance.create(todo);
    _todos.insert(0, newTodo);
    notifyListeners();
  }

  Future toggleTodo(Todo todo) async {
    final updated = todo.copy(isDone: !todo.isDone);
    await TodoDatabase.instance.update(updated);
    final index = _todos.indexWhere((t) => t.id == todo.id);
    _todos[index] = updated;
    notifyListeners();
  }

  Future removeTodo(int id) async {
    await TodoDatabase.instance.delete(id);
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
```

---

### ✅ 4. `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'screens/todo_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider()..loadTodos(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite TODO',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const TodoScreen(),
    );
  }
}
```

---

### ✅ 5. `screens/todo_screen.dart`

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
      appBar: AppBar(title: const Text('TODO with SQLite')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'New Todo'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTodo,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoProvider.todos.length,
              itemBuilder: (_, i) => TodoTile(todo: todoProvider.todos[i]),
            ),
          )
        ],
      ),
    );
  }
}
```

---

### ✅ 6. `widgets/todo_tile.dart`

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
    final provider = Provider.of<TodoProvider>(context, listen: false);
    return ListTile(
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (_) => provider.toggleTodo(todo),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => provider.removeTodo(todo.id!),
      ),
    );
  }
}
```

---

✅ That’s it! You now have a full-featured TODO app using:

* `Provider` for state management
* `SQLite` for local persistent storage

Let me know if you’d like to add sorting, search, or backup/export features!
