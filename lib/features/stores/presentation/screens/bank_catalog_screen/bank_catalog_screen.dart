import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/features/deals/domain/entities/deal_details_type.dart';
import 'package:waffir/features/stores/domain/entities/bank_offer.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank_card.dart';
import 'package:waffir/features/stores/domain/entities/catalog_category.dart';
import 'package:waffir/features/stores/presentation/controllers/bank_catalog_controller.dart';
import 'package:waffir/features/stores/presentation/controllers/catalog_categories_controller.dart';
import 'package:waffir/features/stores/presentation/widgets/catalog_search_filter_bar.dart';
import 'package:waffir/features/stores/presentation/widgets/catalog_status_card.dart';

class BankCatalogScreen extends HookConsumerWidget {
  const BankCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final searchController = useTextEditingController();
    final uiSelectedBankId = useState<String?>(null);
    final uiSelectedCategoryId = useState<String?>(null);
    final isArabic =
        Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';
    final debounce = useRef<Timer?>(null);

    useEffect(() {
      return () {
        debounce.value?.cancel();
      };
    }, const []);

    final state = ref.watch(bankCatalogControllerProvider);
    final controller = ref.read(bankCatalogControllerProvider.notifier);
    final categoriesState = ref.watch(catalogCategoriesControllerProvider);

    useEffect(() {
      final selectedBankId = state.value?.selectedBankId;
      if (uiSelectedBankId.value != selectedBankId) {
        uiSelectedBankId.value = selectedBankId;
      }
      return null;
    }, [state.value?.selectedBankId]);

    useEffect(() {
      final selectedCategoryId = state.value?.selectedCategoryId;
      if (uiSelectedCategoryId.value != selectedCategoryId) {
        uiSelectedCategoryId.value = selectedCategoryId;
      }
      return null;
    }, [state.value?.selectedCategoryId]);

    ref.listen(bankCatalogControllerProvider, (previous, next) {
      final previousFailure = previous?.value?.lastActionFailure;
      final nextFailure = next.value?.lastActionFailure;
      if (nextFailure == null || nextFailure == previousFailure) return;
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.clearSnackBars();
      messenger?.showSnackBar(SnackBar(content: Text(nextFailure.userMessage)));
    });

    void openMyCardsSheet(BankCatalogState data) {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        final messenger = ScaffoldMessenger.maybeOf(context);
        messenger?.clearSnackBars();
        messenger?.showSnackBar(
          const SnackBar(
            content: Text('Please sign in to manage your cards.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: colorScheme.surface,
        builder: (context) {
          final localSelected = {...data.selectedBankCardIds};

          return StatefulBuilder(
            builder: (context, setLocalState) {
              return Padding(
                padding: responsive.scalePadding(
                  EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 16 + responsive.bottomSafeArea,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'My Cards',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.scale(12)),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: data.bankCards.length,
                        separatorBuilder: (context, _) =>
                            SizedBox(height: responsive.scale(8)),
                        itemBuilder: (context, index) {
                          final card = data.bankCards[index];
                          final isSelected = localSelected.contains(card.id);
                          return Material(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(
                              responsive.scale(12),
                            ),
                            child: SwitchListTile(
                              value: isSelected,
                              onChanged: (value) {
                                setLocalState(() {
                                  if (value) {
                                    localSelected.add(card.id);
                                  } else {
                                    localSelected.remove(card.id);
                                  }
                                });
                              },
                              title: Text(
                                card.localizedName(isArabic: isArabic),
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                data.bankById[card.bankId]?.localizedName(
                                      isArabic: isArabic,
                                    ) ??
                                    '',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: responsive.scale(16)),
                    FilledButton(
                      onPressed: data.isSavingCards
                          ? null
                          : () async {
                              // Apply local changes to controller state before saving.
                              final current = ref
                                  .read(bankCatalogControllerProvider)
                                  .value;
                              if (current != null) {
                                for (final id
                                    in current.selectedBankCardIds.difference(
                                      localSelected,
                                    )) {
                                  controller.toggleCardSelection(id);
                                }
                                for (final id in localSelected.difference(
                                  current.selectedBankCardIds,
                                )) {
                                  controller.toggleCardSelection(id);
                                }
                              }
                              await controller.saveSelectedCards();
                              if (context.mounted) Navigator.of(context).pop();
                            },
                      child: Text(data.isSavingCards ? 'Saving…' : 'Save'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    Widget bodyFor(BankCatalogState data) {
      final categories = categoriesState.value ?? const <CatalogCategory>[];

      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (data.isLoadingOffers || data.isLoadingMore || !data.hasMore)
            return false;
          if (notification.metrics.extentAfter > responsive.scale(500))
            return false;
          controller.loadMore();
          return false;
        },
        child: ListView(
          padding: EdgeInsets.only(
            left: responsive.scale(16),
            right: responsive.scale(16),
            top: responsive.scale(16),
            bottom: responsive.scale(24) + responsive.bottomSafeArea,
          ),
          children: [
            CatalogSearchFilterBar(
              controller: searchController,
              onSearchChanged: (value) {
                debounce.value?.cancel();
                debounce.value = Timer(const Duration(milliseconds: 350), () {
                  if (!context.mounted) return;
                  controller.updateSearch(value);
                });
              },
              filters: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        value: uiSelectedBankId.value,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              responsive.scale(12),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: responsive.scalePadding(
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('All banks'),
                          ),
                          ...data.banks.map(
                            (bank) => DropdownMenuItem<String?>(
                              value: bank.id,
                              child: Text(
                                bank.localizedName(isArabic: isArabic),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          uiSelectedBankId.value = value;
                          controller.updateSelectedBank(value);
                        },
                      ),
                    ),
                    SizedBox(width: responsive.scale(12)),
                    OutlinedButton(
                      onPressed: () => openMyCardsSheet(data),
                      child: const Text('My Cards'),
                    ),
                  ],
                ),
                DropdownButtonFormField<String?>(
                  value: uiSelectedCategoryId.value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(responsive.scale(12)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: responsive.scalePadding(
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('All categories'),
                    ),
                    ...categories.map(
                      (category) => DropdownMenuItem<String?>(
                        value: category.id,
                        child: Text(category.localizedName(isArabic: isArabic)),
                      ),
                    ),
                  ],
                  onChanged: categoriesState.isLoading
                      ? null
                      : (value) {
                          uiSelectedCategoryId.value = value;
                          controller.updateSelectedCategory(value);
                        },
                ),
              ],
            ),
            SizedBox(height: responsive.scale(16)),
            Text(
              'Bank Offers',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: responsive.scale(12)),
            if (data.isLoadingOffers && data.offers.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: responsive.scale(16)),
                child: const Center(child: CircularProgressIndicator()),
              )
            else if (data.offers.isEmpty && data.offersFailure == null)
              const CatalogStatusCard(
                variant: CatalogStatusCardVariant.empty,
                message: 'No offers available right now.',
              )
            else if (data.offersFailure != null)
              CatalogStatusCard(
                variant: CatalogStatusCardVariant.error,
                message: data.offersFailure!.userMessage,
                actionLabel: 'Retry',
                onAction: controller.refresh,
              )
            else
              ...data.offers.map((offer) => _BankOfferTile(offer: offer)),
            if (data.isLoadingMore)
              Padding(
                padding: EdgeInsets.symmetric(vertical: responsive.scale(16)),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Banks'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: controller.refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: responsive.scalePadding(const EdgeInsets.all(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: responsive.scale(64),
                  color: colorScheme.onSurfaceVariant,
                ),
                SizedBox(height: responsive.scale(12)),
                Text(
                  'Failed to load banks.',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: responsive.scale(16)),
                FilledButton(
                  onPressed: controller.refresh,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: bodyFor,
      ),
    );
  }
}

class _BankOfferTile extends StatelessWidget {
  const _BankOfferTile({required this.offer});

  final BankOffer offer;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isArabic =
        Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';

    String? discountLabel() {
      final min = offer.discountMinPercent;
      final max = offer.discountMaxPercent;
      if (min == null && max == null) return null;
      if (min != null && max != null && min != max)
        return '${min.toString()}% - ${max.toString()}%';
      final value = (max ?? min);
      return value == null ? null : '${value.toString()}%';
    }

    final label = discountLabel();

    final borderRadius = BorderRadius.circular(responsive.scale(12));

    return Padding(
      padding: EdgeInsets.only(bottom: responsive.scale(12)),
      child: Material(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () {
            context.pushNamed(
              AppRouteNames.dealDetail,
              pathParameters: {
                'type': DealDetailsType.bank.routeValue,
                'id': offer.id,
              },
            );
          },
          child: Padding(
            padding: responsive.scalePadding(const EdgeInsets.all(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: responsive.scale(64),
                  height: responsive.scale(64),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(responsive.scale(10)),
                  ),
                  child:
                      offer.imageUrl == null || offer.imageUrl!.trim().isEmpty
                      ? Icon(
                          Icons.local_offer_outlined,
                          color: colorScheme.onSurfaceVariant,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(
                            responsive.scale(10),
                          ),
                          child: Image.network(
                            offer.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.local_offer_outlined,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                ),
                SizedBox(width: responsive.scale(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.localizedTitle(isArabic: isArabic),
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: responsive.scale(4)),
                      Text(
                        offer.localizedBankName(isArabic: isArabic) ?? '',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (label != null) ...[
                        SizedBox(height: responsive.scale(8)),
                        Container(
                          padding: responsive.scalePadding(
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(
                              responsive.scale(999),
                            ),
                          ),
                          child: Text(
                            label,
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
