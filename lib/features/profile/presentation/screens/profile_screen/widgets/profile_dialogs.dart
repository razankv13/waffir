import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/widgets/dialogs/dialog_service.dart';

/// Profile-related dialog helpers using DialogService
///
/// Provides consistent dialog patterns for profile-related actions
/// like sign out, delete account, etc.
class ProfileDialogs {
  /// Shows sign out confirmation dialog
  ///
  /// Uses DialogService with destructive styling since logout is a
  /// significant action that affects user session.
  ///
  /// **Flow:**
  /// 1. Show confirmation dialog
  /// 2. If confirmed, show success snackbar
  /// 3. Navigate to login screen
  ///
  /// **Returns:** `true` if user confirmed, `false` if cancelled, `null` if dismissed
  ///
  /// **Usage:**
  /// ```dart
  /// await ProfileDialogs.showSignOutDialog(context);
  /// ```
  static Future<bool?> showSignOutDialog(BuildContext context) async {
    final result = await DialogService.showConfirmationDialog(
      context: context,
      title: 'Sign Out',
      content: 'Are you sure you want to sign out of your account?',
      confirmText: 'Sign Out',
      cancelText: 'Cancel',
      isDestructive: true, // Red styling for destructive action
    );

    // If user confirmed sign out
    if (result == true && context.mounted) {
      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully signed out'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to login screen
      context.go(AppRoutes.login);
    }

    return result;
  }

  /// Shows account deletion confirmation dialog
  ///
  /// Uses DialogService with destructive styling for permanent action.
  ///
  /// **Returns:** `true` if user confirmed, `false` if cancelled
  ///
  /// **Usage:**
  /// ```dart
  /// final confirmed = await ProfileDialogs.showDeleteAccountDialog(context);
  /// if (confirmed == true) {
  ///   // Proceed with account deletion
  /// }
  /// ```
  static Future<bool?> showDeleteAccountDialog(BuildContext context) async {
    return DialogService.showConfirmationDialog(
      context: context,
      title: 'Delete Account',
      content:
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
      confirmText: 'Delete Account',
      cancelText: 'Cancel',
      isDestructive: true, // Red styling for destructive action
    );
  }

  /// Shows unsaved changes warning dialog
  ///
  /// Used when user tries to navigate away from profile edit screen
  /// with unsaved changes.
  ///
  /// **Returns:** `true` if user wants to discard changes, `false` if cancelled
  ///
  /// **Usage:**
  /// ```dart
  /// final discard = await ProfileDialogs.showUnsavedChangesDialog(context);
  /// if (discard == true) {
  ///   Navigator.pop(context);
  /// }
  /// ```
  static Future<bool?> showUnsavedChangesDialog(BuildContext context) async {
    return DialogService.showWarningDialog(
      context: context,
      title: 'Unsaved Changes',
      content: 'You have unsaved changes. Are you sure you want to discard them?',
      primaryButtonText: 'Discard',
      secondaryButtonText: 'Keep Editing',
    );
  }

  /// Shows profile update success dialog
  ///
  /// **Usage:**
  /// ```dart
  /// await ProfileDialogs.showUpdateSuccessDialog(context);
  /// ```
  static Future<bool?> showUpdateSuccessDialog(BuildContext context) async {
    return DialogService.showSuccessDialog(
      context: context,
      title: 'Profile Updated',
      content: 'Your profile has been updated successfully.',
      primaryButtonText: 'OK',
    );
  }

  /// Shows profile update error dialog
  ///
  /// **Usage:**
  /// ```dart
  /// await ProfileDialogs.showUpdateErrorDialog(
  ///   context,
  ///   error: 'Network connection failed',
  /// );
  /// ```
  static Future<bool?> showUpdateErrorDialog(
    BuildContext context, {
    String? error,
  }) async {
    return DialogService.showErrorDialog(
      context: context,
      title: 'Update Failed',
      content: error ?? 'Failed to update profile. Please try again.',
      primaryButtonText: 'OK',
    );
  }
}
