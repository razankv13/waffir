#!/bin/bash

# App Store Connect Setup Script
# This script provides step-by-step instructions for creating an app in App Store Connect

set -e

# Load project configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKIP_CONFIG_VALIDATION=true source "$SCRIPT_DIR/config.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Use configuration from config.sh
CATEGORY="$APP_CATEGORY"
SUBCATEGORY="$APP_SUBCATEGORY"
KEYWORDS="$APP_KEYWORDS"

print_header() {
    echo -e "${PURPLE}================================${NC}"
    echo -e "${PURPLE}  ${APP_NAME} App Store Setup   ${NC}"
    echo -e "${PURPLE}================================${NC}"
    echo ""
}

print_section() {
    echo -e "${BLUE}📋 $1${NC}"
    echo "----------------------------------------"
}

print_step() {
    echo -e "${GREEN}✅ Step $1:${NC} $2"
}

print_info() {
    echo -e "${YELLOW}💡 Info:${NC} $1"
}

print_warning() {
    echo -e "${RED}⚠️  Warning:${NC} $1"
}

print_value() {
    echo -e "   ${PURPLE}$1:${NC} $2"
}

show_prerequisites() {
    print_section "Prerequisites"

    echo "Before creating your app in App Store Connect, ensure you have:"
    echo ""
    print_step "1" "Apple Developer Account"
    print_info "Visit https://developer.apple.com and enroll in the Apple Developer Program (\$99/year)"

    print_step "2" "Development Team ID"
    print_value "Your Team ID" "$APPLE_TEAM_ID"
    print_info "This should match your Apple Developer Account"

    print_step "3" "App Icons and Screenshots"
    print_info "Prepare app icons (1024x1024) and screenshots for different device sizes"

    print_step "4" "App Store Assets"
    print_info "App description, keywords, privacy policy URL, support URL"

    echo ""
}

show_app_information() {
    print_section "App Information"

    echo "Use the following information when creating your app:"
    echo ""
    print_value "App Name" "$APP_NAME"
    print_value "Bundle ID" "$BUNDLE_ID"
    print_value "Description" "$APP_DESCRIPTION"
    print_value "Primary Category" "$CATEGORY"
    print_value "Secondary Category" "$SUBCATEGORY"
    print_value "Keywords" "$KEYWORDS"
    print_value "Content Rating" "4+ (Low Maturity)"
    print_value "Pricing" "Free"
    echo ""
}

show_app_store_connect_steps() {
    print_section "App Store Connect Setup Steps"

    echo "Follow these steps to create your app:"
    echo ""

    print_step "1" "Access App Store Connect"
    echo "   • Go to https://appstoreconnect.apple.com"
    echo "   • Sign in with your Apple Developer Account"
    echo ""

    print_step "2" "Create New App"
    echo "   • Click 'My Apps'"
    echo "   • Click the '+' button"
    echo "   • Select 'New App'"
    echo ""

    print_step "3" "Fill Basic Information"
    echo "   • Platform: iOS"
    print_value "   Name" "$APP_NAME"
    print_value "   Primary Language" "English (U.S.)"
    print_value "   Bundle ID" "$BUNDLE_ID"
    print_value "   SKU" "$APP_SKU"
    echo "   • User Access: Full Access"
    echo ""

    print_step "4" "App Information Tab"
    echo "   • Set Privacy Policy URL: ${APP_PRIVACY_POLICY_URL}"
    echo "   • Set App Category: ${CATEGORY}"
    echo "   • Set Secondary Category: ${SUBCATEGORY} (optional)"
    echo "   • Content Rights: Check if applicable"
    echo ""

    print_step "5" "Pricing and Availability"
    echo "   • Price Schedule: Free"
    echo "   • Availability: All Countries/Regions"
    echo "   • App Distribution: App Store"
    echo ""

    print_step "6" "Prepare for Submission"
    echo "   • Add App Screenshots (required for all device types)"
    echo "   • App Preview Videos (optional but recommended)"
    print_value "   App Description" "$APP_DESCRIPTION"
    print_value "   Keywords" "$KEYWORDS"
    echo "   • Support URL"
    echo "   • Marketing URL (optional)"
    echo ""

    print_step "7" "Version Information"
    echo "   • Version Number: 1.0.0"
    echo "   • What's New in This Version: Initial release"
    echo "   • Copyright: ${APP_COPYRIGHT_YEAR} ${APP_COPYRIGHT_HOLDER}"
    echo ""

    print_step "8" "Build Selection"
    echo "   • After uploading your build via Xcode or the build script"
    echo "   • Select the build from TestFlight"
    echo "   • Add build to this version"
    echo ""

    print_step "9" "App Review Information"
    echo "   • Contact Information"
    echo "   • Demo Account (if app requires login)"
    echo "   • Notes for Review (optional)"
    echo ""

    print_step "10" "Submit for Review"
    echo "   • Review all information"
    echo "   • Submit for App Store Review"
    echo "   • Wait for Apple's review (typically 1-7 days)"
    echo ""
}

show_testflight_setup() {
    print_section "TestFlight Setup (Beta Testing)"

    echo "To set up TestFlight for beta testing:"
    echo ""

    print_step "1" "Upload Beta Build"
    echo "   • Use the build script: ./scripts/ios_build.sh -e staging -t archive -m testflight"
    echo "   • Or upload via Xcode"
    echo ""

    print_step "2" "TestFlight Settings"
    echo "   • Go to TestFlight tab in App Store Connect"
    echo "   • Select your uploaded build"
    echo "   • Add What to Test notes"
    echo ""

    print_step "3" "Add Internal Testers"
    echo "   • Add team members (up to 100)"
    echo "   • They get immediate access"
    echo ""

    print_step "4" "Add External Testers (Optional)"
    echo "   • Create test groups"
    echo "   • Add external email addresses (up to 10,000)"
    echo "   • Requires Apple review for external testing"
    echo ""

    print_step "5" "Distribute"
    echo "   • Send invitations"
    echo "   • Testers install TestFlight app"
    echo "   • They can install and test your app"
    echo ""
}

show_required_assets() {
    print_section "Required Assets Checklist"

    echo "Prepare these assets before submission:"
    echo ""

    echo "📱 App Icon:"
    echo "   • 1024x1024 pixels (App Store)"
    echo "   • High resolution, no alpha channel"
    echo ""

    echo "📸 Screenshots (Required for each device type):"
    echo "   • iPhone 6.7\": 1290x2796 or 1284x2778"
    echo "   • iPhone 6.5\": 1242x2688 or 1284x2778"
    echo "   • iPhone 5.5\": 1242x2208"
    echo "   • iPad Pro (6th Gen): 2048x2732"
    echo "   • iPad Pro (2nd Gen): 2048x2732"
    echo ""

    echo "📝 Text Content:"
    echo "   • App Name (max 30 characters)"
    echo "   • Subtitle (max 30 characters)"
    print_value "   Description" "Up to 4000 characters"
    print_value "   Keywords" "Max 100 characters, comma-separated"
    echo "   • What's New (max 4000 characters)"
    echo ""

    echo "🔗 URLs:"
    echo "   • Privacy Policy URL (required for many categories)"
    echo "   • Support URL"
    echo "   • Marketing URL (optional)"
    echo ""
}

show_build_commands() {
    print_section "Build and Upload Commands"

    echo "Use these commands to build and prepare your app:"
    echo ""

    echo "🔨 Development Build:"
    echo "   ./scripts/ios_build.sh -e dev -t build"
    echo ""

    echo "🧪 TestFlight Build:"
    echo "   ./scripts/ios_build.sh -e staging -t archive -m testflight"
    echo ""

    echo "🚀 App Store Build:"
    echo "   ./scripts/ios_build.sh -e production -t archive -m app-store"
    echo ""

    echo "📤 With Auto-Upload:"
    echo "   ./scripts/ios_build.sh -e production -t archive -m app-store --upload"
    echo ""

    print_warning "Remember to update YOUR_APPLE_ID and YOUR_APP_SPECIFIC_PASSWORD in the build script for auto-upload"
}

show_next_steps() {
    print_section "Next Steps"

    echo "After setting up App Store Connect:"
    echo ""

    print_step "1" "Test Your Setup"
    echo "   • Run: ./scripts/ios_build.sh -e dev -t build"
    echo "   • Fix any build issues"
    echo ""

    print_step "2" "Create TestFlight Build"
    echo "   • Run: ./scripts/ios_build.sh -e staging -t archive -m testflight"
    echo "   • Upload to App Store Connect"
    echo "   • Test with internal team"
    echo ""

    print_step "3" "Prepare App Store Assets"
    echo "   • Create app screenshots"
    echo "   • Write app description"
    echo "   • Prepare privacy policy"
    echo ""

    print_step "4" "Submit for Review"
    echo "   • Complete all App Store Connect fields"
    echo "   • Upload production build"
    echo "   • Submit for Apple review"
    echo ""

    echo "🎉 Your app will be live on the App Store after approval!"
}

# Main execution
main() {
    print_header

    echo "This script provides step-by-step guidance for setting up"
    echo "${APP_NAME} in App Store Connect and preparing for submission."
    echo ""

    show_prerequisites
    show_app_information
    show_app_store_connect_steps
    show_testflight_setup
    show_required_assets
    show_build_commands
    show_next_steps

    echo ""
    print_info "For more detailed information, visit:"
    echo "   • App Store Connect Help: https://help.apple.com/app-store-connect"
    echo "   • App Store Review Guidelines: https://developer.apple.com/app-store/review/guidelines"
    echo "   • Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines"
}

# Run main function
main