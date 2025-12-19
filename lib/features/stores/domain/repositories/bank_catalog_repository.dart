import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/stores/domain/entities/bank_offer.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank_card.dart';
import 'package:waffir/features/stores/domain/entities/my_bank_card.dart';

abstract class BankCatalogRepository {
  AsyncResult<List<CatalogBank>> fetchActiveBanks({
    required String languageCode,
  });

  AsyncResult<List<CatalogBankCard>> fetchActiveBankCards({
    required String languageCode,
  });

  AsyncResult<List<BankOffer>> fetchBankOffers({
    String? bankId,
    required String languageCode,
    String? searchQuery,
    String? categoryId,
    int limit = 20,
    int offset = 0,
  });

  AsyncResult<List<MyBankCard>> fetchMyBankCards({
    required String languageCode,
  });

  AsyncResult<void> setMyBankCards({required List<String> bankCardIds});
}
