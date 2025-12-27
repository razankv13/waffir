import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/navigation/app_router.dart';
import 'package:waffir/core/themes/app_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/flavors.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return ResponsiveScope(
      child: MaterialApp.router(
        title: F.title,

        // Waffir Design System Theme
        theme: AppTheme.lightTheme,
        //  darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light, // Can be changed to ThemeMode.system
        // Localization & RTL Support
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        localizationsDelegates: [
          ...context.localizationDelegates,
          CountryLocalizations.delegate,
        ],

        routerConfig: router,

        builder: (context, child) {
          return _flavorBanner(child: child ?? const SizedBox.shrink());
        },

        debugShowCheckedModeBanner: false,
      ),
    );
  }

  Widget _flavorBanner({required Widget child, bool show = true}) => show
      ? Banner(
          location: BannerLocation.topStart,
          message: F.name,
          color: Colors.green.withAlpha(150),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            letterSpacing: 1.0,
          ),
          textDirection: TextDirection.rtl,
          child: child,
        )
      : Container(child: child);
}
