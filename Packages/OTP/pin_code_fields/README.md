```
https://pub.dev/packages/pin_code_fields
```

`main.dart`
```dart
import 'package:flutter/material.dart';
import './OTPVerificationScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const OTPVerificationScreen(),
    );
  }
}
```

`OTPVerificationScreen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _pinController = PinInputController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: MaterialPinField(
                  length: 6,
                  pinController: _pinController,
                  enableAutofill: true,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  theme: MaterialPinTheme(
                    shape: MaterialPinShape.outlined,
                    cellSize: const Size(48, 56),
                    spacing: 8,
                    borderRadius: BorderRadius.circular(12),
                    borderWidth: 1,
                    focusedBorderWidth: 2,
                    borderColor: Colors.grey[300]!,
                    focusedBorderColor: Colors.amber,
                    errorColor: Colors.red,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  onCompleted: (pin) => print('PIN: $pin'),
                  // onCompleted: (_) => _verifyOTP(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
