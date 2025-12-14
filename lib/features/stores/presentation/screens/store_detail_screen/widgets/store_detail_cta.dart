import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/app_text_styles.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/widgets/store_purchase_bottom_sheet.dart';

/// Pixel-perfect header overlay for Store Page (Figma node 7783:7861).
class StorePageHeaderOverlay extends StatelessWidget {
  const StorePageHeaderOverlay({super.key, required this.isRTL});

  final bool isRTL;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    final shadow = BoxShadow(
      color: colorScheme.surfaceContainerHighest, // #F2F2F2
      blurRadius: responsive.scale(8),
      spreadRadius: responsive.scale(2),
      offset: Offset.zero,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.71, 1.0],
          colors: [colorScheme.surface, colorScheme.surface.withValues(alpha: 0.0)],
        ),
      ),
      padding: EdgeInsets.only(
        top: responsive.scale(64),
        left: responsive.scale(16),
        right: responsive.scale(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WaffirBackButton(size: responsive.scale(44), padding: EdgeInsets.zero),
          _StorePill(shadow: shadow),
        ],
      ),
    );
  }
}

class _StorePill extends StatelessWidget {
  const _StorePill({required this.shadow});

  final BoxShadow shadow;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondary, // #00FF88
        borderRadius: BorderRadius.circular(responsive.scale(60)),
        boxShadow: [shadow],
      ),
      child: Padding(
        padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
        child: Text(
          'Store',
          style: AppTextStyles.storePageHeaderLabel.copyWith(color: colorScheme.onSurface),
        ),
      ),
    );
  }
}

/// Pixel-perfect bottom CTA overlay (Figma node 7783:7812).
class StorePageBottomCta extends StatelessWidget {
  const StorePageBottomCta({super.key, required this.storeName});

  final String storeName;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: responsive.scale(96),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.49],
          colors: [colorScheme.surface.withValues(alpha: 0.0), colorScheme.surface],
        ),
      ),
      padding: EdgeInsets.only(
        left: responsive.scale(16),
        right: responsive.scale(16),
        bottom: responsive.scale(48),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: responsive.scale(247),
            height: responsive.scale(48),
            child: Material(
              color: colorScheme.primary, // #0F352D
              borderRadius: BorderRadius.circular(responsive.scale(30)),
              child: InkWell(
                borderRadius: BorderRadius.circular(responsive.scale(30)),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return StorePurchaseBottomSheet(
                        onPurchased: () => Navigator.of(context).pop(),
                        onBrowsing: () => Navigator.of(context).pop(),
                        onClose: () => Navigator.of(context).pop(),
                      );
                    },
                  );
                },
                child: Center(
                  child: Text(
                    'See the deal at ($storeName)',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.storePageCta.copyWith(color: colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: responsive.scale(16)),
          SizedBox(
            width: responsive.scale(44),
            height: responsive.scale(44),
            child: Material(
              color: colorScheme.primary, // #0F352D
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Share tapped')));
                },
                child: Center(
                  child: SizedBox(
                    width: responsive.scale(20),
                    height: responsive.scale(20),
                    child: SvgPicture.asset(
                      'assets/icons/store_detail/share_ios.svg',
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(colorScheme.onPrimary, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
