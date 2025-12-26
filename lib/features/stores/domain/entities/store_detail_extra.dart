import 'package:waffir/features/stores/domain/entities/store.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';

/// Navigation extras for passing store data to the detail screen.
///
/// This allows the detail screen to display data immediately without
/// refetching from the backend.
class StoreDetailExtra {
  const StoreDetailExtra({
    required this.store,
    required this.offers,
  });

  /// The store entity with populated topOffer.
  final Store store;

  /// Full list of offers for this store.
  final List<StoreOffer> offers;
}
