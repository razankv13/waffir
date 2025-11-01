# Product Detail & Store Page Screens - Figma to Implementation Mapping

## Overview
Implementation of product pages based on Figma design (node 54:5766) with complete Clean Architecture and mocked data.

**Figma Reference:**
- File Key: ZsZg4SBnPpkfAcmQYeL7yu
- Section Node ID: 54:5766 ("Product pages")
- Product Page Node ID: 54:5767
- Store Page Node ID: 54:5897

**Implementation Files:**
- Product Screen: `lib/features/products/presentation/screens/product_detail_screen.dart`
- Store Screen: `lib/features/products/presentation/screens/store_page_screen.dart`
- Widgets: `lib/features/products/presentation/widgets/` (8 widget components)
- Mock Data: `lib/features/products/data/services/` (3 services)
- Providers: `lib/features/products/data/providers/product_providers.dart`

---

## Figma Design Structure

### Product Pages Section (54:5766)
Contains 3 screens:
1. **Product Page** (54:5767) - Full product detail with reviews
2. **Store Page** (54:5897) - Store/vendor detail page
3. **Product Page - No Comments** (54:6025) - Product without reviews (not implemented yet)

---

## Color Mapping Strategy

**Figma → Theme Mapping:**

| Figma Color | Hex Code | Theme Role | Usage |
|-------------|----------|------------|-------|
| White | #FFFFFF | `colorScheme.surface` | Screen background |
| Light Gray | #F2F2F2 | `colorScheme.surfaceContainerHighest` | Container backgrounds |
| Dark Green | #0F352D | `colorScheme.primary` | CTA buttons, bottom action |
| Bright Green | #00FF88 | `colorScheme.secondary` | Back button background |
| Black | #151515 | `colorScheme.onSurface` | Primary text |
| Gray | #A3A3A3 | `colorScheme.onSurfaceVariant` | Secondary text |
| Sale Red | #EF4444 | hardcoded | Sale price, sale badges |
| Gold | #FBBF24 | hardcoded | Star ratings |

**Key Rule:** ALL colors accessed via `Theme.of(context).colorScheme` except e-commerce specific colors (sale red, rating gold).

---

## Layout & Spacing Specifications

### Product Detail Screen (54:5767)

**Frame Dimensions:** 393×852px (mobile)

**Component Layout (Top to Bottom):**

```
┌─────────────────────────────────────┐
│  ← Back (Absolute: 64px top, 16px) │
│  Status Bar (Absolute, blur)        │
├─────────────────────────────────────┤
│                                     │
│   Product Image Carousel           │
│   Height: 390px                     │
│   Dots indicator: 8px gap           │
│                                     │
├─────────────────────────────────────┤
│  Product Actions Bar                │ Padding: 12px V, 16px H
│  ♡  Share  Cart                     │
├─────────────────────────────────────┤
│  Price Section                      │ Padding: 16px
│  SAR 459.99  ~~SAR 599.99~~         │
│  23% OFF badge                       │
├─────────────────────────────────────┤
│  Size/Color Selector                │ Padding: 8px V, 16px H
│  Size: S M L XL XXL                 │
│  Color: Black White Red             │
├─────────────────────────────────────┤
│  ─────────────────────              │ Divider (1px, 20% opacity)
├─────────────────────────────────────┤
│  Product Info                       │ Padding: 16px
│  Brand, Title, Description          │
│  Specifications (if any)            │
├─────────────────────────────────────┤
│  ─────────────────────              │ Divider (1px, 20% opacity)
├─────────────────────────────────────┤
│                                     │
│  Reviews & Ratings                  │ Height: 714.2px (fixed)
│  4.5 ⭐⭐⭐⭐⭐ (128 reviews)       │ Padding: 16px
│                                     │
│  [Review List - Scrollable]         │
│  - User avatar, name, rating        │
│  - Comment text                     │
│  - Helpful count                    │
│                                     │
├─────────────────────────────────────┤
│  [•]  [Add to Cart - 247×48]       │ Bottom Bar (absolute)
│   44×44 circular      Dark green    │ Padding: 16px
└─────────────────────────────────────┘
```

### Store Page Screen (54:5897)

**Similar layout with differences:**

```
┌─────────────────────────────────────┐
│  ← Back (Absolute)                  │
├─────────────────────────────────────┤
│                                     │
│   Store Banner Image                │ Height: 390px
│   (or placeholder)                  │
│                                     │
├─────────────────────────────────────┤
│  Store Info Banner                  │ Height: 48.25px
│  [Logo] Store Name ⭐⭐⭐⭐         │ Background: #0F352D
│  [Follow Button]                     │ White text
├─────────────────────────────────────┤
│  About                              │ Padding: 16px
│  Store description...               │
│  [Category Chips]                   │
├─────────────────────────────────────┤
│  Products                           │
│  ┌─────┬─────┐                      │ Grid: 2 columns
│  │ img │ img │                      │ Gap: 12px
│  └─────┴─────┘                      │
└─────────────────────────────────────┘
```

---

## Component Specifications

### 1. ProductImageCarousel (`product_image_carousel.dart`)

**Specs:**
- Height: 390px (fixed from Figma)
- PageView for swipeable images
- Dot indicators at bottom (8px gap between dots)
- Dots: 8×8px circles
- Selected dot: `colorScheme.primary`
- Unselected dot: `colorScheme.onSurface` 30% opacity
- Border: 1px bottom, black 5% opacity
- Loading: CircularProgressIndicator
- Error: Icon placeholder

**Usage:**
```dart
ProductImageCarousel(
  imageUrls: product.imageUrls,
  height: 390,
  showIndicators: true,
)
```

### 2. ProductPriceSection (`product_price_section.dart`)

**Specs:**
- Padding: 16px horizontal, 16px vertical
- Current price: 20px bold (sale red if discounted)
- Original price: 14px regular, strikethrough, gray
- Discount badge: BadgeWidget (sale type)
- Row layout with space-between

**Usage:**
```dart
ProductPriceSection(
  price: 459.99,
  originalPrice: 599.99,
  discountPercentage: 23,
  currency: 'SAR',
)
```

### 3. ProductActionsBar (`product_actions_bar.dart`)

**Specs:**
- Padding: 12px vertical, 16px horizontal
- 3 action buttons: favorite, share, cart
- Button size: 40×40px circular
- Icon size: 24px
- Favorite: Red when active, onSurface when inactive
- Haptic feedback on tap
- Share: Uses share_plus package
- Tooltip support

**Usage:**
```dart
ProductActionsBar(
  isFavorite: true,
  onFavoriteToggle: () {},
  shareText: 'Check out this product!',
  onAddToCart: () {},
)
```

### 4. ProductInfoSection (`product_info_section.dart`)

**Specs:**
- Padding: 16px all sides
- Brand: bodySmall, onSurfaceVariant, weight 500
- Title: titleLarge, bold, onSurface
- Description: bodyMedium, onSurfaceVariant, line-height 1.5
- Specifications: Optional map display
- Gap: 16px between sections

**Usage:**
```dart
ProductInfoSection(
  title: 'Nike Air Max 270',
  description: 'Experience ultimate comfort...',
  brand: 'Nike',
  specifications: {'Material': 'Mesh', 'Weight': '350g'},
)
```

### 5. ReviewsSection (`reviews_section.dart`)

**Specs:**
- **Fixed height:** 714.2px (critical Figma spec)
- Padding: 16px
- Header: titleLarge bold
- Average rating display with stars
- Reviews list: Scrollable ListView
- Gap between reviews: 12px
- Empty state: Icon with message
- View All button (optional)

**Usage:**
```dart
ReviewsSection(
  reviews: reviewList,
  averageRating: 4.5,
  totalReviews: 128,
  height: 714.2,
  onReviewHelpful: (reviewId) {},
)
```

### 6. ReviewCard (`review_card.dart`)

**Specs:**
- Padding: 16px
- Bottom border: 1px, outline 20% opacity
- User avatar: 40px circular
- User name: titleSmall, weight 600
- Verified badge: 16px icon (if verified purchase)
- Timestamp: bodySmall, onSurfaceVariant (using timeago package)
- Rating: RatingDisplay (small size)
- Comment: bodyMedium, line-height 1.5
- Review images: 80×80px, 8px gap (if any)
- Helpful button: thumb icon + count

**Usage:**
```dart
ReviewCard(
  review: reviewObject,
  onHelpfulTap: () {},
)
```

### 7. SizeColorSelector (`size_color_selector.dart`)

**Specs:**
- Padding: 8px vertical, 16px horizontal
- Size chips: 48×48px square, 8px radius
- Color chips: Pill-shaped, 16px radius
- Selected: primary background, onPrimary text, 2px border
- Unselected: surface background, outline border 50% opacity
- Gap between chips: 8px
- Haptic feedback on selection

**Usage:**
```dart
SizeColorSelector(
  availableSizes: ['S', 'M', 'L', 'XL'],
  availableColors: ['Black', 'White', 'Red'],
  selectedSize: 'M',
  selectedColor: 'Black',
  onSizeSelected: (size) {},
  onColorSelected: (color) {},
)
```

### 8. StoreInfoBanner (`store_info_banner.dart`)

**Specs:**
- **Fixed height:** 48.25px (Figma spec)
- **Background:** #0F352D (dark green - hardcoded from Figma)
- Padding: 8px vertical, 16px horizontal
- Store logo: 32×32px, 16px radius
- Store name: titleSmall, white, weight 600
- Rating display: Small stars, gold color
- Follow button: White outline, white text
- Arrow icon: 16px (if no follow button)

**Usage:**
```dart
StoreInfoBanner(
  store: storeObject,
  showFollowButton: true,
  onFollowToggle: () {},
  onTap: () => navigateToStore(),
)
```

---

## Back Button Specification

**Shared across both screens:**

- **Position:** Absolute top-left (or top-right for RTL)
  - Top: 64px
  - Left/Right: 16px
- **Size:** 44×44px circular
- **Background:** #00FF88 (bright green - Figma)
- **Icon:** arrow_back_ios_new, 20px, white
- **Shadow:** 8px blur, 2px spread, #F2F2F2
- **Haptic:** Light impact on tap

---

## Bottom Action Bar Specification

**Product Detail Screen:**

- Container with shadow (blur 10px, offset -2px)
- Safe area (bottom)
- Padding: 16px
- Row layout:
  - Favorite button: 44×44px circular, dark green (#0F352D)
  - Gap: 16px
  - Add to Cart: AppButton.primary, 247×48px, radius 30px

---

## Mock Data Structure

### Products
5 sample products created in `mock_product_service.dart`:
- Nike Air Max 270 (shoes, on sale)
- Adidas Performance T-Shirt (clothing, new)
- Samsung Galaxy S24 Ultra (electronics, featured, on sale)
- Apple Watch Series 9 (electronics, featured)
- Puma RS-X Reinvention (shoes, on sale, low stock)

**Product includes:**
- Multiple images (3-5 per product)
- Price with optional original price
- Discount percentage
- Brand name
- Rating and review count
- Available sizes and colors
- Badge (SALE, NEW, FEATURED)
- Stock quantity
- Category ID

### Reviews
Created in `mock_review_service.dart`:
- **Bilingual:** English and Arabic comments
- **User info:** Names, avatars (optional)
- **Ratings:** 1-5 stars (doubles)
- **Verified purchase** badges
- **Helpful counts**
- **Timestamps:** Realistic dates
- **Review images** (optional)

### Stores
5 sample stores in `mock_store_service.dart`:
- Nike Official Store
- Adidas Saudi Arabia
- Tech Galaxy
- Puma Arabia
- Fashion Hub

**Store includes:**
- Name (bilingual where appropriate)
- Description (bilingual)
- Logo and banner URLs
- Rating and review count
- Follower count
- Product IDs
- Categories
- Contact info (location, phone, email, website)
- Verified status
- Following status

---

## Responsive Design Rules

### Mobile (≤600px)
- Horizontal padding: 16px
- Component widths: Full width minus padding
- Reviews section: 714.2px height (fixed)

### Tablet (>600px)
- Max content width: Maintained
- Same layout, optimized spacing

### Desktop (>900px)
- Same as tablet
- Consider max-width constraints for readability

---

## RTL Support Pattern

Both screens use:

```dart
return Directionality(
  textDirection: context.locale.languageCode == 'ar' 
      ? TextDirection.rtl 
      : TextDirection.ltr,
  child: Scaffold(...)
);
```

Back button position:
```dart
Positioned(
  top: 64,
  left: isRTL ? null : 16,
  right: isRTL ? 16 : null,
  child: backButton,
)
```

---

## Navigation Integration

### Routes Added

**In `routes.dart`:**
```dart
static const String productDetail = '/product/:id';
static const String storeDetail = '/store/:id';
```

**In `app_router.dart`:**
```dart
GoRoute(
  path: '/product/:id',
  name: AppRouteNames.productDetail,
  builder: (context, state) {
    final productId = state.pathParameters['id']!;
    return ProductDetailScreen(productId: productId);
  },
),
```

### Navigation Usage

```dart
// Navigate to product
context.push('/product/prod_001');

// Navigate to store
context.push('/store/store_001');

// Named navigation
context.pushNamed(
  AppRouteNames.productDetail,
  pathParameters: {'id': 'prod_001'},
);
```

---

## State Management Pattern

Using **Riverpod** with family providers:

```dart
// Get product
final productAsync = ref.watch(productByIdProvider(productId));

// Get reviews
final reviewsAsync = ref.watch(productReviewsProvider(productId));

// Get store
final storeAsync = ref.watch(storeByIdProvider(storeId));

// Manage favorites
final favoritesNotifier = ref.watch(favoritesProvider.notifier);
final isFavorite = ref.watch(favoritesProvider).contains(productId);
favoritesNotifier.toggle(productId);

// Manage follows
final followedNotifier = ref.watch(followedStoresNotifierProvider.notifier);
final isFollowing = ref.watch(followedStoresNotifierProvider).contains(storeId);
followedNotifier.toggle(storeId);
```

---

## Testing Checklist

- [ ] Visual match with Figma designs
- [ ] All spacing/dimensions correct (390px carousel, 714.2px reviews, 48.25px banner)
- [ ] Colors use theme system (except e-commerce colors)
- [ ] RTL support works (Arabic language)
- [ ] Responsive on mobile/tablet
- [ ] Navigation works (product ↔ store)
- [ ] Mock data displays correctly
- [ ] Reviews section scrollable
- [ ] Favorite/follow actions work
- [ ] Image carousel swipeable
- [ ] Back button navigation
- [ ] Theme compliance verified
- [ ] Share functionality works
- [ ] Size/color selection works
- [ ] Haptic feedback on interactions

---

## Known Differences from Figma

### Intentional Design Decisions

1. **Color System:** Using theme colors instead of hardcoded hex values for light/dark mode support
2. **Mock Images:** Using external URLs instead of Figma assets (can be replaced)
3. **Products Grid (Store Page):** Placeholder implementation (6 items)
4. **Animations:** Added haptic feedback (not in Figma static)

### Technical Constraints

1. **Exact Measurements:** Minor pixel differences due to Flutter rendering
2. **Font Rendering:** May vary slightly across platforms
3. **Image Aspect Ratios:** Depend on actual product images

---

## Future Enhancements

1. **Product Page - No Comments Variant** (Figma 54:6025)
2. **Real product images** from Figma or backend
3. **Hero animations** for product images
4. **Zoom functionality** for product images
5. **Video support** in carousel
6. **Write review form**
7. **Filter/sort reviews**
8. **Related products section**
9. **Wishlist management**
10. **Cart integration**
11. **Store products grid** with actual data

---

## Dependencies Required

```yaml
cached_network_image: ^3.3.1  # Image caching
share_plus: ^7.2.2           # Share functionality
timeago: ^3.6.1              # Relative timestamps
```

---

## Related Files

- **Theme:** `lib/core/themes/app_theme.dart`
- **Colors:** `lib/core/constants/app_colors.dart` (reference only)
- **Typography:** `lib/core/constants/app_typography.dart`
- **Existing widgets:** `lib/core/widgets/products/` (BadgeWidget, RatingDisplay)
- **Implementation guide:** `IMPLEMENTATION_GUIDE.md`

---

## Implementation Date
2025-01-30

## Last Updated
2025-01-30
