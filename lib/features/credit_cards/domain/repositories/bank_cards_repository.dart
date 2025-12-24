import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/credit_cards/domain/entities/credit_card.dart';

/// Repository interface for bank cards operations
///
/// Provides methods for fetching all bank cards and managing
/// the user's selected cards via Supabase.
abstract class BankCardsRepository {
  /// Fetches all active bank cards with their bank information
  ///
  /// Returns a list of [BankCard] entities with bank info joined.
  AsyncResult<List<BankCard>> fetchAllBankCards();

  /// Fetches the IDs of bank cards selected by the current user
  ///
  /// Returns empty set if user not authenticated or no cards selected.
  AsyncResult<Set<String>> fetchUserSelectedCardIds();

  /// Sets the user's selected bank cards
  ///
  /// Replaces all previous selections with the new set.
  /// Requires user to be authenticated.
  AsyncResult<void> setUserBankCards(Set<String> cardIds);
}
