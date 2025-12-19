import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/stores/data/datasources/bank_catalog_remote_data_source.dart';
import 'package:waffir/features/stores/domain/entities/bank_offer.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank_card.dart';
import 'package:waffir/features/stores/domain/entities/my_bank_card.dart';
import 'package:waffir/features/stores/domain/repositories/bank_catalog_repository.dart';

class BankCatalogRepositoryImpl implements BankCatalogRepository {
  BankCatalogRepositoryImpl(this._remote);

  final BankCatalogRemoteDataSource _remote;

  @override
  AsyncResult<List<CatalogBank>> fetchActiveBanks({
    required String languageCode,
  }) {
    return Result.guard(
      () => _remote.fetchActiveBanks(languageCode: languageCode),
    );
  }

  @override
  AsyncResult<List<CatalogBankCard>> fetchActiveBankCards({
    required String languageCode,
  }) {
    return Result.guard(
      () => _remote.fetchActiveBankCards(languageCode: languageCode),
    );
  }

  @override
  AsyncResult<List<BankOffer>> fetchBankOffers({
    String? bankId,
    required String languageCode,
    String? searchQuery,
    String? categoryId,
    int limit = 20,
    int offset = 0,
  }) {
    return Result.guard(
      () => _remote.fetchBankOffers(
        bankId: bankId,
        languageCode: languageCode,
        searchQuery: searchQuery,
        categoryId: categoryId,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  AsyncResult<List<MyBankCard>> fetchMyBankCards({
    required String languageCode,
  }) {
    return Result.guard(
      () => _remote.fetchMyBankCards(languageCode: languageCode),
    );
  }

  @override
  AsyncResult<void> setMyBankCards({required List<String> bankCardIds}) {
    return Result.guard(() => _remote.setMyBankCards(bankCardIds: bankCardIds));
  }
}
