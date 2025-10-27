#!/usr/bin/env dart

// Build configuration script for different environments
// Usage: dart scripts/build_config.dart <environment>

import 'dart:io';

enum Environment { dev, staging, production }

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Usage: dart scripts/build_config.dart <environment>');
    print('Available environments: dev, staging, production');
    exit(1);
  }

  final environmentString = arguments[0].toLowerCase();
  Environment? environment;

  switch (environmentString) {
    case 'dev':
    case 'development':
      environment = Environment.dev;
      break;
    case 'staging':
    case 'stage':
      environment = Environment.staging;
      break;
    case 'prod':
    case 'production':
      environment = Environment.production;
      break;
    default:
      print('Invalid environment: $environmentString');
      print('Available environments: dev, staging, production');
      exit(1);
  }

  setupEnvironment(environment);
}

void setupEnvironment(Environment environment) {
  print('🔧 Setting up build for ${environment.name} environment...');

  try {
    // Copy appropriate environment file to .env
    final sourceFile = '.env.${environment.name == 'dev' ? 'dev' : environment.name}';
    final targetFile = '.env';

    final source = File(sourceFile);
    final target = File(targetFile);

    if (!source.existsSync()) {
      print('❌ Environment file $sourceFile not found');
      exit(1);
    }

    // Copy environment file
    source.copySync(targetFile);
    print('✅ Copied $sourceFile to $targetFile');

    // Print environment information
    printEnvironmentInfo(environment);

    print('✅ Build configuration complete for ${environment.name}');
    print('');
    print('Next steps:');
    print('  flutter build apk --release          # For Android');
    print('  flutter build ios --release          # For iOS');
    print('  flutter build web --release          # For Web');
  } catch (e) {
    print('❌ Failed to setup environment: $e');
    exit(1);
  }
}

void printEnvironmentInfo(Environment environment) {
  print('');
  print('📋 Environment Configuration:');
  print('  Environment: ${environment.name}');
  
  switch (environment) {
    case Environment.dev:
      print('  Purpose: Development and testing');
      print('  Debug: Enabled');
      print('  Analytics: Enabled (development)');
      print('  Crash Reporting: Enabled (development)');
      break;
    case Environment.staging:
      print('  Purpose: Pre-production testing');
      print('  Debug: Disabled');
      print('  Analytics: Enabled');
      print('  Crash Reporting: Enabled');
      break;
    case Environment.production:
      print('  Purpose: Production release');
      print('  Debug: Disabled');
      print('  Analytics: Enabled');
      print('  Crash Reporting: Enabled');
      break;
  }
  print('');
}