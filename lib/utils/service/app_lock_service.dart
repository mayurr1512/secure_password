import 'dart:async';
import 'package:flutter/material.dart';
import 'package:password_manager/ui/screens/auth_screen.dart';

class AppLockService with WidgetsBindingObserver {
  static final AppLockService _instance = AppLockService._internal();
  factory AppLockService() => _instance;
  AppLockService._internal();

  bool _isLocked = false;
  Timer? _inactivityTimer;
  static const Duration timeout = Duration(minutes: 2);
  late GlobalKey<NavigatorState> navigatorKey;

  void start(GlobalKey<NavigatorState> key) {
    navigatorKey = key;
    WidgetsBinding.instance.addObserver(this);
    _resetTimer();
  }

  void stop() {
    _inactivityTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  void _resetTimer() {
    _isLocked = false;
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(timeout, _lockApp);
  }

  void _lockApp() {
    if (_isLocked) return;
    _isLocked = true;

    final currentContext = navigatorKey.currentContext;
    if (currentContext != null) {
      Navigator.of(currentContext).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
            (route) => false,
      );
    }
  }

  void userInteractionDetected() {
    _resetTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _inactivityTimer?.cancel();
      _lockApp();
    } else if (state == AppLifecycleState.resumed) {
      _resetTimer();
    }
  }
}
