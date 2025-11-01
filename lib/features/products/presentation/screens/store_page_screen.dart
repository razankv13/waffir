import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/features/products/data/providers/product_providers.dart';
import 'package:waffir/features/products/presentation/widgets/store_info_banner.dart';

/// Store page screen
///
/// Matches Figma design (Node 54:5897)
/// Shows store information and products
class StorePageScreen extends ConsumerWidget {
  const StorePageScreen({
    super.key,
    required this.storeId,
  });

  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isRTL = context.locale.languageCode == 'ar';

    final storeAsync = ref.watch(storeByIdProvider(storeId));
    final followedNotifier = ref.watch(followedStoresNotifierProvider.notifier);
    final isFollowing = ref.watch(followedStoresNotifierProvider).contains(storeId);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: storeAsync.when(
          data: (store) {
            if (store == null) {
              return _buildNotFound(context);
            }

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // Store banner image
                    SliverToBoxAdapter(
                      child: Container(
                        height: 390,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          image: store.bannerUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(store.bannerUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: store.bannerUrl == null
                            ? Center(
                                child: Icon(
                                  Icons.store,
                                  size: 64,
                                  color: colorScheme.onSurfaceVariant.withOpacity(0.3),
                                ),
                              )
                            : null,
                      ),
                    ),

                    // Store info banner
                    SliverToBoxAdapter(
                      child: StoreInfoBanner(
                        store: store.copyWith(isFollowing: isFollowing),
                        showFollowButton: true,
                        onFollowToggle: () {
                          HapticFeedback.lightImpact();
                          followedNotifier.toggle(storeId);
                        },
                      ),
                    ),

                    // Store description
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              store.description ?? '',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: store.categories.map((category) {
                                return Chip(
                                  label: Text(category),
                                  backgroundColor: colorScheme.primaryContainer,
                                  labelStyle: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Products section header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Text(
                          'Products',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Products grid (placeholder)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: colorScheme.onSurfaceVariant.withOpacity(0.3),
                              ),
                            ),
                          ),
                          childCount: 6,
                        ),
                      ),
                    ),
                  ],
                ),

                // Back button
                Positioned(
                  top: 64,
                  left: isRTL ? null : 16,
                  right: isRTL ? 16 : null,
                  child: _buildBackButton(context),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildError(context, error.toString()),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00FF88),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF2F2F2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: colorScheme.surface,
          size: 20,
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          context.pop();
        },
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Store not found',
            style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String error) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: colorScheme.error),
          const SizedBox(height: 16),
          Text('Error loading store', style: textTheme.titleLarge),
        ],
      ),
    );
  }
}
