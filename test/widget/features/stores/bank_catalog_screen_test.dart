import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/features/stores/data/providers/catalog_backend_providers.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank_card.dart';
import 'package:waffir/features/stores/domain/entities/my_bank_card.dart';
import 'package:waffir/features/stores/domain/repositories/bank_catalog_repository.dart';
import 'package:waffir/features/stores/domain/repositories/catalog_categories_repository.dart';
import 'package:waffir/features/stores/presentation/screens/bank_catalog_screen/bank_catalog_screen.dart';

class _MockBankCatalogRepository extends Mock implements BankCatalogRepository {}

class _MockCatalogCategoriesRepository extends Mock implements CatalogCategoriesRepository {}

void main() {
  testWidgets('BankCatalogScreen renders empty offers state', (tester) async {
    final bankRepo = _MockBankCatalogRepository();
    final categoriesRepo = _MockCatalogCategoriesRepository();

    when(() => bankRepo.fetchActiveBanks(languageCode: any(named: 'languageCode'))).thenAnswer(
      (_) async => Result.success(
        const <CatalogBank>[
          CatalogBank(id: 'bank-1', name: 'Bank', nameAr: null, logoUrl: null, isActive: true),
        ],
      ),
    );
    when(() => bankRepo.fetchActiveBankCards(languageCode: any(named: 'languageCode'))).thenAnswer(
      (_) async => Result.success(
        const <CatalogBankCard>[
          CatalogBankCard(id: 'card-1', bankId: 'bank-1', name: 'Card', nameAr: null, imageUrl: null, isActive: true),
        ],
      ),
    );
    when(() => bankRepo.fetchMyBankCards(languageCode: any(named: 'languageCode')))
        .thenAnswer((_) async => const Result.success(<MyBankCard>[]));
    when(
      () => bankRepo.fetchBankOffers(
        bankId: any(named: 'bankId'),
        languageCode: any(named: 'languageCode'),
        searchQuery: any(named: 'searchQuery'),
        categoryId: any(named: 'categoryId'),
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer((_) async => const Result.success([]));

    when(() => categoriesRepo.fetchActiveCategories(languageCode: any(named: 'languageCode')))
        .thenAnswer((_) async => const Result.success([]));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localeProvider.overrideWith((ref) => const Locale('en')),
          bankCatalogRepositoryProvider.overrideWithValue(bankRepo),
          catalogCategoriesRepositoryProvider.overrideWithValue(categoriesRepo),
        ],
        child: const MaterialApp(home: BankCatalogScreen()),
      ),
    );

    // Initial loading.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Banks'), findsOneWidget);
    expect(find.text('Bank Offers'), findsOneWidget);
    expect(find.text('No offers available right now.'), findsOneWidget);
  });
}

