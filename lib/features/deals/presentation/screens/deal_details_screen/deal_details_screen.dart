import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart' show ShareParams, SharePlus;
import 'package:url_launcher/url_launcher.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/services/clarity_service.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/deals/domain/entities/deal_details_type.dart';
import 'package:waffir/features/deals/presentation/controllers/deal_details_controller.dart';
import 'package:waffir/features/deals/presentation/screens/deal_details_screen/widgets/deal_detail_view.dart';

class DealDetailsScreen extends HookConsumerWidget {
  const DealDetailsScreen({super.key, required this.dealId, required this.type});

  final String dealId;
  final DealDetailsType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRTL = context.locale.languageCode.toLowerCase() == 'ar';

    final detailsAsync = ref.watch(dealDetailsControllerProvider((type: type, dealId: dealId)));
    final controller = ref.read(
      dealDetailsControllerProvider((type: type, dealId: dealId)).notifier,
    );

    // Analytics tracking
    useEffect(() {
      if (detailsAsync is AsyncLoading) return null;

      detailsAsync.whenOrNull(
        data: (_) {
          ClarityService.instance.logEvent(
            'deal_detail_viewed',
            properties: {'dealId': dealId, 'dealType': type.routeValue},
          );
        },
        error: (error, _) {
          final failure = error is Failure ? error : null;
          ClarityService.instance.logEvent(
            'deal_detail_load_failed',
            properties: {
              'dealId': dealId,
              'dealType': type.routeValue,
              'errorType': failure?.runtimeType.toString() ?? error.runtimeType.toString(),
              'errorCode': failure?.code ?? '',
            },
          );
        },
      );
      return null;
    }, [detailsAsync]);

    Future<void> shareDeal() async {
      final deepLink = '/deal/${type.routeValue}/$dealId';
      await SharePlus.instance.share(ShareParams(text: deepLink));
      ClarityService.instance.logEvent(
        'deal_share_tapped',
        properties: {'dealId': dealId, 'dealType': type.routeValue},
      );
    }

    Future<void> openUrl(String url) async {
      final raw = url.trim();
      if (raw.isEmpty) return;
      final uri = Uri.tryParse(raw.startsWith('http') ? raw : 'https://$raw');
      if (uri == null) return;

      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (ok) {
        ClarityService.instance.logEvent(
          'deal_cta_tapped',
          properties: {'dealId': dealId, 'dealType': type.routeValue, 'action': 'open_url'},
        );
        return;
      }

      if (!context.mounted) return;
      ScaffoldMessenger.maybeOf(context)
        ?..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.dealDetails.errors.couldNotOpenLink.tr()),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: detailsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) {
            final failure = error is Failure ? error : null;
            return _DealDetailsErrorView(
              message: failure?.userMessage ?? LocaleKeys.dealDetails.errors.loadFailed.tr(),
              isNotFound: failure is NotFoundFailure,
              onRetry: controller.refresh,
            );
          },
          data: (data) {
            final title = switch (data.type) {
              DealDetailsType.product => data.productDeal?.title ?? '',
              DealDetailsType.store => data.storeOffer?.localizedTitle(isArabic: isRTL) ?? '',
              DealDetailsType.bank => data.bankOffer?.localizedTitle(isArabic: isRTL) ?? '',
            };

            final subtitle = switch (data.type) {
              DealDetailsType.product => (data.productDeal?.brand ?? '').trim(),
              DealDetailsType.store => '',
              DealDetailsType.bank =>
                (data.bankOffer?.localizedBankName(isArabic: isRTL) ?? '').trim(),
            };

            final imageUrl = switch (data.type) {
              DealDetailsType.product => (data.productDeal?.imageUrl ?? '').trim(),
              DealDetailsType.store => (data.storeOffer?.imageUrl ?? '').trim(),
              DealDetailsType.bank => (data.bankOffer?.imageUrl ?? '').trim(),
            };

            final description = switch (data.type) {
              DealDetailsType.product => (data.productDeal?.description ?? '').trim(),
              DealDetailsType.store =>
                (data.storeOffer?.localizedDescription(isArabic: isRTL) ?? '').trim(),
              DealDetailsType.bank => (data.bankOffer?.description ?? '').trim(),
            };

            final terms = switch (data.type) {
              DealDetailsType.product => null,
              DealDetailsType.store => data.storeOffer?.localizedTerms(isArabic: isRTL),
              DealDetailsType.bank => data.bankOffer?.termsText,
            };

            final promoCode = switch (data.type) {
              DealDetailsType.product => null,
              DealDetailsType.store => data.storeOffer?.promoCode,
              DealDetailsType.bank => data.bankOffer?.promoCode,
            };

            final refUrl = switch (data.type) {
              DealDetailsType.product => null,
              DealDetailsType.store => data.storeOffer?.refUrl,
              DealDetailsType.bank => data.bankOffer?.refUrl,
            };

            // Product specific
            final price = data.type == DealDetailsType.product ? data.productDeal?.price : null;
            final originalPrice =
                data.type == DealDetailsType.product ? data.productDeal?.originalPrice : null;
            final discountPercent = data.type == DealDetailsType.product
                ? data.productDeal?.calculatedDiscountPercentage
                : null;

            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: DealDetailView(
                dealId: dealId,
                dealType: type,
                isRTL: isRTL,
                title: title,
                subtitle: subtitle,
                imageUrl: imageUrl,
                description: description,
                onShopNow: () => openUrl(refUrl ?? ''),
                onShare: shareDeal,
                price: price,
                originalPrice: originalPrice,
                discountPercent: discountPercent,
                promoCode: promoCode,
                terms: terms,
                refUrl: refUrl,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DealDetailsErrorView extends StatelessWidget {
  const _DealDetailsErrorView({
    required this.message,
    required this.isNotFound,
    required this.onRetry,
  });

  final String message;
  final bool isNotFound;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final responsive = context.rs;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: responsive.sPadding(const EdgeInsets.all(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isNotFound ? Icons.search_off_rounded : Icons.error_outline,
              size: responsive.s(64),
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            SizedBox(height: responsive.s(16)),
            Text(
              isNotFound ? LocaleKeys.dealDetails.errors.noLongerAvailable.tr() : message,
              style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsive.s(16)),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: Text(LocaleKeys.buttons.retry.tr(), style: textTheme.labelLarge),
            ),
          ],
        ),
      ),
    );
  }
}
