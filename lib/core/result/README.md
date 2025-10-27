# Result<T> Pattern - Complete Guide

A comprehensive, production-ready Result<T> pattern implementation for Flutter apps using Freezed and functional programming principles.

## Overview

The `Result<T>` type provides a type-safe, declarative way to handle success and failure cases without throwing exceptions. It integrates seamlessly with your existing `Failure` types and Riverpod state management.

## Table of Contents

- [Core Concept](#core-concept)
- [Basic Usage](#basic-usage)
- [Repository Pattern](#repository-pattern)
- [Controller/ViewModel Pattern](#controllerviewmodel-pattern)
- [Advanced Usage](#advanced-usage)
- [Extension Methods](#extension-methods)
- [Best Practices](#best-practices)
- [Migration Guide](#migration-guide)

---

## Core Concept

```dart
@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = Failed<T>;
}
```

**Key Benefits:**
- ✅ Type-safe error handling
- ✅ No silent failures
- ✅ Composable and chainable
- ✅ Works perfectly with existing `Failure` types
- ✅ Integrates with Riverpod's `AsyncValue`

---

## Basic Usage

### 1. Returning Success

```dart
// With data
Future<Result<User>> getUser(String id) async {
  final user = await api.fetchUser(id);
  return Result.success(user);
}

// With void (for operations with no return value)
Future<Result<void>> deleteUser(String id) async {
  await api.deleteUser(id);
  return const Result.success(null);
}
```

### 2. Returning Failure

```dart
Future<Result<User>> getUser(String id) async {
  try {
    final user = await api.fetchUser(id);
    return Result.success(user);
  } catch (e, stackTrace) {
    return Result.failure(
      ExceptionToFailure.convert(e, stackTrace),
    );
  }
}
```

### 3. Using Result.guard

The `Result.guard` helper automatically wraps async operations and converts exceptions to `Failure`:

```dart
Future<Result<User>> getUser(String id) async {
  return Result.guard(() async {
    final user = await api.fetchUser(id);
    return user;
  });
}
```

### 4. Handling Results with `.when()`

```dart
final result = await repository.getUser('123');

result.when(
  success: (user) {
    print('Got user: ${user.name}');
    // Update UI, navigate, etc.
  },
  failure: (failure) {
    print('Error: ${failure.userMessage}');
    // Show error, log, etc.
  },
);
```

---

## Repository Pattern

### Before: Throwing Exceptions

```dart
class UserRepository {
  Future<User> getUser(String id) async {
    try {
      final response = await api.get('/users/$id');
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get user');
    }
  }
}
```

**Problems:**
- Caller must remember to wrap in try-catch
- Easy to forget error handling
- No compile-time safety

### After: Using Result<T>

```dart
class UserRepository {
  AsyncResult<User> getUser(String id) async {
    try {
      final response = await api.get('/users/$id');
      final user = User.fromJson(response.data);
      return Result.success(user);
    } on NetworkException catch (e) {
      return Result.failure(Failure.network(message: e.message));
    } on ServerException catch (e) {
      return Result.failure(Failure.server(message: e.message, statusCode: e.statusCode));
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }

  // Using Result.guard for cleaner code
  AsyncResult<User> getUserSimplified(String id) async {
    return Result.guard(() async {
      final response = await api.get('/users/$id');
      return User.fromJson(response.data);
    });
  }

  // Handling nullable values
  AsyncResult<User> getUserById(String id) async {
    try {
      final user = await api.getUserOrNull(id);

      // Convert null to Result.failure
      if (user == null) {
        return const Result.failure(
          Failure.notFound(message: 'User not found'),
        );
      }

      return Result.success(user);
    } catch (e, stackTrace) {
      return Result.failure(ExceptionToFailure.convert(e, stackTrace));
    }
  }
}
```

---

## Controller/ViewModel Pattern

### Riverpod AsyncNotifier with Result<T>

```dart
class UserController extends AsyncNotifier<UserState> {
  @override
  Future<UserState> build() async {
    return const UserState.initial();
  }

  /// Fetch user - updates AsyncNotifier state
  Future<void> fetchUser(String id) async {
    state = const AsyncValue.loading();

    final result = await ref.read(userRepositoryProvider).getUser(id);

    result.when(
      success: (user) {
        state = AsyncValue.data(UserState.loaded(user));
      },
      failure: (failure) {
        AppLogger.error('Failed to fetch user: ${failure.message}');
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  /// Delete user - returns Result directly
  Future<Result<void>> deleteUser(String id) async {
    final result = await ref.read(userRepositoryProvider).deleteUser(id);

    result.when(
      success: (_) {
        AppLogger.info('User deleted successfully');
      },
      failure: (failure) {
        AppLogger.error('Failed to delete user: ${failure.message}');
      },
    );

    return result; // Return for caller to handle if needed
  }
}
```

### UI Integration

```dart
class UserScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userControllerProvider);

    return userState.when(
      data: (state) => state.when(
        initial: () => Text('Press button to load'),
        loaded: (user) => UserCard(user: user),
        empty: () => Text('No user found'),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) {
        // error is a Failure object
        if (error is Failure) {
          return ErrorView(
            message: error.userMessage,
            canRetry: error.canRetry,
            onRetry: () => ref.read(userControllerProvider.notifier).fetchUser('123'),
          );
        }
        return ErrorView(message: 'Unknown error occurred');
      },
    );
  }
}
```

---

## Advanced Usage

### 1. Chaining Operations with `flatMap`

```dart
final result = await userRepository.getUser('123')
  .then((userResult) => userResult.flatMapAsync(
    (user) => profileRepository.getProfile(user.id),
  ));
```

### 2. Transforming Success Data with `mapData`

```dart
// Transform User to UserDTO
Result<UserDTO> dtoResult = userResult.mapData(
  (user) => UserDTO.fromUser(user),
);

// Or async
Future<Result<UserDTO>> dtoResult = userResult.mapDataAsync(
  (user) async => await transform(user),
);
```

### 3. Combining Multiple Results

```dart
final userResult = await repository.getUser('123');
final settingsResult = await repository.getSettings('123');

final combined = userResult.combine(
  settingsResult,
  (user, settings) => UserProfile(user: user, settings: settings),
);
```

### 4. Collecting Multiple Results

```dart
List<Result<User>> results = [
  await repository.getUser('1'),
  await repository.getUser('2'),
  await repository.getUser('3'),
];

// Get all successful results
List<User> users = results.collectSuccesses();

// Get all failures
List<Failure> failures = results.collectFailures();

// Convert to Result<List<User>> - fails if any fails
Result<List<User>> allOrNothing = results.sequence();
```

### 5. Side Effects with `onSuccess` and `onFailure`

```dart
await repository.createUser(user)
  .onSuccess((user) {
    analytics.logUserCreated(user.id);
    print('User created: ${user.name}');
  })
  .onFailure((failure) {
    crashlytics.recordError(failure);
    print('Creation failed: ${failure.message}');
  });
```

### 6. Getting Data or Defaults

```dart
// Get data or null
User? user = result.dataOrNull;

// Get data or throw
User user = result.getOrThrow();

// Get data or default
User user = result.getOrElse(() => User.guest());

// Check state
if (result.isSuccess) {
  // ...
}
```

---

## Extension Methods

### Core Extensions (on `Result<T>`)

| Method | Description | Example |
|--------|-------------|---------|
| `isSuccess` | Returns true if Success | `if (result.isSuccess) { }` |
| `isFailure` | Returns true if Failure | `if (result.isFailure) { }` |
| `dataOrNull` | Get data or null | `User? user = result.dataOrNull;` |
| `failureOrNull` | Get failure or null | `Failure? error = result.failureOrNull;` |
| `getOrThrow()` | Get data or throw failure | `User user = result.getOrThrow();` |
| `getOrElse(fn)` | Get data or default | `User user = result.getOrElse(() => guestUser);` |
| `mapData<R>(fn)` | Transform success data | `Result<String> names = userResult.mapData((u) => u.name);` |
| `mapFailure(fn)` | Transform failure | `result.mapFailure((f) => simplifyFailure(f));` |
| `flatMap<R>(fn)` | Chain Result operations | `result.flatMap((u) => getProfile(u.id));` |
| `flatMapAsync<R>(fn)` | Async chain operations | `result.flatMapAsync((u) => repository.getProfile(u.id));` |
| `onSuccess(fn)` | Side effect on success | `result.onSuccess((u) => log(u));` |
| `onFailure(fn)` | Side effect on failure | `result.onFailure((f) => reportError(f));` |
| `when<R>(success, failure)` | Pattern match (Freezed) | `result.when(success: (data) => ..., failure: (err) => ...);` |
| `errorMessage` | Get user-friendly error | `String? msg = result.errorMessage;` |
| `isCriticalFailure` | Check if failure is critical | `if (result.isCriticalFailure) { }` |
| `canRetry` | Check if operation can retry | `if (result.canRetry) { }` |

### Future<Result<T>> Extensions

| Method | Description | Example |
|--------|-------------|---------|
| `mapDataAsync<R>(fn)` | Transform async success | `future.mapDataAsync((u) => u.name);` |
| `flatMapAsync<R>(fn)` | Chain async operations | `future.flatMapAsync((u) => getProfile(u.id));` |
| `onSuccessAsync(fn)` | Async side effect on success | `future.onSuccessAsync((u) => log(u));` |
| `onFailureAsync(fn)` | Async side effect on failure | `future.onFailureAsync((f) => report(f));` |
| `dataOrNull` | Await and get data or null | `User? user = await future.dataOrNull;` |
| `getOrThrow()` | Await and get or throw | `User user = await future.getOrThrow();` |
| `getOrElse(fn)` | Await and get or default | `User user = await future.getOrElse(() => guest);` |

### Result<void> Extensions

| Method | Description | Example |
|--------|-------------|---------|
| `isSuccessful` | Check if void operation succeeded | `if (deleteResult.isSuccessful) { }` |
| `mapToValue<T>(value)` | Convert void to valued Result | `Result<bool> boolResult = voidResult.mapToValue(true);` |

### List<Result<T>> Extensions

| Method | Description | Example |
|--------|-------------|---------|
| `sequence()` | Combine all Results | `Result<List<User>> all = results.sequence();` |
| `collectSuccesses()` | Get all success data | `List<User> users = results.collectSuccesses();` |
| `collectFailures()` | Get all failures | `List<Failure> errors = results.collectFailures();` |

---

## Best Practices

### ✅ DO

1. **Use Result<T> for all repository/service returns**
   ```dart
   AsyncResult<User> getUser(String id);
   ```

2. **Convert exceptions to typed Failures**
   ```dart
   return Result.failure(Failure.network(message: 'Connection failed'));
   ```

3. **Use Result.guard for cleaner code**
   ```dart
   return Result.guard(() async => await api.call());
   ```

4. **Handle both success and failure explicitly**
   ```dart
   result.when(
     success: (data) => handleSuccess(data),
     failure: (error) => handleError(error),
   );
   ```

5. **Use AsyncResult<T> type alias**
   ```dart
   AsyncResult<User> = Future<Result<User>>
   ```

### ❌ DON'T

1. **Don't throw exceptions in repositories**
   ```dart
   // ❌ Bad
   Future<User> getUser(String id) async {
     throw Exception('Error');
   }

   // ✅ Good
   AsyncResult<User> getUser(String id) async {
     return Result.failure(Failure.unknown(message: 'Error'));
   }
   ```

2. **Don't ignore failures**
   ```dart
   // ❌ Bad
   result.dataOrNull; // Silent failure

   // ✅ Good
   result.when(
     success: (data) => use(data),
     failure: (error) => log(error),
   );
   ```

3. **Don't nest try-catch when using Result**
   ```dart
   // ❌ Bad - double error handling
   try {
     final result = await repository.getUser(id);
     result.when(...);
   } catch (e) { }

   // ✅ Good - Result handles errors
   final result = await repository.getUser(id);
   result.when(...);
   ```

---

## Migration Guide

### Step 1: Add Result<T> to Repository Interface

```dart
// Before
abstract class AuthRepository {
  Future<User> signIn(String email, String password);
}

// After
abstract class AuthRepository {
  AsyncResult<User> signIn(String email, String password);
}
```

### Step 2: Update Repository Implementation

```dart
// Before
@override
Future<User> signIn(String email, String password) async {
  return await _authService.signIn(email, password);
}

// After
@override
AsyncResult<User> signIn(String email, String password) async {
  try {
    final user = await _authService.signIn(email, password);
    return Result.success(user);
  } catch (e, stackTrace) {
    return Result.failure(ExceptionToFailure.convert(e, stackTrace));
  }
}
```

### Step 3: Update Controllers

```dart
// Before
Future<void> signIn(String email, String password) async {
  try {
    state = const AsyncValue.loading();
    final user = await repository.signIn(email, password);
    state = AsyncValue.data(AuthState.authenticated(user));
  } catch (error, stackTrace) {
    state = AsyncValue.error(error, stackTrace);
  }
}

// After
Future<void> signIn(String email, String password) async {
  state = const AsyncValue.loading();
  final result = await repository.signIn(email, password);

  result.when(
    success: (user) {
      state = AsyncValue.data(AuthState.authenticated(user));
    },
    failure: (failure) {
      state = AsyncValue.error(failure, StackTrace.current);
    },
  );
}
```

---

## Real-World Examples

### Example 1: Login Flow

```dart
class AuthController extends AsyncNotifier<AuthState> {
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.read(authRepositoryProvider)
      .signInWithEmailAndPassword(email: email, password: password);

    result
      .onSuccess((authState) {
        AppLogger.info('✅ Sign in successful');
        analytics.logLogin();
      })
      .onFailure((failure) {
        AppLogger.error('❌ Sign in failed: ${failure.message}');
        crashlytics.recordError(failure);
      })
      .when(
        success: (authState) => state = AsyncValue.data(authState),
        failure: (failure) => state = AsyncValue.error(failure, StackTrace.current),
      );
  }
}
```

### Example 2: Form Validation and Submission

```dart
Future<void> submitProfile() async {
  // Validate all fields and collect results
  final nameResult = validateName(name);
  final emailResult = validateEmail(email);
  final phoneResult = validatePhone(phone);

  // Combine validations
  final validations = [nameResult, emailResult, phoneResult];
  final failures = validations.collectFailures();

  if (failures.isNotEmpty) {
    showErrors(failures.map((f) => f.userMessage).toList());
    return;
  }

  // All valid, submit
  final result = await repository.updateProfile(
    name: name,
    email: email,
    phone: phone,
  );

  result.when(
    success: (_) => showSuccess('Profile updated!'),
    failure: (error) => showError(error.userMessage),
  );
}
```

### Example 3: Parallel Operations

```dart
Future<void> loadDashboard() async {
  state = const AsyncValue.loading();

  // Fetch all data in parallel
  final results = await Future.wait([
    repository.getUser(),
    repository.getStats(),
    repository.getNotifications(),
  ]);

  // Check if all succeeded
  final failures = results.collectFailures();
  if (failures.isNotEmpty) {
    state = AsyncValue.error(
      failures.first,
      StackTrace.current,
    );
    return;
  }

  // All succeeded, extract data
  final user = results[0].dataOrNull!;
  final stats = results[1].dataOrNull!;
  final notifications = results[2].dataOrNull!;

  state = AsyncValue.data(
    DashboardState(
      user: user,
      stats: stats,
      notifications: notifications,
    ),
  );
}
```

---

## Summary

The `Result<T>` pattern provides:

✅ **Type Safety** - Compiler enforces error handling
✅ **Clarity** - Success/failure cases are explicit
✅ **Composability** - Chain and transform operations
✅ **Integration** - Works with Riverpod, Freezed, existing Failures
✅ **Testability** - Easy to test both success and failure paths

**Key Files:**
- `lib/core/result/result.dart` - Core Result<T> definition
- `lib/core/result/result_extensions.dart` - Extension methods
- `lib/core/result/exception_to_failure.dart` - Exception converter

**Next Steps:**
1. Use Result<T> for all new repositories
2. Gradually migrate existing repositories
3. Use extension methods for cleaner code
4. Write tests for both success and failure cases
