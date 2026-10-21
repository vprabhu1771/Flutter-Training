The `share_plus` package documentation doesn't include a complete `HomeScreen` example with a specific WhatsApp share button. Instead, it shows a generic share approach that opens the platform's native share dialog, where WhatsApp would appear as one of the apps (if installed).

Here's the pattern from the docs adapted into a `HomeScreen`-style widget:

```dart
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share to WhatsApp')),
      body: Center(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => _shareToWhatsApp(context),
            child: const Text('Share via WhatsApp'),
          ),
        ),
      ),
    );
  }

  Future<void> _shareToWhatsApp(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;

    final result = await SharePlus.instance.share(
      ShareParams(
        text: 'Check out this great app! https://example.com',
        subject: 'Sharing via WhatsApp',
        sharePositionOrigin:
            box!.localToGlobal(Offset.zero) & box.size,
      ),
    );

    if (result.status == ShareResultStatus.success) {
      debugPrint('Shared successfully');
    }
  }
}
```

**Key points for WhatsApp sharing:**

1. **No direct WhatsApp API** — `share_plus` opens the **native share sheet**, not WhatsApp directly. The user must tap WhatsApp in the sheet. This is the intended behavior of the plugin.

2. **Include a URL in the text** — WhatsApp most reliably handles sharing when the text includes a URL (e.g., `https://example.com`). Some users report that plain text alone can be less reliable in WhatsApp on Android.

3. **`sharePositionOrigin` is required on iPad** — the docs emphasize that without it, the popover can crash or hang on iPad. The `Builder` pattern is necessary to get the button's `context`.

4. **Facebook/WhatsApp caveat** — the docs note that Meta apps (Facebook, Messenger) have restrictions that can block image+text sharing. Text-only sharing typically works fine with WhatsApp, but if you need guaranteed behavior, you may need the native WhatsApp SDK.

5. **Better approach for guaranteed WhatsApp** — if you need to target WhatsApp specifically, use the `url_launcher` package with `https://wa.me/<number>?text=<encoded_message>` to open WhatsApp's chat directly, rather than relying on the share sheet.

**Migration note:** If you find older code using `Share.share('text')`, the current API is `SharePlus.instance.share(ShareParams(text: '...'))` — the static `Share.share()` methods are deprecated.
