# Build and Deploy Scripts

This directory contains automated scripts for building and deploying your Flutter app to iOS and Android platforms.

## Quick Start

### 1. Configure Your Project

All project-specific configuration is centralized in `config.sh`. Update the following values for your project:

```bash
# Edit scripts/config.sh
nano scripts/config.sh
```

**Required configuration:**
- `APP_NAME` - Your app's display name
- `BUNDLE_ID` - Your app's bundle identifier
- `APPLE_TEAM_ID` - Your Apple Developer Team ID
- `IOS_API_KEY_*` or `IOS_APPLE_ID` - iOS authentication credentials
- `ANDROID_SERVICE_ACCOUNT_KEY` - Android authentication (for uploads)

### 2. Build and Deploy

```bash
# Development build
./scripts/deploy.sh -p both -e dev -t build

# Staging build with upload to TestFlight/Internal Testing
./scripts/deploy.sh -p both -e staging -t archive --upload

# Production build and upload
./scripts/deploy.sh -p both -e production -t archive --clean --upload
```

## Configuration File (`config.sh`)

The `config.sh` file is the single source of truth for all project-specific values:

### App Information
- `APP_NAME` - Display name
- `BUNDLE_ID` - Base bundle identifier
- `APP_DESCRIPTION` - App Store description
- `APP_CATEGORY` / `APP_SUBCATEGORY` - Store categories
- `APP_KEYWORDS` - Store keywords

### Team Information
- `APPLE_TEAM_ID` - Apple Developer Team ID
- `APPLE_TEAM_NAME` - Team name

### Authentication Credentials
- `IOS_API_KEY_PATH` - Path to App Store Connect API key (.p8)
- `IOS_API_KEY_ID` - API Key ID
- `IOS_API_ISSUER_ID` - API Issuer ID
- `IOS_APPLE_ID` - Alternative: Apple ID for authentication
- `IOS_APP_SPECIFIC_PASSWORD` - Alternative: App-specific password
- `ANDROID_SERVICE_ACCOUNT_KEY` - Google Play service account JSON

### Environment Configuration
- `BUNDLE_ID_DEV` / `BUNDLE_ID_STAGING` / `BUNDLE_ID_PROD` - Bundle ID suffixes
- `DEFAULT_PLATFORM` / `DEFAULT_ENVIRONMENT` / `DEFAULT_BUILD_TYPE` - Default build settings

## Scripts Overview

### `config.sh` - Central Configuration
**Purpose:** Single source of truth for all project-specific configuration

**Key Features:**
- Helper functions for bundle ID generation
- Configuration validation
- Environment-aware settings
- Exportable for use in all scripts

### `deploy.sh` - Cross-Platform Build and Deploy
**Purpose:** Main build and deploy script for iOS and Android

**Usage:**
```bash
./scripts/deploy.sh [OPTIONS]

Options:
  -p, --platform      Target platform (ios, android, both) [default: from config]
  -e, --environment   Environment (dev, staging, production) [default: from config]
  -t, --type         Build type (build, archive, test) [default: from config]
  -c, --clean        Clean before building
  -u, --upload       Upload to app stores (requires authentication)
  --validate-only    Validate without uploading
  --no-version-bump  Skip version increment
```

**Examples:**
```bash
# Build for both platforms (production)
./scripts/deploy.sh -p both -e production -t archive

# Build and upload iOS only
./scripts/deploy.sh -p ios -e production -t archive --upload

# Build and upload Android only
./scripts/deploy.sh -p android -e production -t archive --upload

# Build and upload both platforms (credentials from config.sh)
./scripts/deploy.sh -p both -e production -t archive --upload

# Validate only (dry run)
./scripts/deploy.sh -p both -e production -t archive --validate-only

# Clean build for staging
./scripts/deploy.sh -p both -e staging -t archive --clean
```

### `create_app_store_connect.sh` - App Store Connect Setup Guide
**Purpose:** Step-by-step guide for creating your app in App Store Connect

**Usage:**
```bash
./scripts/create_app_store_connect.sh
```

**Provides:**
- Prerequisites checklist
- App information to use
- Detailed setup steps
- TestFlight configuration
- Required assets list

### `setup_app_store_upload.sh` - Upload Setup Guide
**Purpose:** Guide for setting up automated uploads

**Usage:**
```bash
./scripts/setup_app_store_upload.sh
```

**Covers:**
- Authentication setup (API keys or Apple ID)
- Bundle ID configuration
- Testing your setup
- Upload examples
- Troubleshooting

### `release/ios.sh` - iOS Release Shortcut
**Purpose:** Quick iOS production release

**Usage:**
```bash
# Uses credentials from config.sh
./scripts/release/ios.sh

# Override environment
./scripts/release/ios.sh --environment staging

# Override credentials
./scripts/release/ios.sh --api-key ./custom-key.p8 --api-key-id XYZ --api-issuer-id UUID
```

## Common Workflows

### Initial Setup

1. **Configure your project:**
   ```bash
   nano scripts/config.sh
   # Update APP_NAME, BUNDLE_ID, APPLE_TEAM_ID, etc.
   ```

2. **Set up App Store Connect:**
   ```bash
   ./scripts/create_app_store_connect.sh
   # Follow the guide to create your app
   ```

3. **Configure authentication:**
   ```bash
   ./scripts/setup_app_store_upload.sh
   # Follow the guide to set up API keys or Apple ID
   ```

4. **Test your setup:**
   ```bash
   ./scripts/deploy.sh -p both -e dev -t build
   ```

### Development Testing

```bash
# Build for iOS simulator
./scripts/deploy.sh -p ios -e dev -t build

# Build for Android emulator
./scripts/deploy.sh -p android -e dev -t build

# Build for both platforms
./scripts/deploy.sh -p both -e dev -t build
```

### Internal Testing (TestFlight / Internal Track)

```bash
# Build and upload staging to TestFlight and Play Console internal track
./scripts/deploy.sh -p both -e staging -t archive --clean --upload
```

### Production Release

```bash
# Build and upload to App Store + Play Console
./scripts/deploy.sh -p both -e production -t archive --clean --upload

# Or use the iOS release shortcut
./scripts/release/ios.sh
```

## Authentication Methods

### iOS - App Store Connect

#### Method 1: API Key (Recommended)

1. Go to [App Store Connect](https://appstoreconnect.apple.com) > Users and Access > Keys
2. Create a new key with "Developer" role
3. Download the `.p8` file (you can only download it once!)
4. Update `config.sh`:
   ```bash
   IOS_API_KEY_PATH="$HOME/.appstoreconnect/private_keys/AuthKey_XXXXXXXXXX.p8"
   IOS_API_KEY_ID="XXXXXXXXXX"
   IOS_API_ISSUER_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
   ```

#### Method 2: Apple ID

1. Go to [appleid.apple.com](https://appleid.apple.com)
2. Generate an app-specific password
3. Update `config.sh`:
   ```bash
   IOS_APPLE_ID="your@email.com"
   IOS_APP_SPECIFIC_PASSWORD="xxxx-xxxx-xxxx-xxxx"
   ```

### Android - Google Play Console

1. Create a service account in Google Cloud Console
2. Grant access in Google Play Console
3. Download the JSON key file
4. Update `config.sh`:
   ```bash
   ANDROID_SERVICE_ACCOUNT_KEY="$HOME/.playstore/service-account.json"
   ```

## Build Environments

### Development (`dev`)
- **Configuration:** Debug
- **Bundle ID:** `{BUNDLE_ID}.dev`
- **Purpose:** Local testing, debugging
- **Upload:** N/A

### Staging (`staging`)
- **Configuration:** Release
- **Bundle ID:** `{BUNDLE_ID}.staging`
- **Purpose:** TestFlight, internal testing
- **Upload:** TestFlight (iOS), Internal Track (Android)

### Production (`production`)
- **Configuration:** Release
- **Bundle ID:** `{BUNDLE_ID}`
- **Purpose:** App Store, Play Store
- **Upload:** App Store (iOS), chosen track (Android)

## Version Management

The scripts automatically increment the version number in `pubspec.yaml` when:
- Building with `--type archive`
- Not in `--validate-only` mode
- Not using `--no-version-bump` flag

**Version Format:** `MAJOR.MINOR.PATCH+BUILD`

**Increment Logic:**
- Patch version increments by 1
- Patch rolls over at 99 → increments minor
- Minor rolls over at 9 → increments major
- Build number always increments

**Example:**
```
1.0.0+1 → 1.0.1+2 → 1.0.2+3 → ... → 1.0.99+100 → 1.1.0+101
```

To skip version increment:
```bash
./scripts/deploy.sh -p both -e production -t archive --no-version-bump
```

## Troubleshooting

### Configuration Issues

**Problem:** Scripts show warnings about default configuration

**Solution:** Update `scripts/config.sh` with your project-specific values

### iOS Code Signing Errors

**Problem:** Build fails with signing errors

**Solutions:**
- Ensure certificates are installed in Keychain
- Verify provisioning profiles are up to date
- Check that `APPLE_TEAM_ID` matches your account

### iOS Upload Failures

**Problem:** Upload to App Store Connect fails

**Solutions:**
- Verify authentication credentials in `config.sh`
- For API keys: Check file path and permissions
- For Apple ID: Use app-specific password, not regular password
- Ensure version number is higher than previous uploads

### Android Upload Failures

**Problem:** Upload to Play Console fails

**Solutions:**
- Verify service account key path in `config.sh`
- Check service account has proper permissions in Play Console
- Ensure app is created in Play Console

### Build Failures

**Problem:** Build fails with compilation errors

**Solutions:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
./scripts/deploy.sh -p both -e dev -t build --clean
```

## Security Best Practices

1. **Never commit credentials to version control**
   - Add `config.sh` to `.gitignore` if it contains secrets
   - Use environment variables for sensitive data
   - Keep API keys and passwords outside the repository

2. **Use template config for version control**
   ```bash
   # Create a template version
   cp scripts/config.sh scripts/config.sh.template
   # Remove sensitive data from template
   # Commit template, ignore actual config
   ```

3. **Rotate credentials regularly**
   - Generate new API keys periodically
   - Revoke old keys when no longer needed

4. **Use restrictive permissions**
   - API keys: Use "Developer" role unless "Admin" is needed
   - Service accounts: Grant minimum required permissions

5. **Secure key files**
   ```bash
   chmod 600 ~/.appstoreconnect/private_keys/*.p8
   chmod 600 ~/.playstore/*.json
   ```

## CI/CD Integration

The scripts are designed to work in CI/CD environments:

1. **Store credentials as secrets** in your CI system
2. **Generate config.sh** from environment variables:
   ```bash
   # In your CI script
   cat > scripts/config.sh << EOF
   export APP_NAME="$CI_APP_NAME"
   export BUNDLE_ID="$CI_BUNDLE_ID"
   export APPLE_TEAM_ID="$CI_APPLE_TEAM_ID"
   # ... etc
   EOF
   ```
3. **Run deployment:**
   ```bash
   ./scripts/deploy.sh -p both -e production -t archive --upload
   ```

## Additional Resources

- **App Store Connect Help:** https://help.apple.com/app-store-connect
- **App Store Review Guidelines:** https://developer.apple.com/app-store/review/guidelines
- **Google Play Console Help:** https://support.google.com/googleplay/android-developer
- **Flutter Build Docs:** https://docs.flutter.dev/deployment

## Support

For issues with these scripts:
1. Check the troubleshooting section above
2. Review the configuration in `config.sh`
3. Run with `--verbose` flag for detailed output
4. Check individual script documentation

For Flutter or platform-specific issues, refer to official documentation.
