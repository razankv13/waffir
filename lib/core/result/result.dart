import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waffir/core/errors/failures.dart';

part 'result.freezed.dart';

/// A generic Result type for handling success and failure cases
///
/// Use this instead of throwing exceptions in repositories and services.
/// Provides a declarative way to handle errors without try-catch blocks.
///
/// Example:
/// ```dart
/// Future<Result<User>> getUser() async {
///   try {
///     final user = await api.fetchUser();
///     return Result.success(user);
///   } catch (e) {
///     return Result.failure(Failure.network(message: 'Failed to fetch user'));
///   }
/// }
///
/// // Usage
/// final result = await getUser();
/// result.when(
///   success: (user) => print('Got user: $user'),
///   failure: (failure) => print('Error: ${failure.userMessage}'),
/// );
/// ```
@freezed
class Result<T> with _$Result<T> {
  const Result._();

  /// Represents a successful result containing data of type [T]
  const factory Result.success(T data) = Success<T>;

  /// Represents a failed result containing a [Failure]
  const factory Result.failure(Failure failure) = Failed<T>;

  /// Creates a Result from a nullable value
  ///
  /// If [value] is null, returns a failure with the provided [failure]
  /// Otherwise returns success with [value]
  factory Result.fromNullable(T? value, Failure failure) {
    return value != null ? Result.success(value) : Result.failure(failure);
  }

  /// Executes an async operation and wraps the result
  ///
  /// Catches exceptions and converts them to appropriate Failures
  /// Useful for wrapping external API calls
  static Future<Result<T>> guard<T>(Future<T> Function() operation) async {
    try {
      final value = await operation();
      return Result.success(value);
    } catch (e, stackTrace) {
      // Convert exceptions to failures
      if (e is Failure) {
        return Result.failure(e);
      }
      return Result.failure(
        Failure.unknown(
          message: 'Unexpected error occurred',
          originalError: e.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  /// Synchronously executes an operation and wraps the result
  ///
  /// Catches exceptions and converts them to appropriate Failures
  static Result<T> sync<T>(T Function() operation) {
    try {
      final value = operation();
      return Result.success(value);
    } catch (e, stackTrace) {
      if (e is Failure) {
        return Result.failure(e);
      }
      return Result.failure(
        Failure.unknown(
          message: 'Unexpected error occurred',
          originalError: e.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }
}

/// Type alias for cleaner async Result declarations
typedef AsyncResult<T> = Future<Result<T>>;
