# Suggested Commands

## Development Commands

### Running the App

**Always use flavors when running (recommended):**
```bash
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor staging -t lib/main_staging.dart
flutter run --flavor production -t lib/main_production.dart
```

**Run with specific device:**
```bash
flutter run --flavor dev -t lib/main_dev.dart -d chrome
flutter run --flavor dev -t lib/main_dev.dart -d macos
flutter run --flavor dev -t lib/main_dev.dart -d iphone
```

**Default run (uses production):**
```bash
flutter run
```

### Code Generation

**IMPORTANT: Run after any changes to:**
- Freezed classes
- JSON serializable classes
- Riverpod providers with annotations
- Hive type adapters

```bash
# Generate once
dart run build_runner build --delete-conflicting-outputs

# Watch mode (continuous generation)
dart run build_runner watch --delete-conflicting-outputs

# Clean generated files
dart run build_runner clean
```

### Asset Generation

```bash
# Generate asset classes (flutter_gen)
dart run build_runner build --build-filter="lib/gen/**"
```

### Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/features/auth/presentation/controllers/auth_controller_test.dart

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/

# Run with Patrol
patrol test
```

### Code Quality

```bash
# Analyze code (always run before committing)
flutter analyze

# Format code (always run before committing)
dart format .

# Auto-fix common issues
dart fix --apply
```

### Building

**Android:**
```bash
flutter build apk --release --flavor production -t lib/main_production.dart
flutter build appbundle --release --flavor production -t lib/main_production.dart
```

**iOS:**
```bash
flutter build ipa --release --flavor production -t lib/main_production.dart
```

**macOS:**
```bash
flutter build macos --release --flavor production -t lib/main_production.dart
```

**Web:**
```bash
flutter build web --release -t lib/main_production.dart
```

### Dependency Management

```bash
# Install dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Check outdated packages
flutter pub outdated

# Clean build artifacts
flutter clean
```

### Flavor Management

```bash
# Regenerate flavor configurations
flutter pub run flutter_flavorizr -f
```

## macOS Utility Commands

Since the system is Darwin (macOS), standard Unix commands are available:

```bash
# File operations
ls -la          # List files with details
find . -name "*.dart"  # Find Dart files
grep -r "search_term" lib/  # Search in files

# Git operations
git status
git add .
git commit -m "message"
git push

# Process management
ps aux | grep flutter
kill <pid>

# Directory navigation
pwd             # Print working directory
cd <path>       # Change directory
```

## Quick Start Sequence

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate code
dart run build_runner build --delete-conflicting-outputs

# 3. Configure environment (if not done)
cp .env.example .env.dev

# 4. Run with dev flavor
flutter run --flavor dev -t lib/main_dev.dart
```

## When Task is Completed

After completing any task, run:

```bash
# 1. Format code
dart format .

# 2. Analyze for issues
flutter analyze

# 3. Run tests
flutter test

# 4. If code generation was needed
dart run build_runner build --delete-conflicting-outputs
```