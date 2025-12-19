import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/features/deals/data/providers/deal_details_providers.dart';
import 'package:waffir/features/deals/data/providers/deals_backend_providers.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/deals/domain/entities/deal_details_type.dart';
import 'package:waffir/features/stores/domain/entities/bank_offer.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';

typedef DealDetailsArgs = ({DealDetailsType type, String dealId});

class DealDetailsData {
  const DealDetailsData({
    required this.type,
    this.productDeal,
    this.storeOffer,
    this.bankOffer,
  });

  final DealDetailsType type;
  final Deal? productDeal;
  final StoreOffer? storeOffer;
  final BankOffer? bankOffer;
}

final dealDetailsControllerProvider = AsyncNotifierProvider.autoDispose
    .family<DealDetailsController, DealDetailsData, DealDetailsArgs>(
      DealDetailsController.new,
    );

class DealDetailsController extends AsyncNotifier<DealDetailsData> {
  DealDetailsController(this.args);

  final DealDetailsArgs args;

  @override
  Future<DealDetailsData> build() async {
    final link = ref.keepAlive();
    Timer? timer;
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 1), link.close);
    });
    ref.onResume(() {
      timer?.cancel();
      timer = null;
    });
    ref.onDispose(() {
      timer?.cancel();
    });

    return _load();
  }

  Future<DealDetailsData> _load() async {
    final languageCode = ref.watch(localeProvider).languageCode;
    final repo = ref.watch(dealDetailsRepositoryProvider);

    switch (args.type) {
      case DealDetailsType.product:
        final result = await repo.fetchProductDealById(
          dealId: args.dealId,
          languageCode: languageCode,
        );
        return result.when(
          success: (deal) {
            unawaited(
              ref
                  .read(dealsRepositoryProvider)
                  .trackDealView(dealId: args.dealId, dealType: 'product'),
            );
            return DealDetailsData(type: args.type, productDeal: deal);
          },
          failure: (failure) => throw failure,
        );
      case DealDetailsType.store:
        final result = await repo.fetchStoreOfferById(
          offerId: args.dealId,
          languageCode: languageCode,
        );
        return result.when(
          success: (offer) {
            unawaited(
              ref
                  .read(dealsRepositoryProvider)
                  .trackDealView(dealId: args.dealId, dealType: 'store'),
            );
            return DealDetailsData(type: args.type, storeOffer: offer);
          },
          failure: (failure) => throw failure,
        );
      case DealDetailsType.bank:
        final result = await repo.fetchBankOfferById(
          offerId: args.dealId,
          languageCode: languageCode,
        );
        return result.when(
          success: (offer) {
            unawaited(
              ref
                  .read(dealsRepositoryProvider)
                  .trackDealView(dealId: args.dealId, dealType: 'bank'),
            );
            return DealDetailsData(type: args.type, bankOffer: offer);
          },
          failure: (failure) => throw failure,
        );
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading<DealDetailsData>();
    state = await AsyncValue.guard(_load);
  }

  Failure? failureFrom(Object error) {
    if (error is Failure) return error;
    return null;
  }
}
