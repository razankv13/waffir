# Notifications & Alerts Screen - Required Asset Export

## Background Blur Shape (CRITICAL)

**Figma Node:** `7774:4001` (named "Shape")  
**File:** `ZsZg4SBnPpkfAcmQYeL7yu`

### Export Instructions

1. **Open Figma file** at node `7774:4001`
2. **Select the "Shape" layer** (the blurred gradient shape at the top)
3. **Export as PNG** with the following settings:
   - Format: PNG
   - Scale: 2x or 3x (for high-DPI screens)
   - **IMPORTANT**: Export with blur effect baked in (Figma will render the 100px blur)
4. **Save as**: `notifications_alerts_blur_shape.png`
5. **Place in**: `assets/images/`

### Technical Specs
- **Original size**: 467.78 × 461.3 px
- **Position in layout**: x=-40, y=-100 (relative to frame origin)
- **Blur effect**: 100px layer blur (`effect_T3933I`)
- **Color/gradient**: As per Figma (multi-color gradient with blur)

### Why PNG and not SVG?
- The blur effect needs to be pre-rendered for pixel-perfect match
- Flutter's `ImageFilter.blur` may not match Figma's blur kernel exactly
- PNG with baked-in blur ensures visual fidelity across platforms

### Usage in Code
The asset is referenced in:
- `lib/features/deals/presentation/screens/notifications_screen.dart`
- Positioned using `ResponsiveHelper.scale()` for proportional sizing

```dart
Image.asset(
  'assets/images/notifications_alerts_blur_shape.png',
  width: responsive.scale(467.78),
  height: responsive.scale(461.3),
  fit: BoxFit.contain,
)
```

## Existing Assets (Already Available)

These icons are already in the repo and will be reused:
- ✅ `assets/icons/back_button.svg` - Back navigation
- ✅ `assets/icons/bolt.svg` - Deal Alerts filter icon (24×24)
- ✅ `assets/icons/notification_bell.svg` - Notifications filter icon (24×24)
- ✅ `assets/icons/chevron_right.svg` - Deal card chevron (24×24)
- ✅ `assets/icons/plus.svg` - Add button icon (16×16)
- ✅ `assets/icons/categories/arrow_filter_icon.svg` - Search button arrow (20×20)

## After Export

1. Place `notifications_alerts_blur_shape.png` in `assets/images/`
2. Run `flutter pub get` to refresh asset bundle (if needed)
3. Verify the image appears in the notifications screen background
4. Test on different screen sizes to ensure ResponsiveHelper scaling works correctly

## Verification Checklist

- [ ] Blur shape PNG exported from Figma with blur effect baked in
- [ ] File placed in `assets/images/notifications_alerts_blur_shape.png`
- [ ] Asset appears in top-left corner of notifications screen
- [ ] Blur effect matches Figma design visually
- [ ] No console errors about missing asset
- [ ] Responsive scaling works on different devices (mobile/tablet)

