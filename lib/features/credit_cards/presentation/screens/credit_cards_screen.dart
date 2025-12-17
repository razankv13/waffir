import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/search/search_bar_widget.dart';
import 'package:waffir/core/widgets/switches/custom_toggle_switch.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/auth/presentation/widgets/blurred_background.dart';
import 'package:waffir/gen/assets.gen.dart';

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
    final searchQuery = useState('');
    final selectedBankIds = useState(<String>{});

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

    List<_BankCardOptionData> filteredBankOptions() {
      final query = searchQuery.value.trim().toLowerCase();
      if (query.isEmpty) {
        return _designBankOptions;
      }
      return _designBankOptions.where((option) {
        final bank = option.bankName.toLowerCase();
        final card = option.cardLabel.toLowerCase();
        return bank.contains(query) || card.contains(query);
      }).toList();
    }

    void handleSearch(String rawQuery) {
      searchQuery.value = rawQuery.trim().toLowerCase();
    }

    void toggleBank(String bankId) {
      final updated = {...selectedBankIds.value};
      if (updated.contains(bankId)) {
        updated.remove(bankId);
      } else {
        updated.add(bankId);
      }
      selectedBankIds.value = updated;
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

    final filteredBanks = filteredBankOptions();
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
              body: filteredBanks.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: responsive.scale(16),
                        right: responsive.scale(16),
                        top: responsive.scale(32),
                        bottom: responsive.scale(120),
                      ),
                      children: [buildEmptyState(emptyTitle, emptyDescription)],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(
                        left: responsive.scale(16),
                        right: responsive.scale(16),
                        top: responsive.scale(32),
                        bottom: responsive.scale(120),
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredBanks.length,
                      separatorBuilder: (context, index) => SizedBox(height: responsive.scale(16)),
                      itemBuilder: (context, index) {
                        final option = filteredBanks[index];
                        final isSelected = selectedBankIds.value.contains(option.id);
                        return _BankSelectionTile(
                          option: option,
                          isSelected: isSelected,
                          responsive: responsive,
                          onToggle: () => toggleBank(option.id),
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

class _BankSelectionTile extends StatelessWidget {
  const _BankSelectionTile({
    required this.option,
    required this.isSelected,
    required this.responsive,
    required this.onToggle,
  });

  final _BankCardOptionData option;
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
            color: theme.colorScheme.surface,
          ),
          clipBehavior: Clip.antiAlias,
          child: option.asset.image(fit: BoxFit.cover),
        ),
        SizedBox(width: responsive.scale(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                option.bankName,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: responsive.scaleFontSize(14, minSize: 12),
                  height: 1.0,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: responsive.scale(4)),
              Text(
                option.cardLabel,
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
}

class _BankCardOptionData {
  const _BankCardOptionData({
    required this.id,
    required this.bankName,
    required this.cardLabel,
    required this.asset,
    this.isDefaultSelected = false,
  });

  final String id;
  final String bankName;
  final String cardLabel;
  final AssetGenImage asset;
  final bool isDefaultSelected;
}

final List<_BankCardOptionData> _designBankOptions = [
  _BankCardOptionData(
    id: 'sab',
    bankName: 'SAB',
    cardLabel: 'Platinum 4609 92',
    asset: Assets.images.creditCards.sabCard,
  ),
  _BankCardOptionData(
    id: 'rajhi',
    bankName: 'Rajhi',
    cardLabel: 'Business 4431 22',
    asset: Assets.images.creditCards.rajhiCard,
    isDefaultSelected: true,
  ),
  _BankCardOptionData(
    id: 'enbd',
    bankName: 'ENBD',
    cardLabel: 'Premium Plus 4992 00',
    asset: Assets.images.creditCards.enbdCard,
  ),
  _BankCardOptionData(
    id: 'snb',
    bankName: 'SNB',
    cardLabel: 'Titanium 5521 43',
    asset: Assets.images.creditCards.snbCard,
  ),
];
