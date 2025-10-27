import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/app.dart';
import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/storage/hive_service.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/flavors.dart';

Future<void> main() async {
  await mainCommon(Flavor.production);
}

Future<void> mainCommon(Flavor flavor) async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set the app flavor
  F.appFlavor = flavor;

  // Run app with error zone
  await runZonedGuarded(
    () async {
      // Initialize environment configuration
      await EnvironmentConfig.initialize();

      // Set preferred orientations
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );

      // Initialize Hive storage
      await HiveService.instance.initialize();

      // Initialize EasyLocalization
      await EasyLocalization.ensureInitialized();

      AppLogger.info('🚀 App initialization completed successfully');

      // Run the app
      runApp(
        EasyLocalization(
          supportedLocales: const [
            Locale('ar', 'SA'), // Arabic (Saudi Arabia)
            Locale('en', 'US'), // English
            Locale('es', 'ES'), // Spanish
            Locale('fr', 'FR'), // French
          ],
          path: 'assets/translations',
          fallbackLocale: const Locale('en', 'US'),
          startLocale: const Locale('ar', 'SA'), // Default to Arabic to match Figma
          child: const ProviderScope(child: App()),
        ),
      );
    },
    (error, stackTrace) {
      AppLogger.error(
        '💥 Uncaught error in app',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}
