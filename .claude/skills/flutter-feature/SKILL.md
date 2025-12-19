---
name: flutter-feature
description: Creates new Flutter features following Waffir's clean architecture pattern. Use when adding new features, screens, or modules that need domain/data/presentation layers with proper structure.
---

# Flutter Feature Implementation (Clean Architecture)

## When to Use This Skill

Use this skill when:
- Creating a new feature module
- Adding new screens with business logic
- Implementing CRUD functionality for a new entity
- Setting up a new domain with repositories and controllers

## Feature Structure

Every complete feature follows this structure:

```
lib/features/[feature_name]/
├── domain/
│   ├── entities/          # Business models (Freezed classes)
│   ├── repositories/      # Repository interfaces (abstract classes)
│   └── usecases/          # Business logic (optional)
├── data/
│   ├── models/            # Data models (JSON serializable)
│   ├── repositories/      # Repository implementations
│   ├── datasources/       # API/database data sources
│   └── providers/         # Riverpod providers for DI
└── presentation/
    ├── screens/           # Full-page UI (HookConsumerWidget)
    ├── widgets/           # Feature-specific widgets
    └── controllers/       # State management (AsyncNotifier)
```

## Implementation Steps

### Step 1: Create Domain Entity (Freezed)

```dart
// lib/features/[feature]/domain/entities/[entity].dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '[entity].freezed.dart';
part '[entity].g.dart';

@freezed
class MyEntity with _$MyEntity {
  const factory MyEntity({
    required String id,
    required String name,
    String? description,
    @Default(false) bool isActive,
  }) = _MyEntity;

  factory MyEntity.fromJson(Map<String, dynamic> json) => _$MyEntityFromJson(json);
}
```

### Step 2: Create Repository Interface (Domain)

```dart
// lib/features/[feature]/domain/repositories/[feature]_repository.dart
import '../entities/my_entity.dart';

abstract class MyFeatureRepository {
  Future<List<MyEntity>> getAll();
  Future<MyEntity?> getById(String id);
  Future<MyEntity> create(MyEntity entity);
  Future<MyEntity> update(MyEntity entity);
  Future<void> delete(String id);
}
```

### Step 3: Create Data Source

```dart
// lib/features/[feature]/data/datasources/[feature]_remote_data_source.dart
import '../../domain/entities/my_entity.dart';

abstract class MyFeatureRemoteDataSource {
  Future<List<MyEntity>> fetchAll();
  Future<MyEntity?> fetchById(String id);
  Future<MyEntity> create(MyEntity entity);
  Future<MyEntity> update(MyEntity entity);
  Future<void> delete(String id);
}

// Supabase implementation
class SupabaseMyFeatureDataSource implements MyFeatureRemoteDataSource {
  final SupabaseClient _client;

  SupabaseMyFeatureDataSource(this._client);

  @override
  Future<List<MyEntity>> fetchAll() async {
    final response = await _client.from('my_table').select();
    return response.map((json) => MyEntity.fromJson(json)).toList();
  }

  // ... other methods
}
```

### Step 4: Implement Repository (Data)

```dart
// lib/features/[feature]/data/repositories/[feature]_repository_impl.dart
import '../../domain/entities/my_entity.dart';
import '../../domain/repositories/my_feature_repository.dart';
import '../datasources/my_feature_remote_data_source.dart';

class MyFeatureRepositoryImpl implements MyFeatureRepository {
  final MyFeatureRemoteDataSource _remoteDataSource;

  MyFeatureRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<MyEntity>> getAll() => _remoteDataSource.fetchAll();

  // ... other methods
}
```

### Step 5: Create Providers

```dart
// lib/features/[feature]/data/providers/[feature]_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '[feature]_providers.g.dart';

@riverpod
MyFeatureRemoteDataSource myFeatureDataSource(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseMyFeatureDataSource(supabase);
}

@riverpod
MyFeatureRepository myFeatureRepository(Ref ref) {
  final dataSource = ref.watch(myFeatureDataSourceProvider);
  return MyFeatureRepositoryImpl(dataSource);
}
```

### Step 6: Create Controller (AsyncNotifier)

```dart
// lib/features/[feature]/presentation/controllers/[feature]_controller.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '[feature]_controller.g.dart';

@riverpod
class MyFeatureController extends _$MyFeatureController {
  @override
  Future<List<MyEntity>> build() async {
    final repository = ref.watch(myFeatureRepositoryProvider);
    return repository.getAll();
  }

  Future<void> addItem(MyEntity entity) async {
    final repository = ref.read(myFeatureRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.create(entity);
      return repository.getAll();
    });
  }

  Future<void> deleteItem(String id) async {
    final repository = ref.read(myFeatureRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.delete(id);
      return repository.getAll();
    });
  }
}
```

### Step 7: Create Screen (HookConsumerWidget)

```dart
// lib/features/[feature]/presentation/screens/[feature]_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyFeatureScreen extends HookConsumerWidget {
  const MyFeatureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    final itemsAsync = ref.watch(myFeatureControllerProvider);

    // Local UI state with hooks
    final searchQuery = useState('');
    final isGridView = useState(true);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.myFeatureTitle)),
      ),
      body: switch (itemsAsync) {
        AsyncData(:final value) => _buildContent(context, value),
        AsyncError(:final error) => _buildError(context, error),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
```

## Critical Rules

1. **Domain layer is pure Dart** - No Flutter imports in domain/
2. **Use Freezed for entities** - Immutable data classes with copyWith
3. **Repository pattern** - Abstract in domain, implement in data
4. **HookConsumerWidget for screens** - Never use StatefulWidget
5. **Theme.of(context)** - Never hardcode colors
6. **ResponsiveHelper** - Never hardcode dimensions
7. **LocaleKeys** - Never hardcode strings

## After Implementation

Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Add routes to `lib/core/navigation/app_router.dart`.
