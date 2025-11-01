# Profile Screen Figma Mapping

**Figma Design Node:** 34:3080 (Profile screen in Waffir-Final)
**Figma File:** ZsZg4SBnPpkfAcmQYeL7yu
**Design Frame:** 393×852px (mobile reference)
**Implementation Date:** November 2, 2025

## 📐 Exact Measurements & Specifications

### Screen Structure

**Main Container (Frame 34:3080)**
- Width: 393px
- Height: 852px
- Layout: Column with space-between alignment
- Gap between sections: 24px (Frame 86 layout)
- Horizontal padding: 16px (for content sections)

---

## 1. Profile Header Section (Node 34:3083)

**Implementation:** `lib/core/widgets/profile/profile_header.dart`

### Exact Dimensions
- **Height:** 234px (fixed)
- **Width:** Full width (393px)
- **Padding:** 24px (all sides)
- **Border Radius:** 0px 0px 30px 30px (bottom corners only)
- **Gap between elements:** 8px vertical

### Colors
- **Background:** #0F352D (primaryColorDarkest / colorScheme.primary)
- **Background Image:** profile_header_bg-bd1db0.png with crop transform
  - ImageRef: 6a9562b1f04e4cbdcef8d11e7bec4a071ca3d833
  - Color overlay: #0F352D with 70% alpha, darken blend mode

### Avatar (Node 35:2370)
- **Size:** 80×80px
- **Shape:** Circular (border-radius: 9999px)
- **Border:** 2px solid rgba(255, 255, 255, 0.4)
- **Image:** Network image or placeholder with person icon

### Name Text (Node 34:3085)
- **Font:** Parkinsans
- **Size:** 20px
- **Weight:** 600 (semiBold)
- **Line Height:** 1em (20px / 20px = 1.0)
- **Color:** #FFFFFF (white / colorScheme.surface)
- **Alignment:** CENTER

### Email Text (Node 34:3086)
- **Font:** Parkinsans
- **Size:** 14px
- **Weight:** 500 (medium)
- **Line Height:** 1em (14px / 14px = 1.0)
- **Color:** #FFFFFF (white / colorScheme.surface)
- **Alignment:** CENTER

### Edit Icon (Hidden in Figma design)
- **Show by default:** false (not visible in Figma design)
- **Size:** 24×24px (if enabled)

---

## 2. Premium Plan Card (Node 34:3087)

**Implementation:** `lib/features/profile/presentation/screens/profile_screen.dart` (Premium card section)

### Card Container
- **Background:** #F2F2F2 (gray01 / colorScheme.surfaceContainerHighest)
- **Border Radius:** 8px
- **Padding:** 16px (all sides)
- **Gap (title to button):** 16px

### Title Row Layout (Node 34:3088)
**Structure:** Icon LEFT, Text RIGHT (Row layout)

**Premium Icon (Node 35:2196)**
- **Size:** 32×32px
- **Shape:** Circular (border-radius: 727.27px)
- **Background:** #0F352D (primaryColorDarkest / colorScheme.primary)
- **Icon:** workspace_premium (Material Icons)
- **Icon Color:** #FFFFFF (white / colorScheme.surface)
- **Icon Size:** 18px

**Gap between icon and text:** 12px

**Text Column (Node 34:3089)**
- **Cross-axis alignment:** start (LEFT aligned)
- **Gap between title and subtitle:** 8px

**Title Text (Node 34:3091)**
- **Content:** "Premium Plan" (or "Free Plan")
- **Font:** Parkinsans
- **Size:** 16px
- **Weight:** 700 (bold)
- **Line Height:** 1em (16px / 16px = 1.0)
- **Color:** #151515 (black / colorScheme.onSurface)
- **Alignment:** LEFT

**Subtitle Text (Node 34:3093)**
- **Content:** "Valid until Dec 2023"
- **Font:** Parkinsans
- **Size:** 12px
- **Weight:** 400 (regular)
- **Line Height:** 1em (12px / 12px = 1.0)
- **Color:** #151515 (black / colorScheme.onSurface)
- **Alignment:** LEFT

### Manage Subscription Button (Node 35:2197)
- **Type:** Secondary button
- **Text:** "Manage Subscription"
- **Font:** Parkinsans
- **Size:** 14px
- **Weight:** 600 (semiBold)
- **Line Height:** 1em (14px / 14px = 1.0)
- **Background:** #FFFFFF (white)
- **Border:** 2px solid #0F352D (primaryColorDarkest)
- **Text Color:** #151515 (black)
- **Border Radius:** 30px
- **Width:** Stretch (full card width)

---

## 3. Menu Items Section (Node 34:3097)

**Implementation:** `lib/core/widgets/profile/profile_menu_item.dart`

### Container
- **Background:** #FFFFFF (white / colorScheme.surface)
- **Border Radius:** 8px
- **Padding:** 0px (items have internal padding)
- **Gap between items:** 8px

### Menu Item (Node 35:2256 and similar)
- **Width:** 362px
- **Height:** 44px
- **Padding:** 8px 0px (vertical only)
- **Gap:** 12px (between icon, text, and chevron)

**Icon (left side)**
- **Size:** 24×24px
- **Color:** Varies by icon type (Material Icons)

**Menu Text (Node I35:2256;35:2250)**
- **Font:** Parkinsans
- **Size:** 14px
- **Weight:** 500 (medium)
- **Line Height:** 1.25em (17.5px / 14px = 1.25)
- **Color:** #151515 (black / colorScheme.onSurface)
- **Alignment:** LEFT

**Chevron Icon (right side, Node I35:2256;35:2251)**
- **Size:** 24×24px
- **Stroke:** 2px
- **Color:** #151515 (black / colorScheme.onSurface)
- **Type:** chevron_right (Material Icons)

### Divider (Node 35:2207)
- **Height:** 0px (line with stroke)
- **Stroke:** 1px
- **Color:** #F2F2F2 (gray01 / colorScheme.surfaceContainerHighest)
- **Gap:** 8px height for divider element

### Menu Items List
1. **Account Manager** - User icon (35:2242)
2. **Favorites** - Star icon (34:5937)
3. **Change City** - Location icon (35:2326)
4. **Notification** - Notification icon (34:5942)
5. **Language** - Language icon (35:2330)
6. **Help Center** - Language icon (35:2330) - reused

---

## 4. Logout Button (Node 35:2182)

**Implementation:** `lib/features/profile/presentation/screens/profile_screen.dart` (Logout button section)

### Button Dimensions
- **Width:** 361px
- **Height:** 56px
- **Border Radius:** 30px

### Button Style
- **Type:** Primary button
- **Background:** #0F352D (primaryColorDarkest / colorScheme.primary)
- **Text:** "Logout"
- **Font:** Parkinsans
- **Size:** 14px
- **Weight:** 600 (semiBold)
- **Line Height:** 1em (14px / 14px = 1.0)
- **Text Color:** #FFFFFF (white / colorScheme.surface)

### Positioning
- **Position:** Bottom of screen (SafeArea)
- **Padding:** 16px horizontal, 16px bottom, 8px top

---

## 5. Bottom Navigation (Node 41:1095)

**Note:** Bottom navigation is handled separately, not part of this screen implementation.

**Specifications for reference:**
- **Position:** Absolute at y: 764px
- **Width:** 393px
- **Padding:** 8px 16px 12px
- **Background:** #0F352D (primaryColorDarkest)

---

## 📱 Responsive Implementation

### Base Design Reference
- **Figma Frame:** 393×852px
- **ResponsiveHelper base:** 393px width

### Scaling Applied
All dimensions use `ResponsiveHelper.scale()` for proportional scaling:
- Heights, widths, padding, margins
- Border radius values
- Icon sizes
- Gap spacing

**Font sizes** use `ResponsiveHelper.scaleFontSize()` with minimum constraints:
- Minimum readable sizes prevent text from becoming too small
- Example: `scaleFontSize(20, minSize: 16)` for profile name

### Device Breakpoints
- **Mobile:** < 600px width
- **Tablet:** 600px - 900px width
- **Desktop:** ≥ 900px width

---

## 🎨 Typography Mapping

### Custom Text Styles Added to AppTypography

**profileName** (AppTypography.profileName)
- Font: Parkinsans, 20px, weight 600, height 1.0
- Used for: Profile header name

**profileEmail** (AppTypography.profileEmail)
- Font: Parkinsans, 14px, weight 500, height 1.0
- Used for: Profile header email

**premiumTitle** (AppTypography.premiumTitle)
- Font: Parkinsans, 16px, weight 700, height 1.0
- Used for: Premium plan card title

**premiumSubtitle** (AppTypography.premiumSubtitle)
- Font: Parkinsans, 12px, weight 400, height 1.0
- Used for: Premium plan card subtitle

**menuItemText** (AppTypography.menuItemText)
- Font: Parkinsans, 14px, weight 500, height 1.25
- Used for: Menu item labels

---

## 🎨 Color Mapping

### Colors from Figma → AppColors

| Figma Color | Hex Code | AppColors Constant | Theme Access |
|-------------|----------|-------------------|--------------|
| Background (white) | #FFFFFF | white | colorScheme.surface |
| Primary dark | #0F352D | primaryColorDarkest | colorScheme.primary |
| Text black | #151515 | black | colorScheme.onSurface |
| Card background | #F2F2F2 | gray01 | colorScheme.surfaceContainerHighest |
| Border/divider | #F2F2F2 | gray01 | colorScheme.surfaceContainerHighest |
| Avatar border | rgba(255,255,255,0.4) | white40 | colorScheme.surface.withValues(alpha: 0.4) |

**Critical:** All widgets use `Theme.of(context).colorScheme` instead of direct AppColors imports.

---

## 📦 Assets

### Exported from Figma

**Profile Header Background Image**
- **Filename:** profile_header_bg-bd1db0.png
- **Location:** assets/images/profile_header_bg-bd1db0.png
- **Dimensions:** 440×234px (cropped with transform)
- **ImageRef:** 6a9562b1f04e4cbdcef8d11e7bec4a071ca3d833
- **Access:** Assets.images.profileHeaderBgBd1db0.provider()

### Icons
- Using Material Icons (already available)
- No custom SVG icons needed for this implementation

---

## ✅ Implementation Checklist

- [x] ProfileHeader widget with exact Figma specs
- [x] Premium card layout (icon LEFT, text RIGHT)
- [x] ProfileMenuItem widget with exact dimensions
- [x] ProfileCard widget with ResponsiveHelper
- [x] Main profile_screen.dart with proper spacing
- [x] All text styles added to AppTypography
- [x] Background image exported and integrated
- [x] ResponsiveHelper applied to all dimensions
- [x] Theme.of(context) used for all colors
- [x] Flutter analyze passes with no errors
- [ ] Testing on multiple screen sizes
- [ ] Visual comparison with Figma design

---

## 🎯 Pixel-Perfect Verification

### Verification Steps
1. **Open Figma design** (node 34:3080) next to Flutter app
2. **Measure header height:** Should be 234px (scaled)
3. **Check avatar size:** Should be 80×80px (scaled)
4. **Verify spacing:** 8px gaps between elements (scaled)
5. **Verify premium card:** Icon left, text right, proper gaps
6. **Check menu items:** 44px height, 12px gaps (scaled)
7. **Test button:** 361×56px dimensions (scaled)
8. **Compare colors:** All colors match Figma exactly
9. **Test responsive:** Check mobile, tablet, desktop layouts
10. **Verify fonts:** All text uses correct styles and sizes

### Known Deviations
- **Edit icon:** Hidden by default (not shown in Figma design)
- **Subscription expiry:** Uses static text "Valid until Dec 2023" from Figma
- **Icons:** Material Icons instead of custom Figma SVG icons (visually similar)

---

## 📝 Implementation Files

### Modified Files
1. `lib/core/constants/app_typography.dart` - Added profile text styles
2. `lib/core/widgets/profile/profile_header.dart` - Pixel-perfect header
3. `lib/core/widgets/profile/profile_menu_item.dart` - Exact menu item specs
4. `lib/core/widgets/profile/profile_card.dart` - Responsive card widget
5. `lib/features/profile/presentation/screens/profile_screen.dart` - Main screen layout

### New Assets
1. `assets/images/profile_header_bg-bd1db0.png` - Header background image

---

## 🚀 Testing Recommendations

### Visual Testing
1. Run app on iPhone 14 Pro (393px width reference)
2. Compare side-by-side with Figma design
3. Verify all spacing matches with pixel ruler
4. Check colors with color picker tool
5. Test on iPad (tablet) and desktop browsers

### Functional Testing
1. Test premium vs free plan card states
2. Verify all menu item navigation works
3. Test logout dialog functionality
4. Check responsive behavior on different sizes
5. Verify SafeArea handling on notched devices

---

## 📚 Related Documentation

- **UI/UX Guidelines:** `.serena/memories/ui_ux_guidelines_and_widgets.md`
- **Code Conventions:** `.serena/memories/code_style_conventions.md`
- **Architecture:** `.serena/memories/architecture.md`
- **ResponsiveHelper:** `lib/core/utils/responsive_helper.dart`
- **Figma Design:** https://www.figma.com/design/ZsZg4SBnPpkfAcmQYeL7yu/Waffir-Final?node-id=34-3080

---

**Last Updated:** November 2, 2025
**Implementation Status:** ✅ Complete (pending visual verification on devices)
