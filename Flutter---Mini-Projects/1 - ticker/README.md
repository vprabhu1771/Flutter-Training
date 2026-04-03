```dart
  // 🔹 TICKER SECTION
  Container(
    height: 36,
    decoration: BoxDecoration(
      color: Colors.orange.withOpacity(0.15),
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(16),
      ),
    ),
    child: _bazaarTicker(),
  ),
```

```dart
Widget _bazaarTicker() {
    return ClipRect(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: -1.5),
        duration: const Duration(seconds: 12),
        onEnd: () {},
        builder: (context, value, child) {
          return FractionalTranslation(
            translation: Offset(value, 0),
            child: child,
          );
        },
        child: Row(
          children: const [
            SizedBox(width: 16),
            Icon(Icons.flash_on, color: Colors.orange, size: 18),
            SizedBox(width: 8),
            Text(
              "Lowest interest rates • Instant approval • No hidden charges •",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
```