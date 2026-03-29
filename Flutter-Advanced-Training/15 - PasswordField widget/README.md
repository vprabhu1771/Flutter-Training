You can achieve the show/hide password functionality using a `StatefulWidget` or by managing state with a `StatefulBuilder` inside a `StatelessWidget`. Below is a `StatefulWidget` implementation:

### Solution:
```dart
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true; // Initial state to hide the password

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText, // Controls text visibility
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText; // Toggle the visibility
            });
          },
        ),
        label: Text(
          'Password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xffB81736),
          ),
        ),
      ),
    );
  }
}
```

### Explanation:
- The `_obscureText` variable controls whether the password is hidden.
- The `IconButton` toggles `_obscureText` between `true` and `false` when tapped.
- The icon dynamically switches between `Icons.visibility_off` and `Icons.visibility`.

### Usage:
Simply use the `PasswordField()` widget wherever you need a password input field.

Let me know if you need any modifications! 🚀