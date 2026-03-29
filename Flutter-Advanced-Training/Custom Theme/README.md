
```dart
import 'package:flutter/material.dart';
import 'package:flutter_laravel_thoondil_meengal_shop/services/UiProvider.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {

  final String title;

  const SettingScreen({super.key, required this.title});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context); // Get the current theme

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: theme.primaryColor, // Use the primary color from the current theme
      ),
      body: Consumer<UiProvider>(
        builder: (context, UiProvider notifier, child) {
          return Column(
            children: [
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text("Dark Theme"),
                trailing: Switch(
                  onChanged: (value) { notifier.changeTheme(); },
                  value: notifier.isDark,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
```
