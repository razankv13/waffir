import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/features/stores/data/providers/catalog_backend_providers.dart';
import 'package:waffir/features/stores/domain/entities/bank_offer.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank_card.dart';
import 'package:waffir/features/stores/domain/entities/my_bank_card.dart';
import 'package:waffir/features/stores/domain/repositories/bank_catalog_repository.dart';
import 'package:waffir/features/stores/presentation/controllers/bank_catalog_controller.dart';

class _MockBankCatalogRepository extends Mock implements BankCatalogRepository {}

void main() {
  group('BankCatalogController', () {
    late _MockBankCatalogRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = _MockBankCatalogRepository();
      container = ProviderContainer(
        overrides: [
          localeProvider.overrideWith((ref) => const Locale('en')),
          bankCatalogRepositoryProvider.overrideWithValue(repository),
        ],
      );
    });

    tearDown(() => container.dispose());

    BankOffer offer(String id) => BankOffer(
          id: id,
          bankId: 'bank-1',
          bankCardId: null,
          merchantStoreId: null,
          merchantNameText: null,
          title: 'Offer',
          titleAr: null,
          description: null,
          descriptionAr: null,
          termsText: null,
          termsTextAr: null,
          bankName: 'Bank',
          bankNameAr: null,
          bankCardName: null,
          bankCardNameAr: null,
          merchantNameAr: null,
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
        );

    test('applies category filter by passing categoryId to repository', () async {
      when(() => repository.fetchActiveBanks(languageCode: any(named: 'languageCode'))).thenAnswer(
        (_) async => Result.success(
          const <CatalogBank>[
            CatalogBank(id: 'bank-1', name: 'Bank', nameAr: null, logoUrl: null, isActive: true),
          ],
        ),
      );
      when(() => repository.fetchActiveBankCards(languageCode: any(named: 'languageCode'))).thenAnswer(
        (_) async => Result.success(
          const <CatalogBankCard>[
            CatalogBankCard(id: 'card-1', bankId: 'bank-1', name: 'Card', nameAr: null, imageUrl: null, isActive: true),
          ],
        ),
      );
      when(() => repository.fetchMyBankCards(languageCode: any(named: 'languageCode')))
          .thenAnswer((_) async => const Result.success(<MyBankCard>[]));

      when(
        () => repository.fetchBankOffers(
          bankId: any(named: 'bankId'),
          languageCode: any(named: 'languageCode'),
          searchQuery: any(named: 'searchQuery'),
          categoryId: any(named: 'categoryId'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((invocation) async {
        final categoryId = invocation.namedArguments[#categoryId] as String?;
        if (categoryId == 'cat-1') return Result.success(<BankOffer>[offer('filtered')]);
        return Result.success(<BankOffer>[offer('initial')]);
      });

      await container.read(bankCatalogControllerProvider.future);

      await container.read(bankCatalogControllerProvider.notifier).updateSelectedCategory('cat-1');

      verify(
        () => repository.fetchBankOffers(
          bankId: any(named: 'bankId'),
          languageCode: any(named: 'languageCode'),
          searchQuery: any(named: 'searchQuery'),
          categoryId: 'cat-1',
          limit: any(named: 'limit'),
          offset: 0,
        ),
      ).called(1);
    });
  });
}

