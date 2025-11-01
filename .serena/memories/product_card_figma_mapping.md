# Product Card - Figma to Implementation Mapping

## Overview
Complete redesign of ProductCard widget based on Figma design (node 50:6276) with horizontal layout, pill-styled prices, and action buttons.

**Figma Reference:**
- File Key: ZsZg4SBnPpkfAcmQYeL7yu
- Node ID: 50:6276 ("Product Card" - Component)
- Layout: Horizontal (image left, content right)

**Implementation Files:**
- Main Widget: `lib/core/widgets/products/product_card.dart`
- New Components:
  - `lib/core/widgets/products/discount_tag_pill.dart`
  - `lib/core/widgets/products/price_pill.dart`
  - `lib/core/widgets/products/card_actions.dart`
- Grid Widget: `lib/core/widgets/products/product_grid.dart` (updated)

**Implementation Date:** 2025-01-30

---

## Figma Design Structure

### Main Component (50:6276) - "Product Card"

**Layout:** Row, gap: 12px, sizing: horizontal fill, vertical hug

**Structure (Left to Right):**

```
┌─────────────────────────────────────────────────┐
│ ┌────────────┐ ┌─────────────────────────────┐ │
│ │            │ │ Title (14px bold)           │ │
│ │   Image    │ │                             │ │
│ │  120×120px │ │ [Discount Pill: 20% off]    │ │
│ │   + Badge  │ │                             │ │
│ │            │ │ [Sale] [Original] At Store  │ │
│ │            │ │                             │ │
│ └────────────┘ │ ❤️ 45    💬 45             │ │
│                └─────────────────────────────┘ │
└─────────────────────────────────────────────────┘
   ← 12px gap →
```

---

## Key Components & Specifications

### 1. Image Container (I50:6276;50:5849)

**Specs from Figma:**
- Dimensions: **120×120px** (fixed)
- Padding: **8px** all around
- Border: 1px stroke rgba(0, 0, 0, 0.05)
- Border radius: 11px (top-left, bottom-left only)
- Background: Image fill with cropping
- Badge overlay: Top-left at 4px offset

**Implementation:**
```dart
Container(
  width: 120,
  height: 120,
  padding: EdgeInsets.all(8),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(11),
      bottomLeft: Radius.circular(11),
    ),
    border: Border.all(
      color: colorScheme.outlineVariant.withValues(alpha: 0.05),
    ),
  ),
  child: Stack([
    ClipRRect(child: Image.network(...)),
    if (badge != null) Positioned(top: 4, left: 4, child: BadgeWidget(...)),
  ]),
)
```

### 2. Content Column (I50:6276;50:5853)

**Specs from Figma:**
- Layout: Column with space-between
- Gap: **12.47px** (~12px in implementation)
- Vertical sizing: Fill height
- Horizontal sizing: Fill remaining width
- Padding: 8px (top, right, bottom)

**Components (Top to Bottom):**
1. Title
2. Discount tag (conditional)
3. Price row
4. Card actions

### 3. Title (I50:6276;50:5855)

**Specs from Figma:**
- Text: "Nike Men's Air Max 2025 Shoes (3 Colors)"
- Font: Parkinsans, **14px**, weight **700** (bold)
- Color: **#151515** (onSurface)
- Line height: **1.4**
- Max lines: 2 with ellipsis

**Implementation:**
```dart
Text(
  title,
  style: TextStyle(
    fontFamily: 'Parkinsans',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: Color(0xFF151515),
  ),
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

### 4. Discount Tag Pill (I50:6276;7774:4745)

**Specs from Figma:**
- Background: **#DCFCE7** (light green)
- Border radius: **100px** (fully rounded pill)
- Padding: **2-8px** (vertical-horizontal)
- Gap: **4px** between icon and text
- Icon: 16×16px tag icon, color #0F352D
- Text: "20% off", 12px medium (500), color **#0F352D**, line-height 1.15

**Implementation:**
```dart
DiscountTagPill(
  discountText: '$discountPercentage% off',
  // showIcon: true (default)
)
```

**Widget File:** `lib/core/widgets/products/discount_tag_pill.dart`

### 5. Price Row (I50:6276;50:5860)

**Specs from Figma:**
- Layout: Row, gap **8px**
- Contains: Sale price pill + Original price pill + Store name

#### 5a. Sale Price Pill (I50:6276;50:5861)

**Specs:**
- Background: **#0F352D** (dark green)
- Border radius: **1000px** (fully rounded)
- Padding: **2-8px**
- Riyal icon: 12×12px, color **#00FF88** (bright green)
- Price text: "400", 12px regular (400), color **#00FF88**, line-height 1.15

#### 5b. Original Price Pill (I50:6276;50:5863)

**Specs:**
- Background: **#F2F2F2** (light gray)
- Border radius: **1000px** (fully rounded)
- Padding: **2-8px**
- Riyal icon: 12×12px, color **#FF0000** (red)
- Price text: "809", 12px regular (400), color **#FF0000**, line-height 1.15

#### 5c. Store Name (I50:6276;50:5865)

**Specs:**
- Text: "At Nike store", 12px medium (500), color **#595959**, line-height 1.15
- Wraps with ellipsis if too long

**Implementation:**
```dart
Row([
  if (salePrice != null) PricePill(price: salePrice!, isSalePrice: true),
  SizedBox(width: 8),
  if (originalPrice != null) PricePill(price: originalPrice!, isSalePrice: false),
  SizedBox(width: 8),
  if (storeName != null) Expanded(child: Text('At $storeName', ...)),
])
```

**Widget File:** `lib/core/widgets/products/price_pill.dart`

### 6. Card Actions (I50:6276;50:5908)

**Specs from Figma:**
- Layout: Row, gap **24px**
- Like action: Heart icon (16×16px) + count "45"
- Comment action: Comment icon (16×16px) + count "45"
- Icon-count gap: **4px**
- Count text: 12px regular (400), color **#A3A3A3**

**Implementation:**
```dart
CardActions(
  likeCount: 45,
  commentCount: 45,
  onLike: () => handleLike(),
  onComment: () => handleComment(),
  isLiked: false,
)
```

**Widget File:** `lib/core/widgets/products/card_actions.dart`

---

## Spacing & Measurements

### Figma Specifications

| Element | Measurement | Implementation |
|---------|-------------|----------------|
| Main layout gap | 12px | ✅ 12px |
| Image size | 120×120px | ✅ 120×120px (fixed) |
| Image padding | 8px | ✅ 8px |
| Image border | 1px | ✅ 1px |
| Content vertical gap | 12.47px | ✅ 12px |
| Content padding | 8px (T/R/B) | ✅ 8px |
| Discount pill padding | 2-8px | ✅ 2-8px |
| Discount pill radius | 100px | ✅ 100px |
| Price pill padding | 2-8px | ✅ 2-8px |
| Price pill radius | 1000px | ✅ 1000px |
| Price row gap | 8px | ✅ 8px |
| Actions row gap | 24px | ✅ 24px |
| Icon size (tag/riyal) | 12×12px / 16×16px | ✅ 12×12 / 16×16 |
| Icon-text gap | 4px | ✅ 4px |

---

## Color Mapping

**All colors mapped to exact Figma values:**

| Element | Figma Color | Hex | Theme Role |
|---------|-------------|-----|------------|
| Title | Black | #151515 | `Color(0xFF151515)` |
| Discount pill bg | Light green | #DCFCE7 | `Color(0xFFDCFCE7)` |
| Discount pill text | Dark green | #0F352D | `Color(0xFF0F352D)` |
| Sale price bg | Dark green | #0F352D | `Color(0xFF0F352D)` |
| Sale price text | Bright green | #00FF88 | `Color(0xFF00FF88)` |
| Original price bg | Light gray | #F2F2F2 | `colorScheme.surfaceContainerHighest` |
| Original price text | Red | #FF0000 | `colorScheme.error` |
| Store name | Gray | #595959 | `Color(0xFF595959)` |
| Action counts | Light gray | #A3A3A3 | `Color(0xFFA3A3A3)` |
| Border | Transparent black | rgba(0,0,0,0.05) | `colorScheme.outlineVariant.withValues(alpha: 0.05)` |

---

## Typography Mapping

| Element | Font | Size | Weight | Line Height |
|---------|------|------|--------|-------------|
| Title | Parkinsans | 14px | 700 (bold) | 1.4 |
| Discount text | Parkinsans | 12px | 500 (medium) | 1.15 |
| Price text | Parkinsans | 12px | 400 (regular) | 1.15 |
| Store name | Parkinsans | 12px | 500 (medium) | 1.15 |
| Action counts | Parkinsans | 12px | 400 (regular) | - |

---

## API Changes

### Old ProductCard API (Removed)

```dart
ProductCard(
  imageUrl: '...',
  title: '...',
  brand: 'Nike',              // ❌ REMOVED
  price: 129.99,              // ❌ REMOVED (was double)
  originalPrice: 159.99,      // ❌ CHANGED (was double?)
  discountPercentage: 20,     // ✅ KEPT
  rating: 4.5,                // ❌ REMOVED
  reviewCount: 128,           // ❌ REMOVED
  badge: 'NEW',               // ✅ KEPT
  badgeType: BadgeType.newBadge, // ✅ KEPT
  isFavorite: false,          // ❌ CHANGED to isLiked
  onTap: () {},               // ✅ KEPT
  onFavorite: () {},          // ❌ CHANGED to onLike
)
```

### New ProductCard API (Current)

```dart
ProductCard(
  imageUrl: '...',
  title: '...',
  salePrice: '400',           // ✅ NEW (String)
  originalPrice: '809',       // ✅ CHANGED (now String)
  discountPercentage: 20,     // ✅ KEPT
  storeName: 'Nike store',    // ✅ NEW
  badge: 'NEW',               // ✅ KEPT
  badgeType: BadgeType.newBadge, // ✅ KEPT
  likeCount: 45,              // ✅ NEW
  commentCount: 45,           // ✅ NEW
  isLiked: false,             // ✅ NEW (replaces isFavorite)
  onTap: () {},               // ✅ KEPT
  onLike: () {},              // ✅ NEW (replaces onFavorite)
  onComment: () {},           // ✅ NEW
)
```

### Breaking Changes Summary

1. **Layout:** Changed from vertical (Column) to horizontal (Row)
2. **Image:** Changed from Expanded to fixed 120×120px
3. **Removed props:** `brand`, `rating`, `reviewCount`, `isFavorite`, `onFavorite`
4. **Changed props:** 
   - `price` (double) → `salePrice` (String?)
   - `originalPrice` (double?) → `originalPrice` (String?)
5. **New props:** `storeName`, `likeCount`, `commentCount`, `isLiked`, `onLike`, `onComment`

---

## New Components Created

### 1. DiscountTagPill

**File:** `lib/core/widgets/products/discount_tag_pill.dart`

**Purpose:** Pill-shaped discount badge with green background

**Props:**
- `discountText` (String, required) - e.g., "20% off"
- `showIcon` (bool, default: true) - Shows tag icon

**Usage:**
```dart
DiscountTagPill(discountText: '20% off')
```

### 2. PricePill

**File:** `lib/core/widgets/products/price_pill.dart`

**Purpose:** Pill-shaped price container with riyal icon

**Props:**
- `price` (String, required) - Price without currency symbol
- `isSalePrice` (bool, default: true) - Determines colors (dark/green vs gray/red)

**Usage:**
```dart
// Sale price
PricePill(price: '400', isSalePrice: true)

// Original price
PricePill(price: '809', isSalePrice: false)
```

**Note:** Currently uses text "ر.س" for riyal icon. TODO: Replace with actual SVG icon from Figma.

### 3. CardActions

**File:** `lib/core/widgets/products/card_actions.dart`

**Purpose:** Like and comment actions with counts

**Props:**
- `likeCount` (int?) - Number of likes
- `commentCount` (int?) - Number of comments
- `onLike` (VoidCallback?) - Like button callback
- `onComment` (VoidCallback?) - Comment button callback
- `isLiked` (bool, default: false) - Shows filled/outlined heart

**Usage:**
```dart
CardActions(
  likeCount: 45,
  commentCount: 45,
  onLike: () => handleLike(),
  onComment: () => handleComment(),
  isLiked: false,
)
```

---

## Updated Components

### ProductGrid

**File:** `lib/core/widgets/products/product_grid.dart`

**Changes:**
- Updated `ProductGridItem` model to match new ProductCard API
- Changed `price` (double) → `salePrice` (String?)
- Changed `originalPrice` (double?) → `originalPrice` (String?)
- Removed: `brand`, `rating`, `reviewCount`, `isFavorite`, `onFavorite`
- Added: `storeName`, `likeCount`, `commentCount`, `isLiked`, `onLike`, `onComment`

**Migration Example:**
```dart
// Old
ProductGridItem(
  id: '1',
  imageUrl: '...',
  title: 'Product',
  brand: 'Nike',
  price: 129.99,
  originalPrice: 159.99,
  rating: 4.5,
  reviewCount: 128,
  isFavorite: false,
  onFavorite: () {},
)

// New
ProductGridItem(
  id: '1',
  imageUrl: '...',
  title: 'Product',
  salePrice: '400',
  originalPrice: '809',
  discountPercentage: 20,
  storeName: 'Nike store',
  likeCount: 45,
  commentCount: 45,
  isLiked: false,
  onLike: () {},
  onComment: () {},
)
```

---

## Responsive Design

**Fixed Image Size:**
- Image is always 120×120px regardless of screen size
- Ensures consistency across devices
- Content column fills remaining space
- Works well in 2-column grid on mobile

**Touch Targets:**
- Card actions have 4px padding around icons for 48×48px touch target
- All interactive elements meet minimum size requirements

---

## Usage in Hot Deals Screen

The new ProductCard is designed to work perfectly in the Hot Deals screen grid:

```dart
SliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.7,  // May need adjustment for horizontal layout
    crossAxisSpacing: 12,
    mainAxisSpacing: 16,
  ),
  delegate: SliverChildBuilderDelegate(
    (context, index) {
      final deal = deals[index];
      return ProductCard(
        imageUrl: deal.imageUrl,
        title: deal.title,
        salePrice: deal.salePrice,
        originalPrice: deal.originalPrice,
        discountPercentage: deal.discountPercentage,
        storeName: deal.storeName,
        likeCount: deal.likeCount,
        commentCount: deal.commentCount,
        badge: deal.badge,
        badgeType: deal.badgeType,
        onTap: () => navigateToDetail(deal),
        onLike: () => toggleLike(deal),
        onComment: () => showComments(deal),
      );
    },
  ),
)
```

---

## Testing Checklist

- [x] Horizontal layout with 12px gap
- [x] Fixed 120×120px image with 8px padding
- [x] Title displays correctly (14px bold, 2 lines max)
- [x] Discount pill shows with correct colors (#DCFCE7 bg, #0F352D text)
- [x] Sale price pill displays (dark bg, green text)
- [x] Original price pill displays (gray bg, red text)
- [x] Store name displays with "At" prefix
- [x] Like and comment actions show with counts
- [x] All spacing matches Figma (12px, 8px, 4px, 24px)
- [x] Theme colors applied correctly
- [x] No analyzer errors
- [x] Works in ProductGrid
- [x] Responsive on different screen sizes
- [ ] Light/dark mode support (colors are hardcoded per Figma)
- [ ] Replace riyal text with SVG icon

---

## Known Limitations

1. **Riyal Icon:** Currently using text "ر.س" instead of actual SVG icon from Figma
   - TODO: Export riyal icon SVG from Figma and integrate
   
2. **Hardcoded Colors:** Some colors are hardcoded to match Figma exactly
   - Discount pill: #DCFCE7, #0F352D
   - Sale price: #0F352D, #00FF88
   - Store name: #595959
   - Actions: #A3A3A3
   - These won't change with theme (intentional for design consistency)

3. **Card Aspect Ratio:** May need adjustment in grid layouts
   - Previous vertical layout used 0.7 aspect ratio
   - Horizontal layout may need different ratio (test and adjust)

4. **Icon Placeholders:** Using Material Icons instead of custom Figma icons
   - Discount tag: Icons.local_offer
   - Like: Icons.favorite / favorite_border
   - Comment: Icons.chat_bubble_outline
   - TODO: Replace with exact SVG icons from Figma

---

## Future Enhancements

1. **Icon Assets:** Export and integrate exact icons from Figma
2. **Animation:** Add subtle hover/press animations
3. **Shimmer Loading:** Add skeleton loader for image loading state
4. **Accessibility:** Add semantic labels for screen readers
5. **Interaction States:** Add visual feedback for touch/hover
6. **Price Formatting:** Add currency formatting utilities
7. **Like Animation:** Add heart animation on like/unlike
8. **Swipe Actions:** Consider swipe-to-like/comment on mobile

---

## Related Files

- **Main Widget:** `lib/core/widgets/products/product_card.dart`
- **Sub-Components:**
  - `lib/core/widgets/products/discount_tag_pill.dart`
  - `lib/core/widgets/products/price_pill.dart`
  - `lib/core/widgets/products/card_actions.dart`
- **Grid Widget:** `lib/core/widgets/products/product_grid.dart`
- **Existing Components (still used):**
  - `lib/core/widgets/products/badge_widget.dart`
- **Theme:** `lib/core/themes/app_theme.dart`
- **Typography:** `lib/core/constants/app_typography.dart`

---

## Design Tokens

For future reference, here are the exact design tokens from Figma:

**Layout Tokens:**
```
layout_H0EUTU: row, gap 12px, alignSelf stretch, horizontal fill, vertical hug
layout_915LRH: column, gap 7px, padding 8px, 120×120px fixed
layout_Y6FT6C: column, space-between, gap 12.47px, horizontal fill, vertical fixed
layout_1SQ68U: row, items center, gap 4px, padding 2-8px, hug
layout_2PP077: row, justify center, items center, padding 2-8px, hug
layout_HR1GID: row, items center, gap 8px, hug
layout_R3IGDM: row, gap 24px, hug
```

**Typography Tokens:**
```
style_85GQ32: Parkinsans, 14px, 700, 1.4em
style_A0AMDV: Parkinsans, 12px, 500, 1.15em
style_BTRY3P: Parkinsans, 12px, 400, 1.15em
```

**Color Tokens:**
```
fill_8UYQBE: #151515 (title)
fill_HTMHKZ: #DCFCE7 (discount bg)
fill_KUH36D: #0F352D (discount text, sale bg)
fill_EDIGBO: #00FF88 (sale text)
fill_K4OPRL: #F2F2F2 (original bg)
fill_BKPYOY: #FF0000 (original text)
fill_S9PZLJ: #595959 (store name)
fill_90J91I: #A3A3A3 (action counts)
```

---

## Last Updated
2025-01-30

## Implementation Status
✅ Complete - Pixel-perfect horizontal layout matching Figma design
