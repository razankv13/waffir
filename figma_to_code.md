# Figma to Flutter Code - Waffir App Integration Guide

This guide provides Claude Code with systematic instructions for converting Figma designs into production-ready Flutter code for the Waffir app, following the existing clean architecture, Material 3 design system, and widget patterns.

---

## 🎯 Prerequisites Check

Before starting, verify:
- [ ] Figma MCP is connected and available (check for `mcp__figma__*` tools)
- [ ] You have the Figma file URL with node ID in format: `https://figma.com/design/{fileKey}/{fileName}?node-id={nodeId}`
- [ ] Current working directory is `/Users/razaabbas/Desktop/Development/projects/waffir`
- [ ] Existing theme system reviewed at `lib/core/themes/app_theme.dart`

---

## 📋 Step-by-Step Workflow

### Phase 1: Design Analysis & Context Gathering

#### 1.1 Extract Figma Design Data

When user provides a Figma URL, use these tools:

```markdown
**Tool: mcp__figma__get_screenshot**
- Purpose: Get visual preview of the design
- Parameters:
  - fileKey: Extract from URL (e.g., "pqrs" from https://figma.com/design/pqrs/...)
  - nodeId: Extract from URL (e.g., "1:2" from ?node-id=1-2)
  - clientFrameworks: "flutter"
  - clientLanguages: "dart"
```

```markdown
**Tool: mcp__figma__get_design_context**
- Purpose: Get generated code and design tokens
- Returns: Code string + asset download URLs
- Use this to understand component structure
```

```markdown
**Tool: mcp__figma__get_metadata**
- Purpose: Get XML structure overview
- Use for: Understanding node hierarchy, layer types, positions
```

**Best Practice:** Start with `get_screenshot` for visual context, then `get_design_context` for implementation details.

#### 1.2 Analyze Against Waffir's Design System

Before implementing, read existing theme:

```dart
// Read: lib/core/themes/app_theme.dart
// Understand:
// - ColorScheme (primary, secondary, surface, background, error)
// - TextTheme (displayLarge, headlineMedium, bodyLarge, etc.)
// - Component themes (ButtonTheme, CardTheme, etc.)
```

**Ask yourself:**
- Does this design fit the existing Material 3 color scheme?
- Are there new colors that need to be added to the theme?
- Does typography match existing TextTheme?
- Can this be built with existing widgets (AppButton, etc.)?

---

### Phase 2: Theme Integration & Extension

#### 2.1 Color Extraction & Mapping

**Extract colors from Figma, then map to existing theme:**

```dart
// NEVER do this in widget files:
// ❌ import 'package:waffir/core/themes/app_colors.dart';
// ❌ color: AppColors.primary

// ALWAYS do this:
// ✅ color: Theme.of(context).colorScheme.primary
// ✅ color: Theme.of(context).colorScheme.surface
```

**If new colors are needed:**

1. Add to `lib/core/themes/app_theme.dart` in the appropriate ColorScheme
2. Use semantic naming (e.g., `surfaceVariant`, `onPrimaryContainer`)
3. Provide both light and dark theme variants

**Color Mapping Example:**
```
Figma Color: #6366F1 (Primary Blue)
→ Maps to: Theme.of(context).colorScheme.primary

Figma Color: #EEF2FF (Light Background)
→ Maps to: Theme.of(context).colorScheme.surfaceVariant

Figma Color: #DC2626 (Error Red)
→ Maps to: Theme.of(context).colorScheme.error
```

#### 2.2 Typography Mapping

**Map Figma text styles to existing TextTheme:**

```
Figma: Display / 32px Bold
→ Theme.of(context).textTheme.displayLarge

Figma: Heading / 24px Semibold
→ Theme.of(context).textTheme.headlineMedium

Figma: Body / 16px Regular
→ Theme.of(context).textTheme.bodyLarge

Figma: Label / 14px Medium
→ Theme.of(context).textTheme.labelLarge

Figma: Caption / 12px Regular
→ Theme.of(context).textTheme.bodySmall
```

**If new text styles are needed:**
- Extend `textTheme` in `app_theme.dart`
- Use Material 3 naming conventions
- Include both light and dark theme variants

---

### Phase 3: Asset Extraction & Organization

#### 3.1 Waffir Asset Directory Structure

```
assets/
├── images/                # PNG/JPG images
│   ├── backgrounds/       # Background images
│   ├── illustrations/     # Illustration assets
│   └── photos/           # Photo assets
├── icons/                # SVG/PNG icons
│   ├── navigation/       # Bottom nav icons
│   ├── actions/          # Action button icons
│   └── social/           # Social media icons
├── translations/         # i18n JSON files (DO NOT MODIFY)
│   ├── en.json
│   ├── es.json
│   └── fr.json
└── (other assets...)
```

#### 3.2 Flutter Asset Naming Conventions

**Icons:**
```
Format: ic_{name}_{variant}.{ext}
Examples:
  - ic_home_outlined.svg
  - ic_home_filled.svg
  - ic_settings.png
```

**Images:**
```
Format: img_{name}_{descriptor}.{ext}
Examples:
  - img_onboarding_welcome.png
  - img_placeholder_profile.png
  - img_background_gradient.png
```

**Backgrounds:**
```
Format: bg_{name}_{variant}.{ext}
Examples:
  - bg_splash.png
  - bg_pattern_dots.svg
```

#### 3.3 Export Assets from Figma

Using `mcp__figma__get_design_context`, you'll receive asset download URLs:

```json
{
  "code": "...",
  "assets": {
    "image_url_1": "https://...",
    "icon_url_2": "https://..."
  }
}
```

**Asset Export Checklist:**
- [ ] Export SVGs for icons (scalable, small file size)
- [ ] Export PNGs for images with @1x, @2x, @3x variants for iOS
- [ ] Optimize file sizes (use compression)
- [ ] Save to appropriate asset directory
- [ ] Use descriptive, lowercase, snake_case names

#### 3.4 Register Assets in pubspec.yaml

After adding assets, update `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/icons/navigation/
    - assets/icons/actions/
    # Add specific files or directories
```

#### 3.5 Generate Asset Classes

Run code generation to create type-safe asset references:

```bash
# Generate asset classes with flutter_gen
dart run build_runner build --delete-conflicting-outputs

# Or use watch mode during development
dart run build_runner watch --delete-conflicting-outputs
```

**Generated classes location:** `lib/gen/assets.gen.dart`

**Usage in code:**
```dart
// ✅ Type-safe asset references
Image.asset(Assets.images.onboardingWelcome.path)
SvgPicture.asset(Assets.icons.navigation.icHome.path)

// ❌ Avoid hardcoded strings
Image.asset('assets/images/onboarding_welcome.png')
```

---

### Phase 4: Widget Implementation

#### 4.1 Determine Widget Location

**Decision Tree:**

```
Is this widget reusable across multiple features?
├─ YES → lib/core/widgets/{category}/
│   ├── buttons/          (e.g., custom button variants)
│   ├── cards/            (e.g., custom card components)
│   ├── inputs/           (e.g., form fields)
│   ├── dialogs/          (e.g., custom dialogs)
│   └── ...
└─ NO → lib/features/{feature_name}/presentation/widgets/
    └── (feature-specific widgets)
```

**Examples:**
- Generic card component → `lib/core/widgets/cards/info_card.dart`
- Auth login button → `lib/features/auth/presentation/widgets/login_button.dart`
- Settings toggle → `lib/features/settings/presentation/widgets/settings_toggle.dart`

#### 4.2 Check for Existing Widgets

**Before creating new widgets, check if these exist:**

```dart
// Core reusable widgets:
lib/core/widgets/buttons/app_button.dart         // Primary button component
lib/core/widgets/loading/loading_indicator.dart  // Loading states
lib/core/widgets/errors/error_view.dart          // Error displays
lib/core/widgets/ads/ad_banner_widget.dart       // Ad integration
lib/core/widgets/premium/premium_feature.dart    // Paywall wrapper
```

**AppButton reference (most commonly used):**
```dart
AppButton(
  text: 'Get Started',
  onPressed: () => {},
  variant: AppButtonVariant.primary,  // primary, secondary, outlined, text, ghost, destructive
  size: AppButtonSize.large,          // small, medium, large
  isLoading: false,
  leadingIcon: Icons.arrow_forward,
  // Uses theme colors automatically
)
```

#### 4.3 Widget Creation Pattern

**Standard widget structure following Waffir patterns:**

```dart
import 'package:flutter/material.dart';
// Import other necessary packages

/// Brief description of what this widget does
///
/// Example usage:
/// ```dart
/// MyCustomWidget(
///   title: 'Hello',
///   onTap: () => print('tapped'),
/// )
/// ```
class MyCustomWidget extends StatelessWidget {
  const MyCustomWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // ✅ ALWAYS access theme through context
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

**Key Patterns:**
- ✅ Use `const` constructors where possible
- ✅ Use named parameters for clarity
- ✅ Access theme via `Theme.of(context)`
- ✅ Use `final` for all properties
- ✅ Add documentation comments
- ✅ Use Material 3 components when available

#### 4.4 Responsive Design Patterns

**Use MediaQuery and LayoutBuilder for responsive layouts:**

```dart
@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final isTablet = size.width > 600;

  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return _buildTabletLayout(context);
      }
      return _buildMobileLayout(context);
    },
  );
}
```

**Use existing extension methods:**
```dart
// lib/core/extensions/context_extensions.dart
context.screenWidth
context.screenHeight
context.isTablet
context.isMobile
```

---

### Phase 5: Screen Implementation

#### 5.1 Screen Location Structure

```
lib/features/{feature_name}/presentation/screens/
└── {screen_name}_screen.dart
```

**Examples:**
```
lib/features/home/presentation/screens/home_screen.dart
lib/features/auth/presentation/screens/login_screen.dart
lib/features/settings/presentation/screens/settings_screen.dart
```

#### 5.2 Screen Template

**Standard screen structure:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// {Screen Name} Screen
///
/// Displays {brief description of what this screen shows}
class MyFeatureScreen extends ConsumerWidget {
  const MyFeatureScreen({super.key});

  // For navigation
  static const String routeName = '/my-feature';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Feature'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Screen content here
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      'Header',
      style: textTheme.headlineMedium,
    );
  }

  Widget _buildContent(BuildContext context) {
    return const Placeholder();
  }
}
```

**For stateful screens with controllers:**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyFeatureScreen extends ConsumerStatefulWidget {
  const MyFeatureScreen({super.key});

  @override
  ConsumerState<MyFeatureScreen> createState() => _MyFeatureScreenState();
}

class _MyFeatureScreenState extends ConsumerState<MyFeatureScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize controller or load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Call controller methods after first frame
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch providers
    final state = ref.watch(myFeatureControllerProvider);

    return state.when(
      data: (data) => _buildContent(context, data),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorView(error: error.toString()),
    );
  }

  Widget _buildContent(BuildContext context, MyData data) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Feature')),
      body: SafeArea(
        child: Container(
          // Implementation
        ),
      ),
    );
  }
}
```

#### 5.3 Add Navigation Route

**Update:** `lib/core/navigation/app_router.dart`

```dart
GoRoute(
  path: MyFeatureScreen.routeName,
  name: 'myFeature',
  builder: (context, state) => const MyFeatureScreen(),
),
```

**Update:** `lib/core/navigation/routes.dart`

```dart
class Routes {
  // ... existing routes
  static const String myFeature = '/my-feature';
}
```

**Navigate to screen:**
```dart
// Using context
context.go(Routes.myFeature);
context.push(Routes.myFeature);

// Using GoRouter
GoRouter.of(context).go(Routes.myFeature);
```

---

### Phase 6: State Management Integration

#### 6.1 When to Create a Controller

**Create a controller (AsyncNotifier) when:**
- Screen has complex business logic
- Screen needs to fetch/mutate data
- Screen has multiple async states (loading, success, error)
- Screen interacts with repositories or services

**Don't create a controller for:**
- Static informational screens
- Simple navigation screens
- Screens that only display passed data

#### 6.2 Controller Template

**Location:** `lib/features/{feature}/presentation/controllers/{name}_controller.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/errors/failures.dart';

// State
class MyFeatureState {
  final List<Item> items;
  final bool isLoading;
  final String? error;

  const MyFeatureState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  MyFeatureState copyWith({
    List<Item>? items,
    bool? isLoading,
    String? error,
  }) {
    return MyFeatureState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Controller
class MyFeatureController extends AsyncNotifier<MyFeatureState> {
  @override
  Future<MyFeatureState> build() async {
    // Initialize state
    return const MyFeatureState();
  }

  Future<void> loadData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(myRepositoryProvider);
      final items = await repository.fetchItems();
      return MyFeatureState(items: items);
    });
  }

  Future<void> performAction() async {
    state.whenData((currentState) async {
      state = AsyncValue.data(currentState.copyWith(isLoading: true));

      try {
        final repository = ref.read(myRepositoryProvider);
        await repository.performAction();

        // Reload data
        await loadData();
      } catch (e) {
        state = AsyncValue.data(
          currentState.copyWith(
            isLoading: false,
            error: e.toString(),
          ),
        );
      }
    });
  }
}

// Provider
final myFeatureControllerProvider =
    AsyncNotifierProvider<MyFeatureController, MyFeatureState>(
  MyFeatureController.new,
);
```

---

### Phase 7: Testing (Optional but Recommended)

#### 7.1 Widget Tests

**Location:** `test/widget/features/{feature}/presentation/widgets/{widget_name}_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waffir/features/{feature}/presentation/widgets/{widget}.dart';

void main() {
  group('MyCustomWidget', () {
    testWidgets('renders with title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyCustomWidget(
              title: 'Test Title',
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyCustomWidget(
              title: 'Test',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(MyCustomWidget));
      expect(tapped, true);
    });
  });
}
```

**Run tests:**
```bash
flutter test test/widget/features/{feature}/
```

---

### Phase 8: Documentation & Handoff

#### 8.1 Create Implementation Summary

Create a markdown file documenting the implementation:

```markdown
# {Feature Name} - Implementation Summary

## Overview
Brief description of what was implemented.

## Figma Design
- Design URL: [link]
- Node ID: {nodeId}
- Screenshots: (attach if helpful)

## Files Created/Modified

### Screens
- `lib/features/{feature}/presentation/screens/{screen}_screen.dart`

### Widgets
- `lib/core/widgets/{category}/{widget}.dart`
- `lib/features/{feature}/presentation/widgets/{widget}.dart`

### Assets
- `assets/icons/{category}/ic_{name}.svg`
- `assets/images/img_{name}.png`

### Theme Updates
- `lib/core/themes/app_theme.dart` (if modified)

### Routes
- `lib/core/navigation/app_router.dart`
- `lib/core/navigation/routes.dart`

## Design Decisions
- Why certain widgets were reused
- Why certain colors were added to theme
- Any deviations from Figma design and reasoning

## Usage Example
```dart
// Code example showing how to use the new feature
```

## Testing
- [ ] Tested on iOS
- [ ] Tested on Android
- [ ] Tested in light mode
- [ ] Tested in dark mode
- [ ] Widget tests added (if applicable)

## Next Steps
- Any follow-up tasks or improvements needed
```

#### 8.2 Update Assets Documentation

If significant assets were added, update or create:

```markdown
# Assets Documentation

## Icons
| Icon | Path | Usage |
|------|------|-------|
| Home | `Assets.icons.navigation.icHome` | Bottom navigation |
| Settings | `Assets.icons.navigation.icSettings` | Bottom navigation |

## Images
| Image | Path | Usage |
|-------|------|-------|
| Onboarding | `Assets.images.onboardingWelcome` | Onboarding screen |

## Access Pattern
```dart
// Generated asset classes (DO NOT hardcode paths)
Image.asset(Assets.images.{name}.path)
SvgPicture.asset(Assets.icons.{category}.{name}.path)
```
```

---

## 🚨 Critical Rules for Waffir Implementation

### ❌ NEVER DO:

1. **Never import or use AppColors directly in widgets**
   ```dart
   // ❌ WRONG
   import 'package:waffir/core/themes/app_colors.dart';
   color: AppColors.primary
   ```

2. **Never hardcode asset paths**
   ```dart
   // ❌ WRONG
   Image.asset('assets/images/logo.png')
   ```

3. **Never create widgets without checking existing widgets first**
   - Always check `lib/core/widgets/` before creating new components

4. **Never skip theme context**
   ```dart
   // ❌ WRONG
   Text('Hello', style: TextStyle(fontSize: 16))

   // ✅ CORRECT
   Text('Hello', style: Theme.of(context).textTheme.bodyLarge)
   ```

5. **Never modify translation files manually**
   - `assets/translations/` files should only be updated through proper i18n workflow

### ✅ ALWAYS DO:

1. **Always use Theme.of(context) for colors and typography**
   ```dart
   // ✅ CORRECT
   color: Theme.of(context).colorScheme.primary
   style: Theme.of(context).textTheme.headlineMedium
   ```

2. **Always use generated asset classes**
   ```dart
   // ✅ CORRECT
   Image.asset(Assets.images.logo.path)
   SvgPicture.asset(Assets.icons.navigation.icHome.path)
   ```

3. **Always run code generation after adding assets**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Always register assets in pubspec.yaml**
   ```yaml
   flutter:
     assets:
       - assets/images/
       - assets/icons/
   ```

5. **Always follow the feature folder structure**
   ```
   lib/features/{feature}/
   ├── domain/
   ├── data/
   └── presentation/
       ├── screens/
       ├── widgets/
       └── controllers/
   ```

6. **Always use const constructors when possible**
   ```dart
   const MyWidget() // Better performance
   ```

7. **Always add documentation comments to public APIs**
   ```dart
   /// Brief description
   ///
   /// Longer description if needed
   class MyWidget extends StatelessWidget { }
   ```

---

## 🔧 Claude Code Execution Workflow

When implementing a Figma design, follow this systematic approach:

### Step 1: Initialize Task Tracking
```dart
// Use TodoWrite to create task list
[
  "Extract Figma design data and screenshots",
  "Analyze design against existing theme",
  "Extract and organize assets",
  "Implement widgets following Waffir patterns",
  "Create screen with proper navigation",
  "Add state management if needed",
  "Test in light/dark mode",
  "Generate documentation"
]
```

### Step 2: Extract Design Data
```markdown
1. Call mcp__figma__get_screenshot for visual reference
2. Call mcp__figma__get_design_context for code and assets
3. Call mcp__figma__get_metadata for structure (if needed)
4. Save screenshots for documentation
```

### Step 3: Analyze & Plan
```markdown
1. Read lib/core/themes/app_theme.dart
2. Check lib/core/widgets/ for reusable components
3. Identify new colors, text styles, assets needed
4. Plan widget hierarchy
5. Decide if controller is needed
```

### Step 4: Assets Setup
```markdown
1. Extract asset URLs from get_design_context response
2. Download and save to proper asset directories
3. Name assets following conventions
4. Update pubspec.yaml
5. Run: dart run build_runner build --delete-conflicting-outputs
6. Verify: Check lib/gen/assets.gen.dart generated
```

### Step 5: Theme Extensions (if needed)
```markdown
1. Add colors to ColorScheme in app_theme.dart (both light/dark)
2. Add text styles to TextTheme if needed
3. Document new theme additions
```

### Step 6: Widget Implementation
```markdown
1. Create widget file in proper location
2. Use Theme.of(context) for all styling
3. Use generated asset classes
4. Follow Waffir widget patterns
5. Add documentation comments
6. Use const constructors
```

### Step 7: Screen Implementation
```markdown
1. Create screen file in features/{feature}/presentation/screens/
2. Add to app_router.dart
3. Add route constant to routes.dart
4. Implement screen with Scaffold
5. Integrate widgets
6. Test navigation
```

### Step 8: State Management (if needed)
```markdown
1. Create controller in presentation/controllers/
2. Define state class
3. Implement AsyncNotifier
4. Create provider
5. Integrate with screen
```

### Step 9: Testing & Verification
```markdown
1. Run: flutter run --flavor dev -t lib/main_dev.dart
2. Test in light mode
3. Test in dark mode
4. Test navigation
5. Test interactions
6. Run: flutter analyze
7. Run: dart format .
```

### Step 10: Documentation
```markdown
1. Create implementation summary
2. Document any theme changes
3. List all files created/modified
4. Add usage examples
5. Note any deviations from Figma
```

---

## 🎨 Design System Reference

### Material 3 Color Roles

Use these semantic color roles from `Theme.of(context).colorScheme`:

**Primary colors:**
- `primary` - Main brand color, primary buttons
- `onPrimary` - Text/icons on primary
- `primaryContainer` - Less prominent primary backgrounds
- `onPrimaryContainer` - Text/icons on primary containers

**Secondary colors:**
- `secondary` - Secondary brand color
- `onSecondary` - Text/icons on secondary
- `secondaryContainer` - Secondary backgrounds
- `onSecondaryContainer` - Text on secondary containers

**Surface colors:**
- `surface` - Card, dialog, sheet backgrounds
- `onSurface` - Text/icons on surfaces
- `surfaceVariant` - Alternative surface color
- `onSurfaceVariant` - Text on surface variants

**Other semantic colors:**
- `error` - Error states, destructive actions
- `onError` - Text on error backgrounds
- `background` - Screen background
- `onBackground` - Text on background
- `outline` - Borders, dividers
- `shadow` - Shadows

### Material 3 Text Styles

Use these from `Theme.of(context).textTheme`:

**Display:**
- `displayLarge` - 57sp, Large marketing headlines
- `displayMedium` - 45sp, Medium marketing headlines
- `displaySmall` - 36sp, Small marketing headlines

**Headline:**
- `headlineLarge` - 32sp, Large page titles
- `headlineMedium` - 28sp, Medium page titles
- `headlineSmall` - 24sp, Small page titles

**Title:**
- `titleLarge` - 22sp, Card/section titles
- `titleMedium` - 16sp, Medium titles
- `titleSmall` - 14sp, Small titles

**Body:**
- `bodyLarge` - 16sp, Primary body text
- `bodyMedium` - 14sp, Secondary body text
- `bodySmall` - 12sp, Captions, helper text

**Label:**
- `labelLarge` - 14sp, Button text
- `labelMedium` - 12sp, Chip text
- `labelSmall` - 11sp, Small labels

---

## 🛠️ Troubleshooting

### Figma MCP Not Available

**Error:** Figma tools not found

**Solution:**
1. Check MCP server is running
2. Verify Figma plugin is installed
3. Restart Claude Code
4. Check `claude_desktop_config.json` for Figma MCP configuration

### Asset Generation Failed

**Error:** `dart run build_runner build` fails

**Solution:**
1. Run: `dart run build_runner clean`
2. Run: `flutter clean`
3. Run: `flutter pub get`
4. Run: `dart run build_runner build --delete-conflicting-outputs`

### Theme Not Applied

**Issue:** Colors not matching design

**Checklist:**
- [ ] Using `Theme.of(context).colorScheme.*`?
- [ ] Not importing `AppColors`?
- [ ] Theme updated in both light and dark variants?
- [ ] App restarted after theme changes?

### Assets Not Found

**Issue:** Asset path errors at runtime

**Checklist:**
- [ ] Assets registered in `pubspec.yaml`?
- [ ] Code generation run?
- [ ] Using generated asset classes (`Assets.*`)?
- [ ] Asset files exist in correct directory?
- [ ] Hot restart performed?

---

## 📚 Additional Resources

**Waffir Documentation:**
- Project overview: `CLAUDE.md`
- Firebase setup: `FIREBASE_SETUP.md`
- Deployment: `scripts/README.md`

**Flutter Documentation:**
- Material 3: https://m3.material.io/
- Theme: https://docs.flutter.dev/cookbook/design/themes
- Navigation: https://pub.dev/packages/go_router
- State Management: https://riverpod.dev/

**Code Generation:**
- Freezed: https://pub.dev/packages/freezed
- Flutter Gen: https://pub.dev/packages/flutter_gen
- Build Runner: https://pub.dev/packages/build_runner

---

## ✅ Implementation Checklist

Use this checklist for each Figma-to-code implementation:

### Pre-Implementation
- [ ] Figma URL with node ID obtained
- [ ] Figma MCP verified working
- [ ] Current theme reviewed (`app_theme.dart`)
- [ ] Existing widgets checked (`lib/core/widgets/`)

### Design Extraction
- [ ] Screenshot captured with `mcp__figma__get_screenshot`
- [ ] Design context extracted with `mcp__figma__get_design_context`
- [ ] Metadata reviewed (if needed)

### Theme Analysis
- [ ] Colors mapped to existing ColorScheme
- [ ] Text styles mapped to existing TextTheme
- [ ] New theme tokens identified (if needed)
- [ ] Theme updates made in both light/dark modes

### Assets
- [ ] Assets downloaded from Figma
- [ ] Assets saved to correct directories with proper naming
- [ ] `pubspec.yaml` updated
- [ ] Code generation run
- [ ] Generated asset classes verified

### Implementation
- [ ] Widgets created in correct locations
- [ ] `Theme.of(context)` used throughout
- [ ] Generated asset classes used
- [ ] Documentation comments added
- [ ] Const constructors used where possible

### Navigation
- [ ] Screen created in features folder
- [ ] Route added to `app_router.dart`
- [ ] Route constant added to `routes.dart`
- [ ] Navigation tested

### State Management
- [ ] Controller created (if needed)
- [ ] Provider defined
- [ ] State integrated with screen
- [ ] Loading/error states handled

### Testing
- [ ] Tested in dev flavor
- [ ] Tested light mode
- [ ] Tested dark mode
- [ ] Tested navigation flows
- [ ] Tested interactions
- [ ] `flutter analyze` passed
- [ ] Code formatted

### Documentation
- [ ] Implementation summary created
- [ ] Files list documented
- [ ] Design decisions noted
- [ ] Usage examples provided
- [ ] Next steps identified

---

**Ready to convert Figma designs to production Flutter code for Waffir!**

*Last Updated: 2025-01-10*
