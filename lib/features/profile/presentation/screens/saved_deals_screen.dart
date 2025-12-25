import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/mock/mock_deals_data.dart';
import 'package:waffir/core/widgets/images/app_network_image.dart';

/// Saved Deals Screen
///
/// Displays a list of deals the user has saved/bookmarked.
/// Follows Waffir design specifications from Figma.
class SavedDealsScreen extends ConsumerStatefulWidget {
  const SavedDealsScreen({super.key});

  @override
  ConsumerState<SavedDealsScreen> createState() => _SavedDealsScreenState();
}

class _SavedDealsScreenState extends ConsumerState<SavedDealsScreen> {
  late List<MockDeal> _savedDeals;

  @override
  void initState() {
    super.initState();
    _savedDeals = List.from(mockSavedDeals);
  }

  void _toggleSave(MockDeal deal) {
    setState(() {
      final index = _savedDeals.indexWhere((d) => d.id == deal.id);
      if (index != -1) {
        _savedDeals.removeAt(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${deal.title} removed from saved deals'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _savedDeals.insert(index, deal);
                });
              },
            ),
          ),
        );
      }
    });
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
                      Expanded(
                        child: Text(
                          'Saved Deals',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${_savedDeals.length} deals',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Deals list
              Expanded(
                child: _savedDeals.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _savedDeals.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final deal = _savedDeals[index];
                          return _buildDealCard(deal);
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDealCard(MockDeal deal) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.surfaceContainerHighest,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to deal details
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Deal image
            if (deal.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: AppNetworkImage(
                    imageUrl: deal.imageUrl!,
                    fit: BoxFit.cover,
                    contentType: ImageContentType.deal,
                    useResponsiveScaling: false,
                    errorWidget: Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 48),
                      ),
                    ),
                  ),
                ),
              ),

            // Deal info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store and discount
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          deal.discount,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        deal.store,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.favorite),
                        color: Colors.red,
                        iconSize: 20,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        onPressed: () => _toggleSave(deal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Deal title
                  Text(
                    deal.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  if (deal.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      deal.description!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Expiry date
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Expires ${_formatDate(deal.expiryDate)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays > 30) {
      return 'in ${(difference.inDays / 30).floor()} months';
    } else if (difference.inDays > 0) {
      return 'in ${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return 'in ${difference.inHours} hours';
    } else {
      return 'soon';
    }
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline,
              size: 80,
              color: colorScheme.onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 24),
            Text(
              'No Saved Deals',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start saving deals you like to access them quickly later',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                context.go('/deals');
              },
              icon: const Icon(Icons.explore),
              label: const Text('Browse Deals'),
            ),
          ],
        ),
      ),
    );
  }
}
