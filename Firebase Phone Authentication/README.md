`pubspec.yaml`
```
# Firebase
firebase_core: ^3.8.1
firebase_messaging: ^15.1.5
firebase_auth: ^5.3.3
```

`FirebaseAuthService.dart`
```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// ignore_for_file: avoid_print

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  int? _resendToken;

  // Callback for auto-detected OTP code (from Firebase SMS auto-read)
  Function(String)? onCodeAutoDetected;
  String? autoDetectedCode;

  // Send OTP
  Future<Map<String, dynamic>> sendOTP(String phoneNumber) async {
    try {
      // Clear previous auto-detected code
      autoDetectedCode = null;


      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("AUTO VERIFIED");
          // Extract OTP code from credential and notify the UI to auto-fill
          // We do NOT auto-sign-in here to avoid session-expired errors
          final smsCode = credential.smsCode;
          if (smsCode != null && smsCode.isNotEmpty) {
            debugPrint('Firebase auto-detected OTP code: $smsCode');
            autoDetectedCode = smsCode;
            onCodeAutoDetected?.call(smsCode);
          }

          // CRITICAL: Disable auto-verification for Play Store builds
          // Auto-verification causes session-expired errors in production
          print('Auto-verification disabled - user must enter OTP manually');
          // DO NOT call signInWithCredential here - forces manual OTP entry
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          print('OTP sent successfully. Verification ID: $verificationId');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          print('Auto-retrieval timeout. Verification ID: $verificationId');
        },
        forceResendingToken: _resendToken,
      );

      // Wait longer for codeSent callback to execute (increased for Play Store builds)
      await Future.delayed(const Duration(milliseconds: 1000));

      return {
        'success': true,
        'message': 'OTP sent successfully',
      };
    } catch (e) {
      print('Send OTP error: $e');
      return {
        'success': false,
        'message': 'Failed to send OTP: ${e.toString()}',
      };
    }
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOTP(String otp) async {
    try {
      if (_verificationId == null) {
        return {
          'success': false,
          'message': 'Please request OTP first',
        };
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      // Sign in with credential — retry on transient FCM / Play-Services errors.
      // Firebase Phone Auth's signInWithCredential internally depends on FCM
      // for device verification. A flaky network or a slow Play Services
      // cold-start often surfaces as [firebase_messaging/unknown]
      // SERVICE_NOT_AVAILABLE, which usually clears in a few seconds.
      await _signInWithRetry(credential);

      // Wait a moment for auth state to settle
      await Future.delayed(const Duration(milliseconds: 300));

      // Get current user after sign in
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        return {
          'success': false,
          'message': 'Authentication failed. Please try again.',
        };
      }

      // Get Firebase token using getIdToken(true) to force refresh
      // Multiple retry attempts with progressive delays for Play Store builds
      String? firebaseToken;

      // Try immediate token fetch first (works for most users)
      try {
        firebaseToken = await currentUser.getIdToken(true);
        print('Firebase token obtained successfully (immediate)');
      } catch (e) {
        print('Error getting ID token (immediate attempt): $e');

        // Retry 1: Short delay
        await Future.delayed(const Duration(milliseconds: 1500));
        try {
          firebaseToken = await currentUser.getIdToken(true);
          print('Firebase token obtained on retry 1');
        } catch (e1) {
          print('Error getting ID token (attempt 1): $e1');

          // Retry 2: Medium delay
          await Future.delayed(const Duration(milliseconds: 2500));
          try {
            firebaseToken = await currentUser.getIdToken(true);
            print('Firebase token obtained on retry 2');
          } catch (e2) {
            print('Error getting ID token (attempt 2): $e2');

            // Retry 3: Longer delay
            await Future.delayed(const Duration(milliseconds: 4000));
            try {
              firebaseToken = await currentUser.getIdToken(true);
              print('Firebase token obtained on retry 3');
            } catch (e3) {
              print('Error getting ID token (attempt 3): $e3');

              // Retry 4: Maximum delay
              await Future.delayed(const Duration(milliseconds: 6000));
              try {
                firebaseToken = await currentUser.getIdToken(true);
                print('Firebase token obtained on retry 4');
              } catch (e4) {
                print('Error getting ID token (attempt 4): $e4');

                // Final retry: Extra long delay
                await Future.delayed(const Duration(milliseconds: 8000));
                try {
                  firebaseToken = await currentUser.getIdToken(true);
                  print('Firebase token obtained on final retry 5');
                } catch (e5) {
                  print('Error getting ID token (final attempt): $e5');
                  return {
                    'success': false,
                    'message':
                        'Failed to get authentication token. Please try again.',
                  };
                }
              }
            }
          }
        }
      }

      if (firebaseToken == null || firebaseToken.isEmpty) {
        return {
          'success': false,
          'message': 'Failed to get authentication token. Please try again.',
        };
      }

      return {
        'success': true,
        'firebaseToken': firebaseToken,
        'phoneNumber': currentUser.phoneNumber,
        'uid': currentUser.uid,
      };
    } on FirebaseAuthException catch (e) {
      String message = 'Invalid OTP';

      if (e.code == 'invalid-verification-code') {
        message = 'Invalid OTP code. Please try again.';
      } else if (e.code == 'session-expired') {
        message = 'OTP expired. Please request a new one.';
      } else if (e.code == 'invalid-phone-number') {
        message = 'Invalid phone number format.';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many attempts. Please try again later.';
      }

      print('Firebase Auth error: ${e.code} - ${e.message}');

      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      print('Verify OTP error: $e');
      return {
        'success': false,
        'message': _friendlyOtpError(e),
      };
    }
  }

  // Retry signInWithCredential up to 3 times when the failure looks like a
  // transient Firebase Messaging / Play Services hiccup (the classic
  // SERVICE_NOT_AVAILABLE error). Other failures bubble up immediately so
  // the caller's existing handlers (FirebaseAuthException etc.) still fire.
  Future<void> _signInWithRetry(PhoneAuthCredential credential) async {
    const delays = [
      Duration(seconds: 2),
      Duration(seconds: 4),
    ];
    for (var attempt = 0; attempt <= delays.length; attempt++) {
      try {
        await _auth.signInWithCredential(credential);
        return;
      } catch (e) {
        final isTransient = _isTransientFcmError(e);
        print(
            'signInWithCredential attempt ${attempt + 1} failed '
            '(transient=$isTransient): $e');
        if (!isTransient || attempt == delays.length) rethrow;
        await Future.delayed(delays[attempt]);
      }
    }
  }

  bool _isTransientFcmError(Object e) {
    final s = e.toString().toLowerCase();
    return s.contains('service_not_available') ||
        s.contains('firebase_messaging') ||
        s.contains('java.io.ioexception');
  }

  String _friendlyOtpError(Object e) {
    if (_isTransientFcmError(e)) {
      return 'Verification temporarily unavailable. '
          'Please check your internet, update Google Play Services from the Play Store, '
          'and try again.';
    }
    return 'Failed to verify OTP. Please try again.';
  }

  // Resend OTP
  Future<Map<String, dynamic>> resendOTP(String phoneNumber) async {
    return await sendOTP(phoneNumber);
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    _verificationId = null;
    _resendToken = null;
  }

  // Check if user is signed in
  bool isSignedIn() {
    return _auth.currentUser != null;
  }
}
```
