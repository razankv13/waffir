# Task Completion Checklist

When a task is completed, follow these steps:

## 1. Code Generation (if applicable)

Run if you modified:
- Freezed classes
- JSON serializable classes
- Riverpod providers with annotations
- Hive type adapters
- Assets (images, icons, translations)

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 2. Code Formatting

**Always run before committing:**
```bash
dart format .
```

## 3. Code Analysis

**Check for linting errors and warnings:**
```bash
flutter analyze
```

Fix any errors or warnings reported.

## 4. Testing

**Run appropriate tests based on changes:**

```bash
# All tests
flutter test

# Specific feature tests
flutter test test/unit/features/auth/

# With coverage (for significant changes)
flutter test --coverage
```

## 5. Manual Testing

If applicable:
- Run the app with appropriate flavor
- Test the affected features
- Verify on different platforms (iOS, Android, Web)
- Test both light and dark themes
- Test different screen sizes

```bash
# Dev environment for testing
flutter run --flavor dev -t lib/main_dev.dart
```

## 6. Environment Configuration

If environment variables were added or modified:
- Update `.env.example`
- Update `.env.dev`, `.env.staging`, `.env.production`
- Update `EnvironmentConfig` class in `lib/core/config/environment_config.dart`
- Document in CLAUDE.md if significant

## 7. Flavor Configuration

If flavor-specific changes were made:
- Update `flavorizr.yaml`
- Regenerate flavor configurations:
  ```bash
  flutter pub run flutter_flavorizr -f
  ```

## 8. Documentation

Update if needed:
- **CLAUDE.md** - For significant architectural changes or new patterns
- **README.md** - For user-facing changes
- **Code comments** - For complex logic
- Inline documentation for public APIs

## 9. Git Workflow

```bash
# Check status
git status

# Stage changes
git add .

# Commit with meaningful message
git commit -m "feat: descriptive message"

# Push to remote
git push
```

## Quick Checklist

- [ ] Code generation run (if needed)
- [ ] Code formatted (`dart format .`)
- [ ] Analysis passed (`flutter analyze`)
- [ ] Tests passing (`flutter test`)
- [ ] Manual testing completed
- [ ] Documentation updated
- [ ] Git committed and pushed

## Common Issues

**Build Runner Conflicts:**
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

**Flutter Clean (if build issues):**
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**Flavor Issues:**
```bash
flutter pub run flutter_flavorizr -f
```