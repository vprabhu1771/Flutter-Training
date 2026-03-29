# ✅ If You Want Simple Quick Fix

If you are currently pushing screens and just want to remove back button:

Inside each Scaffold:

```dart
appBar: AppBar(
  automaticallyImplyLeading: false,
  title: const Text("Profile"),
),
```

That hides the back arrow.

BUT ⚠️
User can still go back using Android system back button.

# ✅ OPTIONAL (Control Back Behavior Manually)

If you want to prevent exit on HomePage:

Wrap Scaffold with `WillPopScope`:

```dart
return WillPopScope(
  onWillPop: () async {
    return false; // disables Android back
  },
  child: Scaffold(
    body: _buildBody(),
    ...
  ),
);
```

From Flutter 3.13+, **`WillPopScope` is deprecated**.
Now we must use **`PopScope`**.

Here is the correct way to prevent Android back button in your `HomePage`.

---

# ✅ 1️⃣ Completely Disable Back Button (Root Screen)

If `HomePage` is root and you want to block back:

```dart
return PopScope(
  canPop: false, // 🔥 prevents system back
  onPopInvoked: (didPop) {
    // This will not pop because canPop is false
  },
  child: Scaffold(
    body: _buildBody(),
    bottomNavigationBar: ...
  ),
);
```

That’s it.
Now Android back won’t work.

---

# ✅ 2️⃣ Double Tap Back To Exit (Recommended UX)

Better UX like many apps:

```dart
DateTime? lastBackPressed;

return PopScope(
  canPop: false,
  onPopInvoked: (didPop) {
    final now = DateTime.now();

    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
      lastBackPressed = now;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Press back again to exit"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      Navigator.of(context).pop(); // exit app
    }
  },
  child: Scaffold(
    body: _buildBody(),
    bottomNavigationBar: ...
  ),
);
```
