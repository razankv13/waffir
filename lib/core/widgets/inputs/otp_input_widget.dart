import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// OTP input widget with 5 circular fields
///
/// Features:
/// - 5 circular input fields
/// - Dot indicators for filled digits
/// - Auto-focus to next field
/// - Backspace support
/// - Configurable styling
///
/// Example usage:
/// ```dart
/// OtpInputWidget(
///   length: 5,
///   onCompleted: (code) => _verifyOtp(code),
///   onChanged: (code) => print(code),
/// )
/// ```
class OtpInputWidget extends StatefulWidget {
  const OtpInputWidget({
    super.key,
    this.length = 5,
    this.onCompleted,
    this.onChanged,
    this.circleSize = 51.0,
    this.spacing = 12.0,
  });

  final int length;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final double circleSize;
  final double spacing;

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _otpCode = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (index) => FocusNode(),
    );

    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNodes.isNotEmpty) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      // Move to next field if not last
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field - unfocus
        _focusNodes[index].unfocus();
      }
    }

    // Build OTP code
    _otpCode = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(_otpCode);

    // Check if completed
    if (_otpCode.length == widget.length) {
      widget.onCompleted?.call(_otpCode);
    }
  }

  void _onBackspace(int index) {
    if (index > 0 && _controllers[index].text.isEmpty) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        final controller = _controllers[index];
        final focusNode = _focusNodes[index];
        final hasFocus = focusNode.hasFocus;
        final hasValue = controller.text.isNotEmpty;

        return _OtpCircle(
          controller: controller,
          focusNode: focusNode,
          size: widget.circleSize,
          onChanged: (value) => _onChanged(index, value),
          onBackspace: () => _onBackspace(index),
          hasFocus: hasFocus,
          hasValue: hasValue,
          colorScheme: colorScheme,
        );
      }),
    );
  }
}

class _OtpCircle extends StatelessWidget {
  const _OtpCircle({
    required this.controller,
    required this.focusNode,
    required this.size,
    required this.onChanged,
    required this.onBackspace,
    required this.hasFocus,
    required this.hasValue,
    required this.colorScheme,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final double size;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;
  final bool hasFocus;
  final bool hasValue;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: hasFocus
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.3),
          width: hasFocus ? 2 : 1,
        ),
        color: Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dot indicator when filled
          if (hasValue)
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary,
              ),
            ),

          // Hidden text field
          TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(
              fontSize: 0, // Hidden but functional
              color: Colors.transparent,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.zero,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              if (value.length == 1) {
                onChanged(value);
              }
            },
            onTap: () {
              // Clear on tap to allow re-entry
              controller.clear();
            },
            onEditingComplete: () {
              // Handle backspace through raw keyboard events
            },
          ),
        ],
      ),
    );
  }
}
