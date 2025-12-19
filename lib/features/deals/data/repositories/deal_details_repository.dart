import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/stores/domain/entities/bank_offer.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';

abstract class DealDetailsRepository {
  AsyncResult<Deal> fetchProductDealById({
    required String dealId,
    required String languageCode,
  });

  AsyncResult<StoreOffer> fetchStoreOfferById({
    required String offerId,
    required String languageCode,
  });

  AsyncResult<BankOffer> fetchBankOfferById({
    required String offerId,
    required String languageCode,
  });
}
