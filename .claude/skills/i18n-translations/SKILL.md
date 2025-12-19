---
name: i18n-translations
description: Adds internationalization support using easy_localization. Use when adding new text strings, creating screens with user-facing text, or updating translations across all supported languages.
---

# Internationalization (i18n)

## When to Use This Skill

Use this skill when:
- Adding new screens with user-facing text
- Creating new UI components with labels
- Adding error messages or notifications
- Updating existing translations

## Supported Locales

- `en-US` - English (primary)
- `ar-SA` - Arabic
- `fr-FR` - French
- `es-ES` - Spanish

## Translation Files Location

```
assets/translations/
├── en-US.json
├── ar-SA.json
├── fr-FR.json
└── es-ES.json
```

## Implementation Steps

### Step 1: Check for Existing Keys

Before creating new keys, check `assets/translations/en-US.json` for reusable keys:

**Common reusable keys:**
- `buttons.save`, `buttons.cancel`, `buttons.confirm`, `buttons.delete`
- `errors.networkError`, `errors.serverError`, `errors.tryAgain`
- `common.loading`, `common.retry`, `common.noData`

### Step 2: Define New Translation Keys

**Naming Convention:**
- Use camelCase for keys
- Nest keys under feature/screen name
- Keep keys descriptive but concise

```json
// assets/translations/en-US.json
{
  "featureName": {
    "screenTitle": "Screen Title",
    "inputLabel": "Enter value",
    "buttonText": "Submit",
    "errorMessage": "Something went wrong",
    "emptyState": "No items found"
  }
}
```

### Step 3: Add to All Language Files

**IMPORTANT:** Update ALL 4 language files simultaneously.

```json
// en-US.json
{
  "profile": {
    "title": "My Profile",
    "editButton": "Edit Profile",
    "logoutButton": "Log Out"
  }
}

// ar-SA.json
{
  "profile": {
    "title": "ملفي الشخصي",
    "editButton": "تعديل الملف",
    "logoutButton": "تسجيل الخروج"
  }
}

// fr-FR.json
{
  "profile": {
    "title": "Mon Profil",
    "editButton": "Modifier le Profil",
    "logoutButton": "Se Deconnecter"
  }
}

// es-ES.json
{
  "profile": {
    "title": "Mi Perfil",
    "editButton": "Editar Perfil",
    "logoutButton": "Cerrar Sesion"
  }
}
```

### Step 4: Update LocaleKeys Class

Add static constants to `lib/core/constants/locale_keys.dart`:

```dart
abstract class LocaleKeys {
  // Existing keys...

  // Profile feature
  static const profileTitle = 'profile.title';
  static const profileEditButton = 'profile.editButton';
  static const profileLogoutButton = 'profile.logoutButton';

  // OR use nested class pattern for larger features
  static const profile = _ProfileKeys();
}

class _ProfileKeys {
  const _ProfileKeys();

  final title = 'profile.title';
  final editButton = 'profile.editButton';
  final logoutButton = 'profile.logoutButton';
}
```

### Step 5: Use in Dart Code

**Basic usage:**

```dart
import 'package:easy_localization/easy_localization.dart';
import 'package:waffir/core/constants/locale_keys.dart';

// In widget
Text(tr(LocaleKeys.profileTitle))

// Or with context
Text(context.tr(LocaleKeys.profileTitle))

// With AppBar
AppBar(title: Text(tr(LocaleKeys.profileTitle)))
```

**With arguments:**

```json
// en-US.json
{
  "greeting": "Hello, {name}!"
}
```

```dart
Text(tr(LocaleKeys.greeting, namedArgs: {'name': userName}))
```

**With pluralization:**

```json
// en-US.json
{
  "itemCount": {
    "zero": "No items",
    "one": "1 item",
    "other": "{count} items"
  }
}
```

```dart
Text(plural(LocaleKeys.itemCount, itemCount))
```

## Complete Example

### 1. JSON Updates (all files)

```json
// en-US.json
{
  "cart": {
    "title": "Shopping Cart",
    "emptyMessage": "Your cart is empty",
    "itemCount": {
      "zero": "No items",
      "one": "1 item",
      "other": "{count} items"
    },
    "total": "Total: {amount}",
    "checkoutButton": "Proceed to Checkout"
  }
}
```

### 2. LocaleKeys Update

```dart
// lib/core/constants/locale_keys.dart
abstract class LocaleKeys {
  // Cart
  static const cartTitle = 'cart.title';
  static const cartEmptyMessage = 'cart.emptyMessage';
  static const cartItemCount = 'cart.itemCount';
  static const cartTotal = 'cart.total';
  static const cartCheckoutButton = 'cart.checkoutButton';
}
```

### 3. Widget Usage

```dart
class CartScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.cartTitle)),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text(tr(LocaleKeys.cartEmptyMessage)))
          : ListView(...),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: context.responsive.scalePadding(
            const EdgeInsets.all(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(plural(LocaleKeys.cartItemCount, cartItems.length)),
              Text(tr(LocaleKeys.cartTotal, namedArgs: {'amount': '\$99.99'})),
              AppButton(
                text: tr(LocaleKeys.cartCheckoutButton),
                onPressed: () => checkout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Critical Rules

1. **NEVER hardcode strings** - All user-facing text must use LocaleKeys
2. **Update ALL languages** - Every key must exist in all 4 JSON files
3. **Use LocaleKeys constants** - Never use raw string keys like `tr('profile.title')`
4. **Check existing keys first** - Reuse common keys when they fit exactly
5. **camelCase keys** - Match the naming convention
6. **Nested structure** - Group keys by feature/screen

## Key Naming Patterns

| Type | Pattern | Example |
|------|---------|---------|
| Screen title | `feature.title` | `profile.title` |
| Button text | `feature.buttonName` | `profile.saveButton` |
| Input label | `feature.inputLabel` | `login.emailLabel` |
| Error message | `feature.errorType` | `login.invalidEmail` |
| Empty state | `feature.emptyMessage` | `cart.emptyMessage` |
| Confirmation | `feature.confirmAction` | `delete.confirmMessage` |

## Testing Translations

```dart
// Change locale programmatically
context.setLocale(const Locale('ar', 'SA'));

// Get current locale
final currentLocale = context.locale;
```
