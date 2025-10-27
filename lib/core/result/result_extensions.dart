import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/errors/failures.dart';

/// Extensions for ergonomic Result handling
extension ResultX<T> on Result<T> {
  /// Returns true if this is a Success result
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a Failure result
  bool get isFailure => this is Failed<T>;

  /// Returns the success data or null if this is a failure
  T? get dataOrNull => when(
        success: (data) => data,
        failure: (_) => null,
      );

  /// Returns the failure or null if this is a success
  Failure? get failureOrNull => when(
        success: (_) => null,
        failure: (failure) => failure,
      );

  /// Returns the success data or throws the failure
  ///
  /// Use this when you need to propagate failures as exceptions
  T getOrThrow() => when(
        success: (data) => data,
        failure: (failure) => throw failure,
      );

  /// Returns the success data or a default value
  ///
  /// Example:
  /// ```dart
  /// final user = result.getOrElse(() => User.guest());
  /// ```
  T getOrElse(T Function() defaultValue) => when(
        success: (data) => data,
        failure: (_) => defaultValue(),
      );

  /// Maps the result using the provided functions
  ///
  /// Example:
  /// ```dart
  /// final message = result.mapResult(
  ///   success: (user) => 'Hello, ${user.name}',
  ///   failure: (error) => 'Error: ${error.userMessage}',
  /// );
  /// ```
  R mapResult<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) =>
      when(success: success, failure: failure);

  /// Transforms the success data, keeping failures unchanged
  ///
  /// Example:
  /// ```dart
  /// Result<String> userNameResult = userResult.mapData((user) => user.name);
  /// ```
  Result<R> mapData<R>(R Function(T data) transform) => when(
        success: (data) => Result.success(transform(data)),
        failure: (failure) => Result.failure(failure),
      );

  /// Transforms the failure, keeping success unchanged
  ///
  /// Example:
  /// ```dart
  /// final simplified = result.mapFailure(
  ///   (failure) => Failure.unknown(message: failure.userMessage),
  /// );
  /// ```
  Result<T> mapFailure(Failure Function(Failure failure) transform) => when(
        success: (data) => Result.success(data),
        failure: (failure) => Result.failure(transform(failure)),
      );

  /// Executes a callback if this is a success, returns this
  ///
  /// Useful for side effects like logging or navigation
  /// Example:
  /// ```dart
  /// result
  ///   .onSuccess((user) => print('Logged in: ${user.name}'))
  ///   .onFailure((error) => showError(error.userMessage));
  /// ```
  Result<T> onSuccess(void Function(T data) callback) {
    if (this is Success<T>) callback((this as Success<T>).data);
    return this;
  }

  /// Executes a callback if this is a failure, returns this
  ///
  /// Useful for side effects like logging or error reporting
  Result<T> onFailure(void Function(Failure failure) callback) {
    if (this is Failed<T>) callback((this as Failed<T>).failure);
    return this;
  }

  /// Chains another Result-returning operation on success
  ///
  /// Useful for sequential operations that depend on previous results
  /// Example:
  /// ```dart
  /// final result = await loginResult.flatMap(
  ///   (user) => fetchUserProfile(user.id),
  /// );
  /// ```
  Result<R> flatMap<R>(Result<R> Function(T data) transform) => when(
        success: (data) => transform(data),
        failure: (failure) => Result.failure(failure),
      );

  /// Async version of flatMap
  ///
  /// Example:
  /// ```dart
  /// final result = await loginResult.flatMapAsync(
  ///   (user) => repository.fetchProfile(user.id),
  /// );
  /// ```
  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T data) transform,
  ) async {
    return when(
      success: (data) => transform(data),
      failure: (failure) => Future.value(Result.failure(failure)),
    );
  }

  /// Folds the result into a single value
  ///
  /// Similar to mapResult but more functional
  /// Example:
  /// ```dart
  /// final count = result.fold(
  ///   onSuccess: (users) => users.length,
  ///   onFailure: (error) => 0,
  /// );
  /// ```
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) =>
      when(success: onSuccess, failure: onFailure);

  /// Swaps success and failure
  ///
  /// Useful in rare cases where you want to invert the result
  Result<Failure> swap() => when(
        success: (data) => Result.failure(
          Failure.unknown(message: 'Expected failure but got success'),
        ),
        failure: (failure) => Result.success(failure),
      );

  /// Combines two Results, returning success only if both succeed
  ///
  /// Example:
  /// ```dart
  /// final combined = userResult.combine(
  ///   settingsResult,
  ///   (user, settings) => UserProfile(user, settings),
  /// );
  /// ```
  Result<R> combine<T2, R>(
    Result<T2> other,
    R Function(T data1, T2 data2) combiner,
  ) {
    return flatMap((data1) {
      return other.mapData((data2) => combiner(data1, data2));
    });
  }

  /// Converts Result to a nullable value, discarding the error
  ///
  /// Use sparingly - prefer handling errors explicitly
  T? toNullable() => dataOrNull;

  /// Gets a user-friendly error message
  ///
  /// Returns null for success, the failure's userMessage for failure
  String? get errorMessage => when(
        success: (_) => null,
        failure: (failure) => failure.userMessage,
      );

  /// Checks if the failure is critical (if this is a failure)
  ///
  /// Returns false for success
  bool get isCriticalFailure => when(
        success: (_) => false,
        failure: (failure) => failure.isCritical,
      );

  /// Checks if the operation can be retried (if this is a failure)
  ///
  /// Returns false for success
  bool get canRetry => when(
        success: (_) => false,
        failure: (failure) => failure.canRetry,
      );
}

/// Extensions for Result<void>
extension ResultVoidX on Result<void> {
  /// Returns true if the void operation succeeded
  bool get isSuccessful => isSuccess;

  /// Converts Result<void> to Result<T> by providing a value on success
  ///
  /// Example:
  /// ```dart
  /// Result<void> deleteResult = await repository.delete(id);
  /// Result<bool> boolResult = deleteResult.mapToValue(true);
  /// ```
  Result<T> mapToValue<T>(T value) => when(
        success: (_) => Result.success(value),
        failure: (failure) => Result.failure(failure),
      );
}

/// Extensions for Lists of Results
extension ResultListX<T> on List<Result<T>> {
  /// Combines a list of Results into a single Result<List<T>>
  ///
  /// Returns failure if any Result is a failure
  /// Returns success with all data if all Results are successful
  ///
  /// Example:
  /// ```dart
  /// List<Result<User>> results = [result1, result2, result3];
  /// Result<List<User>> combined = results.sequence();
  /// ```
  Result<List<T>> sequence() {
    final data = <T>[];
    for (final result in this) {
      final value = result.dataOrNull;
      if (value == null) {
        // Found a failure, return it
        return Result.failure(result.failureOrNull!);
      }
      data.add(value);
    }
    return Result.success(data);
  }

  /// Filters out failures and returns only successful data
  ///
  /// Example:
  /// ```dart
  /// List<User> users = results.collectSuccesses();
  /// ```
  List<T> collectSuccesses() {
    return where((r) => r.isSuccess).map((r) => r.dataOrNull!).toList();
  }

  /// Filters out successes and returns only failures
  ///
  /// Useful for error reporting
  List<Failure> collectFailures() {
    return where((r) => r.isFailure).map((r) => r.failureOrNull!).toList();
  }
}

/// Extensions for Future<Result<T>>
extension FutureResultX<T> on Future<Result<T>> {
  /// Maps the success data asynchronously
  ///
  /// Example:
  /// ```dart
  /// Future<Result<String>> userName = repository.getUser()
  ///   .mapDataAsync((user) => user.name);
  /// ```
  Future<Result<R>> mapDataAsync<R>(R Function(T data) transform) async {
    final result = await this;
    return result.mapData(transform);
  }

  /// Chains another async Result operation on success
  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T data) transform,
  ) async {
    final result = await this;
    return result.flatMapAsync(transform);
  }

  /// Executes a callback on success
  Future<Result<T>> onSuccessAsync(void Function(T data) callback) async {
    final result = await this;
    return result.onSuccess(callback);
  }

  /// Executes a callback on failure
  Future<Result<T>> onFailureAsync(
    void Function(Failure failure) callback,
  ) async {
    final result = await this;
    return result.onFailure(callback);
  }

  /// Gets the data or null
  Future<T?> get dataOrNull async {
    final result = await this;
    return result.dataOrNull;
  }

  /// Gets the data or throws
  Future<T> getOrThrow() async {
    final result = await this;
    return result.getOrThrow();
  }

  /// Gets the data or a default value
  Future<T> getOrElse(T Function() defaultValue) async {
    final result = await this;
    return result.getOrElse(defaultValue);
  }
}
