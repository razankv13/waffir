import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:waffir/core/themes/app_theme.dart';
import 'package:waffir/features/products/presentation/screens/product_detail_screen.dart';

Future<void> _loadProductPageFonts() async {
  final loader = FontLoader('Parkinsans');
  loader
    ..addFont(rootBundle.load('assets/fonts/parkinsans-light.ttf'))
    ..addFont(rootBundle.load('assets/fonts/parkinsans-regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/parkinsans-medium.ttf'))
    ..addFont(rootBundle.load('assets/fonts/parkinsans-semibold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/parkinsans-bold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/parkinsans-extrabold.ttf'));
  await loader.load();

}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testGoldens('ProductDetailScreen matches Figma baseline (393x852)', (WidgetTester tester) async {
    await EasyLocalization.ensureInitialized();
    await loadAppFonts();
    await _loadProductPageFonts();

    final widget = EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'SA'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: const SizedBox(
              width: 393,
              height: 852,
              child: ProductDetailScreen(productId: 'prod_001'),
            ),
          );
        },
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(393, 852),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await expectLater(
      find.byType(ProductDetailScreen),
      matchesGoldenFile('test/goldens/product_detail_screen_34_4022.png'),
    );
  });
}
