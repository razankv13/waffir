#!/bin/bash

# App Store Upload Setup Guide
# This script provides step-by-step guidance for setting up automated App Store uploads

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
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${PURPLE}=============================================${NC}"
    echo -e "${PURPLE}  ${APP_NAME} App Store Upload Setup Guide ${NC}"
    echo -e "${PURPLE}=============================================${NC}"
    echo ""
}

print_section() {
    echo -e "${CYAN}📋 $1${NC}"
    echo "---------------------------------------------"
}

print_step() {
    echo -e "${GREEN}✅ Step $1:${NC} $2"
}

print_info() {
    echo -e "${BLUE}💡 Info:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️  Important:${NC} $1"
}

print_command() {
    echo -e "${CYAN}📝 Command:${NC}"
    echo -e "   ${YELLOW}$1${NC}"
    echo ""
}

show_introduction() {
    print_section "Introduction"
    echo "This guide will help you set up automated iOS App Store uploads"
    echo "for ${APP_NAME} without requiring Xcode GUI."
    echo ""
    print_info "What you'll accomplish:"
    echo "  • Set up App Store Connect authentication"
    echo "  • Configure your development team and certificates"
    echo "  • Test the build and upload pipeline"
    echo "  • Deploy to TestFlight and App Store"
    echo ""
}

show_prerequisites() {
    print_section "Prerequisites"

    print_step "1" "Apple Developer Account"
    print_info "You need an active Apple Developer Program membership (\\$99/year)"
    print_info "Sign up at: https://developer.apple.com/programs/"
    echo ""

    print_step "2" "Xcode Command Line Tools"
    print_info "Required for building and uploading iOS apps"
    print_command "xcode-select --install"

    print_step "3" "Development Certificate and Provisioning Profiles"
    print_info "These should be set up in Xcode or Apple Developer Console"
    print_info "Make sure you have:"
    echo "    • iOS Development Certificate (for testing)"
    echo "    • iOS Distribution Certificate (for App Store)"
    echo "    • Provisioning Profiles for your bundle IDs"
    echo ""

    print_step "4" "Team ID"
    print_info "Find your Team ID in Apple Developer Console > Membership"
    print_warning "Update the Team ID in lib/core/constants/app_constants.dart"
    echo ""
}

show_authentication_setup() {
    print_section "Authentication Setup"

    echo "Choose one of the following authentication methods:"
    echo ""

    print_step "A" "App Store Connect API Key (Recommended)"
    print_info "More secure and reliable for automation"
    echo ""
    echo "   1. Go to App Store Connect > Users and Access > Keys"
    echo "   2. Click '+' to create a new key"
    echo "   3. Name it '${APP_NAME} Upload Key'"
    echo "   4. Select 'Developer' role"
    echo "   5. Click 'Generate' and download the .p8 file"
    echo "   6. Save the Key ID and Issuer ID"
    echo ""
    print_warning "Download the .p8 file immediately - you can't download it again!"
    echo ""

    print_step "B" "Apple ID with App-Specific Password"
    print_info "Alternative method using your Apple ID"
    echo ""
    echo "   1. Go to appleid.apple.com"
    echo "   2. Sign in with your Apple ID"
    echo "   3. Go to 'Sign-In and Security' > 'App-Specific Passwords'"
    echo "   4. Click '+' to generate a new password"
    echo "   5. Label it '${APP_NAME} iOS Upload'"
    echo "   6. Copy the generated password"
    echo ""
}

show_app_store_connect_setup() {
    print_section "App Store Connect App Setup"

    print_step "1" "Create Your App"
    print_info "If you haven't created your app in App Store Connect yet:"
    print_command "./scripts/create_app_store_connect.sh"

    print_step "2" "Bundle ID Configuration"
    print_info "The following bundle IDs are configured:"
    echo "   • Production: $(get_bundle_id production)"
    echo "   • Staging: $(get_bundle_id staging)"
    echo "   • Development: $(get_bundle_id dev)"
    echo ""
    print_warning "Make sure these match your provisioning profiles!"
    echo ""
}

show_build_testing() {
    print_section "Testing Your Setup"

    print_step "1" "Test Development Build"
    print_info "First, let's test a simple development build:"
    print_command "./scripts/ios_build.sh -e dev -t build"

    print_step "2" "Test Archive Creation"
    print_info "Create an archive without uploading:"
    print_command "./scripts/ios_build.sh -e staging -t archive -m testflight"

    print_step "3" "Validate IPA (Dry Run)"
    print_info "Test upload validation without actually uploading:"
    print_command "./scripts/upload_to_app_store.sh --ipa ./build/ios/${APP_NAME}_staging_*.ipa --api-key ./AuthKey_ABC123.p8 --api-key-id ABC123 --api-issuer-id 12345678-1234-1234-1234-123456789012 --validate-only"
    echo ""
}

show_upload_examples() {
    print_section "Upload Examples"

    print_step "1" "TestFlight Upload (Internal Testing)"
    print_info "Build and upload to TestFlight for internal testing:"
    echo ""
    print_info "Using API Key:"
    print_command "./scripts/ios_build.sh -e staging -t archive -m testflight --upload --api-key ./AuthKey_ABC123.p8 --api-key-id ABC123 --api-issuer-id 12345678-1234-1234-1234-123456789012"

    print_info "Using Apple ID:"
    print_command "./scripts/ios_build.sh -e staging -t archive -m testflight --upload --apple-id your@email.com --password abcd-efgh-ijkl-mnop"

    print_step "2" "App Store Upload (Production)"
    print_info "Build and upload to App Store Connect:"
    echo ""
    print_info "Using API Key:"
    print_command "./scripts/ios_build.sh -e production -t archive -m app-store --clean --upload --api-key ./AuthKey_ABC123.p8 --api-key-id ABC123 --api-issuer-id 12345678-1234-1234-1234-123456789012"

    print_step "3" "Separate Build and Upload"
    print_info "You can also build first, then upload separately:"
    print_command "./scripts/ios_build.sh -e production -t archive -m app-store"
    print_command "./scripts/upload_to_app_store.sh --ipa ./build/ios/${APP_NAME}_production_*.ipa --api-key ./AuthKey_ABC123.p8 --api-key-id ABC123 --api-issuer-id 12345678-1234-1234-1234-123456789012"
}

show_environment_variables() {
    print_section "Environment Variables (Optional)"

    print_info "You can set authentication credentials as environment variables:"
    echo ""
    echo "export APPLE_ID=\"your@email.com\""
    echo "export APP_SPECIFIC_PASSWORD=\"abcd-efgh-ijkl-mnop\""
    echo "export API_KEY_PATH=\"./AuthKey_ABC123.p8\""
    echo "export API_KEY_ID=\"ABC123\""
    echo "export API_ISSUER_ID=\"12345678-1234-1234-1234-123456789012\""
    echo ""
    print_info "Add these to your ~/.bashrc or ~/.zshrc for persistence"
    echo ""
}

show_troubleshooting() {
    print_section "Common Issues and Solutions"

    echo "❌ Code Signing Errors:"
    echo "   • Check certificates in Keychain Access"
    echo "   • Verify provisioning profiles are up to date"
    echo "   • Ensure Team ID matches your Apple Developer account"
    echo ""

    echo "❌ Authentication Failures:"
    echo "   • For API keys: Check file path and permissions"
    echo "   • For Apple ID: Use app-specific password, not regular password"
    echo "   • Verify access to App Store Connect account"
    echo ""

    echo "❌ Build Failures:"
    echo "   • Run 'flutter clean' before building"
    echo "   • Ensure dependencies are installed: 'flutter pub get'"
    echo "   • Check Flutter and iOS version compatibility"
    echo ""

    echo "❌ Upload Failures:"
    echo "   • Verify app exists in App Store Connect"
    echo "   • Check bundle IDs match"
    echo "   • Ensure version numbers are higher than previous uploads"
    echo ""
}

show_next_steps() {
    print_section "Next Steps After Upload"

    print_step "1" "TestFlight (Beta Testing)"
    echo "   • Go to App Store Connect > TestFlight"
    echo "   • Add build to test groups"
    echo "   • Invite internal testers (immediate access)"
    echo "   • For external testers: Submit for TestFlight review"
    echo ""

    print_step "2" "App Store Release"
    echo "   • Go to App Store Connect > App Store"
    echo "   • Create a new version"
    echo "   • Add app information, screenshots, description"
    echo "   • Select build from TestFlight"
    echo "   • Submit for App Store review (1-7 days)"
    echo ""

    print_step "3" "Automation"
    echo "   • Set up CI/CD pipeline using these scripts"
    echo "   • Automate uploads on git tags or releases"
    echo "   • Monitor upload status and handle failures"
    echo ""
}

show_quick_start() {
    print_section "Quick Start Checklist"

    echo "Complete this checklist to get started:"
    echo ""
    echo "□ 1. Update Team ID in app_constants.dart"
    echo "□ 2. Set up App Store Connect authentication (API key or Apple ID)"
    echo "□ 3. Create app in App Store Connect (if not done)"
    echo "□ 4. Test development build: ./scripts/ios_build.sh -e dev -t build"
    echo "□ 5. Test archive creation: ./scripts/ios_build.sh -e staging -t archive"
    echo "□ 6. Validate upload: ./scripts/upload_to_app_store.sh --validate-only [params]"
    echo "□ 7. Upload to TestFlight: ./scripts/ios_build.sh -e staging --upload [auth]"
    echo "□ 8. Upload to App Store: ./scripts/ios_build.sh -e production --upload [auth]"
    echo ""
}

show_security_notes() {
    print_section "Security Best Practices"

    print_warning "Important security considerations:"
    echo ""
    echo "🔒 Never commit credentials to version control"
    echo "🔒 Use environment variables or secure files outside the repo"
    echo "🔒 Add credential files to .gitignore"
    echo "🔒 Rotate API keys regularly"
    echo "🔒 Use 'Developer' role for API keys unless 'Admin' needed"
    echo "🔒 Monitor key usage in App Store Connect"
    echo ""
}

# Main execution
main() {
    print_header

    show_introduction
    show_prerequisites
    show_authentication_setup
    show_app_store_connect_setup
    show_build_testing
    show_upload_examples
    show_environment_variables
    show_troubleshooting
    show_next_steps
    show_quick_start
    show_security_notes

    echo ""
    print_info "📚 Additional Resources:"
    echo "  • Detailed setup guide: ./scripts/create_app_store_connect.sh"
    echo "  • Script documentation: ./scripts/README.md"
    echo "  • Build script help: ./scripts/ios_build.sh --help"
    echo "  • Upload script help: ./scripts/upload_to_app_store.sh --help"
    echo ""

    print_info "🎉 You're ready to upload ${APP_NAME} to the App Store!"
}

# Run main function
main