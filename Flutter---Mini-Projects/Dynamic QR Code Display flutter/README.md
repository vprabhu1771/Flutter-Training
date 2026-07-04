# Install Dependencies

Add the modern and highly customizable `pretty_qr_code` package to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  pretty_qr_code: ^3.0.0 # Check pub.dev for the latest version
```

# Implement Dynamic QR Code Implementation

```dart
import 'package:flutter/material.dart';

import 'package:pretty_qr_code/pretty_qr_code.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DynamicQRScreen()
    );
  }
}


class DynamicQRScreen extends StatefulWidget {
  const DynamicQRScreen({super.key});

  @override
  State<DynamicQRScreen> createState() => _DynamicQRScreenState();
}

class _DynamicQRScreenState extends State<DynamicQRScreen> {
  final TextEditingController _textController =
  TextEditingController(text: "https://google.com");

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qrData = _textController.text.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic QR Generator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: PrettyQrView.data(
                key: ValueKey(qrData),
                data: qrData.isEmpty ? "Empty" : qrData,
                decoration: const PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(),
                ),
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Text or URL",
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
```