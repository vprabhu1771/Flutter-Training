# Flutter Autocomplete Widget 

```
https://www.youtube.com/watch?v=TYQlGVTlhqk
```

```
https://www.youtube.com/watch?v=1vwYmU8aE-0
```

```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  static const List<String> listItems = <String> [
    'Apple',
    'Orange',
    'Mango'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Autocomplete"),
      ),
      body: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if(textEditingValue.text == '') {
            return const Iterable<String>.empty();
          }
          return listItems.where((String item) {
            return item.contains(textEditingValue.text);
          });
        },
        onSelected: (String item) {
          print("$item selected");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("$item selected"),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      )
    );
  }
}
```
