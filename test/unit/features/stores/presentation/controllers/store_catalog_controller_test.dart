import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/data/providers/catalog_backend_providers.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';
import 'package:waffir/features/stores/domain/repositories/store_catalog_repository.dart';
import 'package:waffir/features/stores/presentation/controllers/store_catalog_controller.dart';

class _MockStoreCatalogRepository extends Mock implements StoreCatalogRepository {}

void main() {
  group('StoreCatalogController', () {
    late _MockStoreCatalogRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = _MockStoreCatalogRepository();
      container = ProviderContainer(
        overrides: [
          localeProvider.overrideWith((ref) => const Locale('en')),
          storeCatalogRepositoryProvider.overrideWithValue(repository),
        ],
      );
    });

    tearDown(() => container.dispose());

    StoreModel store() => StoreModel(
          id: 'store-1',
          name: 'Store',
          category: 'Other',
          imageUrl: '',
          isActive: true,
        );

    List<StoreOffer> page({required int offset, required int count}) {
      return List.generate(
        count,
        (index) => StoreOffer(
          id: 'offer-${offset + index}',
          storeId: 'store-1',
          title: 'Offer ${offset + index}',
          titleAr: null,
          description: null,
          descriptionAr: null,
          termsText: null,
          termsTextAr: null,
          discountMinPercent: null,
          discountMaxPercent: null,
          promoCode: null,
          onlineOrInstore: 'online',
          startDate: null,
          endDate: null,
          imageUrl: null,
          refUrl: null,
          popularityScore: null,
          createdAt: null,
        ),
      );
    }

    test('uses offset = current offers length for pagination', () async {
      when(() => repository.fetchStoreById(storeId: any(named: 'storeId'), languageCode: any(named: 'languageCode')))
          .thenAnswer((_) async => Result.success(store()));

      when(
        () => repository.fetchStoreOffers(
          storeId: any(named: 'storeId'),
          languageCode: any(named: 'languageCode'),
          searchQuery: any(named: 'searchQuery'),
          categoryId: any(named: 'categoryId'),
          limit: any(named: 'limit'),
          offset: 0,
        ),
      ).thenAnswer((_) async => Result.success(page(offset: 0, count: 20)));

      when(
        () => repository.fetchStoreOffers(
          storeId: any(named: 'storeId'),
          languageCode: any(named: 'languageCode'),
          searchQuery: any(named: 'searchQuery'),
          categoryId: any(named: 'categoryId'),
          limit: any(named: 'limit'),
          offset: 20,
        ),
      ).thenAnswer((_) async => Result.success(page(offset: 20, count: 5)));

      final args = StoreCatalogArgs(storeId: 'store-1');
      final provider = storeCatalogControllerProvider(args);
      final sub = container.listen(provider, (_, __) {});
      addTearDown(sub.close);

      // Build triggers store fetch; offers load is scheduled asynchronously.
      final initial = await container.read(provider.future);
      expect(initial.store.id, 'store-1');

      await untilCalled(
        () => repository.fetchStoreOffers(
          storeId: any(named: 'storeId'),
          languageCode: any(named: 'languageCode'),
          searchQuery: any(named: 'searchQuery'),
          categoryId: any(named: 'categoryId'),
          limit: any(named: 'limit'),
          offset: 0,
        ),
      );

      // Wait for offers load to complete (async reset load runs after build).
      for (var i = 0; i < 50; i++) {
        final state = container.read(provider).value;
        if (state != null && state.offers.length == 20 && !state.isLoadingOffers) {
          break;
        }
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }

      final loaded = container.read(provider).value!;
      expect(loaded.offers, hasLength(20));

      await container.read(provider.notifier).loadMore();

      verify(() => repository.fetchStoreOffers(
            storeId: 'store-1',
            languageCode: any(named: 'languageCode'),
            searchQuery: any(named: 'searchQuery'),
            categoryId: any(named: 'categoryId'),
            limit: any(named: 'limit'),
            offset: 20,
          )).called(1);
    });
  });
}
