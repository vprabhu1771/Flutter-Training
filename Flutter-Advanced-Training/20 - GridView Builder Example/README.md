Here’s an example of how to use a `GridView.builder` in Flutter:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GridViewExample(),
    );
  }
}

class GridViewExample extends StatelessWidget {
  final List<String> items = List.generate(20, (index) => 'Item $index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GridView Builder Example'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.blueAccent,
            child: Center(
              child: Text(
                items[index],
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        },
        padding: EdgeInsets.all(10.0), // Padding around the grid
      ),
    );
  }
}
```

### Explanation:
1. **`GridView.builder`**: Used for creating a grid dynamically.
2. **`SliverGridDelegateWithFixedCrossAxisCount`**:
   - `crossAxisCount`: Number of columns.
   - `crossAxisSpacing` and `mainAxisSpacing`: Set spacing between items.
3. **`itemBuilder`**: Defines how each item in the grid should look.
4. **Padding**: Adds space around the grid items.

### Output:
- A grid with 2 columns and 20 items, each displayed as a blue card with centered text. Adjust `crossAxisCount` to change the number of columns.