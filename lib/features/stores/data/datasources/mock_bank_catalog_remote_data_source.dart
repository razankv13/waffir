import 'package:waffir/features/stores/data/datasources/bank_catalog_remote_data_source.dart';
import 'package:waffir/features/stores/domain/entities/bank_offer.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank_card.dart';
import 'package:waffir/features/stores/domain/entities/my_bank_card.dart';

class MockBankCatalogRemoteDataSource implements BankCatalogRemoteDataSource {
  @override
  Future<List<CatalogBank>> fetchActiveBanks({
    required String languageCode,
  }) async {
    return const <CatalogBank>[];
  }

  @override
  Future<List<CatalogBankCard>> fetchActiveBankCards({
    required String languageCode,
  }) async {
    return const <CatalogBankCard>[];
  }

  @override
  Future<List<BankOffer>> fetchBankOffers({
    String? bankId,
    required String languageCode,
    String? searchQuery,
    String? categoryId,
    int limit = 20,
    int offset = 0,
  }) async {
    return const <BankOffer>[];
  }

  @override
  Future<List<MyBankCard>> fetchMyBankCards({
    required String languageCode,
  }) async {
    return const <MyBankCard>[];
  }

  @override
  Future<void> setMyBankCards({required List<String> bankCardIds}) async {}
}
