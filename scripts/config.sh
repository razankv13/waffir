#!/bin/bash

# =============================================================================
# Project Configuration File
# =============================================================================
# This is the central configuration file for all build and deployment scripts.
# Update these values when setting up a new project or changing project details.
#
# IMPORTANT: Keep this file outside of version control if it contains sensitive
# information like API keys. Consider using environment variables for secrets.
# =============================================================================

# -----------------------------------------------------------------------------
# App Information
# -----------------------------------------------------------------------------
# These are the core identifiers for your application

export APP_NAME="FlutterTemplate"                    # App display name
export BUNDLE_ID="com.yourcompany.fluttertemplate"   # Base bundle identifier (without environment suffix)
export PACKAGE_NAME="$BUNDLE_ID"                     # Android package name (usually same as bundle ID)

# App Store metadata
export APP_DESCRIPTION="A production-ready Flutter template with clean architecture"
export APP_CATEGORY="Developer Tools"                 # Primary category
export APP_SUBCATEGORY="Utilities"                   # Secondary category
export APP_KEYWORDS="flutter,template,starter,app"   # Comma-separated keywords (max 100 chars)

# Copyright and versioning
export APP_COPYRIGHT_YEAR="2024"
export APP_COPYRIGHT_HOLDER="Your Company Name"
export APP_SKU="${APP_NAME}_001"                     # Unique SKU for App Store Connect

# -----------------------------------------------------------------------------
# Development Team Information
# -----------------------------------------------------------------------------
# Apple Developer account details

export APPLE_TEAM_ID="YOUR_TEAM_ID"                  # Find at: developer.apple.com/account > Membership
export APPLE_TEAM_NAME="Your Team Name"

# -----------------------------------------------------------------------------
# Project Paths
# -----------------------------------------------------------------------------
# File system paths for the project

export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"  # Auto-detect project root
export PUBSPEC_PATH="$PROJECT_ROOT/pubspec.yaml"

# Xcode project settings (for iOS)
export IOS_SCHEME="Runner"
export IOS_WORKSPACE="Runner.xcworkspace"

# -----------------------------------------------------------------------------
# Environment-Specific Bundle IDs
# -----------------------------------------------------------------------------
# Bundle ID suffixes for different environments

export BUNDLE_ID_DEV=".dev"           # Development: com.yourcompany.app.dev
export BUNDLE_ID_STAGING=".staging"   # Staging: com.yourcompany.app.staging
export BUNDLE_ID_PROD=""              # Production: com.yourcompany.app

# -----------------------------------------------------------------------------
# iOS Authentication (App Store Connect)
# -----------------------------------------------------------------------------
# Configure ONE of the two methods below for App Store uploads

# Method 1: API Key (Recommended)
# Get these from: appstoreconnect.apple.com > Users and Access > Keys
export IOS_API_KEY_PATH="$HOME/.appstoreconnect/private_keys/AuthKey_XXXXXXXXXX.p8"
export IOS_API_KEY_ID="XXXXXXXXXX"                                    # Your API Key ID
export IOS_API_ISSUER_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"      # Your Issuer ID

# Method 2: Apple ID (Alternative)
# Get app-specific password from: appleid.apple.com > Sign-In and Security > App-Specific Passwords
export IOS_APPLE_ID="your@email.com"                                 # Your Apple ID
export IOS_APP_SPECIFIC_PASSWORD="xxxx-xxxx-xxxx-xxxx"              # App-specific password

# -----------------------------------------------------------------------------
# Android Authentication (Google Play Console)
# -----------------------------------------------------------------------------
# Service account configuration for Google Play uploads

export ANDROID_SERVICE_ACCOUNT_KEY="$HOME/.playstore/service-account.json"
export ANDROID_PACKAGE_NAME="$PACKAGE_NAME"  # Can override if different from bundle ID
export ANDROID_TRACK="internal"              # Default track: internal, alpha, beta, production

# -----------------------------------------------------------------------------
# Build Configuration
# -----------------------------------------------------------------------------
# Default build settings

export DEFAULT_PLATFORM="both"            # Default platform: ios, android, both
export DEFAULT_ENVIRONMENT="production"   # Default environment: dev, staging, production
export DEFAULT_BUILD_TYPE="archive"       # Default type: build, archive, test
export DEFAULT_EXPORT_METHOD="app-store"  # iOS export: app-store, testflight, development

# Build behavior
export AUTO_INCREMENT_VERSION=true        # Automatically increment version on archive
export CLEAN_BUILD_DEFAULT=false          # Clean before building by default

# -----------------------------------------------------------------------------
# Output Directories
# -----------------------------------------------------------------------------
# Where build artifacts are stored

export IOS_OUTPUT_DIR="build/ios"
export ANDROID_OUTPUT_DIR="build/app/outputs"

# -----------------------------------------------------------------------------
# URLs and Links
# -----------------------------------------------------------------------------
# App Store and support links

export APP_PRIVACY_POLICY_URL="https://yourcompany.com/privacy"
export APP_SUPPORT_URL="https://yourcompany.com/support"
export APP_MARKETING_URL="https://yourcompany.com"

# -----------------------------------------------------------------------------
# Store Links
# -----------------------------------------------------------------------------
# Direct links to store pages (fill after app is published)

export APP_STORE_URL="https://apps.apple.com/app/idXXXXXXXXXX"
export PLAY_STORE_URL="https://play.google.com/store/apps/details?id=$PACKAGE_NAME"

# -----------------------------------------------------------------------------
# CI/CD Configuration
# -----------------------------------------------------------------------------
# Settings for continuous integration/deployment

export ENABLE_CI_MODE=false              # Disable interactive prompts in CI
export CI_SLACK_WEBHOOK=""               # Slack webhook for notifications
export CI_EMAIL_NOTIFICATIONS=""         # Email for build notifications

# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

# Get the full bundle ID for a given environment
get_bundle_id() {
    local env=$1
    case $env in
        dev|development)
            echo "${BUNDLE_ID}${BUNDLE_ID_DEV}"
            ;;
        staging)
            echo "${BUNDLE_ID}${BUNDLE_ID_STAGING}"
            ;;
        production|prod)
            echo "${BUNDLE_ID}${BUNDLE_ID_PROD}"
            ;;
        *)
            echo "$BUNDLE_ID"
            ;;
    esac
}

# Get the configuration name for environment
get_configuration() {
    local env=$1
    case $env in
        dev|development)
            echo "Debug"
            ;;
        staging|production|prod)
            echo "Release"
            ;;
        *)
            echo "Release"
            ;;
    esac
}

# Validate configuration
validate_config() {
    local errors=0

    if [ "$APP_NAME" = "FlutterTemplate" ]; then
        echo "⚠️  Warning: APP_NAME is still set to default 'FlutterTemplate'"
        errors=$((errors + 1))
    fi

    if [ "$BUNDLE_ID" = "com.yourcompany.fluttertemplate" ]; then
        echo "⚠️  Warning: BUNDLE_ID is still set to default"
        errors=$((errors + 1))
    fi

    if [ "$APPLE_TEAM_ID" = "YOUR_TEAM_ID" ]; then
        echo "⚠️  Warning: APPLE_TEAM_ID is not configured"
        errors=$((errors + 1))
    fi

    if [ $errors -gt 0 ]; then
        echo ""
        echo "Please update scripts/config.sh with your project-specific values"
        return 1
    fi

    return 0
}

# Print configuration summary
print_config_summary() {
    echo "📋 Project Configuration:"
    echo "  App Name: $APP_NAME"
    echo "  Bundle ID: $BUNDLE_ID"
    echo "  Team ID: $APPLE_TEAM_ID"
    echo ""
}

# Export functions so they can be used in other scripts
export -f get_bundle_id
export -f get_configuration
export -f validate_config
export -f print_config_summary

# -----------------------------------------------------------------------------
# Configuration Validation
# -----------------------------------------------------------------------------
# Automatically validate when sourced (can be disabled by setting SKIP_CONFIG_VALIDATION=true)

if [ "${SKIP_CONFIG_VALIDATION:-false}" = "false" ] && [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    # Only validate if being sourced, not executed directly
    if ! validate_config 2>/dev/null; then
        # Validation failed but don't exit, just warn
        :
    fi
fi
