# UI/UX Guidelines & Widget Library

## 🎨 Design System (Updated 2025)

### Color Scheme

**Primary Brand Color:** Mint Green (#00D9A3)
- Use for primary actions, highlights, selected states
- Access via: `Theme.of(context).colorScheme.primary`

**Secondary Color:** Indigo (#6366F1)
- Use for secondary actions, accents
- Access via: `Theme.of(context).colorScheme.secondary`

**E-Commerce Specific Colors:**
- **Sale Red:** `Color(0xFFFF3B30)` - Sale badges, discounted prices
- **NEW Badge:** `Color(0xFF5856D6)` - "NEW" product labels
- **Rating Gold:** `Color(0xFFFBBF24)` - Star ratings
- **Price Original:** `Color(0xFF9CA3AF)` - Strikethrough original prices
- **Price Discounted:** `Color(0xFFEF4444)` - Sale price text

### Typography

**Product-Specific Styles (from AppTypography):**
- `priceText` - 20px bold for main prices
- `priceSmall` - 16px semibold for smaller price displays
- `salePriceText` - 20px bold for sale prices
- `originalPriceText` - 14px regular with strikethrough
- `badgeText` - 10px bold with wide letter spacing
- `productTitle` - 14px medium for product names
- `productBrand` - 12px regular for brand names

**Access Pattern:**
```dart
// ✅ CORRECT
Text('Product', style: AppTypography.productTitle)
Text('$99.99', style: AppTypography.priceText)

// For themed text:
Text('Product', style: Theme.of(context).textTheme.bodyLarge)
```

---

## 🔴 CRITICAL RULES

### 1. ALWAYS Use Theme.of(context) for Colors

```dart
// ❌ NEVER DO THIS
import 'package:waffir/core/constants/app_colors.dart';
Container(color: AppColors.primary)

// ✅ ALWAYS DO THIS
Container(color: Theme.of(context).colorScheme.primary)
Container(color: Theme.of(context).colorScheme.surface)
```

**Why:** Ensures light/dark mode support, Material 3 consistency, and theme switching works properly.

### 2. ALWAYS Use Theme.of(context) for Text Styles

```dart
// ❌ NEVER DO THIS
Text('Hello', style: TextStyle(fontSize: 16))

// ✅ ALWAYS DO THIS
Text('Hello', style: Theme.of(context).textTheme.bodyLarge)

// ✅ OR with AppTypography for specific styles
Text('$99.99', style: AppTypography.priceText.copyWith(
  color: Theme.of(context).colorScheme.onSurface,
))
```

### 3. ALWAYS Check for Existing Widgets Before Creating New Ones

**Before creating a new widget, check:**
- `lib/core/widgets/` - Core reusable widgets
- `lib/core/widgets/products/` - Product-related widgets
- `lib/core/widgets/search/` - Search and filter widgets
- `lib/core/widgets/cart/` - Shopping cart widgets
- `lib/core/widgets/buttons/` - Button components

---

## 📦 Available Widget Library

### Product Widgets (`lib/core/widgets/products/`)

#### 1. BadgeWidget
**Purpose:** Display product labels (NEW, SALE, 20% OFF)

```dart
BadgeWidget(
  text: 'SALE',
  type: BadgeType.sale,      // sale, newBadge, discount, featured, custom
  size: BadgeSize.medium,    // small, medium, large
)
```

**Types:**
- `BadgeType.sale` - Red background (#FF3B30)
- `BadgeType.newBadge` - Purple background (#5856D6)
- `BadgeType.discount` - Error color
- `BadgeType.featured` - Primary color
- `BadgeType.custom` - Secondary container color

#### 2. RatingDisplay
**Purpose:** Show star ratings with optional review count

```dart
RatingDisplay(
  rating: 4.5,
  reviewCount: 128,           // Optional
  size: RatingSize.medium,    // small, medium, large
  showRatingText: true,       // Shows numerical rating
  starColor: Color(0xFFFBBF24), // Optional custom color
)
```

**Features:**
- Full stars, half stars, empty stars
- Review count in parentheses
- Configurable sizes

#### 3. PriceDisplay
**Purpose:** Display product prices with sale/discount information

```dart
PriceDisplay(
  price: 79.99,
  originalPrice: 99.99,       // Optional, shows strikethrough
  discountPercentage: 20,     // Optional, shows badge
  currency: '\$',
  size: PriceSize.medium,     // small, medium, large
  showCurrency: true,
)
```

**Features:**
- Automatic sale detection
- Strikethrough original price
- Discount percentage badge
- Red color for sale prices

#### 4. SizeSelector
**Purpose:** Size selection chips (S, M, L, XL)

```dart
SizeSelector(
  sizes: ['S', 'M', 'L', 'XL', 'XXL'],
  selectedSize: 'M',
  unavailableSizes: ['XXL'],  // Optional
  onSizeSelected: (size) => handleSizeChange(size),
)
```

**Features:**
- Selected state with primary color
- Disabled state for unavailable sizes
- 48x48 touch targets

#### 5. ProductCard
**Purpose:** Main product card for grid/list displays

```dart
ProductCard(
  imageUrl: 'https://...',
  title: 'Nike Air Max',
  brand: 'Nike',              // Optional
  price: 129.99,
  originalPrice: 159.99,      // Optional
  discountPercentage: 20,     // Optional
  rating: 4.5,                // Optional
  reviewCount: 128,           // Optional
  badge: 'NEW',               // Optional
  badgeType: BadgeType.newBadge, // Optional
  isFavorite: false,
  onTap: () => navigateToDetail(),
  onFavorite: () => toggleFavorite(), // Optional
)
```

**Features:**
- Image with loading/error states
- Badge overlay (top left)
- Favorite button (top right)
- Brand, title, rating, price
- Automatic sale price styling

#### 6. ProductGrid
**Purpose:** Grid layout for products with empty state

```dart
ProductGrid(
  products: productList,
  crossAxisCount: 2,
  childAspectRatio: 0.7,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  padding: EdgeInsets.all(16),
)
```

**ProductGridItem Model:**
```dart
ProductGridItem(
  id: '1',
  imageUrl: '...',
  title: 'Product',
  price: 99.99,
  // ... all ProductCard properties
)
```

#### 7. ProductImageGallery
**Purpose:** Swipeable image gallery for product detail

```dart
ProductImageGallery(
  imageUrls: ['url1', 'url2', 'url3'],
  height: 400,
  showIndicators: true,
  autoPlay: false,            // Optional
  autoPlayInterval: Duration(seconds: 3),
)
```

**Features:**
- PageView with smooth scrolling
- Dot indicators at bottom
- Arrow buttons for desktop
- Loading/error states

### Search & Filter Widgets (`lib/core/widgets/search/`)

#### 8. SearchBarWidget
**Purpose:** Custom search bar with filter button

```dart
SearchBarWidget(
  hintText: 'Search products...',
  onSearch: (query) => performSearch(query),
  onChanged: (query) => updateResults(query),
  onFilterTap: () => showFilters(),
  showFilterButton: true,
  autofocus: false,
)
```

**Features:**
- Search icon (left)
- Clear button (appears when text entered)
- Optional filter button (right)
- Rounded corners (24px radius)

#### 9. CategoryFilterChips
**Purpose:** Horizontal scrollable category chips

```dart
CategoryFilterChips(
  categories: ['All', 'Shoes', 'Clothing', 'Accessories'],
  selectedCategory: 'Shoes',
  onCategorySelected: (category) => filterProducts(category),
  height: 40,
)
```

**Variant with Count:**
```dart
CategoryFilterChipWithCount(
  label: 'Shoes',
  count: 42,
  isSelected: true,
  onTap: () => filterByShoes(),
)
```

### Cart Widgets (`lib/core/widgets/cart/`)

#### 10. CartButton
**Purpose:** Floating cart button with item count badge

```dart
// Floating version
CartButton(
  itemCount: 3,
  onTap: () => navigateToCart(),
  size: CartButtonSize.medium, // small, medium, large
)

// AppBar version
AppBarCartButton(
  itemCount: 3,
  onTap: () => navigateToCart(),
)
```

**Features:**
- Shopping bag icon
- Badge with count (shows "99+" for >99)
- Error color for badge
- Circular shape

#### 11. CartItemCard
**Purpose:** Display cart items with quantity controls

```dart
CartItemCard(
  imageUrl: '...',
  title: 'Nike Air Max',
  brand: 'Nike',              // Optional
  size: 'M',                  // Optional
  color: 'Black',             // Optional
  price: 129.99,
  originalPrice: 159.99,      // Optional
  quantity: 2,
  maxQuantity: 10,
  onQuantityChanged: (qty) => updateQuantity(qty),
  onRemove: () => removeItem(),
)
```

**Features:**
- 80x80 product image
- Brand and title
- Size and color display
- Quantity controls (+/- buttons)
- Price display (sale if applicable)
- Remove button (delete icon)

---

## 🎯 Widget Creation Guidelines

### When Creating New Widgets

1. **Check existing widgets first** - Don't duplicate functionality

2. **Use const constructors** wherever possible:
```dart
const MyWidget({
  super.key,
  required this.title,
  this.subtitle,
})
```

3. **Access theme properly**:
```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;
  
  return Container(color: colorScheme.surface);
}
```

4. **Add documentation comments**:
```dart
/// Brief description of what this widget does
///
/// Example usage:
/// ```dart
/// MyWidget(
///   title: 'Hello',
///   onTap: () => print('tapped'),
/// )
/// ```
class MyWidget extends StatelessWidget { ... }
```

5. **Follow naming conventions**:
   - Reusable core widgets: `lib/core/widgets/{category}/{name}.dart`
   - Feature-specific widgets: `lib/features/{feature}/presentation/widgets/{name}.dart`

6. **Use proper parameter naming**:
   - Required parameters first
   - Optional parameters with defaults where sensible
   - Use `final` for all properties

### Widget Organization

**Core Widgets Structure:**
```
lib/core/widgets/
├── products/        # Product-related widgets
├── search/          # Search and filter widgets
├── cart/            # Shopping cart widgets
├── buttons/         # Button components (AppButton)
├── loading/         # Loading indicators
├── dialogs/         # Dialog components
├── ads/             # Ad integration widgets
└── animations/      # Animation widgets
```

---

## 🎨 Material 3 Color Roles

**Always use semantic color roles:**

```dart
// Surfaces
colorScheme.surface              // Card, dialog backgrounds
colorScheme.surfaceContainerHighest // Elevated surfaces
colorScheme.surfaceVariant       // Alternative surfaces

// Foregrounds
colorScheme.onSurface            // Primary text on surfaces
colorScheme.onSurfaceVariant     // Secondary text
colorScheme.onPrimary            // Text on primary color
colorScheme.onSecondary          // Text on secondary color

// Actions
colorScheme.primary              // Primary buttons, selected items
colorScheme.primaryContainer     // Primary chip backgrounds
colorScheme.secondary            // Secondary buttons
colorScheme.secondaryContainer   // Secondary chip backgrounds

// Feedback
colorScheme.error                // Error states, destructive actions
colorScheme.errorContainer       // Error backgrounds
colorScheme.outline              // Borders, dividers
colorScheme.outlineVariant       // Subtle borders
```

---

## 📱 Responsive Design

**Use MediaQuery and LayoutBuilder:**

```dart
final size = MediaQuery.of(context).size;
final isTablet = size.width > 600;

return LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return _TabletLayout();
    }
    return _MobileLayout();
  },
);
```

**Or use context extensions:**
```dart
context.screenWidth
context.screenHeight
context.isTablet
context.isMobile
```

---

## ✅ Pre-Implementation Checklist

Before implementing any UI:

- [ ] Check `lib/core/widgets/` for existing widgets
- [ ] Review `app_theme.dart` for colors/styles
- [ ] Use `Theme.of(context)` for all colors
- [ ] Use `Theme.of(context).textTheme` or `AppTypography` for text
- [ ] Add const constructors where possible
- [ ] Document with /// comments
- [ ] Test in both light and dark mode

---

## 🚫 Common Mistakes to Avoid

1. **Hardcoding colors**
   ```dart
   // ❌ WRONG
   Container(color: Color(0xFF6366F1))
   
   // ✅ CORRECT
   Container(color: Theme.of(context).colorScheme.primary)
   ```

2. **Hardcoding text styles**
   ```dart
   // ❌ WRONG
   Text('Hello', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
   
   // ✅ CORRECT
   Text('Hello', style: Theme.of(context).textTheme.titleMedium)
   ```

3. **Not using const**
   ```dart
   // ❌ WRONG
   return SizedBox(width: 16)
   
   // ✅ CORRECT
   return const SizedBox(width: 16)
   ```

4. **Creating duplicate widgets**
   - Always check if a widget already exists before creating

5. **Not testing both themes**
   - Always test widgets in light AND dark mode

---

## 🔗 Related Files

- **Theme:** `lib/core/themes/app_theme.dart`
- **Colors:** `lib/core/constants/app_colors.dart` (reference only, don't import in widgets)
- **Typography:** `lib/core/constants/app_typography.dart`
- **Spacing:** `lib/core/constants/app_spacing.dart`
- **Extensions:** `lib/core/extensions/context_extensions.dart`