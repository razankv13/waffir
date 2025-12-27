---
name: responsive-ui
description: Implements responsive layouts using ResponsiveHelper. Use when creating UI components, scaling Figma dimensions, handling different screen sizes, or ensuring cross-device compatibility.
---

# Responsive UI Design

## When to Use This Skill

Use this skill when:
- Converting Figma designs to Flutter
- Creating any UI with dimensions, padding, or fonts
- Building layouts that work on mobile, tablet, and desktop
- Implementing device-specific or orientation-specific variations

## Design Reference

**Figma design frames: 393x852px (mobile)**

**Golden Rule:** NEVER hardcode pixel values. ALWAYS use ResponsiveHelper.

## Setup (Required)

The app must wrap `MaterialApp` with `ResponsiveScope`:

```dart
import 'package:waffir/core/utils/responsive_helper.dart';

ResponsiveScope(
  // Optional: customize config (defaults shown)
  config: const ResponsiveConfig(
    figmaWidth: 393,
    figmaHeight: 852,
    mobileBreakpoint: 600,
    tabletBreakpoint: 900,
    desktopBreakpoint: 1200,
    minScaleFactor: 0.8,
    maxScaleFactor: 1.4,
    scalingCurve: ScalingCurve.bounded,
  ),
  child: MaterialApp(...),
)
```

## Device Breakpoints

- **Mobile:** < 900px width
- **Tablet:** 900px - 1199px width
- **Desktop:** >= 1200px width

## Scaling Curves

| Curve | Behavior |
|-------|----------|
| `ScalingCurve.linear` | Pure linear: `size * scaleFactor` (can be extreme) |
| `ScalingCurve.bounded` | Clamped between `minScaleFactor` and `maxScaleFactor` (default) |
| `ScalingCurve.diminishing` | Logarithmic scaling, gentler on large screens |

## Basic Usage

### Access ResponsiveHelper

```dart
// Via context extension (preferred, shortest)
context.rs.s(16)
context.s(16)           // Even shorter direct access
context.sFont(16)
context.sHeight(16)

// Or get full helper
final rs = context.rs;
rs.s(200)
```

### Scale Dimensions (Most Common)

```dart
Container(
  width: context.s(343),               // 343px from Figma
  height: context.rs.sHeight(200),     // Height-based scaling
  margin: context.rs.sPadding(
    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
)
```

### Scale Font Sizes

```dart
Text(
  'Hello World',
  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    fontSize: context.sFont(16),  // Respects system accessibility settings
  ),
)
```

### Scale Padding & Margins

```dart
// Full EdgeInsets
Padding(
  padding: context.rs.sPadding(const EdgeInsets.all(16)),
  child: child,
)

// Symmetric
Padding(
  padding: context.rs.sPaddingSymmetric(horizontal: 24, vertical: 16),
)

// All sides equal
Padding(
  padding: context.rs.sPaddingAll(16),
)
```

### Scale Border Radius

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: context.rs.sBorderRadius(BorderRadius.circular(12)),
    // Or simpler for circular:
    borderRadius: context.rs.sBorderRadiusCircular(12),
  ),
)
```

## Constrained Scaling

### With Min/Max Constraints

```dart
// Constrain between 80px and 400px
final width = context.rs.sConstrained(200, min: 80, max: 400);

// Only minimum
final height = context.rs.sConstrained(100, min: 80);

// Only maximum
final size = context.rs.sConstrained(300, max: 400);
```

## Device-Specific Values

### Different Values Per Device

```dart
// Different column counts
final columns = context.rs.byDevice(
  mobile: 2,
  tablet: 3,
  desktop: 4,
);

// Different padding
final padding = context.rs.byDevice(
  mobile: 16.0,
  tablet: 24.0,
  desktop: 32.0,
);
```

### Different Values Per Orientation

```dart
final columns = context.rs.byOrientation(
  portrait: 2,
  landscape: 4,
);
```

### Responsive Widgets

```dart
// Use ResponsiveLayout widget
ResponsiveLayout(
  mobile: MobileProductGrid(),
  tablet: TabletProductGrid(),
  desktop: DesktopProductGrid(),
)

// Or OrientationLayout
OrientationLayout(
  portrait: PortraitView(),
  landscape: LandscapeView(),
)
```

## Device & Orientation Detection

```dart
// Device type
if (context.isMobile) { /* Mobile-specific */ }
if (context.isTablet) { /* Tablet-specific */ }
if (context.isDesktop) { /* Desktop-specific */ }

// Orientation
if (context.isPortrait) { /* Portrait */ }
if (context.isLandscape) { /* Landscape */ }

// Full access
final rs = context.rs;
rs.screenWidth
rs.screenHeight
rs.deviceType   // DeviceType.mobile | .tablet | .desktop
rs.orientation  // Orientation.portrait | .landscape
```

## Complete Widget Example

```dart
class ProductDetailScreen extends HookConsumerWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final rs = context.rs;

    return Scaffold(
      body: SingleChildScrollView(
        padding: rs.sPaddingSymmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: rs.sHeight(300),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: rs.sBorderRadiusCircular(16),
              ),
            ),

            ResponsiveGap(24),  // Scaled vertical gap

            // Product Title
            Text(
              'Product Name',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: rs.sFont(24),
              ),
            ),

            ResponsiveGap(8),

            // Price Row
            Row(
              children: [
                Text(
                  '\$99.99',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: rs.sFont(20),
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ResponsiveGap(12, horizontal: true),
                Text(
                  '\$129.99',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: rs.sFont(14),
                    decoration: TextDecoration.lineThrough,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

## Grid Layouts

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: context.rs.gridColumns(),  // 2/3/4 based on device
    crossAxisSpacing: context.s(16),
    mainAxisSpacing: context.s(16),
    childAspectRatio: 0.75,
  ),
  padding: context.rs.sPaddingAll(16),
  itemBuilder: (context, index) => ProductCard(...),
)
```

## Responsive Widgets

### ResponsiveGap

```dart
// Vertical gap (default)
ResponsiveGap(24)

// Horizontal gap
ResponsiveGap(16, horizontal: true)
```

### ResponsiveContent

Constrains content width on large screens:

```dart
ResponsiveContent(
  maxWidth: 1200,  // Optional, uses defaults by device
  child: YourContent(),
)
```

## Standard Spacing Helpers

```dart
// Standard horizontal padding (16/24/32 based on device)
final horizontalPad = context.rs.horizontalPadding();

// Standard vertical padding (16/20/24 based on device)
final verticalPad = context.rs.verticalPadding();

// Max content width (full on mobile, 720 tablet, 1200 desktop)
final maxWidth = context.rs.contentMaxWidth();
```

## Safe Area & Keyboard

```dart
final rs = context.rs;

// Safe area
rs.safeArea          // EdgeInsets
rs.topSafeArea       // double
rs.bottomSafeArea    // double
rs.hasBottomNotch    // bool
rs.hasTopNotch       // bool
rs.safeWidth         // screen width minus safe areas
rs.safeHeight        // screen height minus safe areas

// Keyboard
rs.keyboardHeight    // double
rs.isKeyboardVisible // bool
rs.availableHeight   // screen height minus keyboard
```

## Method Reference

| Method | Use Case |
|--------|----------|
| `s(double)` | Scale any dimension |
| `sHeight(double)` | Scale height-based values (vertical) |
| `sFont(double, {minSize})` | Scale fonts with accessibility |
| `sIcon(double, {minSize})` | Scale icons with minimum |
| `sConstrained(double, {min, max})` | Scale with constraints |
| `sPadding(EdgeInsets)` | Scale EdgeInsets |
| `sPaddingSymmetric({h, v})` | Scale symmetric padding |
| `sPaddingAll(double)` | Scale uniform padding |
| `sBorderRadius(BorderRadius)` | Scale border radius |
| `sBorderRadiusCircular(double)` | Scale circular radius |
| `sSize(Size)` | Scale Size objects |
| `sOffset(Offset)` | Scale Offset values |
| `sConstraints(BoxConstraints)` | Scale constraints |
| `byDevice<T>({mobile, tablet, desktop})` | Device-specific values |
| `byOrientation<T>({portrait, landscape})` | Orientation-specific values |
| `gridColumns({mobile, tablet, desktop})` | Grid column count |
| `horizontalPadding()` | Standard h-padding |
| `verticalPadding()` | Standard v-padding |
| `contentMaxWidth()` | Max content width |

## Responsive Widgets

| Widget | Use Case |
|--------|----------|
| `ResponsiveScope` | Wrap app root (required) |
| `ResponsiveBuilder` | Build with ResponsiveHelper |
| `ResponsiveLayout` | Different widgets per device |
| `OrientationLayout` | Different widgets per orientation |
| `ResponsiveContent` | Constrained content wrapper |
| `ResponsiveGap` | Scaled SizedBox gaps |

## Critical Rules

1. **NEVER hardcode pixels** - Always use `s()` or related methods
2. **ALWAYS scale Figma values** - `s(343)` not `343.0`
3. **Use sFont for text** - `sFont(16)` respects accessibility
4. **Use sHeight for vertical** - `sHeight(24)` for vertical spacing
5. **Use Theme.of(context)** - Colors come from theme, not hardcoded

## Figma to Flutter Workflow

1. Get dimension from Figma design (e.g., width: 343px)
2. Use `context.s(343)` in Flutter
3. For fonts: `context.sFont(16)`
4. For vertical spacing: `context.rs.sHeight(24)` or `ResponsiveGap(24)`
5. For padding: `context.rs.sPadding(EdgeInsets...)` or `sPaddingSymmetric(...)`
6. For radius: `context.rs.sBorderRadiusCircular(12)`

## File Location

`lib/core/utils/responsive_helper.dart`
