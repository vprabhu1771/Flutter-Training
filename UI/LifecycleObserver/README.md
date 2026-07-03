import 'package:flutter/material.dart';

class LifecycleObserver extends StatefulWidget {
  @override
  _LifecycleObserverState createState() => _LifecycleObserverState();
}

class _LifecycleObserverState extends State<LifecycleObserver> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        // App is minimized or in the background
        print('App minimized!');
        break;
      case AppLifecycleState.resumed:
        // App is restored and visible
        print('App restored!');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
