import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/deals/data/mock_data/deals_mock_data.dart';
import 'package:waffir/features/deals/data/repositories/deal_details_repository.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/stores/domain/entities/bank_offer.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';

class MockDealDetailsRepository implements DealDetailsRepository {
  const MockDealDetailsRepository();

  @override
  AsyncResult<Deal> fetchProductDealById({
    required String dealId,
    required String languageCode,
  }) async {
    try {
      final model = DealsMockData.hotDeals.firstWhere(
        (deal) => deal.id == dealId,
      );
      return Result.success(model.toDomain());
    } catch (_) {
      return Result.failure(
        Failure.notFound(message: 'Deal not found', code: 'DEAL_NOT_FOUND'),
      );
    }
  }

  @override
  AsyncResult<StoreOffer> fetchStoreOfferById({
    required String offerId,
    required String languageCode,
  }) async {
    return Result.failure(
      Failure.notFound(
        message: 'Offer not found',
        code: 'STORE_OFFER_NOT_FOUND',
      ),
    );
  }

  @override
  AsyncResult<BankOffer> fetchBankOfferById({
    required String offerId,
    required String languageCode,
  }) async {
    return Result.failure(
      Failure.notFound(
        message: 'Offer not found',
        code: 'BANK_OFFER_NOT_FOUND',
      ),
    );
  }
}
