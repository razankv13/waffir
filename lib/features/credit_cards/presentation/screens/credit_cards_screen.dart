import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/images/app_network_image.dart';
import 'package:waffir/core/widgets/search/search_bar_widget.dart';
import 'package:waffir/core/widgets/switches/custom_toggle_switch.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/auth/presentation/widgets/blurred_background.dart';
import 'package:waffir/features/credit_cards/domain/entities/credit_card.dart';
import 'package:waffir/features/credit_cards/presentation/controllers/bank_cards_controller.dart';

/// Credit Cards Screen - Choose Bank Cards (Figma node: 34:9127)
///
/// Implements the exact layout extracted via Framelink MCP, including:
/// - Decorative blur background
/// - Two-line header
/// - Search container with inline label and CTA
/// - Bank card rows with image tiles and toggle switches
class CreditCardsScreen extends HookConsumerWidget {
  const CreditCardsScreen({super.key, this.showBackButton = false});

  /// When true, shows a top-left back button (used when navigating from Profile/My Account).
  ///
  /// Default is false to preserve the pixel-perfect Credit Cards tab experience.
  final bool showBackButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final responsive = ResponsiveHelper(context);
    final searchController = useTextEditingController();
    final languageCode = ref.watch(localeProvider).languageCode;

    // Watch the bank cards controller
    final bankCardsAsync = ref.watch(bankCardsControllerProvider);
    final controller = ref.read(bankCardsControllerProvider.notifier);

    final headerTitleStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: responsive.scaleFontSize(18, minSize: 16),
      height: 1.0,
      color: theme.colorScheme.onSurface,
    );
    final headerSubtitleStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: responsive.scaleFontSize(16, minSize: 14),
      height: 1.15,
      color: theme.colorScheme.onSurface,
    );

    void handleSearch(String rawQuery) {
      controller.updateSearch(rawQuery);
    }

    void toggleCard(String cardId) {
      controller.toggleCard(cardId);
    }

    void showComingSoonSnackBar() {
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.clearSnackBars();
      messenger?.showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.creditCards.filterComingSoon.tr()),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    Widget buildHeader(String title, String subtitle) {
      return Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: headerTitleStyle),
          SizedBox(height: responsive.scale(16)),
          Text(subtitle, textAlign: TextAlign.center, style: headerSubtitleStyle),
        ],
      );
    }

    Widget buildEmptyState(String title, String description) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.credit_card_outlined,
              size: responsive.scale(80),
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            SizedBox(height: responsive.scale(16)),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: responsive.scaleFontSize(18, minSize: 16),
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: responsive.scale(8)),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: responsive.scaleFontSize(14, minSize: 12),
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    Widget buildLoadingState() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: responsive.scale(48),
              height: responsive.scale(48),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: responsive.scale(16)),
            Text(
              LocaleKeys.creditCards.loading.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    Widget buildErrorState(Object error, StackTrace stackTrace) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: responsive.scale(64),
              color: theme.colorScheme.error,
            ),
            SizedBox(height: responsive.scale(16)),
            Text(
              LocaleKeys.creditCards.error.title.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: responsive.scale(8)),
            Text(
              LocaleKeys.creditCards.error.description.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: responsive.scale(24)),
            FilledButton.tonal(
              onPressed: () => ref.invalidate(bankCardsControllerProvider),
              child: Text(LocaleKeys.creditCards.error.retry.tr()),
            ),
          ],
        ),
      );
    }

    final headerTitle = LocaleKeys.creditCards.title.tr();
    final headerSubtitle = LocaleKeys.creditCards.subtitle.tr();
    final searchHint = LocaleKeys.creditCards.searchHint.tr();
    final emptyTitle = LocaleKeys.creditCards.empty.title.tr();
    final emptyDescription = LocaleKeys.creditCards.empty.description.tr();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          const BlurredBackground(),
          SafeArea(
            bottom: false,
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, _) {
                final horizontalPadding = responsive.scale(16);
                final maxHeaderWidth = MediaQuery.sizeOf(context).width - (horizontalPadding * 2);

                // Header: top spacer + title/subtitle block.
                final topSpacer = responsive.scale(90);

                final titlePainter = TextPainter(
                  text: TextSpan(text: headerTitle, style: headerTitleStyle),
                  textDirection: Directionality.of(context),
                  textAlign: TextAlign.center,
                  textScaler: MediaQuery.textScalerOf(context),
                )..layout(maxWidth: maxHeaderWidth);

                final subtitlePainter = TextPainter(
                  text: TextSpan(text: headerSubtitle, style: headerSubtitleStyle),
                  textDirection: Directionality.of(context),
                  textAlign: TextAlign.center,
                  textScaler: MediaQuery.textScalerOf(context),
                )..layout(maxWidth: maxHeaderWidth);

                final headerBodyHeight =
                    titlePainter.height + responsive.scale(16) + subtitlePainter.height;
                final headerHeight = topSpacer + headerBodyHeight;

                // Search: pinned, with small top spacing.
                final searchTopSpacing = responsive.scale(12);
                const searchHeight = 68.0;
                final pinnedSearchHeight = searchTopSpacing + searchHeight;

                return [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    toolbarHeight: 0,
                    collapsedHeight: headerHeight,
                    expandedHeight: headerHeight,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    flexibleSpace: Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: topSpacer),
                          buildHeader(headerTitle, headerSubtitle),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _PinnedSearchHeaderDelegate(
                      height: pinnedSearchHeight,
                      topSpacing: searchTopSpacing,
                      backgroundColor: theme.colorScheme.surface,
                      horizontalPadding: horizontalPadding,
                      child: SearchBarWidget(
                        controller: searchController,
                        hintText: searchHint,
                        showFilterButton: true,
                        onChanged: handleSearch,
                        onSearch: handleSearch,
                        onFilterTap: showComingSoonSnackBar,
                      ),
                    ),
                  ),
                ];
              },
              body: bankCardsAsync.when(
                loading: () => buildLoadingState(),
                error: (error, stackTrace) => buildErrorState(error, stackTrace),
                data: (state) {
                  final filteredCards = state.filteredBankCards;

                  if (filteredCards.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: responsive.scale(16),
                        right: responsive.scale(16),
                        top: responsive.scale(32),
                        bottom: responsive.scale(120),
                      ),
                      children: [buildEmptyState(emptyTitle, emptyDescription)],
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.only(
                      left: responsive.scale(16),
                      right: responsive.scale(16),
                      top: responsive.scale(32),
                      bottom: responsive.scale(120),
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredCards.length,
                    separatorBuilder: (context, index) => SizedBox(height: responsive.scale(16)),
                    itemBuilder: (context, index) {
                      final card = filteredCards[index];
                      final isSelected = state.isSelected(card.id);
                      return _BankCardSelectionTile(
                        card: card,
                        languageCode: languageCode,
                        isSelected: isSelected,
                        responsive: responsive,
                        onToggle: () => toggleCard(card.id),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          if (showBackButton)
            Positioned(
              left: responsive.scale(16),
              top: MediaQuery.paddingOf(context).top + responsive.scale(16),
              child: WaffirBackButton(size: responsive.scale(44)),
            ),
        ],
      ),
    );
  }
}

class _PinnedSearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedSearchHeaderDelegate({
    required this.height,
    required this.topSpacing,
    required this.backgroundColor,
    required this.horizontalPadding,
    required this.child,
  });

  final double height;
  final double topSpacing;
  final Color backgroundColor;
  final double horizontalPadding;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.only(
          top: topSpacing,
          left: horizontalPadding,
          right: horizontalPadding,
        ),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedSearchHeaderDelegate oldDelegate) {
    return height != oldDelegate.height ||
        topSpacing != oldDelegate.topSpacing ||
        backgroundColor != oldDelegate.backgroundColor ||
        horizontalPadding != oldDelegate.horizontalPadding ||
        child != oldDelegate.child;
  }
}

/// Bank card selection tile with network image support
class _BankCardSelectionTile extends StatelessWidget {
  const _BankCardSelectionTile({
    required this.card,
    required this.languageCode,
    required this.isSelected,
    required this.responsive,
    required this.onToggle,
  });

  final BankCard card;
  final String languageCode;
  final bool isSelected;
  final ResponsiveHelper responsive;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoSize = responsive.scale(80);
    final borderRadius = responsive.scaleBorderRadius(BorderRadius.circular(8));

    return Row(
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: theme.colorScheme.outlineVariant),
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildCardImage(context, logoSize),
        ),
        SizedBox(width: responsive.scale(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.localizedBankName(languageCode),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: responsive.scaleFontSize(14, minSize: 12),
                  height: 1.0,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: responsive.scale(4)),
              Text(
                card.localizedName(languageCode),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: responsive.scaleFontSize(12),
                  height: 1.0,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: responsive.scale(12)),
        CustomToggleSwitch(value: isSelected, onChanged: (_) => onToggle()),
      ],
    );
  }

  Widget _buildCardImage(BuildContext context, double size) {
    final theme = Theme.of(context);
    final imageUrl = card.displayImageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildPlaceholder(theme, size);
    }

    return AppNetworkImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      contentType: ImageContentType.creditCard,
      useResponsiveScaling: false, // Size already scaled by caller
      errorWidget: _buildPlaceholder(theme, size),
    );
  }

  Widget _buildLoadingIndicator(
    ThemeData theme,
    double size,
    ImageChunkEvent loadingProgress,
  ) {
    final progress = loadingProgress.expectedTotalBytes != null
        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
        : null;

    return Center(
      child: SizedBox(
        width: size * 0.4,
        height: size * 0.4,
        child: CircularProgressIndicator(
          value: progress,
          strokeWidth: 2,
          color: theme.colorScheme.primary.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme, double size) {
    return Center(
      child: Icon(
        Icons.credit_card,
        size: size * 0.5,
        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
      ),
    );
  }
}
