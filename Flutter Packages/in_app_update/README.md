```
class InAppUpdateService {

  /// Simple force update check - only performs immediate (blocking) updates
  /// Returns true if no update needed or update succeeded, false if update failed
  static Future<bool> performForceUpdateOnly(BuildContext context) async {
    // Android only, release builds only
    if (!Platform.isAndroid || !kReleaseMode) return true;

    // Prevent multiple concurrent checks
    if (_inProgress) return true;
    _inProgress = true;

    try {
      // Check if update is available
      final AppUpdateInfo info = await InAppUpdate.checkForUpdate();

      // If no update available, continue
      if (info.updateAvailability != UpdateAvailability.updateAvailable) {
        return true;
      }

      // Only proceed if immediate update is allowed
      if (!info.immediateUpdateAllowed) {
        debugPrint('InAppUpdate: Immediate update not allowed');
        return true;
      }

      // Perform the force update (blocking)
      final AppUpdateResult result = await InAppUpdate.performImmediateUpdate();
      return result == AppUpdateResult.success;

    } catch (e) {
      debugPrint('InAppUpdate: Force update failed - $e');
      return true; // Continue app usage on error
    } finally {
      _inProgress = false;
    }
  }

}
