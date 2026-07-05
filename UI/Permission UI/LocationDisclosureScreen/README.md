```dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/app_theme.dart';

/// Prominent disclosure screen shown BEFORE the OS-level location permission
/// dialog, as required by Google Play's User Data policy.
///
/// Layout matches the driver app's LocationDisclosureScreen one-to-one (same
/// icon size, padding, spacing, content structure) so the disclosure renders
/// at full size on both apps.
///
/// Returns `true` (via Navigator.pop) if the user granted permission, `false`
/// if they skipped or denied. The caller is responsible for handling either
/// outcome — typically just continuing to the home screen.
class LocationDisclosureScreen extends StatelessWidget {
  const LocationDisclosureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
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
                      color: AppTheme.primaryYellow.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      size: 60,
                      color: AppTheme.primaryYellow,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Title
                const Text(
                  'Allow Location Access',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.black,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Description
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.offWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryYellow.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'We use your location to:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        icon: Icons.search,
                        text: 'Find drivers nearest to your pickup point',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureItem(
                        icon: Icons.share_location,
                        text: 'Share your pickup location with the assigned driver',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureItem(
                        icon: Icons.timeline,
                        text: 'Show your trip route and accurate fare on the map',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureItem(
                        icon: Icons.security,
                        text: 'Help support resolve issues if anything goes wrong',
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryYellow.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppTheme.primaryYellow,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Your location is used only while the app is open and during an active ride.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.black.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Allow button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _handleAllowPermission(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryYellow,
                      foregroundColor: AppTheme.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Allow Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Privacy note
                const Text(
                  'We respect your privacy. Location data is encrypted and never sold to third parties.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
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
            color: AppTheme.primaryYellow,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 14,
            color: AppTheme.black,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textPrimary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleAllowPermission(BuildContext context) async {
    final status = await Permission.location.request();

    if (status.isGranted || status.isLimited) {
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    } else if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _showSettingsDialog(context);
      }
    } else {
      if (context.mounted) {
        Navigator.pop(context, false);
      }
    }
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Permission Required',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Location permission is required to find drivers and book rides. Please enable it in app settings.',
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
              if (context.mounted) {
                Navigator.pop(context, false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryYellow,
              foregroundColor: AppTheme.black,
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
```
