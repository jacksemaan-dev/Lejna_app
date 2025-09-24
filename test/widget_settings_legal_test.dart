import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lejna/l10n/app_localizations.dart';
import 'package:lejna/screens/settings/settings_page.dart';
import 'package:lejna/screens/settings/settings_page.dart' show LegalPage;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> _pumpSettings(
    WidgetTester tester,
    Locale locale,
    Widget child,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Settings page English', (WidgetTester tester) async {
    await _pumpSettings(tester, const Locale('en'), const SettingsPage());
    await expectLater(
      find.byType(SettingsPage),
      matchesGoldenFile('goldens/settings_page_en.png'),
    );
  });

  testWidgets('Settings page Arabic', (WidgetTester tester) async {
    await _pumpSettings(tester, const Locale('ar'), const SettingsPage());
    await expectLater(
      find.byType(SettingsPage),
      matchesGoldenFile('goldens/settings_page_ar.png'),
    );
  });

  testWidgets('Legal page Privacy Policy English', (WidgetTester tester) async {
    await _pumpSettings(
      tester,
      const Locale('en'),
      const LegalPage(
        title: 'Privacy Policy',
        assetPath: 'assets/legal/privacy_policy.md',
      ),
    );
    await expectLater(
      find.byType(LegalPage),
      matchesGoldenFile('goldens/legal_privacy_en.png'),
    );
  });

  testWidgets('Legal page Privacy Policy Arabic', (WidgetTester tester) async {
    await _pumpSettings(
      tester,
      const Locale('ar'),
      const LegalPage(
        title: 'سياسة الخصوصية',
        assetPath: 'assets/legal/privacy_policy.md',
      ),
    );
    await expectLater(
      find.byType(LegalPage),
      matchesGoldenFile('goldens/legal_privacy_ar.png'),
    );
  });
}