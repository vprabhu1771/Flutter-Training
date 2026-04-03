import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_laravel_kalai_selvan/utils/Constants.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../HomePage.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String mobile_no;

  const OTPVerificationScreen({super.key, required this.mobile_no});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  int _secondsRemaining = 30;
  bool showResend = false;
  late Timer _timer;

  final List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());

  bool isOTPComplete() {
    // Returns true if all OTP boxes are filled
    return otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _secondsRemaining = 30;
    showResend = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        setState(() => showResend = true);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// OTP box with auto-next and auto-backspace
  Widget otpBox(int index) {
    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        controller: otpControllers[index],
        autofocus: index == 0,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          setState(() {}); // Update the Verify button visibility

          if (value.isNotEmpty) {
            if (index < otpControllers.length - 1) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          } else {
            if (index > 0) {
              FocusScope.of(context).previousFocus();
              otpControllers[index - 1].text = "";
            }
          }
        },
      ),
    );
  }

  void verifyOTP() async {
    String otp = otpControllers.map((e) => e.text).join();

    String mobile_no = widget.mobile_no;

    final url = Constants.BASE_URL + Constants.VERIFY_OTP_ROUTE;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "mobile_no": mobile_no,
          "otp": otp,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Success: ${data['message']}")),
        );

        print("Response: $data");

        /// Example: Navigate after success
        // Navigator.pushReplacementNamed(context, '/home');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );

      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${error['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network Error: $e")),
      );
    }

    // You can now send this OTP to your backend for verification
    // print("OTP entered: $otp");
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("OTP Verified: $otp")),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Bottom gradient
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color(0xfff97316)],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Verification Code",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Please enter the verification code sent\nto ${widget.mobile_no}",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (i) => otpBox(i)),
                  ),
                  const SizedBox(height: 20),

                  /// Countdown or resend
                  Center(
                    child: Text(
                      showResend
                          ? "Didn't receive OTP?"
                          : "Resend in 00:${_secondsRemaining.toString().padLeft(2, '0')}",
                      style: TextStyle(
                        fontSize: 16,
                        color: showResend ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Verify OTP Button
                  if (isOTPComplete())
                    Center(
                      child: ElevatedButton(
                        onPressed: verifyOTP,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Verify OTP",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  /// Resend section
                  if (showResend) ...[
                    const SizedBox(height: 30),
                    Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.grey)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "Resend OTP via",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => startTimer(),
                            child: const Text(
                              "SMS/Email",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () => startTimer(),
                            child: const Text(
                              "Whatsapp",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Spacer(),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        "Logo",
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.9)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
