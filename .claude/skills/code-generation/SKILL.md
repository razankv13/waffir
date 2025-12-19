---
name: code-generation
description: Manages Flutter code generation with build_runner for Freezed, JSON, Riverpod, and Hive. Use when creating annotated classes, troubleshooting generation issues, or understanding generated file patterns.
---

# Code Generation (build_runner)

## When to Use This Skill

Use this skill when:
- Creating Freezed immutable classes
- Adding JSON serialization to models
- Creating Riverpod providers with @riverpod
- Setting up Hive type adapters
- Troubleshooting generation errors

## Generated File Patterns

**NEVER edit these files directly:**
- `*.g.dart` - JSON serialization, Riverpod providers, Hive adapters
- `*.freezed.dart` - Freezed immutable classes

## Build Commands

```bash
# Generate once (most common)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (continuous generation during development)
dart run build_runner watch --delete-conflicting-outputs

# Clean all generated files
dart run build_runner clean

# Generate only assets
dart run build_runner build --build-filter="lib/gen/**"
```

## Freezed Classes

### Basic Entity

```dart
// lib/features/[feature]/domain/entities/product.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required double price,
    String? description,
    @Default(false) bool isAvailable,
    @Default([]) List<String> tags,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
```

### With Custom Methods

```dart
@freezed
class Product with _$Product {
  const Product._(); // Required for custom methods

  const factory Product({
    required String id,
    required String name,
    required double price,
    double? originalPrice,
  }) = _Product;

  // Custom getter
  bool get isOnSale => originalPrice != null && originalPrice! > price;

  // Custom method
  double get discountPercentage {
    if (!isOnSale) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
```

### Union Types (Sealed Classes)

```dart
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated({required User user}) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.error({required String message}) = AuthError;
}

// Usage with pattern matching
switch (state) {
  case AuthAuthenticated(:final user):
    return HomeScreen(user: user);
  case AuthError(:final message):
    return ErrorScreen(message: message);
  case AuthLoading():
    return const LoadingScreen();
  default:
    return const LoginScreen();
}
```

## JSON Serialization

### Without Freezed

```dart
// lib/features/[feature]/data/models/api_response.dart
import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse {
  final bool success;
  final String? message;
  final Map<String, dynamic>? data;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
```

### Custom JSON Key Names

```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(includeIfNull: false) String? avatar,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### JSON Converters

```dart
class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) => object.toIso8601String();
}

@freezed
class Event with _$Event {
  const factory Event({
    required String id,
    @DateTimeConverter() required DateTime eventDate,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
```

## Riverpod Providers

### Simple Provider

```dart
// lib/features/[feature]/data/providers/[feature]_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '[feature]_providers.g.dart';

@riverpod
MyService myService(Ref ref) {
  return MyServiceImpl();
}
```

### AsyncNotifier

```dart
@riverpod
class ItemsController extends _$ItemsController {
  @override
  Future<List<Item>> build() async {
    final repository = ref.watch(itemRepositoryProvider);
    return repository.getAll();
  }

  Future<void> addItem(Item item) async {
    state = await AsyncValue.guard(() async {
      await ref.read(itemRepositoryProvider).create(item);
      return ref.read(itemRepositoryProvider).getAll();
    });
  }
}
```

### Family Provider (Parameterized)

```dart
@riverpod
Future<Product> product(Ref ref, String productId) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getById(productId);
}

// Usage
final product = ref.watch(productProvider('product-123'));
```

### KeepAlive

```dart
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  User? build() => null;
}
```

## Hive Type Adapters

```dart
// lib/core/storage/models/cached_settings.dart
import 'package:hive/hive.dart';

part 'cached_settings.g.dart';

@HiveType(typeId: 0) // MUST be unique across all Hive types
class CachedSettings {
  @HiveField(0)
  final bool darkMode;

  @HiveField(1)
  final String languageCode;

  @HiveField(2)
  final bool notificationsEnabled;

  CachedSettings({
    required this.darkMode,
    required this.languageCode,
    required this.notificationsEnabled,
  });
}
```

**TypeId tracking:**
- 0: CachedSettings
- 1: UserPreferences
- 2: CachedProduct
- etc.

## Project Configuration (build.yaml)

```yaml
targets:
  $default:
    builders:
      riverpod_generator:
        options:
          provider_name_prefix: ""
          provider_family_name_prefix: ""
          line_length: 120

      json_serializable:
        options:
          any_map: false
          checked: false
          create_factory: true
          create_to_json: true
          disallow_unrecognized_keys: false
          explicit_to_json: false
          field_rename: none
          include_if_null: true
```

## When to Run build_runner

**ALWAYS run after:**

1. Creating/modifying `@freezed` classes
2. Creating/modifying `@JsonSerializable()` classes
3. Creating/modifying `@riverpod` providers
4. Creating/modifying `@HiveType()` classes
5. Changing field names or types in any annotated class

## Troubleshooting

### Build Fails

```bash
# Step 1: Clean
dart run build_runner clean

# Step 2: Clean Flutter
flutter clean && flutter pub get

# Step 3: Rebuild
dart run build_runner build --delete-conflicting-outputs
```

### Common Errors

**Missing part directive:**
```dart
// Error: Missing 'part' directive
// Fix: Add both part directives
part 'my_class.freezed.dart';
part 'my_class.g.dart';
```

**Conflicting outputs:**
```bash
# Always use --delete-conflicting-outputs flag
dart run build_runner build --delete-conflicting-outputs
```

**Type not found:**
```dart
// Ensure imports are correct
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
```

### Checklist Before Running

- [ ] All annotated classes have correct imports
- [ ] `part` directives match filename
- [ ] Freezed classes have `const factory` constructors
- [ ] Freezed classes use `with _$ClassName` mixin
- [ ] Hive typeIds are unique
- [ ] No syntax errors in source files

## File Naming Convention

```
# Source file
lib/features/products/domain/entities/product.dart

# Generated files (auto-created)
lib/features/products/domain/entities/product.freezed.dart
lib/features/products/domain/entities/product.g.dart
```

## Critical Rules

1. **NEVER edit .g.dart or .freezed.dart** - They're auto-generated
2. **ALWAYS run build_runner** - After modifying annotated classes
3. **ALWAYS use --delete-conflicting-outputs** - Prevents conflicts
4. **Unique Hive typeIds** - Track them to avoid collisions
5. **const factory for Freezed** - Required syntax
6. **Part directives required** - Both .freezed.dart and .g.dart
