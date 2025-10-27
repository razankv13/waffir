# Quick Reference: Build Commands

## Prerequisites

1. **Configure your project** in `scripts/config.sh`:
   - Set `APP_NAME`, `BUNDLE_ID`, `APPLE_TEAM_ID`
   - Configure iOS authentication (API key or Apple ID)
   - Configure Android authentication (service account)

2. **Make scripts executable:**
   ```bash
   chmod +x scripts/*.sh
   chmod +x scripts/release/*.sh
   ```

## Development

```bash
# Debug build (both platforms)
./scripts/deploy.sh -p both -e dev -t build

# Debug build (iOS only)
./scripts/deploy.sh -p ios -e dev -t build

# Debug build (Android only)
./scripts/deploy.sh -p android -e dev -t build

# Run tests
./scripts/deploy.sh -p both -e dev -t test
```

## Staging (TestFlight & Internal Testing)

```bash
# Build staging (both platforms)
./scripts/deploy.sh -p both -e staging -t archive

# Clean build staging
./scripts/deploy.sh -p both -e staging -t archive --clean

# Upload to TestFlight + Play Console internal track
# (uses credentials from config.sh)
./scripts/deploy.sh -p both -e staging -t archive --upload

# iOS staging only
./scripts/deploy.sh -p ios -e staging -t archive --upload

# Android staging only
./scripts/deploy.sh -p android -e staging -t archive --upload
```

## Production

```bash
# Build production (both platforms)
./scripts/deploy.sh -p both -e production -t archive

# Upload to App Store + Play Console
# (uses credentials from config.sh)
./scripts/deploy.sh -p both -e production -t archive --upload

# Clean production build + upload
./scripts/deploy.sh -p both -e production -t archive --clean --upload

# Without version increment
./scripts/deploy.sh -p both -e production -t archive --no-version-bump
```

## Quick iOS Release

```bash
# Production release (uses config.sh credentials)
./scripts/release/ios.sh

# Staging release
./scripts/release/ios.sh --environment staging
```

## Validation (Dry Run)

```bash
# Validate both platforms
./scripts/deploy.sh -p both -e production -t archive --validate-only

# Validate iOS only
./scripts/deploy.sh -p ios -e production -t archive --validate-only

# Validate Android only
./scripts/deploy.sh -p android -e production -t archive --validate-only
```

## Overriding Configuration

While credentials are typically set in `config.sh`, you can override them:

### iOS Authentication Override

**Using API Key:**
```bash
./scripts/deploy.sh -p ios -e production -t archive --upload \
  --api-key ~/.appstoreconnect/private_keys/AuthKey_XXXXXXXXXX.p8 \
  --api-key-id XXXXXXXXXX \
  --api-issuer-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

**Using Apple ID:**
```bash
./scripts/deploy.sh -p ios -e production -t archive --upload \
  --apple-id your@email.com \
  --password xxxx-xxxx-xxxx-xxxx
```

### Android Authentication Override

```bash
./scripts/deploy.sh -p android -e production -t archive --upload \
  --service-account ~/.playstore/service-account.json
```

### Android Release Tracks

```bash
# Internal testing (default)
./scripts/deploy.sh -p android -e production -t archive --upload \
  --track internal

# Alpha testing
./scripts/deploy.sh -p android -e production -t archive --upload \
  --track alpha

# Beta testing
./scripts/deploy.sh -p android -e production -t archive --upload \
  --track beta

# Production release
./scripts/deploy.sh -p android -e production -t archive --upload \
  --track production
```

## Setup Guides

```bash
# App Store Connect setup guide
./scripts/create_app_store_connect.sh

# Upload authentication setup guide
./scripts/setup_app_store_upload.sh
```

## Common Patterns

### First-time setup
```bash
# 1. Configure
nano scripts/config.sh

# 2. Read setup guides
./scripts/create_app_store_connect.sh
./scripts/setup_app_store_upload.sh

# 3. Test local build
./scripts/deploy.sh -p both -e dev -t build
```

### Quick dev test
```bash
./scripts/deploy.sh -p both -e dev -t build
```

### TestFlight/Internal testing
```bash
./scripts/deploy.sh -p both -e staging -t archive --clean --upload
```

### Production release
```bash
# Full build and upload
./scripts/deploy.sh -p both -e production -t archive --clean --upload

# Or just iOS
./scripts/release/ios.sh
```

### Validate before upload
```bash
# Validate first
./scripts/deploy.sh -p both -e production -t archive --validate-only

# Then upload if validation passes
./scripts/deploy.sh -p both -e production -t archive --upload
```

## Help

```bash
# Show full help
./scripts/deploy.sh --help

# Show script-specific help
./scripts/create_app_store_connect.sh
./scripts/setup_app_store_upload.sh
```

## Notes

- All commands use configuration from `scripts/config.sh`
- Credentials are read from `config.sh` by default but can be overridden
- Version numbers auto-increment on archive builds (use `--no-version-bump` to skip)
- Use `--clean` flag for clean builds when facing build issues
- Use `--validate-only` for dry runs without actual uploads
