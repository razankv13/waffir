import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/mock/mock_help_content.dart';
import 'package:waffir/core/widgets/profile/profile_card.dart';

/// Help Center Screen
///
/// Displays FAQ articles grouped by category with expandable sections.
class HelpCenterScreen extends ConsumerStatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  ConsumerState<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends ConsumerState<HelpCenterScreen> {
  String? _expandedArticleId;

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
                        'Help Center',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // FAQ list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: helpCategories.length,
                  itemBuilder: (context, categoryIndex) {
                    final category = helpCategories[categoryIndex];
                    final articles = mockHelpArticles[category] ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (categoryIndex > 0) const SizedBox(height: 24),

                        // Category header
                        ProfileSectionHeader(
                          title: category,
                          padding: const EdgeInsets.only(bottom: 8),
                        ),

                        // Articles
                        ProfileCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: articles.asMap().entries.map((entry) {
                              final index = entry.key;
                              final article = entry.value;
                              final isExpanded = _expandedArticleId == article.id;

                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _expandedArticleId = isExpanded ? null : article.id;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              article.question,
                                              style: textTheme.bodyMedium?.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            isExpanded ? Icons.expand_less : Icons.expand_more,
                                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Answer (expandable)
                                  if (isExpanded)
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      child: Text(
                                        article.answer,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                                          height: 1.5,
                                        ),
                                      ),
                                    ),

                                  if (index < articles.length - 1)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: const ProfileDivider(height: 0),
                                    ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Contact support section
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    border: Border(
                      top: BorderSide(
                        color: colorScheme.surfaceContainerHighest,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Still need help?',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Contact our support team',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Open email app
                              },
                              icon: const Icon(Icons.email_outlined),
                              label: const Text('Email'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Open WhatsApp
                              },
                              icon: const Icon(Icons.chat_outlined),
                              label: const Text('Chat'),
                            ),
                          ),
                        ],
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
