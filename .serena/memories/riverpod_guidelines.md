In 2025, my “default” Riverpod architecture is: **codegen-first + (Async)Notifier-first + explicit dependency graph**. That lines up with where Riverpod itself has been heading (Riverpod 2 introduced `Notifier` / `AsyncNotifier`, and `StateNotifier` is now discouraged). ([Riverpod][1])

### 1) Use Riverpod codegen as the source of truth

Treat providers like *public APIs* for your app modules, and generate them with `@riverpod`. This gives you consistent typing, `Ref` specializations, and a clean “dependency injection” story without service locators.

**Rule of thumb**

* “If it’s shared state or a dependency: it’s a provider.”
* “If it’s state that changes: it’s a Notifier/AsyncNotifier provider.”

Riverpod’s docs explicitly position modern providers as **NotifierProvider / AsyncNotifierProvider / StreamNotifierProvider** depending on what you return. ([Riverpod][2])

---

### 2) Prefer `Notifier` / `AsyncNotifier` (avoid `StateNotifier` for new code)

**Synchronous state** → `Notifier<T>`
**Async state (network/db)** → `AsyncNotifier<T>`

Riverpod’s own migration guide is blunt here: `StateNotifier` is discouraged in favor of the new APIs, with `AsyncNotifier` offering better first-class async ergonomics. ([Riverpod][1])

**Example: “Controller” pattern (async, UI-friendly)**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'todos_controller.g.dart';

@riverpod
class TodosController extends _$TodosController {
  @override
  Future<List<Todo>> build() async {
    final repo = ref.watch(todosRepositoryProvider);
    return repo.fetchTodos();
  }

  Future<void> addTodo(Todo todo) async {
    final repo = ref.read(todosRepositoryProvider);

    state = const AsyncLoading<List<Todo>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      await repo.add(todo);
      // Re-fetch after mutation:
      return repo.fetchTodos();
    });
  }
}
```

This keeps widgets dumb: they render `AsyncValue` and call intent methods (`addTodo`, `refresh`, etc.).

---

### 3) Make dependencies boring: Repository/Data providers are plain `Provider`s

A clean layering that scales:

* **Data**: API client, DAOs, repositories → `Provider`
* **Domain**: use-cases (optional) → `Provider`
* **Presentation**: controllers/view-models → `Notifier` / `AsyncNotifier`

Why this works: your “impure” world (HTTP, storage) is isolated behind providers; your controllers just compose dependencies via `ref.watch(...)`.

---

### 4) Treat caching & lifecycle as deliberate design (not vibes)

**Auto-dispose** is a feature, not a surprise. Riverpod will dispose providers when they have no listeners (based on `ref.watch`/`ref.listen` usage). ([Riverpod][3])

My production pattern:

* Use **autoDispose** for screen-scoped state (search pages, wizards).
* Use **non-autoDispose** (or keepAlive) for “app session” state (auth session, user profile cache).
* For async providers where you want cache retention, explicitly keep them alive rather than “accidentally watched somewhere”.

(Also: Riverpod added lifecycle hooks and a `keepAlive()` API on auto-dispose refs for more controlled retention.) ([Dart packages][4])

---

### 5) Side effects: keep them out of `build()`, wire them with `ref.listen` + invalidation

UI side effects (snackbars, navigation, analytics pings) should be driven by **state transitions**, not sprinkled inside widget builds.

For server mutations, Riverpod documents the “invalidate to refresh” approach (`ref.invalidateSelf()` / invalidation patterns) as a standard mechanism to re-run providers after side effects. ([Riverpod][5])

---

### 6) Parameterized state: use `.family` for IDs/filters, not ad-hoc maps

User profile by id, product details by SKU, search results by query → `.family` is the clean, typed way. Riverpod’s docs show `.family` usage for notifier providers and how the notifier receives the argument. ([Riverpod][6])

---

### 7) Performance baseline: watch narrowly, rebuild narrowly

In UI code:

* Prefer `ref.watch(provider.select((s) => s.someField))` for hot widgets.
* Wrap only the subtree that needs updates in `Consumer`.
* Keep “one widget = one concern”: it keeps rebuilds predictable and profiling simple.

---

**One practical note for 2025:** Riverpod 3.0 exists and is explicitly called a transition toward a simpler/unified Riverpod, with lifecycle changes that can bite during upgrades—so I pin versions per app and schedule migrations intentionally. ([Riverpod][7])

If you build around the pattern above, the nice part is: upgrades mostly become mechanical (providers + notifiers), not architectural rewrites.

[1]: https://riverpod.dev/docs/migration/from_state_notifier?utm_source=chatgpt.com "From `StateNotifier`"
[2]: https://riverpod.dev/docs/concepts2/providers?utm_source=chatgpt.com "Providers"
[3]: https://riverpod.dev/docs/concepts2/auto_dispose?utm_source=chatgpt.com "Automatic disposal"
[4]: https://pub.dev/packages/flutter_riverpod/versions/2.6.1/changelog?utm_source=chatgpt.com "flutter_riverpod 2.6.1 changelog | Flutter package"
[5]: https://docs-v2.riverpod.dev/zh-hans/docs/essentials/side_effects?utm_source=chatgpt.com "Performing side effects"
[6]: https://riverpod.dev/docs/concepts2/family?utm_source=chatgpt.com "Family"
[7]: https://riverpod.dev/docs/whats_new?utm_source=chatgpt.com "What's new in Riverpod 3.0"
