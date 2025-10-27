# Microsoft Clarity Integration

This document provides information on how to use Microsoft Clarity for session recording and analytics in this Flutter app.

## Overview

Microsoft Clarity is a free user behavior analytics tool that helps you understand how users interact with your app through:
- Session recordings
- Heatmaps
- User interaction tracking
- Performance insights

## Setup

### 1. Get Your Clarity Project ID

1. Visit [Microsoft Clarity](https://clarity.microsoft.com/)
2. Create a new project or select an existing one
3. Copy your Project ID from the Settings page

### 2. Configure Environment Variables

Add your Clarity Project ID to your `.env` file:

```env
# Microsoft Clarity Configuration
CLARITY_PROJECT_ID=your_clarity_project_id
ENABLE_CLARITY=true
```

### 3. The App Will Automatically Initialize

The Clarity SDK is automatically initialized in `main.dart` during app startup. No additional configuration is needed.

## Usage

### Setting Custom User ID

To associate sessions with a specific user:

```dart
import 'package:flutter_template/core/services/clarity_service.dart';

// After user login
await ClarityService.instance.setCustomUserId('user-123');
```

### Masking Sensitive Information

Use `ClarityMask` widget to hide sensitive information from recordings:

```dart
import 'package:clarity_flutter/clarity_flutter.dart';

ClarityMask(
  child: Text('Sensitive credit card number'),
)
```

### Unmasking Specific Widgets

Use `ClarityUnmask` to reveal specific content within a masked area:

```dart
ClarityUnmask(
  child: Text('Non-sensitive public information'),
)
```

## Configuration Options

### Log Levels

The log level is automatically set based on the environment:
- **Production**: `LogLevel.None` (no logs)
- **Development with Debug Mode**: `LogLevel.Verbose` (detailed logs)
- **Other**: `LogLevel.Info` (informational logs)

You can override this in `ClarityService.initialize()`:

```dart
await ClarityService.instance.initialize(
  logLevel: LogLevel.Debug,
);
```

### Disabling Clarity

To disable Clarity, set in your `.env`:

```env
ENABLE_CLARITY=false
```

## Privacy Considerations

- Clarity automatically masks input fields by default
- Use `ClarityMask` for additional sensitive UI elements
- Session recordings do not capture passwords or payment information
- Consider your privacy policy requirements

## Troubleshooting

### No Data in Clarity Dashboard

1. Verify your Project ID is correct in `.env`
2. Check that `ENABLE_CLARITY=true`
3. Enable verbose logging and check console output:
   ```env
   ENABLE_DEBUG_MODE=true
   ```
4. Ensure you've waited a few minutes for data to appear

### App Performance Issues

Clarity is designed to be lightweight, but if you experience issues:
1. Disable Clarity in development: `ENABLE_CLARITY=false`
2. Check your log level isn't set to `Verbose` in production

## API Reference

### ClarityService

**Singleton Instance**
```dart
ClarityService.instance
```

**Methods**

- `initialize({String? projectId, LogLevel? logLevel})` - Initialize Clarity SDK
- `setCustomUserId(String userId)` - Set custom user identifier
- `printConfiguration()` - Print current configuration (debug only)
- `exportConfiguration()` - Get configuration as Map

**Properties**

- `isInitialized` - Check if Clarity is initialized
- `config` - Get current ClarityConfig

## Resources

- [Microsoft Clarity Documentation](https://docs.microsoft.com/en-us/clarity/)
- [Clarity Flutter Package](https://pub.dev/packages/clarity_flutter)
- [Privacy & Security](https://docs.microsoft.com/en-us/clarity/privacy-security)
