```dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Prominent disclosure screen shown BEFORE the OS-level camera permission
/// dialog, as required by App Store and Google Play policy.
///
/// Features a clean, toggleable Switch UI for smooth user interaction.
/// Returns `true` via Navigator.pop if the user granted permission, `false` otherwise.
class CameraDisclosureScreen extends StatefulWidget {
  const CameraDisclosureScreen({super.key});

  @override
  State<CameraDisclosureScreen> createState() => _CameraDisclosureScreenState();
}

class _CameraDisclosureScreenState extends State<CameraDisclosureScreen> {
  bool _isCameraEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkCurrentStatus();
  }

  /// Check if permission is already granted when entering the screen
  Future<void> _checkCurrentStatus() async {
    final status = await Permission.camera.status;
    if (status.isGranted || status.isLimited) {
      setState(() {
        _isCameraEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skip / Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Icon
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.photo_camera_rounded,
                      size: 60,
                      color: Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Title
                const Center(
                  child: Text(
                    'Camera Permission',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 24),

                // Feature List Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'We need camera access to let you:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        icon: Icons.qr_code_scanner,
                        text: 'Scan QR codes instantly for rapid setup',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureItem(
                        icon: Icons.account_box,
                        text: 'Take a profile picture or upload dynamic avatars',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureItem(
                        icon: Icons.receipt_long,
                        text: 'Snap photos of documents, receipts, or verifications',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Interactive Switch Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.videocam_outlined, color: Colors.black87),
                          SizedBox(width: 12),
                          Text(
                            'Enable Camera Access',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        value: _isCameraEnabled,
                        activeColor: Colors.blue,
                        onChanged: (value) => _handleTogglePermission(value),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Bottom Primary Action Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, _isCameraEnabled);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Privacy assurance note
                const Center(
                  child: Text(
                    'Your camera feeds are strictly local and are never accessed or stored without your knowledge.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  /// Coordinates requesting access or redirecting denied permissions to system settings
  Future<void> _handleTogglePermission(bool shouldEnable) async {
    // If user attempts to switch off, we let them know it must be handled in OS settings if already authorized
    if (!shouldEnable) {
      _showSettingsDialog('To revoke access, please adjust permissions inside your device system settings.');
      return;
    }

    final status = await Permission.camera.request();

    if (status.isGranted || status.isLimited) {
      setState(() {
        _isCameraEnabled = true;
      });
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        _showSettingsDialog('Camera permission is permanently denied. Please enable it inside your device application settings.');
      }
    } else {
      setState(() {
        _isCameraEnabled = false;
      });
    }
  }

  void _showSettingsDialog(String absoluteMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Permission Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          absoluteMessage,
          style: const TextStyle(fontSize: 15, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
              // Re-check permission status upon returning to app focus
              _checkCurrentStatus();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
```
