# Riverpod State Management Guidelines
## Complete Guide for Small to Mid-Level Flutter Apps (2025)

Based on Riverpod 2.6.1+ (with Riverpod 3.0 considerations)

---

## Table of Contents
1. [Setup & Installation](#setup--installation)
2. [Project Structure](#project-structure)
3. [Provider Types & When to Use Them](#provider-types--when-to-use-them)
4. [Code Generation Approach](#code-generation-approach)
5. [Best Practices](#best-practices)
6. [Common Patterns](#common-patterns)
7. [Testing](#testing)
8. [Migration Notes](#migration-notes)

---

## Setup & Installation

### Required Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1

dev_dependencies:
  build_runner: ^2.4.13
  riverpod_generator: ^2.6.3
  custom_lint: ^0.6.0
  riverpod_lint: ^2.6.1
```

### Installation Commands

```bash
flutter pub add flutter_riverpod
flutter pub add riverpod_annotation
flutter pub add dev:riverpod_generator
flutter pub add dev:build_runner
flutter pub add dev:custom_lint
flutter pub add dev:riverpod_lint
```

### Enable Riverpod Lint Rules

Create `analysis_options.yaml` in your project root:

```yaml
analyzer:
  plugins:
    - custom_lint

linter:
  rules:
    # Your existing lint rules
```

### Running Code Generation

```bash
# Watch mode (recommended during development)
dart run build_runner watch -d

# One-time generation
dart run build_runner build --delete-conflicting-outputs
```

---

## Project Structure

### Recommended Folder Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── utils/
│   └── theme/
├── features/
│   ├── authentication/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── data_sources/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── usecases/
│   │   ├── presentation/
│   │   │   ├── providers/
│   │   │   ├── views/
│   │   │   └── widgets/
│   │   └── authentication.dart
│   ├── home/
│   └── profile/
├── shared/
│   ├── providers/
│   ├── widgets/
│   └── models/
└── router/
    └── app_router.dart
```

### Feature-First Organization

Each feature should be self-contained with its own providers, models, and UI components. This makes your app modular and scalable.

---

## Provider Types & When to Use Them

### Current Recommended Providers (Riverpod 2.6+)

#### 1. **Provider** - For Computed/Immutable Values

Use for computed values, configurations, or dependencies that don't change.

```dart
@riverpod
String appTitle(Ref ref) {
  return 'My Awesome App';
}

@riverpod
ApiService apiService(Ref ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  return ApiService(baseUrl: baseUrl);
}
```

**When to use:**
- Computed values
- Service initialization
- Configuration values
- Dependency injection

---

#### 2. **NotifierProvider** - For Mutable State

Use for state that needs to be mutated over time. This is the modern replacement for StateNotifierProvider.

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_provider.g.dart';

@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}
```

**When to use:**
- Managing local UI state
- Form state management
- Counter, toggles, selections
- Any synchronous mutable state

---

#### 3. **FutureProvider** - For Async Read-Only Data

Use for one-time asynchronous operations.

```dart
@riverpod
Future<User> currentUser(Ref ref) async {
  final userId = ref.watch(userIdProvider);
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getUser(userId);
}
```

**When to use:**
- Fetching data from an API
- Reading from local storage
- One-time async operations
- Data that refreshes automatically when dependencies change

---

#### 4. **AsyncNotifierProvider** - For Mutable Async State

Use for asynchronous state that needs mutation over time.

```dart
@riverpod
class Todos extends _$Todos {
  @override
  Future<List<Todo>> build() async {
    // Initial async data loading
    return _fetchTodos();
  }

  Future<void> addTodo(String title) async {
    // Set loading state
    state = const AsyncValue.loading();
    
    // Perform async operation
    state = await AsyncValue.guard(() async {
      final newTodo = await _apiService.createTodo(title);
      final currentTodos = await future;
      return [...currentTodos, newTodo];
    });
  }

  Future<void> toggleTodo(String id) async {
    state = await AsyncValue.guard(() async {
      await _apiService.toggleTodo(id);
      final todos = await future;
      return todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(completed: !todo.completed);
        }
        return todo;
      }).toList();
    });
  }

  Future<List<Todo>> _fetchTodos() async {
    final response = await _apiService.getTodos();
    return response;
  }
}
```

**When to use:**
- CRUD operations with API
- Managing collections with server sync
- Any async state that changes over time
- Loading, error, and data states management

---

#### 5. **StreamProvider** - For Realtime Data Streams

Use for listening to streams of data.

```dart
@riverpod
Stream<List<Message>> messages(Ref ref, String chatId) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
    .collection('messages')
    .where('chatId', isEqualTo: chatId)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
}
```

**When to use:**
- Firestore real-time updates
- WebSocket connections
- Server-sent events
- Any continuous stream of data

---

### Deprecated Providers (Avoid in New Projects)

- **StateNotifierProvider** - Use NotifierProvider instead
- **StateProvider** - Use NotifierProvider instead
- **ChangeNotifierProvider** - Only for migration from Provider package

---

## Code Generation Approach

### Why Use Code Generation?

Code generation with `@riverpod` annotation provides:
- Less boilerplate
- Compile-time safety
- Better refactoring support
- Automatic provider naming
- Type inference

### Basic Template

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_provider.g.dart';

@riverpod
class MyState extends _$MyState {
  @override
  MyData build() {
    // Initial state
    return MyData();
  }

  void updateState(MyData newData) {
    state = newData;
  }
}
```

### Using Family Modifier (Parameters)

```dart
@riverpod
Future<Product> product(Ref ref, String productId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getProduct(productId);
}

// Usage
final product = ref.watch(productProvider('product-123'));
```

### KeepAlive Modifier

By default, providers are auto-disposed when not in use. Use `keepAlive: true` to persist state.

```dart
@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  User? build() => null;

  void login(User user) => state = user;
  void logout() => state = null;
}
```

**When to use keepAlive:**
- Authentication state
- App-wide configuration
- Cached data that should persist
- Global app state

---

## Best Practices

### 1. Immutable State Models

Always use immutable data classes with copyWith method.

```dart
class Todo {
  final String id;
  final String title;
  final bool completed;

  const Todo({
    required this.id,
    required this.title,
    this.completed = false,
  });

  Todo copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
```

Consider using `freezed` package for automatic generation:

```dart
@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    @Default(false) bool completed,
  }) = _Todo;
}
```

### 2. Avoid Business Logic in UI

Keep your UI clean by moving logic to providers.

**❌ Bad:**
```dart
class TodoScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final title = titleController.text;
        if (title.isEmpty) return;
        
        try {
          final api = ref.read(apiServiceProvider);
          await api.createTodo(title);
          // More logic...
        } catch (e) {
          // Error handling...
        }
      },
      child: Text('Add Todo'),
    );
  }
}
```

**✅ Good:**
```dart
class TodoScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        final title = titleController.text;
        ref.read(todosProvider.notifier).addTodo(title);
      },
      child: Text('Add Todo'),
    );
  }
}
```

### 3. Handle Async States Properly

Use pattern matching for clean async state handling.

```dart
class TodosScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todosProvider);

    return switch (todosAsync) {
      AsyncData(:final value) => TodosList(todos: value),
      AsyncError(:final error) => ErrorView(error: error),
      _ => const CircularProgressIndicator(),
    };
  }
}
```

### 4. Separate Concerns

Keep providers focused on a single responsibility.

```dart
// ❌ Bad: One provider doing everything
@riverpod
class AppState extends _$AppState {
  // User management, todos, settings, etc. all in one
}

// ✅ Good: Separate providers
@riverpod
class AuthState extends _$AuthState { }

@riverpod
class Todos extends _$Todos { }

@riverpod
class AppSettings extends _$AppSettings { }
```

### 5. Use Ref.watch vs Ref.read Correctly

**ref.watch** - Rebuilds when provider changes (use in build method)
```dart
Widget build(BuildContext context, WidgetRef ref) {
  final count = ref.watch(counterProvider);
  return Text('$count');
}
```

**ref.read** - One-time read without listening (use in callbacks)
```dart
onPressed: () {
  ref.read(counterProvider.notifier).increment();
}
```

**ref.listen** - Side effects without rebuilding
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  ref.listen(authStateProvider, (previous, next) {
    if (next == null) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  });
  
  return Scaffold(...);
}
```

### 6. Provider Dependencies

Providers can depend on other providers using ref.watch.

```dart
@riverpod
Future<List<Todo>> filteredTodos(Ref ref) async {
  final todos = await ref.watch(todosProvider.future);
  final filter = ref.watch(filterProvider);
  
  return switch (filter) {
    TodoFilter.all => todos,
    TodoFilter.completed => todos.where((t) => t.completed).toList(),
    TodoFilter.active => todos.where((t) => !t.completed).toList(),
  };
}
```

### 7. Error Handling in AsyncNotifier

Always use `AsyncValue.guard` for proper error handling.

```dart
Future<void> updateData() async {
  state = await AsyncValue.guard(() async {
    final result = await _repository.updateData();
    return result;
  });
}
```

### 8. Avoid Using ref.refresh Unnecessarily

Instead of refreshing, make your providers reactive.

**❌ Bad:**
```dart
ref.refresh(todosProvider);
```

**✅ Good:**
```dart
// Todos automatically refresh when dependencies change
@riverpod
Future<List<Todo>> todos(Ref ref) async {
  final userId = ref.watch(currentUserIdProvider);
  return _fetchTodos(userId);
}
```

---

## Common Patterns

### Pattern 1: Repository Pattern

```dart
// Data source
@riverpod
ApiService apiService(Ref ref) {
  return ApiService();
}

// Repository
@riverpod
TodoRepository todoRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return TodoRepository(apiService);
}

// Provider using repository
@riverpod
class Todos extends _$Todos {
  @override
  Future<List<Todo>> build() async {
    final repository = ref.watch(todoRepositoryProvider);
    return repository.getTodos();
  }

  Future<void> addTodo(String title) async {
    final repository = ref.read(todoRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.createTodo(title);
      return repository.getTodos();
    });
  }
}
```

### Pattern 2: Pagination

```dart
@riverpod
class PaginatedProducts extends _$PaginatedProducts {
  @override
  Future<List<Product>> build() async {
    return _fetchProducts(page: 1);
  }

  int _currentPage = 1;
  bool _hasMore = true;

  Future<void> fetchMore() async {
    if (!_hasMore) return;

    final currentState = await future;
    _currentPage++;
    
    final newProducts = await _fetchProducts(page: _currentPage);
    
    if (newProducts.isEmpty) {
      _hasMore = false;
    } else {
      state = AsyncData([...currentState, ...newProducts]);
    }
  }

  Future<List<Product>> _fetchProducts({required int page}) async {
    final repository = ref.read(productRepositoryProvider);
    return repository.getProducts(page: page);
  }
}
```

### Pattern 3: Search/Filter

```dart
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

@riverpod
Future<List<Product>> searchResults(Ref ref) async {
  final query = ref.watch(searchQueryProvider);
  
  if (query.isEmpty) {
    return [];
  }

  // Debounce can be implemented here
  await Future.delayed(const Duration(milliseconds: 300));
  
  final repository = ref.watch(productRepositoryProvider);
  return repository.searchProducts(query);
}
```

### Pattern 4: Form State Management

```dart
@riverpod
class LoginForm extends _$LoginForm {
  @override
  LoginFormState build() {
    return const LoginFormState();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  bool validate() {
    final isValid = state.email.isNotEmpty && 
                    state.password.length >= 6;
    state = state.copyWith(isValid: isValid);
    return isValid;
  }
}

class LoginFormState {
  final String email;
  final String password;
  final bool isValid;

  const LoginFormState({
    this.email = '',
    this.password = '',
    this.isValid = false,
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isValid,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
    );
  }
}
```

### Pattern 5: Pull to Refresh

```dart
class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        // Invalidate and wait for new data
        return ref.refresh(productsProvider.future);
      },
      child: switch (productsAsync) {
        AsyncData(:final value) => ProductsList(products: value),
        AsyncError(:final error) => ErrorView(error: error),
        _ => const LoadingView(),
      },
    );
  }
}
```

---

## Testing

### Setup Test File

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Counter increments', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Initial state
    expect(container.read(counterProvider), 0);

    // Increment
    container.read(counterProvider.notifier).increment();
    
    // Verify
    expect(container.read(counterProvider), 1);
  });
}
```

### Override Providers in Tests

```dart
test('Mocked API test', () async {
  final container = ProviderContainer(
    overrides: [
      apiServiceProvider.overrideWithValue(MockApiService()),
    ],
  );
  addTearDown(container.dispose);

  final todos = await container.read(todosProvider.future);
  expect(todos, isNotEmpty);
});
```

### Widget Testing

```dart
testWidgets('Display counter value', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: CounterScreen(),
      ),
    ),
  );

  expect(find.text('0'), findsOneWidget);

  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  expect(find.text('1'), findsOneWidget);
});
```

---

## Migration Notes

### From Riverpod 2.x to 3.0

Key changes in Riverpod 3.0:
- Unified Ref (no more FutureProviderRef, etc.)
- Automatic retry on errors with exponential backoff
- Listeners automatically pause when widgets are not visible
- Simplified syntax for generated providers

**Before (2.x):**
```dart
@riverpod
Example example(ExampleRef ref) {
  return Example();
}
```

**After (3.0):**
```dart
@riverpod
Example example(Ref ref) {
  return Example();
}
```

### From StateNotifierProvider to NotifierProvider

**Before:**
```dart
class Counter extends StateNotifier<int> {
  Counter() : super(0);
  
  void increment() => state++;
}

final counterProvider = StateNotifierProvider<Counter, int>((ref) {
  return Counter();
});
```

**After:**
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  
  void increment() => state++;
}
```

---

## Quick Reference

### Consumer Widgets

```dart
// ConsumerWidget - For stateless widgets
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(myProvider);
    return Text('$value');
  }
}

// ConsumerStatefulWidget - For stateful widgets
class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final value = ref.watch(myProvider);
    return Text('$value');
  }
}

// Consumer - For partial rebuilds
Consumer(
  builder: (context, ref, child) {
    final value = ref.watch(myProvider);
    return Text('$value');
  },
)
```

### Ref Methods

- `ref.watch()` - Listen to provider and rebuild on change
- `ref.read()` - Read once without listening
- `ref.listen()` - Execute side effects on change
- `ref.invalidate()` - Force provider to rebuild
- `ref.refresh()` - Read provider and force rebuild
- `ref.exists()` - Check if provider is initialized

---

## Additional Resources

- [Official Riverpod Documentation](https://riverpod.dev)
- [Riverpod GitHub Repository](https://github.com/rrousselGit/riverpod)
- [Code with Andrea - Riverpod Tutorial](https://codewithandrea.com/articles/flutter-state-management-riverpod/)

---

## Conclusion

Riverpod provides a robust, type-safe, and testable solution for state management in Flutter. By following these guidelines and best practices, you'll build maintainable and scalable applications. Start with simple providers and gradually adopt more advanced patterns as your app grows.

Remember: The key to mastering Riverpod is understanding when to use each provider type and keeping your state management logic separate from your UI code.