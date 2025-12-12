import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/search/search_bar_widget.dart';
import 'package:waffir/core/widgets/switches/custom_toggle_switch.dart';
import 'package:waffir/gen/assets.gen.dart';

/// Credit Cards Screen - Choose Bank Cards (Figma node: 34:9127)
///
/// Implements the exact layout extracted via Framelink MCP, including:
/// - Decorative blur background
/// - Two-line header
/// - Search container with inline label and CTA
/// - Bank card rows with image tiles and toggle switches
class CreditCardsScreen extends ConsumerStatefulWidget {
  const CreditCardsScreen({super.key, this.showBackButton = false});

  /// When true, shows a top-left back button (used when navigating from Profile/My Account).
  ///
  /// Default is false to preserve the pixel-perfect Credit Cards tab experience.
  final bool showBackButton;

  @override
  ConsumerState<CreditCardsScreen> createState() => _CreditCardsScreenState();
}

class _CreditCardsScreenState extends ConsumerState<CreditCardsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late final Set<String> _selectedBankIds = {
    for (final option in _designBankOptions)
      if (option.isDefaultSelected) option.id,
  };

  List<_BankCardOptionData> get _filteredBankOptions {
    if (_searchQuery.isEmpty) {
      return _designBankOptions;
    }
    final query = _searchQuery;
    return _designBankOptions.where((option) {
      final bank = option.bankName.toLowerCase();
      final card = option.cardLabel.toLowerCase();
      return bank.contains(query) || card.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String rawQuery) {
    setState(() {
      _searchQuery = rawQuery.trim().toLowerCase();
    });
  }

  void _toggleBank(String bankId) {
    setState(() {
      if (_selectedBankIds.contains(bankId)) {
        _selectedBankIds.remove(bankId);
      } else {
        _selectedBankIds.add(bankId);
      }
    });
  }

  void _showComingSoonSnackBar(BuildContext context) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.clearSnackBars();
    messenger?.showSnackBar(
      const SnackBar(
        content: Text('Filter functionality coming soon'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = ResponsiveHelper(context);
    final filteredBanks = _filteredBankOptions;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          _buildBackgroundShape(responsive, theme),
          SafeArea(
            bottom: false,
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, _) {
                final horizontalPadding = responsive.scale(16);
                final maxHeaderWidth = MediaQuery.sizeOf(context).width - (horizontalPadding * 2);

                // Header: top spacer + title/subtitle block.
                final topSpacer = responsive.scale(90);
                final titleStyle = theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: responsive.scaleFontSize(18, minSize: 16),
                  height: 1.0,
                  color: theme.colorScheme.onSurface,
                );
                final subtitleStyle = theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: responsive.scaleFontSize(16, minSize: 14),
                  height: 1.15,
                  color: theme.colorScheme.onSurface,
                );

                final titlePainter = TextPainter(
                  text: TextSpan(text: 'Select Your\nCredit Card/Debit Card', style: titleStyle),
                  textDirection: Directionality.of(context),
                  textAlign: TextAlign.center,
                  textScaler: MediaQuery.textScalerOf(context),
                )..layout(maxWidth: maxHeaderWidth);

                final subtitlePainter = TextPainter(
                  text: TextSpan(
                    text:
                        'Please note: you only need to select your card type - you will not be asked to provide any other details.',
                    style: subtitleStyle,
                  ),
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
                    backgroundColor: theme.colorScheme.surface,
                    surfaceTintColor: Colors.transparent,
                    flexibleSpace: Container(
                      color: theme.colorScheme.surface,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: topSpacer),
                            _buildHeader(theme, responsive),
                          ],
                        ),
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
                        controller: _searchController,
                        hintText: 'Card, or Bank Name',
                        showFilterButton: true,
                        onChanged: _handleSearch,
                        onSearch: _handleSearch,
                        onFilterTap: () => _showComingSoonSnackBar(context),
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
                      children: [
                        _buildEmptyState(theme, responsive),
                      ],
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
                      separatorBuilder: (context, index) =>
                          SizedBox(height: responsive.scale(16)),
                      itemBuilder: (context, index) {
                        final option = filteredBanks[index];
                        final isSelected = _selectedBankIds.contains(option.id);
                        return _BankSelectionTile(
                          option: option,
                          isSelected: isSelected,
                          responsive: responsive,
                          onToggle: () => _toggleBank(option.id),
                        );
                      },
                    ),
            ),
                    ),
          if (widget.showBackButton)
            Positioned(
              left: responsive.scale(16),
              top: MediaQuery.paddingOf(context).top + responsive.scale(16),
              child: WaffirBackButton(size: responsive.scale(44)),
            ),
        ],
      ),
    );
  }

  Widget _buildBackgroundShape(ResponsiveHelper responsive, ThemeData theme) {
    final blurColor = theme.colorScheme.secondary;
    return Positioned(
      left: responsive.scale(-40),
      top: responsive.scale(-100),
      child: IgnorePointer(
        child: Container(
          width: responsive.scale(467.78),
          height: responsive.scale(461.3),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                blurColor.withValues(alpha: 0.35),
                theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                Colors.transparent,
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(responsive.scale(240)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ResponsiveHelper responsive) {
    final titleStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: responsive.scaleFontSize(18, minSize: 16),
      height: 1.0,
      color: theme.colorScheme.onSurface,
    );
    final subtitleStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: responsive.scaleFontSize(16, minSize: 14),
      height: 1.15,
      color: theme.colorScheme.onSurface,
    );

    return Column(
      children: [
        Text('Select Your\nCredit Card/Debit Card', textAlign: TextAlign.center, style: titleStyle),
        SizedBox(height: responsive.scale(16)),
        Text(
          'Please note: you only need to select your card type - you will not be asked to provide any other details.',
          textAlign: TextAlign.center,
          style: subtitleStyle,
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme, ResponsiveHelper responsive) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card_outlined,
            size: responsive.scale(80),
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: responsive.scale(16)),
          Text(
            'No banks found',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: responsive.scaleFontSize(18, minSize: 16),
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: responsive.scale(8)),
          Text(
            'Try a different search term',
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
