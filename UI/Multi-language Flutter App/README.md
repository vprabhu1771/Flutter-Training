To create a **multi-language Flutter app (Internationalization - i18n and Localization - l10n)**, follow these steps.

## 1. Add Dependencies

In `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2

flutter:
  generate: true
```

Run:

```bash
flutter pub get
```

---

## 2. Create Language Files

Create a folder:

```
lib/l10n/
```

### app_en.arb

```json
{
  "appTitle": "Taxi App",
  "welcome": "Welcome",
  "@welcome": {
    "description": "Welcome message"
  }
}
```

### app_ta.arb

```json
{
  "appTitle": "டாக்ஸி செயலி",
  "welcome": "வரவேற்கிறோம்"
}
```

### app_hi.arb

```json
{
  "appTitle": "टैक्सी ऐप",
  "welcome": "स्वागत है"
}
```

---

## 3. Configure l10n

Create `l10n.yaml` in project root:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

---

## 4. Update MaterialApp

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('en'),
        Locale('ta'),
        Locale('hi'),
      ],

      home: const HomePage(),
    );
  }
}
```

---

## 5. Use Translated Strings

```dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: Center(
        child: Text(
          l10n.welcome,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
```

---

## 6. Change Language Dynamically

Create a locale provider:

```dart
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void changeLanguage(String code) {
    _locale = Locale(code);
    notifyListeners();
  }
}
```

Using Provider:

```yaml
dependencies:
  provider: ^6.1.2
```

---

### Main.dart

```dart
ChangeNotifierProvider(
  create: (_) => LocaleProvider(),
  child: const MyApp(),
);
```

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          locale: provider.locale,

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          supportedLocales: const [
            Locale('en'),
            Locale('ta'),
            Locale('hi'),
          ],

          home: const HomePage(),
        );
      },
    );
  }
}
```

---

## 7. Language Selection UI

```dart
DropdownButton<String>(
  value: 'en',
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
  onChanged: (value) {
    context.read<LocaleProvider>()
        .changeLanguage(value!);
  },
)
```

---

## Persist Selected Language

Use [shared_preferences package documentation](https://pub.dev/packages/shared_preferences?utm_source=chatgpt.com) to save the selected language:

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setString('languageCode', 'ta');
```

Load on app startup:

```dart
String code =
    prefs.getString('languageCode') ?? 'en';
```

---

### Result

Your Flutter app will support:

* English 🇺🇸
* Tamil 🇮🇳
* Hindi 🇮🇳
* Automatic localization generation
* Runtime language switching
* Saved language preference
* Scalable support for additional languages

This approach is the recommended Flutter localization method and works well for production apps such as taxi booking, e-commerce, and delivery applications.
