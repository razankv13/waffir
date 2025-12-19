import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/alerts/data/providers/alerts_backend_providers.dart';

/// Provider for fetching popular/trending alert keywords.
///
/// Returns a list of popular keywords that users can subscribe to.
/// Returns empty list on failure to maintain a graceful UX.
final popularKeywordsProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(alertsRepositoryProvider);
  final result = await repository.fetchPopularKeywords();

  return result.when(
    success: (keywords) => keywords,
    failure: (_) => <String>[],
  );
});
