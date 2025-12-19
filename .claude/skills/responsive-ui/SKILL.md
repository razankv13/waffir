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
- Implementing device-specific variations

## Design Reference

**Figma design frames: 393x852px (mobile)**

**Golden Rule:** NEVER hardcode pixel values. ALWAYS use ResponsiveHelper.

## Device Breakpoints

- **Mobile:** < 600px width
- **Tablet:** 600px - 900px width
- **Desktop:** >= 900px width

## Basic Usage

### Access ResponsiveHelper

```dart
// Via context extension (preferred)
final responsive = context.responsive;

// Or create instance
final responsive = ResponsiveHelper(context);
```

### Scale Dimensions (Most Common)

```dart
// Scale any dimension from Figma
Container(
  width: context.responsive.scale(343),   // 343px from Figma
  height: context.responsive.scale(200),
  margin: context.responsive.scalePadding(
    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
)
```

### Scale Font Sizes

```dart
Text(
  'Hello World',
  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    fontSize: context.responsive.scaleFontSize(16, minSize: 12),
  ),
)
```

### Scale Padding & Margins

```dart
Padding(
  padding: context.responsive.scalePadding(
    const EdgeInsets.all(16),
  ),
  child: child,
)

Container(
  margin: context.responsive.scalePadding(
    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  ),
)
```

### Scale Border Radius

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: context.responsive.scaleBorderRadius(
      BorderRadius.circular(12),
    ),
  ),
)
```

## Constrained Scaling

### Minimum Size (Prevent Too Small)

```dart
// Element won't shrink below 80px
final width = context.responsive.scaleWithMin(100, min: 80);
```

### Maximum Size (Prevent Too Large)

```dart
// Element won't grow beyond 400px
final width = context.responsive.scaleWithMax(300, max: 400);
```

### Both Min and Max

```dart
// Constrain between 120px and 200px
final width = context.responsive.scaleWithRange(
  150,
  min: 120,
  max: 200,
);
```

## Device-Specific Values

### Different Values Per Device

```dart
// Different column counts
final columns = context.responsive.responsiveValue(
  mobile: 2,
  tablet: 3,
  desktop: 4,
);

// Different padding
final padding = context.responsive.responsiveValue(
  mobile: 16.0,
  tablet: 24.0,
  desktop: 32.0,
);
```

### Different Widgets Per Device

```dart
context.responsive.responsiveWidget(
  mobile: MobileProductGrid(),
  tablet: TabletProductGrid(),
  desktop: DesktopProductGrid(),
)
```

## Device Detection

```dart
// Check device type
if (context.isMobile) {
  // Mobile-specific code
} else if (context.isTablet) {
  // Tablet-specific code
} else if (context.isDesktop) {
  // Desktop-specific code
}

// Screen dimensions
final width = context.screenWidth;
final height = context.screenHeight;
```

## Complete Widget Example

```dart
class ProductDetailScreen extends HookConsumerWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    return Scaffold(
      body: SingleChildScrollView(
        padding: responsive.scalePadding(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: responsive.scale(300),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: responsive.scaleBorderRadius(
                  BorderRadius.circular(16),
                ),
              ),
            ),

            SizedBox(height: responsive.scale(24)),

            // Product Title
            Text(
              'Product Name',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: responsive.scaleFontSize(24, minSize: 18),
              ),
            ),

            SizedBox(height: responsive.scale(8)),

            // Price Row
            Row(
              children: [
                Text(
                  '\$99.99',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: responsive.scaleFontSize(20, minSize: 16),
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: responsive.scale(12)),
                Text(
                  '\$129.99',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: responsive.scaleFontSize(14, minSize: 12),
                    decoration: TextDecoration.lineThrough,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            SizedBox(height: responsive.scale(24)),

            // Description
            Text(
              'Product description goes here...',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: responsive.scaleFontSize(14, minSize: 12),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: responsive.scalePadding(
            const EdgeInsets.all(16),
          ),
          child: SizedBox(
            height: responsive.scale(56),
            child: AppButton(
              text: tr(LocaleKeys.addToCart),
              onPressed: () {},
            ),
          ),
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
    crossAxisCount: context.responsive.gridColumns(), // 2/3/4 based on device
    crossAxisSpacing: context.responsive.scale(16),
    mainAxisSpacing: context.responsive.scale(16),
    childAspectRatio: 0.75,
  ),
  padding: context.responsive.scalePadding(
    const EdgeInsets.all(16),
  ),
  itemBuilder: (context, index) => ProductCard(...),
)
```

## Standard Spacing Helpers

```dart
// Standard horizontal padding (16/24/32 based on device)
final horizontalPad = context.responsive.horizontalPadding();

// Standard vertical padding (16/20/24 based on device)
final verticalPad = context.responsive.verticalPadding();

// Max content width (full on mobile, 900 tablet, 1200 desktop)
Container(
  width: context.responsive.contentMaxWidth(),
  child: content,
)
```

## Safe Area Handling

```dart
// Check for notch/safe area
if (context.responsive.hasBottomNotch) {
  // Add extra bottom padding
}

// Access safe area insets
final safeArea = context.responsive.safeAreaInsets;
final bottomSafe = context.responsive.bottomSafeArea;
```

## Method Reference

| Method | Use Case |
|--------|----------|
| `scale(double)` | General dimensions |
| `scaleWithMin(double, min)` | Prevent too small |
| `scaleWithMax(double, max)` | Prevent too large |
| `scaleWithRange(double, min, max)` | Constrain both |
| `scaleFontSize(double, minSize)` | Font sizes |
| `scalePadding(EdgeInsets)` | Padding/margins |
| `scaleBorderRadius(BorderRadius)` | Border radius |
| `scaleSize(Size)` | Size objects |
| `scaleOffset(Offset)` | Offset values |
| `scaleConstraints(BoxConstraints)` | Constraints |
| `responsiveValue<T>()` | Device-specific values |
| `responsiveWidget()` | Device-specific widgets |
| `gridColumns()` | Grid column count (2/3/4) |
| `horizontalPadding()` | Standard h-padding |
| `verticalPadding()` | Standard v-padding |
| `contentMaxWidth()` | Max content width |

## Critical Rules

1. **NEVER hardcode pixels** - Always use `scale()` or related methods
2. **ALWAYS scale Figma values** - `scale(343)` not `343.0`
3. **Scale fonts with minSize** - `scaleFontSize(16, minSize: 12)`
4. **Scale ALL padding** - Use `scalePadding()` for EdgeInsets
5. **Use Theme.of(context)** - Colors come from theme, not hardcoded

## Figma to Flutter Workflow

1. Get dimension from Figma design (e.g., width: 343px)
2. Use `context.responsive.scale(343)` in Flutter
3. For fonts: `context.responsive.scaleFontSize(16)`
4. For padding: `context.responsive.scalePadding(EdgeInsets...)`
5. For radius: `context.responsive.scaleBorderRadius(...)`

## File Location

`lib/core/utils/responsive_helper.dart`
