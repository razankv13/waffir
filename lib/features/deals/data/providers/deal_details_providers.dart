import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/providers/supabase_providers.dart';
import 'package:waffir/features/deals/data/repositories/deal_details_repository.dart';
import 'package:waffir/features/deals/data/repositories/mock_deal_details_repository.dart';
import 'package:waffir/features/deals/data/repositories/supabase_deal_details_repository.dart';

final dealDetailsRepositoryProvider = Provider<DealDetailsRepository>((ref) {
  final useMock =
      EnvironmentConfig.useMockDeals && EnvironmentConfig.useMockStores;
  if (useMock) {
    return const MockDealDetailsRepository();
  }

  try {
    final client = ref.watch(supabaseClientProvider);
    return SupabaseDealDetailsRepository(client);
  } catch (e) {
    throw Failure.configuration(
      message:
          'Supabase is not initialized. Ensure SUPABASE_URL and SUPABASE_ANON_KEY are set.',
      code: 'SUPABASE_NOT_INITIALIZED',
    );
  }
});
