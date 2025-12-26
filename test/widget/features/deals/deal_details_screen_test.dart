import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/core/themes/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide AsyncResult;
import 'package:waffir/features/deals/data/providers/deal_details_providers.dart';
import 'package:waffir/features/deals/data/providers/deals_backend_providers.dart';
import 'package:waffir/features/deals/data/repositories/deal_details_repository.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/deals/domain/entities/deal_details_type.dart';
import 'package:waffir/features/deals/domain/repositories/deals_repository.dart';
import 'package:waffir/features/deals/presentation/screens/deal_details_screen/deal_details_screen.dart';
import 'package:waffir/features/stores/domain/entities/bank_offer.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';

class _StubDealDetailsRepository implements DealDetailsRepository {
  _StubDealDetailsRepository(this.storeOffer);

  final StoreOffer storeOffer;

  @override
  AsyncResult<Deal> fetchProductDealById({
    required String dealId,
    required String languageCode,
  }) async {
    return Result.success(
      Deal(id: dealId, title: 'T', description: 'D', price: 1, imageUrl: ''),
    );
  }

  @override
  AsyncResult<StoreOffer> fetchStoreOfferById({
    required String offerId,
    required String languageCode,
  }) async {
    return Result.success(storeOffer);
  }

  @override
  AsyncResult<BankOffer> fetchBankOfferById({
    required String offerId,
    required String languageCode,
  }) async {
    return Result.failure(
      Failure.notFound(message: 'Missing', code: 'NOT_FOUND'),
    );
  }
}

class _StubDealsRepository implements DealsRepository {
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();
  });

  Widget wrap(dynamic overrides, Widget child) {
    return EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      saveLocale: false,
      child: Builder(
        builder: (context) {
          return ProviderScope(
            overrides: overrides,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(393, 852)),
              child: MaterialApp(
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.lightTheme,
                themeMode: ThemeMode.light,
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                home: child,
              ),
            ),
          );
        },
      ),
    );
  }

  testWidgets('DealDetailsScreen renders store offer title', (tester) async {
    final storeOffer = StoreOffer(
      id: 'o1',
      storeId: 's1',
      title: 'Store Offer Title',
      description: 'Desc',
      refUrl: 'https://example.com',
    );

    final dynamic overrides = [
      localeProvider.overrideWith((ref) => const Locale('en', 'US')),
      dealDetailsRepositoryProvider.overrideWithValue(
        _StubDealDetailsRepository(storeOffer),
      ),
      dealsRepositoryProvider.overrideWithValue(_StubDealsRepository()),
    ];

    await tester.pumpWidget(
      wrap(
        overrides,
        const DealDetailsScreen(dealId: 'o1', type: DealDetailsType.store),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    expect(find.text('Store Offer Title'), findsOneWidget);
    expect(find.text('Deal Details'), findsOneWidget);
    expect(find.text('Shop now'), findsOneWidget);
  });
}
