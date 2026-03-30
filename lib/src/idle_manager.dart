import 'dart:async';
import 'package:flutter/foundation.dart';

class IdleManager {
  final Duration timeout;
  final VoidCallback onIdle;
  final VoidCallback? onActive;

  Timer? _timer;
  bool _isIdle = false;

  IdleManager({required this.timeout, required this.onIdle, this.onActive});

  void start() {
    _resetTimer();
  }

  void userInteracted() {
    if (_isIdle) {
      _isIdle = false;
      onActive?.call();
    }
    _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(timeout, () {
      _isIdle = true;
      onIdle();
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
