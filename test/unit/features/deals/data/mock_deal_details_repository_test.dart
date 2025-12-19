import 'package:flutter_test/flutter_test.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/deals/data/mock_data/deals_mock_data.dart';
import 'package:waffir/features/deals/data/repositories/mock_deal_details_repository.dart';

void main() {
  test(
    'MockDealDetailsRepository returns a product deal when id exists',
    () async {
      final repo = const MockDealDetailsRepository();
      final id = DealsMockData.hotDeals.first.id;

      final result = await repo.fetchProductDealById(
        dealId: id,
        languageCode: 'en',
      );

      result.when(
        success: (deal) => expect(deal.id, id),
        failure: (failure) => fail('Expected success, got $failure'),
      );
    },
  );

  test(
    'MockDealDetailsRepository returns NotFoundFailure when product deal id is missing',
    () async {
      final repo = const MockDealDetailsRepository();

      final result = await repo.fetchProductDealById(
        dealId: 'missing-id',
        languageCode: 'en',
      );

      result.when(
        success: (_) => fail('Expected failure'),
        failure: (failure) => expect(failure, isA<NotFoundFailure>()),
      );
    },
  );
}
