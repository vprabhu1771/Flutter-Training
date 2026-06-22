If you want a **single "Book Ride" button fixed at the bottom** of a `Scaffold`, use the `bottomNavigationBar` property.

```dart
import 'package:flutter/material.dart';

class RideScreen extends StatelessWidget {
  const RideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Ride'),
      ),
      body: const Center(
        child: Text('Select your pickup and destination'),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Book ride action
              },
              child: const Text('Book Ride'),
            ),
          ),
        ),
      ),
    );
  }
}
```

### Alternative using `bottomSheet`

```dart
Scaffold(
  body: YourBody(),
  bottomSheet: Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    child: ElevatedButton(
      onPressed: () {},
      child: const Text('Book Ride'),
    ),
  ),
);
```

For ride-booking apps like Uber/Ola, `bottomNavigationBar` is usually the preferred approach because it stays fixed at the bottom and respects safe areas automatically.
