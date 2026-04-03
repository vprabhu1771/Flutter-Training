Good move 👍 — using a **UiProvider (Theme Provider)** will make your app scalable and allow easy theme switching later (dark/light/custom).

Let’s implement it cleanly using `ChangeNotifier`.

---

# ✅ 1. Create UiProvider

📁 `lib/providers/ui_provider.dart`

```dart
import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  /// Primary Color (#2980b9)
  static const Color primaryColor = Color(0xFF2980B9);

  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white,

        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
        ),

        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,

        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
      );

  ThemeData get currentTheme => _isDark ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
```

---

# ✅ 2. Add Provider to main.dart

Add dependency first:

```bash
flutter pub add provider
```

Then update `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/ui_provider.dart';
import 'screens/SplashScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UiProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: uiProvider.currentTheme,
      home: SplashScreen(),
    );
  }
}
```

---

# ✅ 3. Use Theme in Your MobileNumberScreen

### 🔥 Replace hardcoded colors like:

```dart
backgroundColor: Colors.white,
```

### ✅ With:

```dart
backgroundColor: Theme.of(context).scaffoldBackgroundColor,
```

---

### 🔥 Replace button color:

```dart
backgroundColor: const Color(0xfff15a24),
```

### ✅ With:

```dart
backgroundColor: Theme.of(context).primaryColor,
```

---

### 🔥 Replace text colors:

```dart
color: Colors.grey.shade900,
```

### ✅ With:

```dart
color: Theme.of(context).textTheme.bodyLarge?.color,
```

---

# ✅ 4. Add Theme Toggle Button (Optional)

Anywhere (like AppBar or settings):

```dart
IconButton(
  icon: Icon(Icons.dark_mode),
  onPressed: () {
    Provider.of<UiProvider>(context, listen: false).toggleTheme();
  },
)
```

---

# 🎯 Result

✔ Centralized theme
✔ Easy color updates
✔ Dark mode ready
✔ No more hardcoded colors

---

# 🔥 Pro Tip (Important)

Instead of this:

```dart
Color(0xfff15a24)
```

Use:

```dart
Theme.of(context).colorScheme.secondary
```

👉 Keeps your UI consistent everywhere

---

If you want next level 🔥
I can:

* Convert your full app to **clean architecture (Provider + Services + UI)**
* Add **dynamic branding (change theme from API)**
* Create **modern login UI with animations**

Just tell 👍
