```dart id="tvq7oz"
import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  /// Dynamic Branding Variables
  Color _primaryColor = const Color(0xFF2980B9);
  Color _secondaryColor = const Color(0xFFF15A24);

  String _appName = "THOOYAN";
  String _logoUrl = "";

  /// Getters
  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  String get appName => _appName;
  String get logoUrl => _logoUrl;

  /// HEX String → Color
  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");

    if (hex.length == 6) {
      hex = "FF$hex";
    }

    return Color(int.parse(hex, radix: 16));
  }

  /// Apply Theme From API
  ///
  /// Example API Response:
  /// {
  ///   "primary_color":"#2980b9",
  ///   "secondary_color":"#f15a24",
  ///   "app_name":"THOOYAN",
  ///   "logo_url":"https://domain.com/logo.png"
  /// }
  ///
  void setThemeFromApi(Map<String, dynamic> data) {
    _primaryColor =
        hexToColor(data['primary_color'] ?? "#2980b9");

    _secondaryColor =
        hexToColor(data['secondary_color'] ?? "#f15a24");

    _appName = data['app_name'] ?? "THOOYAN";

    _logoUrl = data['logo_url'] ?? "";

    notifyListeners();
  }

  /// LIGHT THEME
  ThemeData get lightTheme => ThemeData(
        useMaterial3: true,

        brightness: Brightness.light,

        primaryColor: _primaryColor,

        scaffoldBackgroundColor: Colors.white,

        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.light,
          primary: _primaryColor,
          secondary: _secondaryColor,
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _primaryColor),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      );

  /// DARK THEME
  ThemeData get darkTheme => ThemeData(
        useMaterial3: true,

        brightness: Brightness.dark,

        primaryColor: _primaryColor,

        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.dark,
          primary: _primaryColor,
          secondary: _secondaryColor,
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
        ),
      );

  /// Current Theme
  ThemeData get currentTheme =>
      _isDark ? darkTheme : lightTheme;

  /// Toggle Light / Dark
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
```

### ✅ Example API Call Usage

```dart id="f00f17"
Provider.of<UiProvider>(context, listen: false)
    .setThemeFromApi({
  "primary_color": "#2980b9",
  "secondary_color": "#f15a24",
  "app_name": "THOOYAN",
  "logo_url": "https://yourdomain.com/logo.png"
});
```

### ✅ Use Anywhere in UI

#### App Name

```dart id="x9x6jm"
Text(
  context.watch<UiProvider>().appName,
)
```

#### Logo

```dart id="h3yq9s"
Image.network(
  context.watch<UiProvider>().logoUrl,
)
```

#### Primary Color

```dart id="hih88j"
Theme.of(context).primaryColor
```

#### Secondary Color

```dart id="gv9mr8"
Theme.of(context).colorScheme.secondary
```
