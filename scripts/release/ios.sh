#!/bin/bash

# iOS Release Script
# This script uploads the iOS app to App Store Connect using the deploy.sh script

set -e

# Load project configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

# Note: The API key file path can be any valid path to your .p8 file
# The deploy script will automatically copy it to the expected location with the correct naming convention
# (AuthKey_{KEY_ID}.p8) that altool requires

# Use configuration from config.sh
# You can override these by passing arguments to this script
API_KEY_PATH="${IOS_API_KEY_PATH}"
API_KEY_ID="${IOS_API_KEY_ID}"
API_ISSUER_ID="${IOS_API_ISSUER_ID}"

# Parse any command line overrides
while [[ $# -gt 0 ]]; do
    case $1 in
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
        --environment|-e)
            ENVIRONMENT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--api-key PATH] [--api-key-id ID] [--api-issuer-id ID] [--environment ENV]"
            exit 1
            ;;
    esac
done

# Default to production if not specified
ENVIRONMENT="${ENVIRONMENT:-production}"

# Execute the deployment
"$SCRIPT_DIR/../deploy.sh" -p ios -e "$ENVIRONMENT" -t archive --upload \
  --api-key "$API_KEY_PATH" \
  --api-key-id "$API_KEY_ID" \
  --api-issuer-id "$API_ISSUER_ID"