import 'package:flutter/material.dart';
import 'idle_manager.dart';

/// A widget that detects when the user becomes idle or active.
///
/// Listens to pointer events anywhere in its [child] subtree. If no
/// interaction occurs within [timeout], [onIdle] is called. The next
/// interaction after an idle period triggers [onActive].
///
/// Example:
/// ```dart
/// IdleDetector(
///   timeout: const Duration(seconds: 10),
///   onIdle: () => print('idle'),
///   onActive: () => print('active'),
///   child: const MyHomePage(),
/// )
/// ```
class IdleDetector extends StatefulWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// How long the user must be inactive before [onIdle] is fired.
  final Duration timeout;

  /// Called once when the user has been idle for [timeout].
  final VoidCallback onIdle;

  /// Called when the user interacts again after an idle period.
  ///
  /// Optional — if null, no callback fires on resumed activity.
  final VoidCallback? onActive;

  /// Creates an [IdleDetector].
  ///
  /// [child], [timeout], and [onIdle] are required.
  const IdleDetector({
    super.key,
    required this.child,
    required this.timeout,
    required this.onIdle,
    this.onActive,
  });

  @override
  State<IdleDetector> createState() => _IdleDetectorState();
}

class _IdleDetectorState extends State<IdleDetector> {
  late IdleManager _idleManager;

  @override
  void initState() {
    super.initState();
    _idleManager = IdleManager(
      timeout: widget.timeout,
      onIdle: widget.onIdle,
      onActive: widget.onActive,
    );
    _idleManager.start();
  }

  // recreate manager if parent passes new timeout/callbacks.
  // Without this, hot-reload and dynamic config changes are silently ignored.
  @override
  void didUpdateWidget(IdleDetector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.timeout != widget.timeout ||
        oldWidget.onIdle != widget.onIdle ||
        oldWidget.onActive != widget.onActive) {
      _idleManager.dispose();
      _idleManager = IdleManager(
        timeout: widget.timeout,
        onIdle: widget.onIdle,
        onActive: widget.onActive,
      );
      _idleManager.start();
    }
  }

  // [dynamic _] instead of [_] — resolves the pub.dev INFO lint.
  void _onUserInteraction([dynamic _]) {
    _idleManager.userInteracted();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onUserInteraction,
      onPointerMove: _onUserInteraction,
      onPointerSignal: _onUserInteraction,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _idleManager.dispose();
    super.dispose();
  }
}
