import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waffir/app.dart';
import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/services/firebase_service.dart';
import 'package:waffir/core/services/push_notification_service.dart';
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

      // Initialize Supabase (optional; requires env vars)
      final supabaseUrl = EnvironmentConfig.supabaseUrl;
      final supabaseAnonKey = EnvironmentConfig.supabaseAnonKey;
      if (supabaseUrl != null && supabaseAnonKey != null) {
        await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
      } else {
        AppLogger.warning('Supabase not initialized (missing SUPABASE_URL/SUPABASE_ANON_KEY)');
      }

      // Initialize Firebase (required for push notifications, analytics, crashlytics)
      //   if (EnvironmentConfig.enableNotifications) {
      //     try {
      //       await FirebaseService.instance.initialize();
      //     } catch (e) {
      //       AppLogger.error('Failed to initialize Firebase', error: e);
      //     }
      //   }

      // Initialize Push Notifications
      if (EnvironmentConfig.enableNotifications) {
        try {
          // Wait for Supabase to be ready if it was initialized
          // We pass the client even if not fully authed, service handles it.
          // Note: PushNotificationService needs SupabaseClient.
          // Supabase.instance.client throws if not initialized.
          if (supabaseUrl != null && supabaseAnonKey != null) {
            await PushNotificationService.instance.initialize(supabase: Supabase.instance.client);
          }
        } catch (e) {
          AppLogger.error('Failed to initialize push notifications', error: e);
        }
      }

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
          startLocale: const Locale('en', 'US'), // Default to Arabic to match Figma
          child: const ProviderScope(child: App()),
        ),
      );
    },
    (error, stackTrace) {
      AppLogger.error('💥 Uncaught error in app', error: error, stackTrace: stackTrace);
    },
  );
}
