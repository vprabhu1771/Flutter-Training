In Flutter, **`ListTile`** is a pre-built widget used to create rows in lists with leading/trailing widgets, titles, subtitles, and tap actions.

### Basic Syntax

```dart
ListTile(
  leading: Icon(Icons.person),
  title: Text("John"),
  subtitle: Text("Software Developer"),
  trailing: Icon(Icons.arrow_forward),
  onTap: () {
    print("Tile tapped");
  },
)
```

### Common Properties

| Property            | Description                                               |
| ------------------- | --------------------------------------------------------- |
| `leading`           | Widget displayed at the start (usually an icon or avatar) |
| `title`             | Main text of the tile                                     |
| `subtitle`          | Secondary text below the title                            |
| `trailing`          | Widget displayed at the end                               |
| `onTap`             | Called when the tile is tapped                            |
| `onLongPress`       | Called when the tile is long-pressed                      |
| `tileColor`         | Background color                                          |
| `selected`          | Indicates whether the tile is selected                    |
| `selectedTileColor` | Background color when selected                            |
| `dense`             | Reduces tile height                                       |
| `enabled`           | Enables/disables interactions                             |
| `contentPadding`    | Padding around the content                                |
| `shape`             | Defines the tile's border shape                           |

### Example with ListView

```dart
ListView(
  children: [
    ListTile(
      leading: CircleAvatar(
        child: Text("P"),
      ),
      title: Text("Prabhu"),
      subtitle: Text("Flutter Developer"),
      trailing: Icon(Icons.phone),
      onTap: () {
        print("Prabhu selected");
      },
    ),
    ListTile(
      leading: Icon(Icons.email),
      title: Text("Email"),
      subtitle: Text("prabhu@example.com"),
    ),
  ],
)
```

### Example Inside Card

```dart
Card(
  child: ListTile(
    leading: Icon(Icons.shopping_cart),
    title: Text("Order #123"),
    subtitle: Text("Delivered"),
    trailing: Icon(Icons.check_circle),
  ),
)
```

### Frequently Used Methods (Callbacks)

```dart
ListTile(
  onTap: () {
    // Executes when tapped
  },
  onLongPress: () {
    // Executes when long pressed
  },
)
```

`ListTile` itself doesn't have many methods; it mainly uses **properties and callback functions** such as `onTap`, `onLongPress`, `onFocusChange`, and `onHover`.
