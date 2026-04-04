Got it — you want an **“X (clear)” icon in the AppBar** to clear the Autocomplete input.

To do this, you need to control the text field using a **TextEditingController**.

Here’s the clean solution 👇

```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  static const List<String> listItems = <String>[
    'Apple',
    'Orange',
    'Mango'
  ];

  TextEditingController? _controller;

  void _clearText() {
    _controller?.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Autocomplete"),
        actions: [
          if (_controller?.text.isNotEmpty ?? false)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _clearText,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return listItems.where((String item) {
              return item
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          fieldViewBuilder: (
              BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
              ) {
            _controller = textEditingController; // ✅ use internal controller

            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: const InputDecoration(
                hintText: "Search fruit...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {}); // update AppBar icon
              },
            );
          },
          onSelected: (String item) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$item selected")),
            );
          },
        ),
      ),
    );
  }
}
```

---

### 🔥 What this does

* Shows **X icon in AppBar** only when text is entered
* Clicking **X clears the input**
* Autocomplete updates instantly

---

### ⚡ Pro tip (better UX)

If you want the clear button **inside the text field instead of AppBar**, I can show that too (more common pattern).

Just say 👍
