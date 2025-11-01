import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/profile/profile_card.dart';

/// Language Selection Screen
///
/// Allows users to change the app language. Supports multiple languages
/// including English, Arabic, Spanish, and French.
class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  String _selectedLanguage = 'English';
  bool _isLoading = false;

  final Map<String, Map<String, String>> _languages = {
    'English': {'name': 'English', 'nativeName': 'English', 'code': 'en'},
    'Arabic': {'name': 'Arabic', 'nativeName': 'العربية', 'code': 'ar'},
    'Spanish': {'name': 'Spanish', 'nativeName': 'Español', 'code': 'es'},
    'French': {'name': 'French', 'nativeName': 'Français', 'code': 'fr'},
  };

  Future<void> _saveLanguage() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Language changed to $_selectedLanguage'),
          duration: const Duration(seconds: 2),
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
            top: -85,
            left: -40,
            child: Container(
              width: 468,
              height: 395,
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
                        'Language',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Language list
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ProfileCard(
                    child: Column(
                      children: [
                        ..._languages.entries.map((entry) {
                          final isSelected = _selectedLanguage == entry.key;
                          final lang = entry.value;

                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedLanguage = entry.key;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    children: [
                                      Radio<String>(
                                        value: entry.key,
                                        groupValue: _selectedLanguage,
                                        onChanged: (String? value) {
                                          if (value != null) {
                                            setState(() {
                                              _selectedLanguage = value;
                                            });
                                          }
                                        },
                                        activeColor: colorScheme.primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              lang['name']!,
                                              style: textTheme.bodyLarge?.copyWith(
                                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              lang['nativeName']!,
                                              style: textTheme.bodySmall?.copyWith(
                                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          color: colorScheme.primary,
                                          size: 24,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              if (entry.key != _languages.keys.last)
                                const ProfileDivider(),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              // Save button
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppButton.primary(
                    onPressed: _isLoading ? null : _saveLanguage,
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
}
