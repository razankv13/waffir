import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/widgets/debug_drawer.dart';

/// Floating debug button that provides access to developer tools
/// Only shown in debug/development builds
class DebugOverlay extends StatefulWidget {
  final Widget child;

  const DebugOverlay({
    super.key,
    required this.child,
  });

  @override
  State<DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<DebugOverlay> {
  bool _showDebugButton = false;
  int _tapCount = 0;
  DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
    // Show debug button by default in debug/development builds
    _showDebugButton = !kReleaseMode || EnvironmentConfig.isDevelopment;
  }

  void _onTap() {
    final now = DateTime.now();

    // Reset tap count if more than 2 seconds have passed
    if (_lastTapTime == null || now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }

    _lastTapTime = now;

    // Show debug button after 5 rapid taps (for release builds)
    if (_tapCount >= 5 && kReleaseMode && !EnvironmentConfig.isProduction) {
      setState(() {
        _showDebugButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main app content - make it tappable for secret debug access
        GestureDetector(
          onTap: _onTap,
          child: widget.child,
        ),

        // Debug button overlay
        if (_showDebugButton)
          Positioned(
            bottom: 100,
            right: 16,
            child: _DebugFloatingButton(
              onPressed: () => _showDebugDrawer(context),
              onDismiss: () => setState(() => _showDebugButton = false),
            ),
          ),
      ],
    );
  }

  void _showDebugDrawer(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Debug Drawer',
      pageBuilder: (context, animation, secondaryAnimation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: Align(
            alignment: Alignment.centerRight,
            child: Material(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: double.infinity,
                child: const DebugDrawer(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DebugFloatingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback onDismiss;

  const _DebugFloatingButton({
    required this.onPressed,
    required this.onDismiss,
  });

  @override
  State<_DebugFloatingButton> createState() => __DebugFloatingButtonState();
}

class __DebugFloatingButtonState extends State<_DebugFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Auto-pulse animation to draw attention
    _startPulseAnimation();
  }

  void _startPulseAnimation() async {
    while (mounted) {
      await _animationController.forward();
      await _animationController.reverse();
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Expanded menu items
        if (_isExpanded) ...[
          _buildMenuItem(
            Icons.bug_report,
            'Debug Tools',
            widget.onPressed,
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            Icons.close,
            'Hide',
            widget.onDismiss,
          ),
          const SizedBox(height: 16),
        ],

        // Main debug button
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                  if (!_isExpanded) {
                    widget.onPressed();
                  }
                },
                backgroundColor: Colors.red.shade400,
                child: Icon(
                  _isExpanded ? Icons.close : Icons.bug_report,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onPressed) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension to easily wrap any widget with debug overlay
extension DebugOverlayExtension on Widget {
  Widget withDebugOverlay() {
    return DebugOverlay(child: this);
  }
}