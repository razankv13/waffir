# Internationalization (i18n) Implementation Prompt

Use the following prompt when asking for new screens or features to ensure consistent internationalization handling across the codebase.

---

## Prompt for implementing i18n in Waffir

**Context:**
This project uses `easy_localization` for internationalization.
- Translation files are located in: `assets/translations/`
- Supported locales: `en-US`, `ar-SA`, `fr-FR`, `es-ES`
- Structure: Nested JSON objects (e.g., `feature.screen.key`)

**Rules for adding translations:**

1.  **Check Reuse**: Before creating a new key, check `assets/translations/en-US.json` for existing common keys (e.g., `buttons.save`, `errors.networkError`). Reuse them if they fit exactly.
2.  **Naming Convention**:
    -   Use camelCase for keys.
    -   Nest keys logically under the feature or screen name.
    -   Example:
        ```json
        "login": {
          "title": "Welcome Back",
          "emailHint": "Enter your email"
        }
        ```
3.  **File Updates**: You must provide the JSON updates for **all** supported languages (`en-US`, `ar-SA`, `es-ES`, `fr-FR`). If you don't know the exact translation for non-English languages, provide a placeholder or a machine-translated version, but explicitly mark it for review.
4.  **Static Keys Class**:
    -   Maintain a `LocaleKeys` class (or similar, e.g., in `lib/core/constants/locale_keys.dart`) to store translation keys as static constants.
    -   Structure the class to mirror the JSON structure using nested classes or dot-notation variable names.
    -   **Example**:
        ```dart
        abstract class LocaleKeys {
          static const loginTitle = 'login.title';
          static const loginEmailHint = 'login.emailHint';
          // or nested
          static const onBoarding = _OnBoardingKeys();
        }
        
        class _OnBoardingKeys {
          const _OnBoardingKeys();
          final familyInvite = 'onboarding.familyInvite';
          // ...
        }
        ```
5.  **Dart Implementation**:
    -   Use `easy_localization`'s extension methods with the static keys.
    -   Preferred usage: `tr(LocaleKeys.loginTitle)` or `context.tr(LocaleKeys.loginTitle)`.
    -   For pluralization or arguments, use standard `easy_localization` syntax.
    -   **Avoid hardcoded strings** and **raw string keys** in widgets. Always use the `LocaleKeys` constants.

**Output Requirement:**
When generating code for the UI:
1.  Provide the JSON additions.
2.  Provide the updates to the `LocaleKeys` class.
3.  Provide the UI code using the static keys.

```json
// Add to assets/translations/en-US.json
{
  "newFeature": {
    "title": "New Feature Title"
  }
}
```

```dart
// Update LocaleKeys
static const newFeatureTitle = 'newFeature.title';
```
---
