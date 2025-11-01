import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/switches/custom_toggle_switch.dart';
import 'package:waffir/core/widgets/profile/profile_card.dart';
import 'package:waffir/core/mock/mock_notification_settings.dart';

/// Notification Settings Screen
///
/// Allows users to configure their notification preferences including
/// push notifications, email notifications, and specific content categories.
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  late MockNotificationSettings _settings;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _settings = defaultMockNotificationSettings;
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification settings saved successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background shape
          Positioned(
            top: -100,
            left: -40,
            child: Container(
              width: 468,
              height: 461,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(200),
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
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: colorScheme.onSurface,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.surface,
                          elevation: 2,
                          shadowColor: Colors.black.withValues(alpha: 0.1),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Notifications',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Settings list
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Master switches section
                      ProfileCard(
                        child: Column(
                          children: [
                            _buildToggleItem(
                              title: 'Push Notifications',
                              subtitle: 'Receive notifications on your device',
                              value: _settings.pushNotificationsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _settings = _settings.copyWith(pushNotificationsEnabled: value);
                                });
                              },
                            ),
                            const ProfileDivider(),
                            _buildToggleItem(
                              title: 'Email Notifications',
                              subtitle: 'Receive notifications via email',
                              value: _settings.emailNotificationsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _settings = _settings.copyWith(emailNotificationsEnabled: value);
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Content preferences section
                      ProfileSectionHeader(title: 'Content Preferences'),
                      const SizedBox(height: 8),

                      ProfileCard(
                        child: Column(
                          children: [
                            _buildToggleItem(
                              title: 'New Deals',
                              subtitle: 'Get notified when new deals are available',
                              value: _settings.newDealsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _settings = _settings.copyWith(newDealsEnabled: value);
                                });
                              },
                            ),
                            const ProfileDivider(),
                            _buildToggleItem(
                              title: 'New Stores',
                              subtitle: 'Be first to know when new stores join',
                              value: _settings.newStoresEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _settings = _settings.copyWith(newStoresEnabled: value);
                                });
                              },
                            ),
                            const ProfileDivider(),
                            _buildToggleItem(
                              title: 'Favorite Stores',
                              subtitle: 'Updates from your favorite stores',
                              value: _settings.favoriteStoresEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _settings = _settings.copyWith(favoriteStoresEnabled: value);
                                });
                              },
                            ),
                            const ProfileDivider(),
                            _buildToggleItem(
                              title: 'Price Drops',
                              subtitle: 'Alerts when prices drop on saved deals',
                              value: _settings.priceDropsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _settings = _settings.copyWith(priceDropsEnabled: value);
                                });
                              },
                            ),
                            const ProfileDivider(),
                            _buildToggleItem(
                              title: 'Expiring Deals',
                              subtitle: 'Reminders for deals about to expire',
                              value: _settings.expiringDealsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _settings = _settings.copyWith(expiringDealsEnabled: value);
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Marketing section
                      ProfileSectionHeader(title: 'Marketing'),
                      const SizedBox(height: 8),

                      ProfileCard(
                        child: Column(
                          children: [
                            _buildToggleItem(
                              title: 'Weekly Digest',
                              subtitle: 'Weekly summary of best deals',
                              value: _settings.weeklyDigestEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _settings = _settings.copyWith(weeklyDigestEnabled: value);
                                });
                              },
                            ),
                            const ProfileDivider(),
                            _buildToggleItem(
                              title: 'Promotional Emails',
                              subtitle: 'Special offers and promotions',
                              value: _settings.promotionalEmailsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _settings = _settings.copyWith(promotionalEmailsEnabled: value);
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sound & Vibration section
                      ProfileSectionHeader(title: 'Notification Style'),
                      const SizedBox(height: 8),

                      ProfileCard(
                        child: Column(
                          children: [
                            _buildToggleItem(
                              title: 'Sound',
                              subtitle: 'Play sound for notifications',
                              value: _settings.soundEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _settings = _settings.copyWith(soundEnabled: value);
                                });
                              },
                            ),
                            const ProfileDivider(),
                            _buildToggleItem(
                              title: 'Vibration',
                              subtitle: 'Vibrate for notifications',
                              value: _settings.vibrationEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _settings = _settings.copyWith(vibrationEnabled: value);
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Save button
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppButton.primary(
                    onPressed: _isLoading ? null : _saveSettings,
                    isLoading: _isLoading,
                    child: const Text('Save'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CustomToggleSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
