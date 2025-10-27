# Code Style & Conventions

## Linting

Uses **flutter_lints** package with custom rules in `analysis_options.yaml`.

### Key Rules
- `always_declare_return_types: true`
- `avoid_void_async: true`
- `prefer_const_constructors: true`
- `prefer_final_fields: true`
- `sort_constructors_first: true`
- `always_use_package_imports: true` (never use relative imports from lib)
- `avoid_relative_lib_imports: true`
- `unawaited_futures: error` (must await or explicitly ignore)
- `constant_identifier_names: false` (allows UPPER_CASE constants)
- `non_constant_identifier_names: false`
- `curly_braces_in_flow_control_structures: false` (optional)

### Excluded Paths
- `build/**`
- `.dart_tool/**`

## Naming Conventions

### Files
- Snake case: `auth_controller.dart`, `user_model.dart`
- Generated files: `*.g.dart`, `*.freezed.dart`

### Classes
- PascalCase: `AuthController`, `UserModel`, `HomeScreen`
- Widgets end with widget context: `HomeScreen`, `AppButton`, `AdBannerWidget`

### Variables & Functions
- camelCase: `currentUser`, `signIn()`, `isAuthenticated`
- Private members: `_privateMethod()`, `_internalState`
- Constants: ALL_CAPS or camelCase (both allowed)

### Providers (Riverpod)
- Suffix with `Provider`: `authControllerProvider`, `authRepositoryProvider`
- State providers: `authStateProvider`
- Family providers: `userProfileProvider.family`

## Code Patterns

### Immutability with Freezed

**Always use Freezed for:**
- Domain entities
- Data models
- State classes
- Union types

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.authenticated({required UserModel user}) = Authenticated;
  const factory AuthState.error(String message) = Error;
}
```

### State Management with AsyncNotifier

**Pattern for controllers:**

```dart
class AuthController extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    // Initialize state
    return const AuthState.initial();
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await repository.signIn(email, password);
      return AuthState.authenticated(user: user);
    });
  }
}
```

### Repository Pattern

**Interface (domain):**
```dart
abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signIn(String email, String password);
  Future<Either<Failure, Unit>> signOut();
}
```

**Implementation (data):**
```dart
class SupabaseAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, UserModel>> signIn(String email, String password) async {
    try {
      // Implementation
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
```

## Theme System

**CRITICAL RULE: ALWAYS use `Theme.of(context)` to access colors and styles.**

**NEVER directly import or use `AppColors` in widget files.**

```dart
// ❌ WRONG - Never do this
import 'package:flutter_template/core/themes/app_colors.dart';
final color = AppColors.primary;

// ✅ CORRECT - Always use Theme.of(context)
final primaryColor = Theme.of(context).colorScheme.primary;
final textStyle = Theme.of(context).textTheme.bodyLarge;
```

This ensures proper:
- Light/dark mode support
- Material 3 consistency
- Theme switching

## Import Organization

1. Dart/Flutter imports
2. Package imports
3. Local imports (always absolute from package root)

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_template/core/themes/app_theme.dart';
import 'package:flutter_template/features/auth/domain/entities/user.dart';
```

## Widget Structure

### Constructor
- Always `const` when possible
- Use `super.key` for key parameter

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
}
```

### Build Method
- Keep build methods small
- Extract complex widgets to separate methods or classes
- Use extension methods from `ContextExtensions`

## Testing Patterns

- Unit tests for controllers, repositories, utilities
- Widget tests for UI components
- Integration tests for full flows
- Use mocktail for mocking
- Test utilities in `test/utils/`

## Documentation

- Use /// for public APIs
- Document complex logic
- Keep comments concise
- Prefer self-documenting code

## Constants

- Define in `lib/core/constants/`
- Group by purpose (app_constants.dart, api_constants.dart, etc.)
- Use static const or enum where appropriate