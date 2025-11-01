# Phone Login Screen - Figma to Implementation Mapping

## Overview
Pixel-perfect implementation of the phone login screen based on Figma design (node 50:3051).

**Figma Reference:**
- File Key: ZsZg4SBnPpkfAcmQYeL7yu
- Node ID: 50:3051
- Frame: "Login" (393×852px - mobile frame)

**Implementation Files:**
- Screen: `lib/features/auth/presentation/screens/phone_login_screen.dart`
- Background: `lib/features/auth/presentation/widgets/blurred_background.dart`
- Phone Input: `lib/core/widgets/inputs/phone_input_widget.dart`
- Social Button: `lib/core/widgets/buttons/social_auth_button.dart`

---

## Figma Assets Downloaded

All assets stored in `assets/images/` and `assets/icons/`:

| Figma Node | Asset Name | Path | Dimensions | Type |
|------------|------------|------|------------|------|
| 50:3056 | login_blur_shape.png | assets/images/ | 1336×1323 @2x | PNG |
| 50:3060 | waffir_icon_login.png | assets/images/ | 354×350 @2x | PNG |
| 50:5556 | back_button.svg | assets/icons/ | 393×118 | SVG |
| I50:3067;50:5577 | flag_sa.svg | assets/icons/ | 42×25 | SVG |
| I50:3073;50:5622 | google_icon.svg | assets/icons/ | 24×24 | SVG |
| I50:3074;50:5633 | apple_icon.svg | assets/icons/ | 24×24 | SVG |
| 35:2510 | arrow_icon.svg | assets/icons/ | 24×24 | SVG |

**Access via:** `Assets.images.loginBlurShape.path`, `Assets.icons.flagSa.path`, etc.

---

## Color Mapping Strategy

**Figma → Theme Mapping:**

| Figma Color | Hex Code | Theme Role | Usage | Implementation |
|-------------|----------|------------|-------|----------------|
| White | #FFFFFF | `colorScheme.background` | Screen background | BlurredBackground |
| Light Gray | #F2F2F2 | `colorScheme.surface` | Container backgrounds, divider lines | PhoneInputWidget, SocialAuthButton |
| Dark Green | #0F352D | `colorScheme.onSurface` | Primary text, submit button | All text elements |
| Black | #151515 | `colorScheme.onSurface` | Input text, labels | PhoneInputWidget text |
| Gray | #A3A3A3 | `colorScheme.onSurfaceVariant.withOpacity(0.64)` | Placeholder text | PhoneInputWidget hint |

**Key Rule:** ALL colors accessed via `Theme.of(context).colorScheme` for light/dark mode support.

---

## Typography Specifications

**Font Family:** Parkinsans (available in project)

### Title Text
```dart
// Figma: Parkinsans, 20px, weight 700, line-height 1em
Text(
  'مرحباً بكم في وفــــر',
  style: const TextStyle(
    fontFamily: 'Parkinsans',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.0,
  ),
)
```
**Note:** Changed from mixed weights (normal + w900) to uniform bold (w700).

### Subtitle Text
```dart
// Figma: Parkinsans, 16px, weight 400, line-height 1.25em
Text(
  'سجّل الدخول أو أنشئ حساباً للمتابعة',
  style: const TextStyle(
    fontFamily: 'Parkinsans',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.25,
  ),
)
```

### Divider Text
```dart
// Figma: Parkinsans, 14px, weight 500, line-height 1.25em
Text(
  'أو',
  style: const TextStyle(
    fontFamily: 'Parkinsans',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.25,
  ),
)
```

### Phone Input Typography
- **Country Code:** Parkinsans, 14px, weight 600, height 1.0
- **Placeholder:** Parkinsans, 14px, weight 500, height 1.0

### Social Button Typography
- **Label:** Parkinsans, 14px, weight 600, height 1.0

---

## Layout & Spacing Specifications

### Main Container
- **Padding:** 0px 16px (horizontal)
- **Content Width:** 361px (fixed for components)
- **Bottom Padding:** 120px

### Vertical Spacing (Top to Bottom)
```
Top Padding: 60-80px (responsive)
    ↓
Waffir Icon: 177×175px
    ↓ 40-42px
Title: "مرحباً بكم في وفــــر"
    ↓ 16px
Subtitle: "سجّل الدخول أو أنشئ حساباً للمتابعة"
    ↓ 32px
Phone Input: 361×56px
    ↓ 40px
Divider: "أو"
    ↓ 40px
Google Button: 361×48px
    ↓ 24px
Apple Button: 361×48px
    ↓ 120px
Bottom Padding
```

### Back Button
- **Position:** Absolute, top: 64px, right: 16px
- **Size:** 44×44px
- **Asset:** `Assets.icons.backButton.path`

---

## Component Specifications

### 1. BlurredBackground
**File:** `lib/features/auth/presentation/widgets/blurred_background.dart`

**Structure:**
- White background container
- Blurred shape positioned at (-40, -100)
- Shape dimensions: 467.78×461.3px
- Blur filter: 100px (sigmaX and sigmaY)

**Usage:**
```dart
const Positioned.fill(child: BlurredBackground())
```

---

### 2. PhoneInputWidget
**File:** `lib/core/widgets/inputs/phone_input_widget.dart`

**Dimensions:**
- Total width: 361px
- Total height: 56px
- Submit button: 44×44px (was 60×60px)
- Gap between button and container: 16px

**Submit Button:**
- Size: 44×44px
- Shape: Circle
- Active color: `colorScheme.onSurface` (#0F352D)
- Inactive color: `colorScheme.surface` (#F2F2F2)
- Icon: `Assets.icons.arrowIcon.path` (24×24px)
- Box shadow: 8px blur, 2px spread

**Container:**
- Border radius: 16px (was 30px)
- Background: `colorScheme.surface` (#F2F2F2)
- Padding: 16px (all sides)

**Internal Layout:**
- Flag: 22×15px (using `Assets.icons.flagSa.path`)
- Gap after flag: 8px
- Country code: "+966" (Parkinsans 14px weight 600)
- Gap after code: 12px
- Dropdown arrow: 12×12px
- Gap to phone input: 24px
- Phone input: Parkinsans 14px weight 600
- Placeholder: Parkinsans 14px weight 500, opacity 0.64

**Changes from Previous:**
- Button: 60×60 → 44×44px
- Border radius: 30 → 16px
- Padding: 14px horizontal → 16px all sides
- Gap after button: 8 → 16px
- Removed vertical divider
- Updated typography to Parkinsans

---

### 3. SocialAuthButton
**File:** `lib/core/widgets/buttons/social_auth_button.dart`

**Dimensions:**
- Width: 361px (constrained by parent)
- Height: 48px (was 56px)
- Border radius: 30px (unchanged)
- Padding: 16px horizontal, 12px vertical

**Layout:**
- Icon: 23.64×23.64px (using `Assets.icons.googleIcon.path` or `appleIcon.path`)
- Gap between icon and text: 11px
- Text: Parkinsans 14px weight 600

**Colors:**
- Background: `colorScheme.surface` (#F2F2F2)
- Text: `colorScheme.onSurface` (#151515)

**Changes from Previous:**
- Height: 56 → 48px
- Removed box shadow
- Icons: Material icons → Figma SVG assets
- Typography: theme → Parkinsans

---

### 4. PhoneLoginScreen
**File:** `lib/features/auth/presentation/screens/phone_login_screen.dart`

**Key Changes:**
1. **Background:** RadialStarburstBackground → BlurredBackground
2. **Back Button:** Added (top right, 64px from top, 16px from right)
3. **Icon:** 200×200 → 177×175px, using `Assets.images.waffirIconLogin.path`
4. **Title:** 25.4px mixed weights → 20px bold (w700)
5. **Subtitle:** Updated to Parkinsans 16px
6. **Spacing:** Updated all vertical gaps per Figma specs
7. **Component Width:** All components constrained to 361px
8. **Divider:** Updated color and typography

**Responsive Behavior:**
- Maintained tablet (>600px) and desktop (>900px) breakpoints
- Increased top padding for tablet: 80px
- Title/subtitle scale proportionally on larger screens
- Max content width: 500px on tablet

---

## Component Hierarchy (Figma Structure)

```
Login (Frame 50:3051)
├── Shape (50:3056) - Blurred background
├── Back (50:5556) - Back button
├── Waffir-Icon (50:3060) - Logo
└── Container (50:3061)
    ├── Container (50:3062)
    │   ├── Frame 133 (50:3063)
    │   │   └── Container (50:3064)
    │   │       ├── Title text (50:5571)
    │   │       └── Subtitle text (50:3066)
    │   └── Phone Number (50:3067) - Component instance
    │       ├── Oval-BTN (submit button)
    │       └── Container (input field)
    ├── Container (50:3068) - Divider
    │   ├── Line (50:3069)
    │   ├── "أو" text (50:3070)
    │   └── Line (50:3071)
    └── Sign In (50:3072)
        ├── Google Button (50:3073) - Component instance
        └── Apple Button (50:3074) - Component instance
```

---

## Responsive Design Rules

### Mobile (≤600px)
- Horizontal padding: 16px
- Icon size: 177×175px
- Title: 20px
- Subtitle: 16px
- Top padding: 60px
- Bottom padding: 120px

### Tablet (>600px)
- Horizontal padding: 40px (not used due to 361px constraint)
- Max content width: 500px
- Icon size: 177×175px (same as mobile)
- Title: 20px (Figma doesn't specify scaling)
- Top padding: 80px
- Bottom padding: 120px

### Desktop (>900px)
- Horizontal padding: 48px (not used due to 361px constraint)
- Max content width: 500px
- All other values same as tablet

**Note:** Component widths are fixed at 361px per Figma, overriding responsive padding.

---

## Testing Checklist

- [x] Background matches Figma (white with blur)
- [x] All spacing values match Figma specs
- [x] Typography uses Parkinsans font
- [x] Typography sizes and weights correct
- [x] Icon size: 177×175px
- [x] Submit button: 44×44px
- [x] Social buttons: 48px height
- [x] Border radii correct (16px input, 30px buttons)
- [x] Assets render properly (SVG/PNG)
- [x] RTL text direction works
- [x] Back button positioned correctly
- [x] All colors use theme system
- [ ] Test on physical device (393×852px)
- [ ] Test on tablet
- [ ] Test dark mode (via theme)
- [ ] Test phone input validation
- [ ] Test social auth buttons
- [ ] Test animations (button press)

---

## Known Differences from Figma

### Intentional Design Decisions

1. **Color System:** Using theme colors instead of hardcoded hex values for light/dark mode support
2. **Responsive Behavior:** Added tablet/desktop breakpoints not in Figma mobile frame
3. **Component Width:** 361px components may overflow on narrow screens (<393px)
4. **Back Button Asset:** Using full back button SVG (393×118) scaled to 44×44
5. **Animation Retained:** Submit button and social button press animations (not in Figma static)

### Technical Constraints

1. **Blur Implementation:** Using `ImageFilter.blur` instead of CSS-like blur filter
2. **SVG Rendering:** Some SVG rendering may differ slightly from Figma due to Flutter's SVG parser
3. **Font Rendering:** Parkinsans rendering may vary slightly across platforms

---

## Maintenance Notes

### Updating Assets
If Figma design changes:
1. Download new assets using `mcp__Framelink_MCP_for_Figma__download_figma_images`
2. Run `dart run build_runner build --delete-conflicting-outputs`
3. Update this memory file with new specifications

### Color Updates
If colors change in Figma:
1. Update theme mappings in `lib/core/themes/app_theme.dart`
2. Do NOT hardcode new hex values in widgets
3. Always use `Theme.of(context).colorScheme.*`

### Spacing Updates
If spacing changes:
1. Update spacing constants in component files
2. Maintain responsive behavior logic
3. Test on multiple screen sizes

---

## Related Files

- **Theme:** `lib/core/themes/app_theme.dart`
- **Colors:** `lib/core/constants/app_colors.dart` (reference only)
- **Typography:** `lib/core/constants/app_typography.dart`
- **Assets:** `lib/gen/assets.gen.dart` (generated)
- **Memories:** `.serena/memories/ui_ux_guidelines_and_widgets.md`

---

## Implementation Date
2025-01-30

## Last Updated
2025-01-30