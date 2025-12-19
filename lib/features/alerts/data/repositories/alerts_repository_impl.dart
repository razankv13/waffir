import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/alerts/data/datasources/alerts_remote_data_source.dart';
import 'package:waffir/features/alerts/domain/repositories/alerts_repository.dart';
import 'package:waffir/features/deals/domain/entities/alert.dart';

/// Concrete implementation of AlertsRepository
///
/// Wraps the remote data source with Result<T> error handling and
/// converts models to domain entities.
class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsRemoteDataSource _remoteDataSource;

  AlertsRepositoryImpl(this._remoteDataSource);

  @override
  AsyncResult<List<Alert>> fetchMyAlerts() async {
    try {
      final models = await _remoteDataSource.fetchMyAlerts();
      final alerts = models.map((m) => m.toDomain()).toList(growable: false);
      return Result.success(alerts);
    } on Failure catch (failure) {
      AppLogger.warning('⚠️ Repository: fetchMyAlerts failed - $failure');
      return Result.failure(failure);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Repository: Unexpected error in fetchMyAlerts', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  AsyncResult<Alert> createAlert({required String keyword}) async {
    try {
      final model = await _remoteDataSource.createAlert(keyword: keyword);
      return Result.success(model.toDomain());
    } on Failure catch (failure) {
      AppLogger.warning('⚠️ Repository: createAlert failed - $failure');
      return Result.failure(failure);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Repository: Unexpected error in createAlert', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  AsyncResult<void> deleteAlert({required String alertId}) async {
    try {
      await _remoteDataSource.deleteAlert(alertId: alertId);
      return const Result.success(null);
    } on Failure catch (failure) {
      AppLogger.warning('⚠️ Repository: deleteAlert failed - $failure');
      return Result.failure(failure);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Repository: Unexpected error in deleteAlert', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  AsyncResult<List<String>> fetchPopularKeywords() async {
    try {
      final keywords = await _remoteDataSource.fetchPopularKeywords();
      return Result.success(keywords);
    } on Failure catch (failure) {
      AppLogger.warning('⚠️ Repository: fetchPopularKeywords failed - $failure');
      return Result.failure(failure);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Repository: Unexpected error in fetchPopularKeywords', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }
}
