import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:waffir/core/widgets/snackbars/custom_snackbar.dart';

class SnackBarService {
  factory SnackBarService() => _instance;
  SnackBarService._internal();
  static final SnackBarService _instance = SnackBarService._internal();

  static SnackBarService get instance => _instance;

  final Queue<SnackBarItem> _queue = Queue<SnackBarItem>();
  OverlayEntry? _currentOverlay;
  Timer? _currentTimer;
  bool _isShowing = false;
  BuildContext? _context;

  void initialize(BuildContext context) {
    _context = context;
  }

  void showSuccess({
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    bool showCloseButton = true,
    bool priority = false,
  }) {
    _enqueueSnackBar(
      type: SnackBarType.success,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
      showCloseButton: showCloseButton,
      priority: priority,
    );
  }

  void showError({
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 6),
    bool showCloseButton = true,
    bool priority = true,
  }) {
    _enqueueSnackBar(
      type: SnackBarType.error,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
      showCloseButton: showCloseButton,
      priority: priority,
    );
  }

  void showWarning({
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 5),
    bool showCloseButton = true,
    bool priority = false,
  }) {
    _enqueueSnackBar(
      type: SnackBarType.warning,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
      showCloseButton: showCloseButton,
      priority: priority,
    );
  }

  void showInfo({
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    bool showCloseButton = false,
    bool priority = false,
  }) {
    _enqueueSnackBar(
      type: SnackBarType.info,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
      showCloseButton: showCloseButton,
      priority: priority,
    );
  }

  void _enqueueSnackBar({
    required SnackBarType type,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    required Duration duration,
    bool showCloseButton = false,
    bool priority = false,
  }) {
    if (_context == null) return;

    final snackBarItem = SnackBarItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      snackBar: CustomSnackBar(
        type: type,
        message: message,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        duration: duration,
        showCloseButton: showCloseButton,
        onDismissed: _hideCurrentSnackBar,
      ),
      duration: duration,
    );

    if (priority) {
      // Add to front of queue for priority items
      _queue.addFirst(snackBarItem);
      // If currently showing, hide it to show priority item
      if (_isShowing) {
        _hideCurrentSnackBar();
      }
    } else {
      _queue.add(snackBarItem);
    }

    _processQueue();
  }

  void _processQueue() {
    if (_isShowing || _queue.isEmpty || _context == null) return;

    final item = _queue.removeFirst();
    _showSnackBar(item);
  }

  void _showSnackBar(SnackBarItem item) {
    if (_context == null) return;

    _isShowing = true;

    _currentOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 0,
        right: 0,
        child: item.snackBar,
      ),
    );

    Overlay.of(_context!).insert(_currentOverlay!);

    // Auto-hide timer
    _currentTimer = Timer(item.duration, () {
      _hideCurrentSnackBar();
    });
  }

  void _hideCurrentSnackBar() {
    if (!_isShowing) return;

    _currentTimer?.cancel();
    _currentTimer = null;

    _currentOverlay?.remove();
    _currentOverlay = null;
    _isShowing = false;

    // Process next item in queue
    Future.delayed(const Duration(milliseconds: 300), () {
      _processQueue();
    });
  }

  void hideAll() {
    _queue.clear();
    _hideCurrentSnackBar();
  }

  void hideById(String id) {
    _queue.removeWhere((item) => item.id == id);
  }

  bool get isShowing => _isShowing;
  int get queueLength => _queue.length;

  void dispose() {
    _currentTimer?.cancel();
    _currentOverlay?.remove();
    _queue.clear();
    _isShowing = false;
    _context = null;
  }
}

// Extension for easier usage
extension SnackBarExtension on BuildContext {
  SnackBarService get snackBar {
    SnackBarService.instance.initialize(this);
    return SnackBarService.instance;
  }

  void showSuccessSnackBar({
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    bool showCloseButton = true,
    bool priority = false,
  }) {
    snackBar.showSuccess(
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
      showCloseButton: showCloseButton,
      priority: priority,
    );
  }

  void showErrorSnackBar({
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 6),
    bool showCloseButton = true,
    bool priority = true,
  }) {
    snackBar.showError(
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
      showCloseButton: showCloseButton,
      priority: priority,
    );
  }

  void showWarningSnackBar({
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 5),
    bool showCloseButton = true,
    bool priority = false,
  }) {
    snackBar.showWarning(
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
      showCloseButton: showCloseButton,
      priority: priority,
    );
  }

  void showInfoSnackBar({
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    bool showCloseButton = false,
    bool priority = false,
  }) {
    snackBar.showInfo(
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
      showCloseButton: showCloseButton,
      priority: priority,
    );
  }
}