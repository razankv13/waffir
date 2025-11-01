import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/constants/app_typography.dart';

/// OTP (One-Time Password) input widget with circular indicators
///
/// Displays 5-digit verification code input with dots indicating filled digits.
/// Matches Waffir design system from Figma.
///
/// Example:
/// ```dart
/// OTPInput(
///   length: 5,
///   onCompleted: (code) => verifyOTP(code),
///   onChanged: (code) => setState(() => _code = code),
/// )
/// ```
class OTPInput extends StatefulWidget {
  const OTPInput({
    super.key,
    this.length = 5,
    required this.onCompleted,
    this.onChanged,
    this.autoFocus = true,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool autoFocus;

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _code = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (_) => FocusNode(),
    );

    // Auto-focus first field
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _focusNodes[0].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field - complete
        _focusNodes[index].unfocus();
      }
    }

    // Update code
    _code = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(_code);

    // Check if completed
    if (_code.length == widget.length) {
      widget.onCompleted(_code);
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          // Move to previous field
          _focusNodes[index - 1].requestFocus();
          _controllers[index - 1].clear();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // OTP input fields (hidden)
        SizedBox(
          height: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.length,
              (index) => SizedBox(
                width: 0,
                child: KeyboardListener(
                  focusNode: FocusNode(),
                  onKeyEvent: (event) => _onKeyEvent(index, event),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) => _onChanged(index, value),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 17),

        // Visual indicators (circles with dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.length,
            (index) {
              final hasValue = index < _code.length;
              return Padding(
                padding: EdgeInsets.only(
                  right: index < widget.length - 1 ? 27.0 : 0,
                ),
                child: _buildIndicator(index, hasValue),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(int index, bool hasValue) {
    final isFocused = _focusNodes[index].hasFocus;

    return GestureDetector(
      onTap: () => _focusNodes[index].requestFocus(),
      child: Container(
        width: 51,
        height: 51,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isFocused
                ? Theme.of(context).colorScheme.primary
                : AppColors.gray02,
            width: isFocused ? 2 : 1,
          ),
          color: Colors.transparent,
        ),
        child: Center(
          child: hasValue
              ? Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textSecondary,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

/// Helper method to show OTP input dialog
Future<String?> showOTPInputDialog(
  BuildContext context, {
  required String title,
  required String description,
  int length = 5,
}) async {
  String? code;

  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: AppTypography.headlineSmall,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          OTPInput(
            length: length,
            onCompleted: (value) {
              code = value;
              Navigator.of(context).pop(value);
            },
          ),
        ],
      ),
    ),
  );

  return code;
}
