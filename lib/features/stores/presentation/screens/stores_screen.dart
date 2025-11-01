import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/widgets/cards/store_card.dart';
import 'package:waffir/core/widgets/filters/stores_category_chips.dart';
import 'package:waffir/core/widgets/overlays/bottom_gradient_cta.dart';
import 'package:waffir/core/widgets/search/waffir_search_bar.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/data/providers/stores_providers.dart';

/// Stores Screen - displays stores with category filters and sections
///
/// Features:
/// - Search bar with filter button
/// - Horizontal scrollable category filters
/// - Two sections: Near You stores and Mall stores
/// - Store cards with distance, rating, and category
class StoresScreen extends ConsumerStatefulWidget {
  const StoresScreen({super.key});

  @override
  ConsumerState<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends ConsumerState<StoresScreen> {
  String _searchQuery = '';

  /// Available categories for filtering
  static const List<String> _categories = [
    'All',
    'Dining',
    'Fashion',
    'Electronics',
    'Beauty',
    'Travel',
    'Lifestyle',
    'Jewelry',
    'Entertainment',
    'Other',
  ];

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _handleFilterTap() {
    // TODO: Implement filter dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filter dialog coming soon')),
    );
  }

  List<StoreModel> _filterStoresBySearch(List<StoreModel> stores) {
    if (_searchQuery.isEmpty) return stores;

    return stores.where((store) {
      final nameLower = store.name.toLowerCase();
      final categoryLower = store.category.toLowerCase();
      final addressLower = store.address?.toLowerCase() ?? '';
      return nameLower.contains(_searchQuery) ||
          categoryLower.contains(_searchQuery) ||
          addressLower.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedCategory = ref.watch(selectedStoreCategoryProvider);
    final nearYouStores = ref.watch(filteredNearYouStoresProvider);
    final mallStores = ref.watch(filteredMallStoresProvider);

    // Filter by search query
    final filteredNearYou = _filterStoresBySearch(nearYouStores);
    final filteredMall = _filterStoresBySearch(mallStores);

    // Group mall stores by mall name
    final Map<String, List<StoreModel>> mallStoresByMall = {};
    for (final store in filteredMall) {
      final mallName = store.location ?? 'Other Locations';
      mallStoresByMall.putIfAbsent(mallName, () => []).add(store);
    }

    final hasResults = filteredNearYou.isNotEmpty || filteredMall.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stores',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
      ),
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Search Bar (Waffir branded with exact Figma specs)
              Padding(
                padding: const EdgeInsets.all(16),
                child: WaffirSearchBar(
                  hintText: 'Search stores...',
                  onChanged: _handleSearch,
                  onSearch: _handleSearch,
                  onFilterTap: _handleFilterTap,
                ),
              ),

              // Category Filters (with icons and bottom borders)
              StoresCategoryChips(
                categories: _categories,
                selectedCategory: selectedCategory,
                onCategorySelected: (category) {
                  ref.read(selectedStoreCategoryProvider.notifier).selectCategory(category);
                },
              ),

              const SizedBox(height: 16),

              // Stores List
              Expanded(
                child: !hasResults
                    ? _buildEmptyState(context)
                    : ListView(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 300, // Extra padding for CTA overlay + bottom nav
                        ),
                        children: [
                          // Near You Section
                          if (filteredNearYou.isNotEmpty) ...[
                            _buildSectionHeader(
                              context,
                              'Near to you',
                              'قريب منك',
                              filteredNearYou.length,
                            ),
                            const SizedBox(height: 12),
                            _buildStoreGrid(filteredNearYou),
                            const SizedBox(height: 24),
                          ],

                          // Mall Stores Sections
                          if (filteredMall.isNotEmpty) ...[
                            for (final entry in mallStoresByMall.entries) ...[
                              _buildSectionHeader(
                                context,
                                'In Mall shops near to you',
                                entry.key, // Arabic mall name
                                entry.value.length,
                              ),
                              const SizedBox(height: 12),
                              _buildStoreGrid(entry.value),
                              const SizedBox(height: 24),
                            ],
                          ],
                        ],
                      ),
              ),
            ],
          ),

          // Bottom Gradient CTA Overlay
          Positioned(
            bottom: 88, // Above bottom nav (88px = nav height)
            left: 0,
            right: 0,
            child: BottomGradientCTA(
              buttonText: 'Login to view full deal details',
              onButtonPressed: () {
                // TODO: Navigate to login screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigate to login')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String titleAr,
    int count,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.storeSectionHeader.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          '$count ${count == 1 ? 'store' : 'stores'}',
          style: AppTypography.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStoreGrid(List<StoreModel> stores) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Changed from 3 to 2 per Figma
        childAspectRatio: 0.70, // Adjusted for 160x160px image + text container
        crossAxisSpacing: 12, // Exact from Figma
        mainAxisSpacing: 12, // Exact from Figma
      ),
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        return StoreCard(
          imageUrl: store.imageUrl,
          storeName: store.name,
          category: store.category,
          distance: store.distance,
          rating: store.rating,
          onTap: () {
            // TODO: Navigate to store details
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped: ${store.name}')),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 80,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No stores found',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Try selecting a different category'
                : 'Try a different search term',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
