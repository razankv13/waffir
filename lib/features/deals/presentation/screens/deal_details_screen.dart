import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/services/clarity_service.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/deals/domain/entities/deal_details_type.dart';
import 'package:waffir/features/deals/presentation/controllers/deal_details_controller.dart';

class DealDetailsScreen extends HookConsumerWidget {
  const DealDetailsScreen({
    super.key,
    required this.dealId,
    required this.type,
  });

  final String dealId;
  final DealDetailsType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isRTL = context.locale.languageCode.toLowerCase() == 'ar';
    final isTermsExpanded = useState(false);

    final detailsAsync = ref.watch(
      dealDetailsControllerProvider((type: type, dealId: dealId)),
    );
    final controller = ref.read(
      dealDetailsControllerProvider((type: type, dealId: dealId)).notifier,
    );

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
              'errorType':
                  failure?.runtimeType.toString() ??
                  error.runtimeType.toString(),
              'errorCode': failure?.code ?? '',
            },
          );
        },
      );
      return null;
    }, [detailsAsync]);

    Future<void> shareDeal() async {
      final deepLink = '/deal/${type.routeValue}/$dealId';
      await Share.share(deepLink);
      ClarityService.instance.logEvent(
        'deal_share_tapped',
        properties: {'dealId': dealId, 'dealType': type.routeValue},
      );
    }

    Future<void> openUrl(String url) async {
      final raw = url.trim();
      if (raw.isEmpty) return;
      final uri = Uri.tryParse(raw);
      if (uri == null) return;

      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (ok) {
        ClarityService.instance.logEvent(
          'deal_cta_tapped',
          properties: {
            'dealId': dealId,
            'dealType': type.routeValue,
            'action': 'open_url',
          },
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
        appBar: AppBar(
          title: Text(LocaleKeys.dealDetails.title.tr()),
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          actions: [
            IconButton(
              tooltip: LocaleKeys.dealDetails.actions.share.tr(),
              onPressed: shareDeal,
              icon: const Icon(Icons.share_outlined),
            ),
          ],
        ),
        body: detailsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) {
            final failure = error is Failure ? error : null;
            return _DealDetailsErrorView(
              message:
                  failure?.userMessage ??
                  LocaleKeys.dealDetails.errors.loadFailed.tr(),
              isNotFound: failure is NotFoundFailure,
              onRetry: controller.refresh,
            );
          },
          data: (data) {
            final title = switch (data.type) {
              DealDetailsType.product => data.productDeal?.title ?? '',
              DealDetailsType.store =>
                data.storeOffer?.localizedTitle(isArabic: isRTL) ?? '',
              DealDetailsType.bank =>
                data.bankOffer?.localizedTitle(isArabic: isRTL) ?? '',
            };

            final subtitle = switch (data.type) {
              DealDetailsType.product => (data.productDeal?.brand ?? '').trim(),
              DealDetailsType.store => 'Store offer',
              DealDetailsType.bank =>
                (data.bankOffer?.localizedBankName(isArabic: isRTL) ?? '')
                    .trim(),
            };

            final imageUrl = switch (data.type) {
              DealDetailsType.product =>
                (data.productDeal?.imageUrl ?? '').trim(),
              DealDetailsType.store => (data.storeOffer?.imageUrl ?? '').trim(),
              DealDetailsType.bank => (data.bankOffer?.imageUrl ?? '').trim(),
            };

            final description = switch (data.type) {
              DealDetailsType.product =>
                (data.productDeal?.description ?? '').trim(),
              DealDetailsType.store =>
                (data.storeOffer?.localizedDescription(isArabic: isRTL) ?? '')
                    .trim(),
              DealDetailsType.bank =>
                (data.bankOffer?.description ?? '').trim(),
            };

            final terms = switch (data.type) {
              DealDetailsType.product => null,
              DealDetailsType.store => data.storeOffer?.localizedTerms(
                isArabic: isRTL,
              ),
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

            Widget hero() {
              if (imageUrl.isEmpty) {
                return Container(
                  height: responsive.scale(220),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(responsive.scale(16)),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.local_offer_outlined,
                    size: responsive.scale(48),
                    color: colorScheme.onSurfaceVariant,
                  ),
                );
              }

              return ClipRRect(
                borderRadius: BorderRadius.circular(responsive.scale(16)),
                child: Image.network(
                  imageUrl,
                  height: responsive.scale(220),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: responsive.scale(220),
                    width: double.infinity,
                    color: colorScheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: responsive.scale(48),
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }

            Widget promoCodeCard() {
              final code = (promoCode ?? '').trim();
              if (code.isEmpty) return const SizedBox.shrink();

              return Container(
                padding: responsive.scalePadding(const EdgeInsets.all(12)),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(responsive.scale(12)),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.dealDetails.labels.promoCode.tr(),
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: responsive.scale(6)),
                          Text(
                            code,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: responsive.scale(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: responsive.scale(12)),
                    FilledButton.tonalIcon(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: code));
                        if (!context.mounted) return;
                        ScaffoldMessenger.maybeOf(context)
                          ?..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                LocaleKeys.dealDetails.success.promoCodeCopied
                                    .tr(),
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        ClarityService.instance.logEvent(
                          'deal_cta_tapped',
                          properties: {
                            'dealId': dealId,
                            'dealType': type.routeValue,
                            'action': 'copy_promo_code',
                          },
                        );
                      },
                      icon: const Icon(Icons.copy_rounded),
                      label: Text(LocaleKeys.buttons.copy.tr()),
                    ),
                  ],
                ),
              );
            }

            Widget termsSection() {
              final text = (terms ?? '').trim();
              if (text.isEmpty) return const SizedBox.shrink();

              final maxLines = isTermsExpanded.value ? null : 4;

              return Container(
                padding: responsive.scalePadding(const EdgeInsets.all(12)),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(responsive.scale(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.dealDetails.labels.terms.tr(),
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: responsive.scale(8)),
                    Text(
                      text,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: maxLines,
                      overflow: isTermsExpanded.value
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                    SizedBox(height: responsive.scale(8)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          isTermsExpanded.value = !isTermsExpanded.value;
                          ClarityService.instance.logEvent(
                            'deal_terms_toggled',
                            properties: {
                              'dealId': dealId,
                              'dealType': type.routeValue,
                              'expanded': isTermsExpanded.value,
                            },
                          );
                        },
                        child: Text(
                          isTermsExpanded.value
                              ? LocaleKeys.buttons.readLess.tr()
                              : LocaleKeys.buttons.readMore.tr(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            Widget productPriceSection() {
              final deal = data.productDeal;
              if (deal == null) return const SizedBox.shrink();

              final hasDiscount =
                  deal.originalPrice != null &&
                  deal.originalPrice! > deal.price;

              return Container(
                padding: responsive.scalePadding(const EdgeInsets.all(12)),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(responsive.scale(12)),
                ),
                child: Row(
                  children: [
                    Text(
                      '\$${deal.price.toStringAsFixed(2)}',
                      style: textTheme.headlineSmall?.copyWith(
                        color: hasDiscount
                            ? colorScheme.error
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (hasDiscount) ...[
                      SizedBox(width: responsive.scale(12)),
                      Text(
                        '\$${deal.originalPrice!.toStringAsFixed(2)}',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(width: responsive.scale(10)),
                      Container(
                        padding: responsive.scalePadding(
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          borderRadius: BorderRadius.circular(
                            responsive.scale(999),
                          ),
                        ),
                        child: Text(
                          '-${deal.calculatedDiscountPercentage}%',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onError,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }

            Widget descriptionSection() {
              if (description.isEmpty) return const SizedBox.shrink();
              return Text(
                description,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              );
            }

            Widget refUrlHint() {
              final url = (refUrl ?? '').trim();
              if (url.isEmpty) return const SizedBox.shrink();

              final borderRadius = BorderRadius.circular(responsive.scale(12));

              return Material(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: borderRadius,
                child: InkWell(
                  borderRadius: borderRadius,
                  onTap: () => openUrl(url),
                  child: Padding(
                    padding: responsive.scalePadding(const EdgeInsets.all(12)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.link_rounded,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: responsive.scale(10)),
                        Expanded(
                          child: Text(
                            url,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: responsive.scale(10)),
                        Icon(
                          Icons.open_in_new_rounded,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            Widget bottomActions() {
              final url = (refUrl ?? '').trim();
              final hasUrl = url.isNotEmpty;

              return SafeArea(
                top: false,
                child: Padding(
                  padding: responsive.scalePadding(
                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: hasUrl ? () => openUrl(url) : null,
                          icon: const Icon(Icons.open_in_new_rounded),
                          label: Text(
                            LocaleKeys.dealDetails.actions.shopNow.tr(),
                          ),
                        ),
                      ),
                      SizedBox(width: responsive.scale(12)),
                      IconButton.filledTonal(
                        tooltip: LocaleKeys.dealDetails.actions.share.tr(),
                        onPressed: shareDeal,
                        icon: const Icon(Icons.share_outlined),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: ListView(
                padding: responsive.scalePadding(const EdgeInsets.all(16)),
                children: [
                  hero(),
                  SizedBox(height: responsive.scale(16)),
                  Text(
                    title,
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: responsive.scale(6)),
                    Text(
                      subtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  SizedBox(height: responsive.scale(16)),
                  if (type == DealDetailsType.product) ...[
                    productPriceSection(),
                    SizedBox(height: responsive.scale(16)),
                  ],
                  descriptionSection(),
                  if (description.isNotEmpty)
                    SizedBox(height: responsive.scale(16)),
                  promoCodeCard(),
                  if ((promoCode ?? '').trim().isNotEmpty)
                    SizedBox(height: responsive.scale(16)),
                  termsSection(),
                  if ((terms ?? '').trim().isNotEmpty)
                    SizedBox(height: responsive.scale(16)),
                  refUrlHint(),
                  SizedBox(height: responsive.scale(24)),
                  bottomActions(),
                ],
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
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: responsive.scalePadding(const EdgeInsets.all(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isNotFound ? Icons.search_off_rounded : Icons.error_outline,
              size: responsive.scale(64),
              color: colorScheme.onSurfaceVariant.withAlpha(
                (0.6 * 255).round(),
              ),
            ),
            SizedBox(height: responsive.scale(16)),
            Text(
              isNotFound
                  ? LocaleKeys.dealDetails.errors.noLongerAvailable.tr()
                  : message,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsive.scale(16)),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: Text(
                LocaleKeys.buttons.retry.tr(),
                style: textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
