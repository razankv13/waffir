import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:waffir/core/widgets/dialogs/base_dialog.dart';

class DialogService {
  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useBlur = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black54,
      builder: (context) => useBlur
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: child,
            )
          : child,
    );
  }

  static Future<bool?> showSuccessDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    Widget? customContent,
    bool dismissible = true,
    bool showCloseButton = false,
    bool useBlur = true,
  }) {
    return showCustomDialog<bool>(
      context: context,
      barrierDismissible: dismissible,
      useBlur: useBlur,
      child: BaseDialog(
        type: DialogType.success,
        title: title,
        content: content,
        primaryButtonText: primaryButtonText ?? 'OK',
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
        customContent: customContent,
        dismissible: dismissible,
        showCloseButton: showCloseButton,
      ),
    );
  }

  static Future<bool?> showErrorDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    Widget? customContent,
    bool dismissible = true,
    bool showCloseButton = false,
    bool useBlur = true,
  }) {
    return showCustomDialog<bool>(
      context: context,
      barrierDismissible: dismissible,
      useBlur: useBlur,
      child: BaseDialog(
        type: DialogType.error,
        title: title,
        content: content,
        primaryButtonText: primaryButtonText ?? 'OK',
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
        customContent: customContent,
        dismissible: dismissible,
        showCloseButton: showCloseButton,
      ),
    );
  }

  static Future<bool?> showWarningDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    Widget? customContent,
    bool dismissible = true,
    bool showCloseButton = false,
    bool useBlur = true,
  }) {
    return showCustomDialog<bool>(
      context: context,
      barrierDismissible: dismissible,
      useBlur: useBlur,
      child: BaseDialog(
        type: DialogType.warning,
        title: title,
        content: content,
        primaryButtonText: primaryButtonText ?? 'OK',
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
        customContent: customContent,
        dismissible: dismissible,
        showCloseButton: showCloseButton,
      ),
    );
  }

  static Future<bool?> showInfoDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    Widget? customContent,
    bool dismissible = true,
    bool showCloseButton = false,
    bool useBlur = true,
  }) {
    return showCustomDialog<bool>(
      context: context,
      barrierDismissible: dismissible,
      useBlur: useBlur,
      child: BaseDialog(
        type: DialogType.info,
        title: title,
        content: content,
        primaryButtonText: primaryButtonText ?? 'OK',
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
        customContent: customContent,
        dismissible: dismissible,
        showCloseButton: showCloseButton,
      ),
    );
  }

  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Widget? customContent,
    bool dismissible = true,
    bool showCloseButton = false,
    bool useBlur = true,
    bool isDestructive = false,
  }) {
    return showCustomDialog<bool>(
      context: context,
      barrierDismissible: dismissible,
      useBlur: useBlur,
      child: Builder(
        builder: (dialogContext) => BaseDialog(
          type: isDestructive ? DialogType.error : DialogType.confirmation,
          title: title,
          content: content,
          primaryButtonText: confirmText ?? 'Confirm',
          secondaryButtonText: cancelText ?? 'Cancel',
          onPrimaryPressed: () {
            onConfirm?.call();
            Navigator.of(dialogContext).pop(true);
          },
          onSecondaryPressed: () {
            onCancel?.call();
            Navigator.of(dialogContext).pop(false);
          },
          customContent: customContent,
          dismissible: dismissible,
          showCloseButton: showCloseButton,
        ),
      ),
    );
  }

  static Future<String?> showTextInputDialog({
    required BuildContext context,
    required String title,
    required String hintText,
    String? initialValue,
    String? confirmText,
    String? cancelText,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    bool obscureText = false,
    String? Function(String?)? validator,
    bool dismissible = true,
    bool useBlur = true,
  }) {
    final controller = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();

    return showCustomDialog<String>(
      context: context,
      barrierDismissible: dismissible,
      useBlur: useBlur,
      child: BaseDialog(
        type: DialogType.info,
        title: title,
        content: '',
        primaryButtonText: confirmText ?? 'OK',
        secondaryButtonText: cancelText ?? 'Cancel',
        onPrimaryPressed: () {
          if (formKey.currentState?.validate() ?? false) {
            Navigator.of(context).pop(controller.text);
          }
        },
        onSecondaryPressed: () => Navigator.of(context).pop(),
        dismissible: dismissible,
        customContent: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            obscureText: obscureText,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              counterText: maxLength != null ? null : '',
            ),
            autofocus: true,
          ),
        ),
      ),
    );
  }

  static Future<T?> showBottomDialog<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      builder: (context) => child,
    );
  }
}