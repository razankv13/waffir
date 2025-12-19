import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:waffir/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:waffir/features/stores/domain/entities/store.dart';

/// Concrete implementation of favorites repository.
///
/// Wraps the remote data source with Result<T> error handling and
/// converts models to domain entities.
class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._remoteDataSource);

  final FavoritesRemoteDataSource _remoteDataSource;

  @override
  AsyncResult<List<Deal>> fetchFavoritedProducts({String languageCode = 'en'}) async {
    try {
      final models = await _remoteDataSource.fetchFavoritedProducts(
        languageCode: languageCode,
      );

      final deals = models.map((model) => model.toDomain()).toList(growable: false);

      return Result.success(deals);
    } on Failure catch (failure) {
      AppLogger.warning('⚠️ Repository: fetchFavoritedProducts failed - ${failure.message}');
      return Result.failure(failure);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Repository: Unexpected error in fetchFavoritedProducts', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  AsyncResult<List<Store>> fetchFavoritedStores({String languageCode = 'en'}) async {
    try {
      final models = await _remoteDataSource.fetchFavoritedStores(
        languageCode: languageCode,
      );

      final stores = models.map((model) => model.toDomain()).toList(growable: false);

      return Result.success(stores);
    } on Failure catch (failure) {
      AppLogger.warning('⚠️ Repository: fetchFavoritedStores failed - ${failure.message}');
      return Result.failure(failure);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Repository: Unexpected error in fetchFavoritedStores', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  AsyncResult<bool> toggleDealLike({
    required String dealId,
    String dealType = 'product',
  }) async {
    try {
      final nowLiked = await _remoteDataSource.toggleDealLike(
        dealId: dealId,
        dealType: dealType,
      );

      return Result.success(nowLiked);
    } on Failure catch (failure) {
      AppLogger.warning('⚠️ Repository: toggleDealLike failed - ${failure.message}');
      return Result.failure(failure);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Repository: Unexpected error in toggleDealLike', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  AsyncResult<bool> toggleStoreFavorite({required String storeId}) async {
    try {
      final nowFavorited = await _remoteDataSource.toggleStoreFavorite(
        storeId: storeId,
      );

      return Result.success(nowFavorited);
    } on Failure catch (failure) {
      AppLogger.warning('⚠️ Repository: toggleStoreFavorite failed - ${failure.message}');
      return Result.failure(failure);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Repository: Unexpected error in toggleStoreFavorite', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  AsyncResult<void> migrateFavorites({
    required List<String> productIds,
    required List<String> storeIds,
  }) async {
    try {
      await _remoteDataSource.migrateFavorites(
        productIds: productIds,
        storeIds: storeIds,
      );

      return const Result.success(null);
    } on Failure catch (failure) {
      AppLogger.warning('⚠️ Repository: migrateFavorites failed - ${failure.message}');
      return Result.failure(failure);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Repository: Unexpected error in migrateFavorites', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }
}
