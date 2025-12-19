import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/profile/profile_card.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/auth/presentation/controllers/auth_controller.dart';
import 'package:waffir/features/profile/presentation/controllers/profile_controller.dart';

/// Delete Account Screen
///
/// Allows users to permanently delete their account with confirmation steps.
/// Refactored to HookConsumerWidget and integrated with ProfileController
/// for actual account deletion via Supabase backend.
class DeleteAccountScreen extends HookConsumerWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final responsive = ResponsiveHelper(context);

    // Local state using hooks
    final confirmationChecked = useState(false);
    final isLoading = useState(false);

    Future<void> deleteAccount() async {
      if (!confirmationChecked.value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please confirm that you understand the consequences'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Show final confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Delete Account?'),
          content: const Text(
            'Are you absolutely sure? This action cannot be undone and all your data will be permanently deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      isLoading.value = true;

      // Call profile controller to request account deletion
      final failure = await ref.read(profileControllerProvider.notifier).requestAccountDeletion();

      if (!context.mounted) return;

      if (failure == null) {
        // Sign out the user after successful deletion
        await ref.read(authControllerProvider.notifier).signOut();

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate to login screen after deletion
        context.go('/login');
      } else {
        isLoading.value = false;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message ?? 'Failed to delete account'),
            backgroundColor: colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background shape
          Positioned(
            top: responsive.scale(-85),
            left: responsive.scale(-40),
            child: Container(
              width: responsive.scale(468),
              height: responsive.scale(395),
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(responsive.scale(200)),
              ),
            ),
          ),

          // Main content
          Column(
            children: [
              // App bar
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: responsive.scalePadding(const EdgeInsets.all(16)),
                  child: Row(
                    children: [
                      WaffirBackButton(size: responsive.scale(44)),
                      SizedBox(width: responsive.scale(16)),
                      Text(
                        'Delete Account',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: responsive.scaleFontSize(22, minSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Warning content
              Expanded(
                child: SingleChildScrollView(
                  padding: responsive.scalePadding(const EdgeInsets.all(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Warning icon
                      Center(
                        child: Container(
                          width: responsive.scale(80),
                          height: responsive.scale(80),
                          decoration: BoxDecoration(
                            color: colorScheme.error.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            size: responsive.scale(48),
                            color: colorScheme.error,
                          ),
                        ),
                      ),

                      SizedBox(height: responsive.scale(24)),

                      // Warning title
                      Text(
                        'Are you sure you want to delete your account?',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: responsive.scaleFontSize(22, minSize: 18),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: responsive.scale(16)),

                      // Warning description
                      Text(
                        'This action is permanent and cannot be undone. All your data will be permanently deleted.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: responsive.scaleFontSize(14, minSize: 12),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: responsive.scale(32)),

                      // What will be deleted section
                      ProfileCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'What will be deleted:',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: responsive.scaleFontSize(14, minSize: 12),
                              ),
                            ),
                            SizedBox(height: responsive.scale(16)),
                            const _DeletedItem(
                              icon: Icons.person_outline,
                              title: 'Personal Information',
                              subtitle: 'Name, email, phone, and profile data',
                            ),
                            SizedBox(height: responsive.scale(12)),
                            const _DeletedItem(
                              icon: Icons.favorite_outline,
                              title: 'Saved Deals',
                              subtitle: 'All your bookmarked deals',
                            ),
                            SizedBox(height: responsive.scale(12)),
                            const _DeletedItem(
                              icon: Icons.credit_card_outlined,
                              title: 'Credit Cards',
                              subtitle: 'Saved credit card preferences',
                            ),
                            SizedBox(height: responsive.scale(12)),
                            const _DeletedItem(
                              icon: Icons.history,
                              title: 'Activity History',
                              subtitle: 'All your browsing and interaction history',
                            ),
                            SizedBox(height: responsive.scale(12)),
                            const _DeletedItem(
                              icon: Icons.settings_outlined,
                              title: 'Preferences',
                              subtitle: 'App settings and notification preferences',
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: responsive.scale(24)),

                      // Confirmation checkbox
                      InkWell(
                        onTap: () {
                          confirmationChecked.value = !confirmationChecked.value;
                        },
                        borderRadius: BorderRadius.circular(responsive.scale(8)),
                        child: Padding(
                          padding: responsive.scalePadding(
                            const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: confirmationChecked.value,
                                onChanged: (value) {
                                  confirmationChecked.value = value ?? false;
                                },
                                activeColor: colorScheme.error,
                              ),
                              SizedBox(width: responsive.scale(8)),
                              Expanded(
                                child: Text(
                                  'I understand that this action cannot be undone and all my data will be permanently deleted.',
                                  style: textTheme.bodySmall?.copyWith(
                                    fontSize: responsive.scaleFontSize(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: responsive.scale(32)),
                    ],
                  ),
                ),
              ),

              // Action buttons
              SafeArea(
                top: false,
                child: Padding(
                  padding: responsive.scalePadding(const EdgeInsets.all(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton(
                        onPressed: isLoading.value ? null : deleteAccount,
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          minimumSize: Size.fromHeight(responsive.scale(48)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(responsive.scale(24)),
                          ),
                        ),
                        child: isLoading.value
                            ? SizedBox(
                                width: responsive.scale(20),
                                height: responsive.scale(20),
                                child: CircularProgressIndicator(
                                  strokeWidth: responsive.scaleWithMin(2, min: 1.5),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    colorScheme.onError,
                                  ),
                                ),
                              )
                            : Text(
                                'Delete Account',
                                style: textTheme.labelLarge?.copyWith(
                                  fontSize: responsive.scaleFontSize(14, minSize: 12),
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onError,
                                ),
                              ),
                      ),
                      SizedBox(height: responsive.scale(12)),
                      OutlinedButton(
                        onPressed: isLoading.value ? null : () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size.fromHeight(responsive.scale(48)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(responsive.scale(24)),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: textTheme.labelLarge?.copyWith(
                            fontSize: responsive.scaleFontSize(14, minSize: 12),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A single item showing what will be deleted.
class _DeletedItem extends StatelessWidget {
  const _DeletedItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final responsive = ResponsiveHelper(context);

    return Row(
      children: [
        Icon(
          icon,
          size: responsive.scale(24),
          color: colorScheme.error,
        ),
        SizedBox(width: responsive.scale(16)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: responsive.scaleFontSize(14, minSize: 12),
                ),
              ),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: responsive.scaleFontSize(12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
