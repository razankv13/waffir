import 'package:waffir/features/stores/domain/entities/bank_offer.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank_card.dart';
import 'package:waffir/features/stores/domain/entities/my_bank_card.dart';

abstract class BankCatalogRemoteDataSource {
  Future<List<CatalogBank>> fetchActiveBanks({required String languageCode});

  Future<List<CatalogBankCard>> fetchActiveBankCards({
    required String languageCode,
  });

  Future<List<BankOffer>> fetchBankOffers({
    String? bankId,
    required String languageCode,
    String? searchQuery,
    String? categoryId,
    int limit = 20,
    int offset = 0,
  });

  Future<List<MyBankCard>> fetchMyBankCards({required String languageCode});

  Future<void> setMyBankCards({required List<String> bankCardIds});
}
