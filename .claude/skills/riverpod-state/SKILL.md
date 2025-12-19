---
name: riverpod-state
description: Implements Riverpod state management following Waffir patterns. Use when creating providers, controllers, async state, or managing app/feature state with proper error handling.
---

# Riverpod State Management

## When to Use This Skill

Use this skill when:
- Creating new providers for dependency injection
- Building AsyncNotifier controllers for feature state
- Implementing async data fetching with proper loading/error states
- Setting up provider dependencies and composition

## Provider Types & When to Use

### 1. Provider - Computed/Immutable Values

```dart
@riverpod
ApiService apiService(Ref ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  return ApiService(baseUrl: baseUrl);
}

@riverpod
MyRepository myRepository(Ref ref) {
  final dataSource = ref.watch(myDataSourceProvider);
  return MyRepositoryImpl(dataSource);
}
```

**Use for:** Service initialization, dependency injection, computed values.

### 2. NotifierProvider - Mutable Synchronous State

```dart
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
  void clear() => state = '';
}

@riverpod
class SelectedTab extends _$SelectedTab {
  @override
  int build() => 0;

  void select(int index) => state = index;
}
```

**Use for:** UI state (toggles, selections, form inputs).

### 3. AsyncNotifierProvider - Mutable Async State (MOST COMMON)

```dart
@riverpod
class ItemsController extends _$ItemsController {
  @override
  Future<List<Item>> build() async {
    final repository = ref.watch(itemRepositoryProvider);
    return repository.getAll();
  }

  Future<void> addItem(Item item) async {
    final repository = ref.read(itemRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.create(item);
      return repository.getAll();
    });
  }

  Future<void> deleteItem(String id) async {
    final repository = ref.read(itemRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.delete(id);
      return repository.getAll();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(itemRepositoryProvider);
      return repository.getAll();
    });
  }
}
```

**Use for:** CRUD operations, API data, any async state that changes.

### 4. FutureProvider - Read-Only Async Data

```dart
@riverpod
Future<User> currentUser(Ref ref) async {
  final userId = ref.watch(userIdProvider);
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUser(userId);
}

@riverpod
Future<Config> appConfig(Ref ref) async {
  final configService = ref.watch(configServiceProvider);
  return configService.fetchConfig();
}
```

**Use for:** One-time fetches, data that auto-refreshes when deps change.

### 5. StreamProvider - Real-time Data

```dart
@riverpod
Stream<List<Message>> messages(Ref ref, String chatId) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase
      .from('messages')
      .stream(primaryKey: ['id'])
      .eq('chat_id', chatId)
      .map((data) => data.map((e) => Message.fromJson(e)).toList());
}
```

**Use for:** Real-time updates, WebSockets, Supabase streams.

## Family Providers (Parameterized)

```dart
// With code generation - parameters are method arguments
@riverpod
Future<Product> product(Ref ref, String productId) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getById(productId);
}

// Usage
final product = ref.watch(productProvider('product-123'));
```

## KeepAlive for Persistent State

```dart
@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  User? build() => null;

  void login(User user) => state = user;
  void logout() => state = null;
}
```

**Use keepAlive for:** Auth state, app settings, cached data.

## Consuming Providers in Widgets

### ref.watch - Rebuilds on Change (in build method)

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final itemsAsync = ref.watch(itemsControllerProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return switch (itemsAsync) {
    AsyncData(:final value) => ItemsList(items: value),
    AsyncError(:final error) => ErrorView(error: error),
    _ => const CircularProgressIndicator(),
  };
}
```

### ref.read - One-time Read (in callbacks)

```dart
onPressed: () {
  ref.read(itemsControllerProvider.notifier).addItem(newItem);
}

onTap: () {
  ref.read(searchQueryProvider.notifier).clear();
}
```

### ref.listen - Side Effects Without Rebuilding

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  ref.listen(authStateProvider, (previous, next) {
    if (next == null) {
      context.go('/login');
    }
  });

  ref.listen(itemsControllerProvider, (previous, next) {
    next.whenOrNull(
      error: (error, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      },
    );
  });

  return Scaffold(...);
}
```

## Error Handling Pattern

**ALWAYS use AsyncValue.guard:**

```dart
Future<void> performAction() async {
  state = await AsyncValue.guard(() async {
    // Your async operation
    final result = await repository.doSomething();
    return result;
  });
}
```

**In UI, handle all states:**

```dart
return switch (asyncState) {
  AsyncData(:final value) => SuccessWidget(data: value),
  AsyncError(:final error, :final stackTrace) => ErrorWidget(
    error: error,
    onRetry: () => ref.invalidate(myProvider),
  ),
  AsyncLoading() => const LoadingWidget(),
  _ => const LoadingWidget(), // Refreshing state
};
```

## Common Patterns

### Pagination

```dart
@riverpod
class PaginatedItems extends _$PaginatedItems {
  int _page = 1;
  bool _hasMore = true;

  @override
  Future<List<Item>> build() async {
    _page = 1;
    _hasMore = true;
    return _fetchPage(1);
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;

    final currentItems = state.valueOrNull ?? [];
    _page++;

    final newItems = await _fetchPage(_page);
    if (newItems.isEmpty) {
      _hasMore = false;
    } else {
      state = AsyncData([...currentItems, ...newItems]);
    }
  }

  Future<List<Item>> _fetchPage(int page) async {
    final repository = ref.read(itemRepositoryProvider);
    return repository.getPage(page: page, limit: 20);
  }
}
```

### Search with Filtering

```dart
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';
  void update(String q) => state = q;
}

@riverpod
Future<List<Item>> filteredItems(Ref ref) async {
  final allItems = await ref.watch(itemsControllerProvider.future);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  if (query.isEmpty) return allItems;

  return allItems.where((item) =>
    item.name.toLowerCase().contains(query)
  ).toList();
}
```

### Pull to Refresh

```dart
RefreshIndicator(
  onRefresh: () => ref.refresh(itemsControllerProvider.future),
  child: ListView(...),
)
```

## Critical Rules

1. **ref.watch in build**, ref.read in callbacks
2. **AsyncValue.guard** for all async mutations
3. **Switch expressions** for async state handling
4. **keepAlive: true** only for app-wide state
5. **Separate concerns** - one provider per responsibility
6. **Don't refresh unnecessarily** - make providers reactive instead

## File Structure

```
lib/features/[feature]/
├── data/
│   └── providers/
│       └── [feature]_providers.dart    # DI providers
└── presentation/
    └── controllers/
        └── [feature]_controller.dart   # AsyncNotifier
```

After creating providers, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```
