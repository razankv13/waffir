import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide AsyncResult;
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/features/deals/data/providers/deal_details_providers.dart';
import 'package:waffir/features/deals/data/repositories/deal_details_repository.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/deals/domain/entities/deal_details_type.dart';
import 'package:waffir/features/deals/domain/repositories/deals_repository.dart';
import 'package:waffir/features/deals/data/providers/deals_backend_providers.dart';
import 'package:waffir/features/deals/presentation/controllers/deal_details_controller.dart';
import 'package:waffir/features/stores/domain/entities/bank_offer.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';

class _FakeDealDetailsRepository implements DealDetailsRepository {
  _FakeDealDetailsRepository({
    this.productResult,
    this.storeResult,
    this.bankResult,
  });

  Result<Deal>? productResult;
  Result<StoreOffer>? storeResult;
  Result<BankOffer>? bankResult;

  @override
  AsyncResult<Deal> fetchProductDealById({
    required String dealId,
    required String languageCode,
  }) async {
    return productResult ??
        Result.failure(Failure.notFound(message: 'Missing', code: 'NOT_FOUND'));
  }

  @override
  AsyncResult<StoreOffer> fetchStoreOfferById({
    required String offerId,
    required String languageCode,
  }) async {
    return storeResult ??
        Result.failure(Failure.notFound(message: 'Missing', code: 'NOT_FOUND'));
  }

  @override
  AsyncResult<BankOffer> fetchBankOfferById({
    required String offerId,
    required String languageCode,
  }) async {
    return bankResult ??
        Result.failure(Failure.notFound(message: 'Missing', code: 'NOT_FOUND'));
  }
}

class _FakeDealsRepository implements DealsRepository {
  String? lastTrackedDealId;
  String? lastTrackedDealType;

  @override
  AsyncResult<List<Deal>> fetchHotDeals({
    String? category,
    String? searchQuery,
    String languageCode = 'en',
    int limit = 20,
    int offset = 0,
  }) async {
    return const Result.success(<Deal>[]);
  }

  @override
  AsyncResult<void> trackDealView({
    required String dealId,
    String dealType = 'product',
  }) async {
    lastTrackedDealId = dealId;
    lastTrackedDealType = dealType;
    return const Result.success(null);
  }

  @override
  AsyncResult<bool> toggleDealLike({
    required String dealId,
    String dealType = 'product',
  }) async {
    return const Result.success(true);
  }
}

Deal _deal(String id) {
  return Deal(
    id: id,
    title: 'T$id',
    description: 'D$id',
    price: 10,
    imageUrl: 'https://example.com/$id.png',
  );
}

void main() {
  test('DealDetailsController loads product deal and tracks view', () async {
    final fakeRepo = _FakeDealDetailsRepository(
      productResult: Result.success(_deal('d1')),
    );
    final fakeDealsRepo = _FakeDealsRepository();

    final container = ProviderContainer(
      overrides: [
        localeProvider.overrideWith((ref) => const Locale('en', 'US')),
        dealDetailsRepositoryProvider.overrideWithValue(fakeRepo),
        dealsRepositoryProvider.overrideWithValue(fakeDealsRepo),
      ],
    );
    addTearDown(container.dispose);

    final data = await container.read(
      dealDetailsControllerProvider((
        type: DealDetailsType.product,
        dealId: 'd1',
      )).future,
    );

    expect(data.productDeal?.id, 'd1');
    expect(fakeDealsRepo.lastTrackedDealId, 'd1');
    expect(fakeDealsRepo.lastTrackedDealType, 'product');
  });

  test('DealDetailsController surfaces not found failures', () async {
    final fakeRepo = _FakeDealDetailsRepository(
      storeResult: Result.failure(
        Failure.notFound(message: 'Missing', code: 'PGRST116'),
      ),
    );

    final container = ProviderContainer(
      overrides: [
        localeProvider.overrideWith((ref) => const Locale('en', 'US')),
        dealDetailsRepositoryProvider.overrideWithValue(fakeRepo),
      ],
    );
    addTearDown(container.dispose);

    final provider = dealDetailsControllerProvider((
      type: DealDetailsType.store,
      dealId: 's1',
    ));
    final sub = container.listen(provider, (_, __) {}, fireImmediately: true);
    addTearDown(sub.close);

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(provider);
    expect(state.hasError, isTrue);
    expect(state.error, isA<NotFoundFailure>());
  });
}
