You can add a **Language Selection** setting tile to your existing Settings screen and persist the selected language using `SharedPreferences`.

### 1. Add Dependencies

```yaml
dependencies:
  shared_preferences: ^2.5.3
  provider: ^6.1.5
```

---

### 2. Update LocaleProvider

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('language_code') ?? 'en';

    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('language_code', languageCode);

    _locale = Locale(languageCode);
    notifyListeners();
  }
}
```

---

### 3. Add State Variable in SettingsScreen

```dart
String _selectedLanguage = 'en';
```

---

### 4. Load Saved Language

Inside `initState()`:

```dart
@override
void initState() {
  super.initState();
  loadVersion();
  _loadLanguage();
}

Future<void> _loadLanguage() async {
  final prefs = await SharedPreferences.getInstance();

  setState(() {
    _selectedLanguage =
        prefs.getString('language_code') ?? 'en';
  });
}
```

---

### 5. Add Language Section

Place it under **Preferences** section.

```dart
_buildSettingTile(
  icon: Icons.language,
  title: 'Language',
  subtitle: 'Select app language',
  trailing: DropdownButton<String>(
    value: _selectedLanguage,
    underline: const SizedBox(),
    items: const [
      DropdownMenuItem(
        value: 'en',
        child: Text('English'),
      ),
      DropdownMenuItem(
        value: 'ta',
        child: Text('தமிழ்'),
      ),
      DropdownMenuItem(
        value: 'hi',
        child: Text('हिन्दी'),
      ),
    ],
    onChanged: (value) async {
      if (value == null) return;

      setState(() {
        _selectedLanguage = value;
      });

      await context
          .read<LocaleProvider>()
          .changeLanguage(value);
    },
  ),
),
```

---

### 6. Connect LocaleProvider in main.dart

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
    ),
  ],
  child: const MyApp(),
)
```

Inside `MaterialApp`:

```dart
Consumer<LocaleProvider>(
  builder: (context, localeProvider, child) {
    return MaterialApp(
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ta'),
        Locale('hi'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  },
)
```

---

### Result

✅ Language selection appears in Settings
✅ English / Tamil / Hindi supported
✅ Selected language saved in `SharedPreferences`
✅ Language automatically restored when app restarts
✅ Works with Provider-based localization setup.
