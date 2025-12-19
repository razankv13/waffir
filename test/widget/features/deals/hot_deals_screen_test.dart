import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/themes/app_theme.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/deals/presentation/controllers/hot_deals_controller.dart';
import 'package:waffir/features/deals/presentation/screens/hot_deals_screen.dart';

class _StubHotDealsController extends HotDealsController {
  _StubHotDealsController(this._state);

  final HotDealsState _state;

  @override
  Future<HotDealsState> build() async => _state;

  @override
  Future<void> refresh() async {}

  @override
  Future<void> updateCategory(String category) async {}

  @override
  Future<void> updateSearch(String query) async {}

  @override
  Future<void> loadMore() async {}

  @override
  Future<Failure?> toggleLike(Deal deal) async => null;

  @override
  Future<void> trackView(Deal deal) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();
  });

  Widget wrap(dynamic override) {
    return EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      saveLocale: false,
      child: Builder(
        builder: (context) {
          return ProviderScope(
            overrides: [override],
            child: MediaQuery(
              data: const MediaQueryData(size: Size(393, 852)),
              child: MaterialApp(
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.lightTheme,
                themeMode: ThemeMode.light,
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                home: const HotDealsScreen(),
              ),
            ),
          );
        },
      ),
    );
  }

  testWidgets('HotDealsScreen renders empty state when deals list is empty', (tester) async {
    final override = hotDealsControllerProvider.overrideWith(() {
      return _StubHotDealsController(const HotDealsState.initial());
    });

    await tester.pumpWidget(wrap(override));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    expect(find.byIcon(Icons.shopping_bag_outlined, skipOffstage: false), findsOneWidget);
  });
}
