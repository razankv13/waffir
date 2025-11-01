# Account Details Screen - Figma Design Mapping

## Implementation Details

### Figma Design Specifications

**Source:** `https://www.figma.com/design/ZsZg4SBnPpkfAcmQYeL7yu/Waffir-Final?node-id=50-3102`

**Key Measurements:**
- Frame: 393x852 (mobile reference)
- Main padding: 0px 16px 120px bottom
- Title font: Parkinsans 700, 20px, line-height 1.15em
- Input border radius: 16px (changed from 30px)
- Input text: Parkinsans 500, 16px
- Checkbox: 24x24, 4px border radius
- Checkbox text: Parkinsans 400, 14px, line-height 1.4em
- Button: 330x48, 30px border radius, Parkinsans 600, 14px

### Layout Structure

```
Stack
├── White background (#FFFFFF)
├── Blur shape image (positioned at -40, -100, mirrored for RTL)
│   └── login_blur_shape.png (467.78 x 461.3)
└── SafeArea with Column
    ├── Back button (20px padding, 38x38 size)
    ├── Expanded ScrollView (16px/24px horizontal padding)
    │   ├── Title (80px top spacing)
    │   ├── Name input (16px spacing below)
    │   ├── Gender selector (11px spacing)
    │   ├── Referral input (11px spacing)
    │   └── Terms checkbox (105px spacing above)
    └── AppButton.primary (330px wide, centered, 120px/60px bottom)
```

### Components Used

**AppButton.primary** - Replaced custom `_PremiumButton`
- Width: 330px (fixed, as per Figma)
- Border radius: 30px (overridden from default)
- Size: ButtonSize.medium (creates 48px height)
- Text: 14px, Parkinsans 600

**GenderSelector** - Already used correctly
- 80px gap between options
- 24x24 rounded square checkboxes
- Matches Figma specifications

**_PillTextField** - Custom input widget
- Height: 56px
- Border radius: 16px (changed from 30px)
- Background: surfaceContainerHighest with 0.6 alpha
- Text: 16px, Parkinsans 500
- Centered text alignment

**_RoundedSquareCheckbox** - Custom checkbox widget
- Size: 24x24
- Border radius: 4px (changed from 6px)
- Border: 2px, primary color when checked
- Check icon: 16px, **bright green (#00FF88)** via secondary color
- Animated with 200ms duration

### RTL Support

**Implementation:**
- Wraps entire screen with `Directionality` widget
- Detects RTL via `context.locale.languageCode == 'ar'`
- Mirrors back button position (AppBackButton handles this automatically)
- Mirrors background shape using `Transform.scale(scaleX: -1.0)`
- Text naturally adapts with `TextDirection` inheritance

### Responsive Design

**Breakpoints:**
```dart
final isSmallScreen = size.height < 700;
```

**Horizontal Padding:**
- Mobile (<600px): 16px
- Tablet (≥600px): 24px

**Bottom Padding:**
- Small screens (<700px height): 60px
- Normal screens: 120px

**Button:**
- Fixed width: 330px (centered)
- Never full width, even on tablets

### Theme System Compliance

**All colors use `Theme.of(context)`:**
- ✅ Surface: `colorScheme.surface` (white)
- ✅ Text: `colorScheme.onSurface`, `colorScheme.onSurfaceVariant`
- ✅ Primary: `colorScheme.primary` (#0F352D)
- ✅ Secondary: `colorScheme.secondary` (#00FF88) - checkbox icon
- ✅ Input background: `surfaceContainerHighest.withAlpha(0.6)`
- ✅ Borders: `colorScheme.outline`

**Text styles:**
- Title: `titleLarge` with size 20, weight 700, height 1.15
- Inputs: `bodyMedium` with size 16, weight 500
- Checkbox text: `bodySmall` with size 14, weight 400, height 1.4

### Key Improvements from Previous Implementation

**Background:**
- ❌ Old: Gradient from primary.withAlpha(0.15) to surface
- ✅ New: White background with blur shape image overlay

**Padding:**
- ❌ Old: 39px horizontal, 158px/40px bottom
- ✅ New: 16px/24px horizontal, 120px/60px bottom

**Button:**
- ❌ Old: Custom `_PremiumButton` with 56px height, 60px radius, full width
- ✅ New: `AppButton.primary` with 48px height, 30px radius, 330px width

**Typography:**
- ❌ Old: Title 28px, inputs 14px, checkbox text 12px
- ✅ New: Title 20px, inputs 16px, checkbox text 14px

**Border Radius:**
- ❌ Old: Input 30px, checkbox 6px, button 60px
- ✅ New: Input 16px, checkbox 4px, button 30px

**Checkbox Icon:**
- ❌ Old: White icon (onPrimary)
- ✅ New: Bright green (#00FF88) via secondary color

### Assets Used

**Background Shape:**
- File: `assets/images/login_blur_shape.png`
- Generated via: `Assets.images.loginBlurShape.path`
- Same shape used in login/auth screens
- Positioned at top-left with negative offset
- Mirrored for RTL languages

**Widgets Used:**
- `AppButton.primary` - `lib/core/widgets/buttons/app_button.dart`
- `AppBackButton` - `lib/core/widgets/buttons/back_button.dart`
- `GenderSelector` - `lib/core/widgets/inputs/gender_selector.dart`

### Testing Checklist

- [x] Visual match with Figma design
- [x] Title displays at 20px
- [x] Input fields have 16px border radius
- [x] Button is 330x48 with 30px border radius
- [x] Checkbox icon is bright green (#00FF88)
- [x] Background image displays correctly
- [x] RTL layout works for Arabic
- [x] LTR layout works for other languages
- [x] Form validation works (name, gender, terms required)
- [x] Button enables/disables based on form state
- [x] Navigation works (back button, confirm to home)
- [x] Responsive on mobile/tablet/desktop
- [x] Theme system compliance (light/dark mode ready)
- [x] Uses AppButton instead of custom button
- [x] Code duplication removed (_PremiumButton deleted)

### Related Files

- **Screen:** `lib/features/auth/presentation/screens/account_details_screen.dart`
- **Widgets:** `lib/core/widgets/buttons/app_button.dart`, `lib/core/widgets/buttons/back_button.dart`, `lib/core/widgets/inputs/gender_selector.dart`
- **Assets:** `assets/images/login_blur_shape.png`

### Notes

- Design is pixel-perfect match with Figma while maintaining responsive behavior
- All codebase conventions followed (theme usage, const constructors, naming)
- AppButton provides excellent consistency across the app
- RTL support follows the same pattern as OTP verification screen
- Background shape image adds premium polish to the screen
- Checkbox icon color (#00FF88) creates visual consistency with brand colors
