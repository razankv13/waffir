# Getting Started with Build Scripts

## What Changed?

All dynamic values and project-specific configuration are now centralized in a single file: **`config.sh`**

This makes it easy to:
- Set up new projects quickly
- Update credentials in one place
- Share configuration patterns across projects
- Keep sensitive data separate from scripts

## Quick Setup (5 Minutes)

### 1. Edit config.sh

Open `scripts/config.sh` and update these essential values:

```bash
# Open the config file
nano scripts/config.sh
```

**Required changes:**
```bash
# App Information
export APP_NAME="YourAppName"                    # Change this!
export BUNDLE_ID="com.yourcompany.yourapp"       # Change this!

# Team Information
export APPLE_TEAM_ID="YOUR_TEAM_ID"              # Change this!

# iOS Authentication (choose ONE method)
# Method 1: API Key (recommended)
export IOS_API_KEY_PATH="$HOME/.appstoreconnect/private_keys/AuthKey_XXXXXXXXXX.p8"
export IOS_API_KEY_ID="XXXXXXXXXX"
export IOS_API_ISSUER_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# Method 2: Apple ID (alternative)
export IOS_APPLE_ID="your@email.com"
export IOS_APP_SPECIFIC_PASSWORD="xxxx-xxxx-xxxx-xxxx"

# Android Authentication
export ANDROID_SERVICE_ACCOUNT_KEY="$HOME/.playstore/service-account.json"
```

**Optional changes:**
```bash
export APP_DESCRIPTION="Your app description"
export APP_CATEGORY="Your Category"
export APP_KEYWORDS="keyword1,keyword2,keyword3"
```

### 2. Test Your Configuration

```bash
# Test a development build
./scripts/deploy.sh -p both -e dev -t build
```

If you see warnings about default values, go back and update `config.sh`.

### 3. You're Ready!

All scripts now automatically use your configuration:

```bash
# Development
./scripts/deploy.sh -p both -e dev -t build

# Staging with upload
./scripts/deploy.sh -p both -e staging -t archive --upload

# Production release
./scripts/deploy.sh -p both -e production -t archive --upload
```

## What's in config.sh?

The configuration file contains:

### App Identity
- `APP_NAME` - Display name shown in stores
- `BUNDLE_ID` - Base bundle identifier (e.g., com.company.app)
- `PACKAGE_NAME` - Android package name (usually same as BUNDLE_ID)

### Store Metadata
- `APP_DESCRIPTION` - Store description
- `APP_CATEGORY` / `APP_SUBCATEGORY` - Store categories
- `APP_KEYWORDS` - Search keywords
- `APP_SKU` - App Store Connect SKU

### Team Information
- `APPLE_TEAM_ID` - Your Apple Developer Team ID
- `APPLE_TEAM_NAME` - Your team name

### Authentication
- **iOS:** API key or Apple ID credentials
- **Android:** Service account JSON key

### Build Settings
- Default platform, environment, build type
- Bundle ID suffixes for different environments
- Auto-increment version setting

### URLs
- Privacy policy, support, marketing URLs
- Store links (once published)

## Finding Your Apple Team ID

1. Go to [Apple Developer](https://developer.apple.com/account/)
2. Sign in with your Apple ID
3. Go to **Membership**
4. Your Team ID is shown on that page

## Setting Up Authentication

### For iOS

**Option 1: API Key (Recommended)**

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to **Users and Access** > **Keys**
3. Click **+** to create a new key
4. Name it (e.g., "MyApp Upload Key")
5. Select **Developer** role
6. Click **Generate**
7. **Download the .p8 file immediately** (you can't download it again!)
8. Note the **Key ID** and **Issuer ID**
9. Update config.sh with these values

**Option 2: Apple ID**

1. Go to [appleid.apple.com](https://appleid.apple.com)
2. Sign in
3. Go to **Sign-In and Security** > **App-Specific Passwords**
4. Click **+** to generate
5. Name it (e.g., "MyApp iOS Upload")
6. Copy the password (format: xxxx-xxxx-xxxx-xxxx)
7. Update config.sh with your Apple ID and this password

### For Android

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create or select your project
3. Go to **IAM & Admin** > **Service Accounts**
4. Create a service account
5. Download the JSON key
6. Go to [Google Play Console](https://play.google.com/console)
7. Go to **Setup** > **API access**
8. Grant access to your service account
9. Update config.sh with the path to the JSON file

## Common Commands

```bash
# Development build
./scripts/deploy.sh -p both -e dev -t build

# Build staging and upload to TestFlight/Internal Track
./scripts/deploy.sh -p both -e staging -t archive --upload

# Build production and upload to stores
./scripts/deploy.sh -p both -e production -t archive --upload

# iOS only
./scripts/deploy.sh -p ios -e production -t archive --upload

# Android only
./scripts/deploy.sh -p android -e production -t archive --upload

# Quick iOS release
./scripts/release/ios.sh
```

## Configuration Templates

### Minimal Template (Development Only)

```bash
export APP_NAME="MyApp"
export BUNDLE_ID="com.mycompany.myapp"
export APPLE_TEAM_ID="ABCDEFGHIJ"
```

### Full Template (Production Ready)

```bash
# App
export APP_NAME="MyApp"
export BUNDLE_ID="com.mycompany.myapp"
export APP_DESCRIPTION="My app description"
export APPLE_TEAM_ID="ABCDEFGHIJ"

# iOS Auth
export IOS_API_KEY_PATH="$HOME/.appstoreconnect/private_keys/AuthKey_ABC123.p8"
export IOS_API_KEY_ID="ABC123"
export IOS_API_ISSUER_ID="12345678-1234-1234-1234-123456789012"

# Android Auth
export ANDROID_SERVICE_ACCOUNT_KEY="$HOME/.playstore/service-account.json"
```

## Security Note

The `config.sh` file may contain sensitive credentials. Consider:

1. **For version control:**
   ```bash
   # Create a template without secrets
   cp scripts/config.sh scripts/config.sh.template
   # Remove sensitive values from template
   # Add config.sh to .gitignore
   echo "scripts/config.sh" >> .gitignore
   ```

2. **For CI/CD:**
   - Store credentials as secrets in your CI system
   - Generate config.sh from environment variables at build time

3. **For team sharing:**
   - Share config.sh.template
   - Each developer maintains their own config.sh with their credentials

## Need Help?

- **Full documentation:** `scripts/README.md`
- **Quick commands:** `scripts/commands.md`
- **App Store setup:** `./scripts/create_app_store_connect.sh`
- **Authentication setup:** `./scripts/setup_app_store_upload.sh`
- **Script help:** `./scripts/deploy.sh --help`

## What's Next?

1. ✅ Update `config.sh` with your values
2. ✅ Test a development build
3. 📱 Set up App Store Connect (if needed)
4. 🔐 Configure authentication
5. 🚀 Deploy to staging/production

Happy building! 🎉
