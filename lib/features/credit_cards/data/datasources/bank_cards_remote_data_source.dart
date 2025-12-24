import 'package:waffir/features/credit_cards/data/models/credit_card_model.dart';

/// Remote data source interface for bank cards operations
///
/// Defines the contract for fetching bank cards data and managing
/// user's selected cards from Supabase.
abstract class BankCardsRemoteDataSource {
  /// Fetches all active bank cards with their bank information
  ///
  /// Returns a list of [BankCardModel] with bank info joined.
  /// Throws [Failure] on error.
  Future<List<BankCardModel>> fetchAllBankCards();

  /// Fetches the IDs of bank cards selected by the current user
  ///
  /// Uses RPC `get_my_bank_cards()`.
  /// Returns empty set if user not authenticated or no cards selected.
  /// Throws [Failure] on error.
  Future<Set<String>> fetchUserSelectedCardIds();

  /// Sets the user's selected bank cards
  ///
  /// Uses RPC `set_user_bank_cards(p_bank_card_ids)`.
  /// Replaces all previous selections with the new set.
  /// Throws [Failure] on error or if not authenticated.
  Future<void> setUserBankCards(Set<String> cardIds);
}
