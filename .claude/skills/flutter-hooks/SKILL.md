---
name: flutter-hooks
description: Implements Flutter Hooks for UI state and lifecycle. Use when creating widgets that need local state, controllers, animations, or lifecycle management instead of StatefulWidget.
---

# Flutter Hooks First

## When to Use This Skill

Use this skill when:
- Creating widgets with local UI state (toggles, selections, counters)
- Managing TextEditingController, ScrollController, FocusNode
- Implementing animations with AnimationController
- Handling lifecycle (initState/dispose equivalent)
- Building forms with multiple input controllers

## Widget Type Selection

### HookWidget - Hooks Only (No Riverpod)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MyWidget extends HookWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final count = useState(0);

    return Text('Count: ${count.value}');
  }
}
```

### HookConsumerWidget - Hooks + Riverpod (MOST COMMON)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyScreen extends HookConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks for local UI state
    final searchQuery = useState('');
    final isExpanded = useState(false);

    // Riverpod for shared/business state
    final itemsAsync = ref.watch(itemsProvider);

    return Scaffold(...);
  }
}
```

### HookConsumer - For Partial Widget Trees

```dart
Widget build(BuildContext context) {
  return Column(
    children: [
      const StaticHeader(),
      HookConsumer(
        builder: (context, ref, child) {
          final count = useState(0);
          final data = ref.watch(dataProvider);
          return Text('${count.value} - $data');
        },
      ),
    ],
  );
}
```

## Common Hooks

### useState - Simple State

```dart
// Boolean toggle
final isVisible = useState(false);
isVisible.value = !isVisible.value;

// String
final text = useState('');
text.value = 'new value';

// List (must reassign, not mutate)
final items = useState<List<String>>([]);
items.value = [...items.value, 'new item'];

// Nullable
final selectedId = useState<String?>(null);
```

### useTextEditingController - Text Input

```dart
final emailController = useTextEditingController();
final passwordController = useTextEditingController(text: 'initial');

// With listener
useEffect(() {
  void listener() => print(emailController.text);
  emailController.addListener(listener);
  return () => emailController.removeListener(listener);
}, [emailController]);

return TextField(controller: emailController);
```

### useScrollController - Scrolling

```dart
final scrollController = useScrollController();

// Scroll to position
useEffect(() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    scrollController.jumpTo(100);
  });
  return null;
}, []);

return ListView(controller: scrollController);
```

### useFocusNode - Focus Management

```dart
final emailFocus = useFocusNode();
final passwordFocus = useFocusNode();

return Column(
  children: [
    TextField(
      focusNode: emailFocus,
      onSubmitted: (_) => passwordFocus.requestFocus(),
    ),
    TextField(
      focusNode: passwordFocus,
    ),
  ],
);
```

### useEffect - Lifecycle & Side Effects

```dart
// Runs once on mount (like initState)
useEffect(() {
  print('Widget mounted');
  return () => print('Widget disposed'); // Cleanup (like dispose)
}, []);

// Runs when dependency changes
useEffect(() {
  print('userId changed: $userId');
  fetchUserData(userId);
  return null; // No cleanup needed
}, [userId]);

// Runs every build (no deps array)
useEffect(() {
  print('Every build');
  return null;
});
```

### useMemoized - Expensive Computations

```dart
// Computed once, cached
final expensiveValue = useMemoized(() {
  return computeExpensiveValue(data);
}, [data]); // Recompute when data changes
```

### useCallback - Stable Callbacks

```dart
final onTap = useCallback(() {
  doSomething(itemId);
}, [itemId]);
```

### useAnimationController - Animations

```dart
final animationController = useAnimationController(
  duration: const Duration(milliseconds: 300),
);

final animation = useAnimation(animationController);

useEffect(() {
  animationController.forward();
  return null;
}, []);

return FadeTransition(
  opacity: animationController,
  child: content,
);
```

### useTabController - Tab Navigation

```dart
final tabController = useTabController(initialLength: 3);

return Column(
  children: [
    TabBar(controller: tabController, tabs: [...]),
    Expanded(
      child: TabBarView(controller: tabController, children: [...]),
    ),
  ],
);
```

### usePageController - PageView

```dart
final pageController = usePageController(initialPage: 0);

return PageView(
  controller: pageController,
  children: [...],
);
```

## Migration from StatefulWidget

### Before (StatefulWidget)

```dart
class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$_count'),
        TextField(controller: _controller),
        ElevatedButton(
          onPressed: () => setState(() => _count++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

### After (HookWidget)

```dart
class CounterWidget extends HookWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final count = useState(0);
    final controller = useTextEditingController();

    return Column(
      children: [
        Text('${count.value}'),
        TextField(controller: controller),
        ElevatedButton(
          onPressed: () => count.value++,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

## Complete Screen Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final responsive = context.responsive;

    // Local UI state (hooks)
    final searchController = useTextEditingController();
    final searchFocus = useFocusNode();
    final isSearching = useState(false);
    final showFilters = useState(false);

    // Debounced search
    useEffect(() {
      final timer = Timer(const Duration(milliseconds: 300), () {
        if (searchController.text.isNotEmpty) {
          ref.read(searchQueryProvider.notifier).update(searchController.text);
        }
      });
      return timer.cancel;
    }, [searchController.text]);

    // Shared state (Riverpod)
    final resultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          focusNode: searchFocus,
          decoration: InputDecoration(
            hintText: tr(LocaleKeys.searchHint),
            border: InputBorder.none,
          ),
          onChanged: (_) => isSearching.value = true,
        ),
        actions: [
          IconButton(
            icon: Icon(showFilters.value ? Icons.filter_alt : Icons.filter_alt_outlined),
            onPressed: () => showFilters.value = !showFilters.value,
          ),
        ],
      ),
      body: Column(
        children: [
          if (showFilters.value) const FilterChips(),
          Expanded(
            child: switch (resultsAsync) {
              AsyncData(:final value) => ResultsList(results: value),
              AsyncError(:final error) => ErrorView(error: error),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}
```

## Hook Mapping Reference

| StatefulWidget | Flutter Hooks |
|----------------|---------------|
| `setState` + variable | `useState<T>()` |
| `TextEditingController` | `useTextEditingController()` |
| `ScrollController` | `useScrollController()` |
| `FocusNode` | `useFocusNode()` |
| `TabController` | `useTabController()` |
| `PageController` | `usePageController()` |
| `AnimationController` | `useAnimationController()` |
| `initState` | `useEffect(() {...}, [])` |
| `dispose` | Return cleanup from `useEffect` |
| `didChangeDependencies` | `useEffect` with dependencies |

## State Location Guidelines

| State Type | Where | Example |
|------------|-------|---------|
| UI toggles, selections | Hooks (`useState`) | `isExpanded`, `selectedTab` |
| Form inputs | Hooks (`useTextEditingController`) | Email, password fields |
| Animations | Hooks (`useAnimationController`) | Fade, slide animations |
| Scroll position | Hooks (`useScrollController`) | List scroll state |
| Auth state | Riverpod (`AsyncNotifier`) | User login status |
| Feature data | Riverpod (`AsyncNotifier`) | Products, orders list |
| App settings | Riverpod (`Notifier`) | Theme, language |

## Critical Rules

1. **HookConsumerWidget for screens** - Combines hooks + Riverpod
2. **Hooks for local UI state** - Toggles, forms, animations
3. **Riverpod for shared state** - Auth, data, business logic
4. **Always const constructors** - `const MyWidget({super.key})`
5. **Never StatefulWidget** - Unless no hooks equivalent exists
6. **Dispose automatically** - Hooks handle cleanup

## When NOT to Use Hooks

Use StatefulWidget only when:
- Third-party library requires it
- Complex widget lifecycle not covered by hooks
- Legacy code migration in progress

Always add a comment explaining why:

```dart
// Using StatefulWidget: Required by VideoPlayer lifecycle
class VideoScreen extends StatefulWidget { ... }
```
