#!/bin/bash

# Cross-Platform Build and Deploy Script
# This script handles building Flutter apps for iOS/Android and uploading them to App Store Connect/Google Play Console

set -e

# Load project configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Use configuration from config.sh
SCHEME="$IOS_SCHEME"
WORKSPACE="$IOS_WORKSPACE"
TEAM_ID="$APPLE_TEAM_ID"

# Default values (can be overridden by command line arguments)
PLATFORM="${DEFAULT_PLATFORM}"
ENVIRONMENT="${DEFAULT_ENVIRONMENT}"
BUILD_TYPE="${DEFAULT_BUILD_TYPE}"
EXPORT_METHOD="${DEFAULT_EXPORT_METHOD}"
AUTO_INCREMENT_VERSION="${AUTO_INCREMENT_VERSION}"
UPLOAD_TO_STORE=false
VALIDATE_ONLY=false
CLEAN_BUILD="${CLEAN_BUILD_DEFAULT}"
VERBOSE=false

# iOS Authentication variables (initialized from config, can be overridden by CLI)
APPLE_ID="${IOS_APPLE_ID}"
APP_SPECIFIC_PASSWORD="${IOS_APP_SPECIFIC_PASSWORD}"
API_KEY_PATH="${IOS_API_KEY_PATH}"
API_KEY_ID="${IOS_API_KEY_ID}"
API_ISSUER_ID="${IOS_API_ISSUER_ID}"

# Android Authentication variables (initialized from config, can be overridden by CLI)
GOOGLE_SERVICE_ACCOUNT_KEY="${ANDROID_SERVICE_ACCOUNT_KEY}"
GOOGLE_PACKAGE_NAME="${ANDROID_PACKAGE_NAME}"
GOOGLE_TRACK="${ANDROID_TRACK}"

print_header() {
    echo -e "${PURPLE}======================================${NC}"
    echo -e "${PURPLE}  ${APP_NAME} Cross-Platform Deploy  ${NC}"
    echo -e "${PURPLE}======================================${NC}"
    echo ""
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_platform() {
    local platform=$1
    case $platform in
        ios)
            echo -e "${CYAN}[iOS]${NC} $2"
            ;;
        android)
            echo -e "${YELLOW}[ANDROID]${NC} $2"
            ;;
        *)
            echo -e "${BLUE}[GENERAL]${NC} $2"
            ;;
    esac
}

show_help() {
    echo "${APP_NAME} Cross-Platform Build and Deploy Script"
    echo ""
    echo "This script builds Flutter apps for iOS and/or Android and optionally uploads them to their respective app stores."
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Platform Options:"
    echo "  -p, --platform      Target platform (ios, android, both) [default: both]"
    echo ""
    echo "Build Options:"
    echo "  -e, --environment   Build environment (dev, staging, production) [default: production]"
    echo "  -t, --type         Build type (build, archive, test) [default: archive]"
    echo "  -m, --method       Export method for iOS (app-store, testflight, development) [default: app-store]"
    echo "  -c, --clean        Clean before building"
    echo ""
    echo "Upload Options:"
    echo "  -u, --upload       Upload to app stores (requires archive)"
    echo "  --validate-only    Only validate the app, don't upload"
    echo "  --no-version-bump  Skip automatic version increment"
    echo ""
    echo "iOS Authentication (choose one method):"
    echo "  Method 1 - API Key (recommended):"
    echo "    --api-key        Path to App Store Connect API key (.p8 file)"
    echo "    --api-key-id     App Store Connect API Key ID"
    echo "    --api-issuer-id  App Store Connect API Issuer ID"
    echo ""
    echo "  Method 2 - Apple ID:"
    echo "    --apple-id       Your Apple ID email"
    echo "    --password       App-specific password"
    echo ""
    echo "Android Authentication:"
    echo "  --service-account  Path to Google Play Console service account JSON key"
    echo "  --package-name     Android package name (defaults to bundle ID)"
    echo "  --track           Release track (internal, alpha, beta, production) [default: internal]"
    echo ""
    echo "Other Options:"
    echo "  --verbose         Enable verbose output"
    echo "  -h, --help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  # Build for both platforms (production)"
    echo "  $0 --platform both --environment production --type archive"
    echo ""
    echo "  # Build and upload iOS only"
    echo "  $0 -p ios -e production -t archive --upload --api-key ~/.appstoreconnect/AuthKey.p8 --api-key-id KEYID --api-issuer-id ISSUERID"
    echo ""
    echo "  # Build and upload Android only"
    echo "  $0 -p android -e production -t archive --upload --service-account ~/.playstore/service-account.json"
    echo ""
    echo "  # Build and upload both platforms"
    echo "  $0 -p both -e production -t archive --upload --api-key ~/.appstoreconnect/AuthKey.p8 --api-key-id KEYID --api-issuer-id ISSUERID --service-account ~/.playstore/service-account.json"
    echo ""
    echo "  # Validate only (dry run)"
    echo "  $0 -p both -e production -t archive --validate-only --api-key ~/.appstoreconnect/AuthKey.p8 --api-key-id KEYID --api-issuer-id ISSUERID --service-account ~/.playstore/service-account.json"
    echo ""
    echo "  # Clean build for staging"
    echo "  $0 -p both -e staging -t archive --clean"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--platform)
            PLATFORM="$2"
            shift 2
            ;;
        -e|--environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -t|--type)
            BUILD_TYPE="$2"
            shift 2
            ;;
        -m|--method)
            EXPORT_METHOD="$2"
            shift 2
            ;;
        -c|--clean)
            CLEAN_BUILD=true
            shift
            ;;
        -u|--upload)
            UPLOAD_TO_STORE=true
            shift
            ;;
        --validate-only)
            VALIDATE_ONLY=true
            UPLOAD_TO_STORE=true
            shift
            ;;
        --no-version-bump)
            AUTO_INCREMENT_VERSION=false
            shift
            ;;
        --apple-id)
            APPLE_ID="$2"
            shift 2
            ;;
        --password)
            APP_SPECIFIC_PASSWORD="$2"
            shift 2
            ;;
        --api-key)
            API_KEY_PATH="$2"
            shift 2
            ;;
        --api-key-id)
            API_KEY_ID="$2"
            shift 2
            ;;
        --api-issuer-id)
            API_ISSUER_ID="$2"
            shift 2
            ;;
        --service-account)
            GOOGLE_SERVICE_ACCOUNT_KEY="$2"
            shift 2
            ;;
        --package-name)
            GOOGLE_PACKAGE_NAME="$2"
            shift 2
            ;;
        --track)
            GOOGLE_TRACK="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate platform
case $PLATFORM in
    ios|android|both)
        ;;
    *)
        print_error "Invalid platform: $PLATFORM"
        print_info "Valid platforms: ios, android, both"
        exit 1
        ;;
esac

# Validate environment
case $ENVIRONMENT in
    dev|development)
        CONFIGURATION="Debug"
        BUNDLE_ID_SUFFIX=".dev"
        ;;
    staging)
        CONFIGURATION="Release"
        BUNDLE_ID_SUFFIX=".staging"
        ;;
    production|prod)
        CONFIGURATION="Release"
        BUNDLE_ID_SUFFIX=""
        ;;
    *)
        print_error "Invalid environment: $ENVIRONMENT"
        print_info "Valid environments: dev, staging, production"
        exit 1
        ;;
esac

# Set identifiers for environment using helper function from config
FULL_BUNDLE_ID=$(get_bundle_id "$ENVIRONMENT")
if [ -z "$GOOGLE_PACKAGE_NAME" ]; then
    GOOGLE_PACKAGE_NAME="$FULL_BUNDLE_ID"
fi

get_current_version() {
    if [ ! -f "$PUBSPEC_PATH" ]; then
        print_error "pubspec.yaml not found at: $PUBSPEC_PATH"
        exit 1
    fi

    # Extract version line from pubspec.yaml
    local version_line=$(grep "^version:" "$PUBSPEC_PATH")
    if [ -z "$version_line" ]; then
        print_error "Version not found in pubspec.yaml"
        exit 1
    fi

    # Extract version (format: version: 1.0.0+1)
    echo "$version_line" | sed 's/version: //'
}

increment_version() {
    local current_version=$(get_current_version)
    print_info "Current version: $current_version"

    # Split version into semantic version and build number
    local sem_version=$(echo "$current_version" | cut -d'+' -f1)
    local build_number=$(echo "$current_version" | cut -d'+' -f2)

    # Split semantic version into major.minor.patch
    local major=$(echo "$sem_version" | cut -d'.' -f1)
    local minor=$(echo "$sem_version" | cut -d'.' -f2)
    local patch=$(echo "$sem_version" | cut -d'.' -f3)

    # Increment patch version with rollover logic
    local new_patch=$((patch + 1))
    local new_minor=$minor
    local new_major=$major

    # Handle patch rollover (99 -> 0, increment minor)
    if [ $new_patch -gt 99 ]; then
        new_patch=0
        new_minor=$((minor + 1))

        # Handle minor rollover (9 -> 0, increment major)
        if [ $new_minor -gt 9 ]; then
            new_minor=0
            new_major=$((major + 1))
        fi
    fi

    local new_sem_version="${new_major}.${new_minor}.${new_patch}"

    # Increment build number
    local new_build_number=$((build_number + 1))
    local new_version="${new_sem_version}+${new_build_number}"

    print_info "New version: $new_version"

    # Create backup
    cp "$PUBSPEC_PATH" "${PUBSPEC_PATH}.backup"
    print_info "Created backup: ${PUBSPEC_PATH}.backup"

    # Update pubspec.yaml
    if sed -i '' "s/^version: $current_version/version: $new_version/" "$PUBSPEC_PATH"; then
        print_success "Successfully updated version in pubspec.yaml"

        # Verify the change
        local updated_version=$(get_current_version)
        if [ "$updated_version" = "$new_version" ]; then
            print_success "Version update verified: $updated_version"
        else
            print_error "Version update verification failed!"
            print_info "Restoring backup..."
            mv "${PUBSPEC_PATH}.backup" "$PUBSPEC_PATH"
            exit 1
        fi
    else
        print_error "Failed to update pubspec.yaml"
        print_info "Restoring backup..."
        mv "${PUBSPEC_PATH}.backup" "$PUBSPEC_PATH"
        exit 1
    fi

    # Clean up backup on success
    rm -f "${PUBSPEC_PATH}.backup"
}

validate_upload_auth() {
    if [ "$UPLOAD_TO_STORE" = false ]; then
        return 0
    fi

    local ios_auth_valid=false
    local android_auth_valid=false

    # Check iOS authentication if building for iOS
    if [ "$PLATFORM" = "ios" ] || [ "$PLATFORM" = "both" ]; then
        if [ -n "$API_KEY_PATH" ] && [ -n "$API_KEY_ID" ] && [ -n "$API_ISSUER_ID" ]; then
            if [ ! -f "$API_KEY_PATH" ]; then
                print_error "iOS API key file not found: $API_KEY_PATH"
                exit 1
            fi
            ios_auth_valid=true
        elif [ -n "$APPLE_ID" ] && [ -n "$APP_SPECIFIC_PASSWORD" ]; then
            ios_auth_valid=true
        else
            print_error "iOS upload requested but no authentication method provided."
            print_info "Please provide either:"
            print_info "  1. API key: --api-key, --api-key-id, --api-issuer-id"
            print_info "  2. Apple ID: --apple-id, --password"
            show_setup_instructions
            exit 1
        fi
    else
        ios_auth_valid=true  # Not building iOS, so auth not required
    fi

    # Check Android authentication if building for Android
    if [ "$PLATFORM" = "android" ] || [ "$PLATFORM" = "both" ]; then
        if [ -n "$GOOGLE_SERVICE_ACCOUNT_KEY" ]; then
            if [ ! -f "$GOOGLE_SERVICE_ACCOUNT_KEY" ]; then
                print_error "Android service account key file not found: $GOOGLE_SERVICE_ACCOUNT_KEY"
                exit 1
            fi
            android_auth_valid=true
        else
            print_error "Android upload requested but no service account key provided."
            print_info "Please provide: --service-account path/to/service-account.json"
            show_setup_instructions
            exit 1
        fi
    else
        android_auth_valid=true  # Not building Android, so auth not required
    fi

    if [ "$ios_auth_valid" = true ] && [ "$android_auth_valid" = true ]; then
        return 0
    else
        exit 1
    fi
}

show_setup_instructions() {
    echo ""
    print_info "📝 Setup Instructions:"
    echo ""

    if [ "$PLATFORM" = "ios" ] || [ "$PLATFORM" = "both" ]; then
        echo "🍎 iOS - App Store Connect Setup:"
        echo ""
        echo "🔑 To create an App Store Connect API key:"
        echo "  1. Go to App Store Connect > Users and Access > Keys"
        echo "  2. Click '+' to create a new key"
        echo "  3. Give it a name (e.g., '${APP_NAME} Upload Key')"
        echo "  4. Select 'Developer' role (or 'Admin' for full access)"
        echo "  5. Click 'Generate'"
        echo "  6. Download the .p8 key file immediately (you can't download it again)"
        echo "  7. Note the Key ID and Issuer ID shown on the page"
        echo ""

        echo "🔐 To create an app-specific password:"
        echo "  1. Go to appleid.apple.com"
        echo "  2. Sign in with your Apple ID"
        echo "  3. Go to 'Sign-In and Security' > 'App-Specific Passwords'"
        echo "  4. Click '+' to generate a new password"
        echo "  5. Give it a label (e.g., '${APP_NAME} iOS Upload')"
        echo "  6. Copy the generated password (format: abcd-efgh-ijkl-mnop)"
        echo ""
    fi

    if [ "$PLATFORM" = "android" ] || [ "$PLATFORM" = "both" ]; then
        echo "🤖 Android - Google Play Console Setup:"
        echo ""
        echo "🔑 To create a Google Play Console service account:"
        echo "  1. Go to Google Cloud Console (console.cloud.google.com)"
        echo "  2. Select your project or create a new one"
        echo "  3. Go to IAM & Admin > Service Accounts"
        echo "  4. Click 'Create Service Account'"
        echo "  5. Give it a name (e.g., '${APP_NAME} Upload Service')"
        echo "  6. Click 'Create and Continue'"
        echo "  7. Skip role assignment for now, click 'Done'"
        echo "  8. Click on the created service account"
        echo "  9. Go to 'Keys' tab, click 'Add Key' > 'Create new key'"
        echo "  10. Choose 'JSON' format and download the key file"
        echo ""
        echo "  11. Go to Google Play Console (play.google.com/console)"
        echo "  12. Go to Setup > API access"
        echo "  13. Link the Google Cloud project if not already linked"
        echo "  14. Under 'Service accounts', grant access to your service account"
        echo "  15. Choose appropriate permissions (Admin or Release Manager)"
        echo ""
    fi
}

check_requirements() {
    # Check if we're in the right directory
    if [ ! -f "pubspec.yaml" ]; then
        print_error "This script must be run from the Flutter project root directory"
        exit 1
    fi

    # Check Flutter
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter not found. Please install Flutter and add it to your PATH."
        exit 1
    fi

    # Check iOS requirements
    if [ "$PLATFORM" = "ios" ] || [ "$PLATFORM" = "both" ]; then
        if [ "$UPLOAD_TO_STORE" = true ]; then
            if ! command -v xcrun &> /dev/null; then
                print_error "xcrun not found. This script requires Xcode Command Line Tools for iOS."
                print_info "Install with: xcode-select --install"
                exit 1
            fi

            # Check altool specifically
            if ! xcrun altool --help &> /dev/null; then
                print_error "altool not found or not working properly."
                print_info "Make sure Xcode Command Line Tools are properly installed."
                exit 1
            fi
        fi
    fi

    # Check Android requirements
    if [ "$PLATFORM" = "android" ] || [ "$PLATFORM" = "both" ]; then
        if [ "$UPLOAD_TO_STORE" = true ]; then
            # Check if fastlane is available for Google Play upload
            if ! command -v fastlane &> /dev/null; then
                print_warning "fastlane not found. Installing via bundler..."
                if ! command -v bundle &> /dev/null; then
                    print_error "bundler not found. Please install Ruby and bundler first."
                    print_info "Install with: gem install bundler"
                    exit 1
                fi
            fi
        fi
    fi
}

upload_ios_app() {
    local ios_output_dir="$IOS_OUTPUT_DIR"
    local ipa_file=$(find "$ios_output_dir" -name "*.ipa" | head -1)

    if [ ! -f "$ipa_file" ]; then
        print_error "IPA file not found in $ios_output_dir"
        return 1
    fi

    local action="upload-app"
    if [ "$VALIDATE_ONLY" = true ]; then
        action="validate-app"
        print_platform "ios" "🔍 Validating app package (dry run)..."
    else
        print_platform "ios" "📤 Uploading app to App Store Connect..."
    fi

    local cmd_args=""
    local verbose_flag=""

    if [ "$VERBOSE" = true ]; then
        verbose_flag="--verbose"
    fi

    if [ -n "$API_KEY_PATH" ] && [ -n "$API_KEY_ID" ] && [ -n "$API_ISSUER_ID" ]; then
        print_platform "ios" "Using App Store Connect API key authentication"
        print_platform "ios" "Key ID: $API_KEY_ID"
        print_platform "ios" "Issuer ID: $API_ISSUER_ID"

        # altool expects the key file to be named AuthKey_{KEY_ID}.p8 in specific directories
        # Copy the key to ~/.appstoreconnect/private_keys/ with the correct name
        local expected_key_name="AuthKey_${API_KEY_ID}.p8"
        local expected_key_dir="$HOME/.appstoreconnect/private_keys"
        local expected_key_path="$expected_key_dir/$expected_key_name"

        # Expand tilde in API_KEY_PATH
        local expanded_api_key_path="${API_KEY_PATH/#\~/$HOME}"

        # Create directory if it doesn't exist
        mkdir -p "$expected_key_dir"

        # Copy the key file to the expected location with the correct name
        if [ ! -f "$expected_key_path" ] || [ "$expanded_api_key_path" -nt "$expected_key_path" ]; then
            print_platform "ios" "Copying API key to expected location: $expected_key_path"
            cp "$expanded_api_key_path" "$expected_key_path"
            chmod 600 "$expected_key_path"  # Secure the key file
        fi

        cmd_args="--apiKey $API_KEY_ID --apiIssuer $API_ISSUER_ID"

    elif [ -n "$APPLE_ID" ] && [ -n "$APP_SPECIFIC_PASSWORD" ]; then
        print_platform "ios" "Using Apple ID authentication"
        print_platform "ios" "Apple ID: $APPLE_ID"

        cmd_args="--username $APPLE_ID --password $APP_SPECIFIC_PASSWORD"
    fi

    print_platform "ios" "IPA File: $ipa_file"
    print_platform "ios" "File Size: $(ls -lh "$ipa_file" | awk '{print $5}')"

    # Execute the upload command
    if xcrun altool --$action \
        --type ios \
        --file "$ipa_file" \
        $cmd_args \
        $verbose_flag; then

        if [ "$VALIDATE_ONLY" = true ]; then
            print_success "✅ iOS app validation completed successfully!"
        else
            print_success "✅ iOS app uploaded successfully to App Store Connect!"
        fi
        return 0
    else
        print_error "❌ iOS upload failed!"
        return 1
    fi
}

upload_android_app() {
    local android_output_dir="build/app/outputs/bundle/release"
    local aab_file=$(find "$android_output_dir" -name "*.aab" | head -1)

    if [ ! -f "$aab_file" ]; then
        print_error "AAB file not found in $android_output_dir"
        return 1
    fi

    if [ "$VALIDATE_ONLY" = true ]; then
        print_platform "android" "🔍 Validating app package (dry run)..."
        print_success "✅ Android app validation completed successfully!"
        return 0
    else
        print_platform "android" "📤 Uploading app to Google Play Console..."
    fi

    # Create a temporary fastlane setup for upload
    local temp_fastlane_dir="$(mktemp -d)"
    local fastfile="$temp_fastlane_dir/Fastfile"

    cat > "$fastfile" << EOF
default_platform(:android)

platform :android do
  desc "Upload to Google Play Console"
  lane :upload do
    upload_to_play_store(
      package_name: ENV['PACKAGE_NAME'],
      json_key: ENV['SERVICE_ACCOUNT_KEY'],
      aab: ENV['AAB_FILE'],
      track: ENV['TRACK'],
      skip_upload_metadata: true,
      skip_upload_images: true,
      skip_upload_screenshots: true
    )
  end
end
EOF

    # Set environment variables for fastlane
    export PACKAGE_NAME="$GOOGLE_PACKAGE_NAME"
    export SERVICE_ACCOUNT_KEY="$GOOGLE_SERVICE_ACCOUNT_KEY"
    export AAB_FILE="$aab_file"
    export TRACK="$GOOGLE_TRACK"

    print_platform "android" "Package Name: $GOOGLE_PACKAGE_NAME"
    print_platform "android" "AAB File: $aab_file"
    print_platform "android" "File Size: $(ls -lh "$aab_file" | awk '{print $5}')"
    print_platform "android" "Track: $GOOGLE_TRACK"

    # Execute the upload
    if (cd "$temp_fastlane_dir" && fastlane android upload); then
        print_success "✅ Android app uploaded successfully to Google Play Console!"
        rm -rf "$temp_fastlane_dir"
        return 0
    else
        print_error "❌ Android upload failed!"
        rm -rf "$temp_fastlane_dir"
        return 1
    fi
}

build_ios() {
    print_platform "ios" "🔨 Starting iOS build..."

    # Set output directory
    local ios_output_dir="$IOS_OUTPUT_DIR"
    mkdir -p "$ios_output_dir"

    # Clean if requested
    if [ "$CLEAN_BUILD" = true ]; then
        print_platform "ios" "🧹 Cleaning previous iOS builds..."
        rm -rf "$ios_output_dir"
        mkdir -p "$ios_output_dir"
        cd ios
        xcodebuild clean -workspace $WORKSPACE -scheme $SCHEME
        cd ..
    fi

    # Flutter build
    print_platform "ios" "🔨 Running Flutter build for iOS..."
    case $BUILD_TYPE in
        build)
            if [ "$CONFIGURATION" = "Debug" ]; then
                flutter build ios --debug --no-codesign
            else
                flutter build ios --release --no-codesign
            fi
            ;;
        archive|test)
            flutter build ios --release
            ;;
        *)
            print_error "Invalid build type: $BUILD_TYPE"
            return 1
            ;;
    esac

    # Xcode build
    cd ios

    case $BUILD_TYPE in
        build)
            print_platform "ios" "🏗️  Building iOS app..."
            xcodebuild build \
                -workspace $WORKSPACE \
                -scheme $SCHEME \
                -configuration $CONFIGURATION \
                -destination 'generic/platform=iOS'
            ;;

        archive)
            print_platform "ios" "📦 Creating iOS archive..."
            local archive_path="../$ios_output_dir/${APP_NAME}_${ENVIRONMENT}_$(date +%Y%m%d_%H%M%S).xcarchive"

            xcodebuild archive \
                -workspace $WORKSPACE \
                -scheme $SCHEME \
                -configuration $CONFIGURATION \
                -archivePath "$archive_path" \
                -destination 'generic/platform=iOS'

            print_success "iOS Archive created: $archive_path"

            # Export IPA
            print_platform "ios" "📱 Exporting IPA..."

            # Create export options plist
            local export_plist="../$ios_output_dir/ExportOptions.plist"
            local actual_method
            case $EXPORT_METHOD in
                testflight|app-store)
                    actual_method="app-store-connect"
                    ;;
                development)
                    actual_method="development"
                    ;;
                *)
                    actual_method="$EXPORT_METHOD"
                    ;;
            esac

            cat > "$export_plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>$actual_method</string>
    <key>teamID</key>
    <string>$TEAM_ID</string>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>compileBitcode</key>
    <false/>
</dict>
</plist>
EOF

            xcodebuild -exportArchive \
                -archivePath "$archive_path" \
                -exportPath "../$ios_output_dir" \
                -exportOptionsPlist "$export_plist"

            print_success "iOS IPA exported to: $ios_output_dir"
            ;;

        test)
            print_platform "ios" "🧪 Running iOS tests..."
            xcodebuild test \
                -workspace $WORKSPACE \
                -scheme $SCHEME \
                -configuration $CONFIGURATION \
                -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest'
            ;;
    esac

    cd ..

    # Upload if requested
    if [ "$UPLOAD_TO_STORE" = true ] && [ "$BUILD_TYPE" = "archive" ]; then
        upload_ios_app
    fi

    print_success "🎉 iOS build completed successfully!"
}

build_android() {
    print_platform "android" "🔨 Starting Android build..."

    # Set output directory
    local android_output_dir="$ANDROID_OUTPUT_DIR"

    # Clean if requested
    if [ "$CLEAN_BUILD" = true ]; then
        print_platform "android" "🧹 Cleaning previous Android builds..."
        rm -rf "$android_output_dir"
        cd android
        ./gradlew clean
        cd ..
    fi

    # Flutter build
    print_platform "android" "🔨 Running Flutter build for Android..."
    case $BUILD_TYPE in
        build)
            if [ "$CONFIGURATION" = "Debug" ]; then
                flutter build apk --debug
            else
                flutter build apk --release
            fi
            ;;
        archive)
            # Build AAB for Play Store
            flutter build appbundle --release
            ;;
        test)
            flutter build apk --debug
            ;;
        *)
            print_error "Invalid build type: $BUILD_TYPE"
            return 1
            ;;
    esac

    case $BUILD_TYPE in
        build)
            print_platform "android" "🏗️  Android APK build completed"
            if [ "$CONFIGURATION" = "Debug" ]; then
                print_success "Debug APK: build/app/outputs/flutter-apk/app-debug.apk"
            else
                print_success "Release APK: build/app/outputs/flutter-apk/app-release.apk"
            fi
            ;;

        archive)
            print_platform "android" "📦 Android App Bundle build completed"
            print_success "AAB: build/app/outputs/bundle/release/app-release.aab"

            # Upload if requested
            if [ "$UPLOAD_TO_STORE" = true ]; then
                upload_android_app
            fi
            ;;

        test)
            print_platform "android" "🧪 Running Android tests..."
            cd android
            ./gradlew test
            cd ..
            ;;
    esac

    print_success "🎉 Android build completed successfully!"
}

# Main execution
main() {
    print_header

    print_info "This script builds Flutter apps for iOS and/or Android and optionally uploads them to their respective app stores."
    echo ""

    check_requirements
    validate_upload_auth

    print_info "📋 Build Configuration:"
    print_info "  App: $APP_NAME"
    print_info "  Platform(s): $PLATFORM"
    print_info "  Bundle ID: $FULL_BUNDLE_ID"
    if [ "$PLATFORM" = "android" ] || [ "$PLATFORM" = "both" ]; then
        print_info "  Package Name: $GOOGLE_PACKAGE_NAME"
    fi
    print_info "  Environment: $ENVIRONMENT"
    print_info "  Configuration: $CONFIGURATION"
    print_info "  Build Type: $BUILD_TYPE"
    if [ "$UPLOAD_TO_STORE" = true ]; then
        if [ "$VALIDATE_ONLY" = true ]; then
            print_info "  Mode: Build + Validate (dry run)"
        else
            print_info "  Mode: Build + Upload to app stores"
        fi
    else
        print_info "  Mode: Build only"
    fi
    echo ""

    # Handle version increment
    if [ "$AUTO_INCREMENT_VERSION" = true ] && [ "$BUILD_TYPE" = "archive" ] && [ "$VALIDATE_ONLY" = false ]; then
        print_info "🔢 Incrementing version number..."
        increment_version
        echo ""
    elif [ "$AUTO_INCREMENT_VERSION" = true ] && [ "$VALIDATE_ONLY" = true ]; then
        print_info "🔢 Version increment skipped (validation mode)"
        local current_version=$(get_current_version)
        print_info "Current version: $current_version"
        echo ""
    fi

    # General Flutter clean if requested
    if [ "$CLEAN_BUILD" = true ]; then
        print_info "🧹 Running Flutter clean..."
        flutter clean
        echo ""
    fi

    # Build for requested platforms
    local ios_success=true
    local android_success=true

    if [ "$PLATFORM" = "ios" ] || [ "$PLATFORM" = "both" ]; then
        if ! build_ios; then
            ios_success=false
        fi
        echo ""
    fi

    if [ "$PLATFORM" = "android" ] || [ "$PLATFORM" = "both" ]; then
        if ! build_android; then
            android_success=false
        fi
        echo ""
    fi

    # Final status
    if [ "$ios_success" = true ] && [ "$android_success" = true ]; then
        print_success "🎉 All builds completed successfully!"
    else
        print_error "❌ Some builds failed!"
        if [ "$ios_success" = false ]; then
            print_error "  - iOS build failed"
        fi
        if [ "$android_success" = false ]; then
            print_error "  - Android build failed"
        fi
        exit 1
    fi

    # Show next steps
    if [ "$ENVIRONMENT" = "production" ] && [ "$BUILD_TYPE" = "archive" ] && [ "$UPLOAD_TO_STORE" = false ]; then
        echo ""
        print_info "📱 Next Steps:"

        if [ "$PLATFORM" = "ios" ] || [ "$PLATFORM" = "both" ]; then
            echo ""
            print_info "🍎 iOS - App Store Connect:"
            echo "  1. Open App Store Connect (${APP_STORE_URL:-https://appstoreconnect.apple.com})"
            echo "  2. Navigate to 'My Apps' > '$APP_NAME'"
            echo "  3. Upload your IPA file manually or re-run with --upload"
        fi

        if [ "$PLATFORM" = "android" ] || [ "$PLATFORM" = "both" ]; then
            echo ""
            print_info "🤖 Android - Google Play Console:"
            echo "  1. Open Google Play Console (${PLAY_STORE_URL:-https://play.google.com/console})"
            echo "  2. Navigate to your app"
            echo "  3. Upload your AAB file manually or re-run with --upload"
        fi
    fi
}

# Run main function if script is executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi