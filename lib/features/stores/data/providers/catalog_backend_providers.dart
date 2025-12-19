import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/providers/supabase_providers.dart';
import 'package:waffir/features/stores/data/datasources/catalog_categories_remote_data_source.dart';
import 'package:waffir/features/stores/data/datasources/bank_catalog_remote_data_source.dart';
import 'package:waffir/features/stores/data/datasources/mock_catalog_categories_remote_data_source.dart';
import 'package:waffir/features/stores/data/datasources/mock_bank_catalog_remote_data_source.dart';
import 'package:waffir/features/stores/data/datasources/mock_store_catalog_remote_data_source.dart';
import 'package:waffir/features/stores/data/datasources/store_catalog_remote_data_source.dart';
import 'package:waffir/features/stores/data/datasources/supabase_catalog_categories_remote_data_source.dart';
import 'package:waffir/features/stores/data/datasources/supabase_bank_catalog_remote_data_source.dart';
import 'package:waffir/features/stores/data/datasources/supabase_store_catalog_remote_data_source.dart';
import 'package:waffir/features/stores/data/repositories/catalog_categories_repository_impl.dart';
import 'package:waffir/features/stores/data/repositories/bank_catalog_repository_impl.dart';
import 'package:waffir/features/stores/data/repositories/store_catalog_repository_impl.dart';
import 'package:waffir/features/stores/domain/repositories/catalog_categories_repository.dart';
import 'package:waffir/features/stores/domain/repositories/bank_catalog_repository.dart';
import 'package:waffir/features/stores/domain/repositories/store_catalog_repository.dart';

final storeCatalogRemoteDataSourceProvider =
    Provider<StoreCatalogRemoteDataSource>((ref) {
      try {
        final client = ref.watch(supabaseClientProvider);
        return SupabaseStoreCatalogRemoteDataSource(client);
      } catch (_) {
        return MockStoreCatalogRemoteDataSource();
      }
    });

final storeCatalogRepositoryProvider = Provider<StoreCatalogRepository>((ref) {
  final remote = ref.watch(storeCatalogRemoteDataSourceProvider);
  return StoreCatalogRepositoryImpl(remote);
});

final bankCatalogRemoteDataSourceProvider = Provider<BankCatalogRemoteDataSource>((
  ref,
) {
  try {
    final client = ref.watch(supabaseClientProvider);
    return SupabaseBankCatalogRemoteDataSource(client);
  } catch (_) {
    return MockBankCatalogRemoteDataSource();
  }
});

final bankCatalogRepositoryProvider = Provider<BankCatalogRepository>((ref) {
  final remote = ref.watch(bankCatalogRemoteDataSourceProvider);
  return BankCatalogRepositoryImpl(remote);
});

final catalogCategoriesRemoteDataSourceProvider =
    Provider<CatalogCategoriesRemoteDataSource>((ref) {
      try {
        final client = ref.watch(supabaseClientProvider);
        return SupabaseCatalogCategoriesRemoteDataSource(client);
      } catch (_) {
        return MockCatalogCategoriesRemoteDataSource();
      }
    });

final catalogCategoriesRepositoryProvider =
    Provider<CatalogCategoriesRepository>((ref) {
      final remote = ref.watch(catalogCategoriesRemoteDataSourceProvider);
      return CatalogCategoriesRepositoryImpl(remote);
    });
