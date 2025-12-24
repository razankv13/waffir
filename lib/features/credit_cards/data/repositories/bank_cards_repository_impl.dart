import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/credit_cards/data/datasources/bank_cards_remote_data_source.dart';
import 'package:waffir/features/credit_cards/domain/entities/credit_card.dart';
import 'package:waffir/features/credit_cards/domain/repositories/bank_cards_repository.dart';

/// Implementation of [BankCardsRepository] using Supabase remote data source
class BankCardsRepositoryImpl implements BankCardsRepository {
  BankCardsRepositoryImpl(this._remote);

  final BankCardsRemoteDataSource _remote;

  @override
  AsyncResult<List<BankCard>> fetchAllBankCards() {
    return Result.guard(() async {
      final models = await _remote.fetchAllBankCards();
      return models.map((m) => m.toDomain()).toList(growable: false);
    });
  }

  @override
  AsyncResult<Set<String>> fetchUserSelectedCardIds() {
    return Result.guard(() => _remote.fetchUserSelectedCardIds());
  }

  @override
  AsyncResult<void> setUserBankCards(Set<String> cardIds) {
    return Result.guard(() => _remote.setUserBankCards(cardIds));
  }
}
